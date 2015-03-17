#!/usr/bin/env python
# -*- coding: utf-8 -*-

'''
Created on Feb 2, 2012

@author: mengchen
'''
from mox import Comparator

class StoreArg(Comparator):
    def equals(self, rhs):
        self.arg = rhs
        return True
