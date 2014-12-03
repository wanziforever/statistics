#!/usr/bin/env python

from common.grabber_manager import GrabberManager
from common.grabber_worker import GrabberWorker
from common.calc_manager import CalcManager
from common.calc_worker import CalcWorker
from common.echo import echo, debug, warn, err
from tmtags import TMTAGS
from msgtype import MsgType
from pymongo import MongoClient
from bson.objectid import ObjectId
from messages import *
from common.vender_info import vender_dict
from common.stat_time import StatTime
from common.stat_user import UsersInfo, StatUser
from core.mydb import Mydb
from common.log_entry_def import *
import datetime
import json
import os
import time

mongo_host = "127.0.0.1"
mongo_port = 27017

def default_encoder(obj):
    return obj.__json__()

class PlayTimeGrabber(GrabberWorker):
    def __init__(self, msgh, mgrq, myname, config):
        GrabberWorker.__init__(self, msgh, mgrq, myname, config)
        self.log_path = '/data/logs/'
        self.work_dir = '/data/logs/work/'
        self.dups = {}

    def _grab_files(self):
        spos = int(str(self.config['start']))
        epos = int(str(self.config['end']))
        dates = []
        for f in os.listdir(self.log_path):
            if f[0:4] != 'vod_' or f[-7:] != '.log.gz':
                continue
            date = f[4:12]
            try:
                ts = int(time.mktime(time.strptime(date, "%Y%m%d")) * 1000)
            except Exception, e:
                continue
            if ts >= spos and ts < epos:
                #path = os.path.join(self.log_path, f)
                dates.append(f)

            dates = sorted(dates)
        return [os.path.join(self.log_path, f) for f in dates]
                
    def _grab(self):
        for log_gz_file in self._grab_files():
            echo("processing %s"%log_gz_file)
            dirname = os.path.dirname(log_gz_file)
            input_file = log_gz_file[:-3]
            input_file_base_name = os.path.basename(input_file)
            new_input_file = \
                os.path.join(self.work_dir, input_file_base_name)
            
            if not os.path.exists(new_input_file):
                #print 'cp %s %s'%(log_gz_file, self.work_dir)
                os.system('cp %s %s'%(log_gz_file, self.work_dir))
                print 'cd %s;gunzip %s'%(self.work_dir, input_file_base_name)
                os.system('cd %s;gunzip %s'%(self.work_dir, input_file_base_name))
            fd = open(new_input_file, "r")
            for record in fd:
                code = record[4:8]
                if code != "5011" and code != "5042":
                    continue
                
                self._handle_record(record)
                self.current += 1
            fd.close()
            #os.system('cd %s; gzip %s'%(dirname, input_file))

    def _handle_record(self, raw):
        e = gen_entry(raw)
        if e.parse() is False:
            return
        # remove the duplate 5042 and 5011
        userid = e.get_userid()
        code = e.get_code()
        ts = e.get_ts()
        if code == "5042":
            self.dups[userid] = ts
        if code == "5011" and userid in self.dups:
            if abs(int(ts) - int(self.dups[userid])) < 40000:
                #print "found dup records 5042 has %s, and 5011 has %s, "\
                #      "user=%s"%(self.dups[userid], ts, userid)
                return
            
        msg = MsgPlayRetentionCalc()
        msg.set_userid(e.get_userid())
        msg.set_timestamp(e.get_ts())
        msg.set_vender(e.get_vender())
        msg.set_retention(e.get_retention())
        i = self.next_rrobin()
        self.queue.send(self.calc_queues[i], msg)

class PlayTimeCollector(object):
    def __init__(self, vender, start, end):
        self.vender = vender
        self.stat_time = StatTime(start, end)

    def get_vender(self):
        return self.vender

    def __repr__(self):
        s = "vender: %s, info: %s"%(self.vender, repr(self.stat_time))
        return s

top_num = 10
tops = [0 for i in range(top_num)]
def add_top(value):
    i = 0
    while i < top_num:
        #print "tops[%s] >= %s"%(i, value)
        if tops[i] > value:
            i += 1
        elif tops[i] == value:
            return 0
        else:
            j = top_num -1 
            while True:
                if j == i:
                    break
                #print "top[%s] = top[%s]"%(j, j-1), tops
                tops[j] = tops[j-1]
                j -= 1
            tops[i] = value
            break
        
class PlayTimeCalc(CalcWorker):
    def __init__(self, msgh, mgrq, myname, config):
        CalcWorker.__init__(self, msgh, mgrq, myname, config)
        self.report_intvl = 4
        self.report_threshold = 50
        #self.eh.register_timer(self.report_intvl * 1000,
        #                       TMTAGS.SEND_REPORT, True)
        self.stat_user = StatUser(self.config['start'], self.config['end'])
        self.same_num = 0

    def _process_msg(self, msg):
        msgtype = msg.get_msgtype()
        if msgtype == MsgType.MsgPlayRetentionCalc:
            calc_msg = MsgPlayRetentionCalc()
            calc_msg.cast(msg)
            calc_msg.parse()
            ts = calc_msg.get_timestamp()
            user = calc_msg.get_userid()
            vender = calc_msg.get_vender()
            retention = calc_msg.get_retention()
            ret = add_top(int(retention))
            if ret == 0:
                self.same_num += 1
            #print "PlayTimeCalc::_process_msg() user: %s, vender: %s"%(user, vender)
            if vender in vender_dict:
                vender = vender_dict[vender]
            if ts.find('.') != -1 or ts.isdigit() is False:
                warn("invalid timestamp %s for user %s"%(ts, user))
                return
            #print '-calc------', ts, user, vender, retention
            self.stat_user.mark(user, ts, vender, int(retention))
            #print "marked user: %s, ts: %s, vender: %s"%(user, ts, vender)
            #print "current user: %s, current count: %s"%(self.stat_user.count_user(),self.current)
            
            if self.stat_user.count_user() > self.report_threshold:
                self._send_report()
            self.current += 1
        else:
            super(PlayTimeCalc, self)._process_msg(msg)

    def _process_timer(self, msg):
        tag = msg.get_tag()
        if tag == TMTAGS.SEND_REPORT:
            self._send_report()
        else:
            super(PlayTimeCalc, self)._process_timer(msg)

    def _send_report(self):
        ptr_msg = MsgPlayTimeReport()
         #self.stat_user.show_user_info().replace('\\', '')
        ptr_msg.set_report_info(
            self.stat_user.show_user_info())
        self.queue.send(self.mgrq, ptr_msg)
        self.stat_user.clear_data()

    def _final(self):
        self._send_report()
        #print "----top 10-----", tops
        #print "print top records....."
        #ff = open('aaa', 'w')
        #ff.write(str(tops))
        #ff.close()
        #n = 0
        #p = 0
        #for i in tops:
        #    if i == 0:
        #        continue
        #    p += i
        #    n += 1
        #print "numer in tops is ", n
        #print "same numer for tops is ", self.same_num
        #print "total tops is", p
        super(PlayTimeCalc, self)._final()
        
class PlayTimeCalcMgr(CalcManager):
    def __init__(self, msgh, config):
        CalcManager.__init__(self, msgh)
        self.report_fd = None
        self.collectors = {}
        self.config = config
        self.stat_user = StatUser(config['start'], config['end'])
        self.rpt_print_intvl = 10
        #self.eh.register_timer(self.rpt_print_intvl * 1000,
        #                       TMTAGS.PRINT_REPORT, True)
        self.db = Mydb()
        self.db.connect('report')

    def set_config(self, config):
        self.config = config

    def _process_msg(self, msg):
        debug("PlayTimeCalcMgr::_process_msg() enter")
        msgtype = msg.get_msgtype()
        if msgtype == MsgType.MsgPlayTimeReport:
            debug("PlayTimeCalcMgr::_process_msg() got "
                  "report message %s"%msg.get_body())
            #print "PlayerStartupCalcMgr::_process_msg() got "\
            #      "report message %s"%msg.get_body()
            ptr_msg = MsgPlayTimeReport()
            ptr_msg.cast(msg)
            data = json.loads(ptr_msg.get_report_info())
            for user, play_info in data.items():
                self.stat_user.merge_user_info(user, play_info)
            #for vender, counts in data.items():
            #    self.collectors[vender].stat_time.merge(counts)
        else:
            super(PlayTimeCalcMgr, self)._process_msg(msg)

    def _process_timer(self, msg):
        #tag = msg.get_tag()
        #if tag == TMTAGS.PRINT_REPORT:
        #    self._print_report()
        #else:
        #    super(PlayTimeCalcMgr, self)._process_timer(msg)
        super(PlayTimeCalcMgr, self)._process_timer(msg)

    def _print_report(self):
        print "currently the total user:", self.stat_user.count_user()
        self.dbsession = self.db.open('play_time_day')
        data = {"vender": '',
                'date': '%s_%s'%(self.config['start'],
                                 self.config['end']),
                'time': 0}
        
        venders_time = self.stat_user.gen_stat_count_by_vender_per_day()
        venders_user = self.stat_user.gen_stat_users_by_vender_per_day()
        for vender, stat_time in venders_user.items():
            if vender not in venders_time:
                continue
            time_infos = venders_time[vender].show_info()
            user_infos = stat_time.show_info()
            total, rate, u = 0, 0, 0
            for day, count in user_infos.items():
                if day not in time_infos:
                    continue
                total += int(time_infos[day]) / int(count)
                u += 1
            if u == 0:
                continue
            rate = total / u
            data['vender'] = vender
            data['time'] = rate
            self.dbsession.insert(data)

        total, rate, u = 0, 0, 0
        time_infos = self.stat_user.gen_stat_times().show_info()
        user_infos = self.stat_user.gen_stat_users().show_info()
        for day, count in user_infos.items():
            if day not in time_infos:
                continue
            total += int(time_infos[day]) / int(count)
            u += 1
        rate = total / u
        data['vender'] = 'HISENSE'
        data['time'] = rate
        self.dbsession.insert(data)
        self.dbsession.close()

    def _final(self):
        self._print_report()
        super(PlayTimeCalcMgr, self)._final()

