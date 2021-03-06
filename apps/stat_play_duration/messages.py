#!/usr/bin/env python

import json
from msgtype import MsgType
from core.mymessage import MyMessage
from core.eventype import EVENTYPE
import zlib

def default_encoder(obj):
    return obj.__json__()

class MsgPlayRetentionCalc(MyMessage):
    def __init__(self):
        MyMessage.__init__(self, evtype=EVENTYPE.NORMALMSG,
                           msgtype=MsgType.MsgPlayRetentionCalc)
        self.user_id = ""
        self.ts = ""
        self.vender = ""
        self.retention = ""

    def set_userid(self, userid):
        self.user_id = userid

    def set_timestamp(self, ts):
        self.ts = ts

    def set_vender(self, vender):
        self.vender = vender

    def set_retention(self, retention):
        self.retention = retention

    def get_userid(self):
        return self.user_id

    def get_timestamp(self):
        return self.ts

    def get_vender(self):
        return self.vender

    def get_retention(self):
        return self.retention

    def build(self):
        self.body = "{0}::{1}::{2}::{3}".format(self.user_id,
                                                self.ts,
                                                self.vender,
                                                self.retention)
    def parse(self):
        self.user_id, self.ts, self.vender, \
                      self.retention = self.body.split("::")


class MsgPlayTimeReport(MyMessage):
    def __init__(self):
        MyMessage.__init__(self, evtype=EVENTYPE.NORMALMSG,
                           msgtype=MsgType.MsgPlayTimeReport)
    def set_report_info(self, data):
        #self.body = zlib.compress(
        #    json.dumps(data, default=default_encoder)
        #    )
        #self.body = json.dumps(data, default=default_encoder)
        self.body = data

    def get_report_info(self):
        #return json.loads(zlib.decompress(self.body, zlib.MAX_WBITS|32))
        #return json.loads(self.body)
        return self.body
