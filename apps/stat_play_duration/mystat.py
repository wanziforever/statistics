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

def default_encoder(obj):
    return obj.__json__()

class PlayTimeGrabber(GrabberWorker):
    def __init__(self, msgh, mgrq, myname, config):
        GrabberWorker.__init__(self, msgh, mgrq, myname, config)
        self.log_path = '/data/logs/source/'
        self.work_dir = '/data/logs/work/'
        self.dups = {}

    def _grab_files(self):
        spos = int(str(self.config['log_start_ts']))
        epos = int(str(self.config['log_end_ts']))
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
        if ts.find('.') != -1:
            return
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
        
class PlayTimeCalc(CalcWorker):
    def __init__(self, msgh, mgrq, myname, config):
        CalcWorker.__init__(self, msgh, mgrq, myname, config)
        self.report_intvl = 4
        self.report_threshold = 50
        #self.eh.register_timer(self.report_intvl * 1000,
        #                       TMTAGS.SEND_REPORT, True)
        self.stat_user = StatUser(self.config['start'], self.config['end'])

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
            if int(retention) > 14400:
                print "------invalid retention", retention
                return
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
        self._duration_rate()
        self._duration_rate_day()
        self._duration_total_day()

    def _duration_rate_day(self):
        self.dbsession = self.db.open('play_duration_rate_day')
        data = {"vender": '',
                'date': '',
                'time': 0}
        
        venders_time = self.stat_user.gen_stat_count_by_vender_per_day()
        venders_user = self.stat_user.gen_stat_users_by_vender_per_day()

        for vender, stat_time in venders_time.items():
            print "--------", vender, stat_time.show_info()

        for vender, stat_time in venders_user.items():
            print "_duration_rate_day(): ", vender, stat_time.show_info()
            if vender not in venders_time:
                warn('_duration_rate_day():user vender %s is not in time venders[%s]'%(vender, str(venders_time)))
                continue
            time_infos = venders_time[vender].show_info()
            user_infos = stat_time.show_info()
            total, rate = 0, 0
            data['vender'] = vender
            for day, count in user_infos.items():
                if day not in time_infos:
                    warn("_duration_rate_day():user day %s is not in time days[%s]"%(day, str(time_infos.keys())))
                    continue
                rate = int(time_infos[day]) / int(count)
                data['date'] = day
                data['time'] = rate
                self.dbsession.insert(data)
            self.dbsession.commit()

        total, rate = 0, 0
        time_infos = self.stat_user.gen_stat_times().show_info()
        user_infos = self.stat_user.gen_stat_users().show_info()
        data['vender'] = 'HISENSE'
        for day, count in user_infos.items():
            if day not in time_infos:
                warn('user ay %s is not in time days[%s]'%(day, str(time_infos.keys())))
                continue
            rate = int(time_infos[day]) / int(count)
            data['date'] = day
            data['time'] = rate
            self.dbsession.insert(data)
        self.dbsession.commit()
        self.dbsession.close()
        
    def _duration_rate(self):
        self.dbsession = self.db.open('play_duration_rate')
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
        self.dbsession.commit()

        total, rate, u = 0, 0, 0
        time_infos = self.stat_user.gen_stat_times().show_info()
        user_infos = self.stat_user.gen_stat_users().show_info()
        for day, count in user_infos.items():
            if day not in time_infos:
                continue
            total += int(time_infos[day]) / int(count)
            u += 1
        if u == 0:
            return
        rate = total / u
        data['vender'] = 'HISENSE'
        data['time'] = rate
        self.dbsession.insert(data)
        self.dbsession.commit()
        self.dbsession.close()

    def _duration_total_day(self):
        self.dbsession = self.db.open('play_duration_day')
        data = {"vender": '',
                'date': '',
                'time': 0}
        venders_time = self.stat_user.gen_stat_count_by_vender_per_day()
        for vender, stat_time in venders_time.items():
            time_infos = stat_time.show_info()
            data['vender'] = vender
            for day, count in time_infos.items():
                data['date'] = day
                data['time'] = count
                self.dbsession.insert(data)
        self.dbsession.commit()
        
        time_infos = self.stat_user.gen_stat_times().show_info()
        for day, count in time_infos.items():
            data['vender'] = 'HISENSE'
            data['date'] = day
            data['time'] = count
            self.dbsession.insert(data)

        self.dbsession.commit()
        self.dbsession.close()

    def _final(self):
        self._print_report()
        super(PlayTimeCalcMgr, self)._final()

