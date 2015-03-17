#!/usr/bin/python
# -*- coding: UTF-8 -*-

'''
Created on Oct 31, 2011

@author: mengchen
'''
from common.error.errors import BadArgTypeError
import StringIO
import doctest
import urllib2

def stub_urlopen(resp):
    if isinstance(resp, (str, unicode)):
        urllib2.urlopen = lambda: StringIO.StringIO(resp)
    elif callable(resp):
        def _urlopen(url, data=None):
            return StringIO.StringIO(resp(url, data))
        urllib2.urlopen = _urlopen
    else:
        raise BadArgTypeError('resp', type(resp), (str, unicode, callable))

if __name__ == '__main__':
    doctest.testmod()
    