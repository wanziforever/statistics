#!/usr/bin/env python

import json

from stat_time import StatTime

def default_encoder(obj):
    return obj.__json__()

class PlayInfo(object):
    ''' PlayInfo has the following structure stored in hash
    {vender: count}
    '''
    def __init__(self):
        self.vender_info = {}
    def add(self, vender, count=1):
        if vender not in self.vender_info:
            self.vender_info[vender] = count
            return 1
        self.vender_info[vender] += count
        return self.vender_info[vender]
    def __json__(self):
        #return json.dumps(self.vender_info, default=default_encoder)
        return self.vender_info

    def __repr__(self):
        return self.__json__()

    def count(self):
        total = 0
        for vender, count in self.vender_info.items():
            total += count
        return count

    def count_with_vender(self):
        return self.vender_info

class UserPlayInfo(object):
    '''UserPlayInfo has the following structure stored in hash with PlayInfo
    {time_index: {vender: count}}'''
    def __init__(self):
        self.play_infos = {}

    def mark(self, index, vender, count=1):
        if index in self.play_infos:
            self.play_infos[index].add(vender, count)
            return
        p = PlayInfo()
        p.add(vender, count)
        self.play_infos[index] = p

    def count_with_index(self):
        ret = {}
        for index, info in self.play_infos.items():
            ret[index] = info.count()
        return ret
    def count_with_index_and_vender(self):
        ret = {}
        for index, info in self.play_infos.items():
            ret[index] = info.count_with_vender()
        return ret

    def __json__(self):
        return self.play_infos

    def __repr__(self):
        return self.__json__()

class UsersInfo(object):
    def __init__(self):
        self.users = {}

    def mark(self, user, index, vender, count=1):
        if user in self.users:
            self.users[user.strip()].mark(index, vender, count)
            return
        u = UserPlayInfo()
        u.mark(index, vender, count)
        self.users[user.strip()] = u

    def clear_data(self):
        self.users = {}

    def __json__(self):
        return self.users

    def __repr__(self):
        return self.__json__()

    def count_user(self):
        return len(self.users)


class StatUser(object):
    def __init__(self, start_day, end_day):
        self.start_day = start_day
        self.end_day = end_day
        self.stat_time = StatTime(start_day, end_day)
        self.users_info = UsersInfo()

    def mark(self, user, ts, vender, count=1):
        index = self.stat_time.get_index_by_ts(int(ts))
        if index == -1:
            return
        self.users_info.mark(user, index, vender, count)
        
    def __json__(self):
        return self.users_info.users

    def __repr__(self):
        return self.__json__()

    def clear_data(self):
        self.users_info.clear_data()

    def merge_user_info(self, user, play_info):
        for index, info in play_info.items():
            for vender, count in info.items():
                self.users_info.mark(user, index, vender, count)

    def show_user_info(self):
        return json.dumps(self, default=default_encoder)
     
    def count_user(self):
        return len(self.users_info.users)

    def gen_stat_times(self):
        stat_time = StatTime(self.start_day, self.end_day)
        for usr, play_info in self.users_info.users.items():
            count_with_indx = play_info.count_with_index()
            for index, count in count_with_indx.items():
                stat_time.stat_count_by_index(int(index), int(count))
        return stat_time

    def gen_stat_users(self):
        stat_time = StatTime(self.start_day, self.end_day)
        for usr, play_info in self.users_info.users.items():
            count_with_indx = play_info.count_with_index()
            for index, count in count_with_indx.items():
                stat_time.stat_count_by_index(int(index))
        return stat_time
    
    def gen_stat_users_by_model(self):
        models = {}
        for usr in self.users_info.users.keys():
            m = usr[0:24]
            if m in models:
                models[m] += 1
            else:
                models[m] = 1
        return models

    def gen_stat_users_by_model_per_day(self):
        models = {}
        for usr, play_info in self.users_info.users.items():
            m = usr[0:24]
            count_with_indx = play_info.count_with_index()
            stat_time = None
            if m in models:
                stat_time = models[m]
            else:
                stat_time = StatTime(self.start_day, self.end_day)
                models[m] = stat_time

            for index, count in count_with_indx.items():
                stat_time.stat_count_by_index(int(index))

        return models

    def verify_users(self):
        test_set = set()
        for user in self.users_info.users.keys():
            test_set.add(user.strip())

        print "test set length is", len(test_set)
        print "user number is ", self.count_user()
        
    def gen_stat_users_by_vender(self):
        from common.vender_info import vender_dict
        venders = {}
        for usr, play_info in self.users_info.users.items():
            infos = play_info.count_with_index_and_vender()
            has_found = {}
            for index, vender_info in infos.items():
                for vender, count in vender_info.items():
                    if vender in vender_dict:
                        vender = vender_dict[vender]
                    if vender in has_found:
                        continue
                    if vender in venders:
                        venders[vender] += 1
                    else:
                        venders[vender] = 1
                    has_found[vender] = True
        return venders

    def gen_stat_users_by_vender_per_day(self):
        from common.vender_info import vender_dict
        venders = {}
        for usr, play_info in self.users_info.users.items():
            infos = play_info.count_with_index_and_vender()
            for index, vender_info in infos.items():
                for vender, count in vender_info.items():
                    if vender in vender_dict:
                        vender = vender_dict[vender]
                    stat_time = None
                    if vender in venders:
                        stat_time = venders[vender]
                    else:
                        stat_time = StatTime(self.start_day, self.end_day)
                        venders[vender] = stat_time
                    stat_time.stat_count_by_index(int(index))
        return venders

    def gen_stat_count(self):
        total = 0
        for usr, play_info in self.users_info.users.items():
            infos = play_info.count_with_index_and_vender()
            for index, vender_info in infos.items():
                for vender, count in vender_info.items():
                    total += count
        return total

    def gen_stat_count_by_vender(self):
        from common.vender_info import vender_dict
        venders = {}
        for usr, play_info in self.users_info.users.items():
            infos = play_info.count_with_index_and_vender()
            for index, vender_info in infos.items():
                for vender, count in vender_info.items():
                    if vender in vender_dict:
                        vender = vender_dict[vender]
                    if vender in venders:
                        venders[vender] += count
                    else:
                        venders[vender] = count
        return venders
            
    def gen_stat_count_by_vender_per_day(self):
        from common.vender_info import vender_dict
        venders = {}
        for usr, play_info in self.users_info.users.items():
            infos = play_info.count_with_index_and_vender()
            for index, vender_info in infos.items():
                for vender, count in vender_info.items():
                    if vender in vender_dict:
                        vender = vender_dict[vender]
                    stat_time = None
                    if vender in venders:
                        stat_time = venders[vender]
                    else:
                        stat_time = StatTime(self.start_day, self.end_day)
                        venders[vender] = stat_time
                    stat_time.stat_count_by_index(int(index), count)
        return venders
                    
    
