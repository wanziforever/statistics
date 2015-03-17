#!/usr/bin/python
# -*- coding: UTF-8 -*-

'''
Created on Dec 9, 2011

@author: mengchen
'''
from common import settings
from common.error.errors import ModNotFoundError
from common.test import testutil
from common.util import modutil

class Fixture(object):
    def setUp(self):
        pass
    
    def tearDown(self):
        pass
    
class StubFixture(Fixture):
    def __init__(self):
        self._stubbed = False
        self._stubs = []
        
    def setUp(self):
        super(StubFixture, self).setUp()
        for stub in self._stubs:
            self._stub(stub)
        self._stubbed = True
    
    def tearDown(self):
        stubs = list(self._stubs)
        stubs.reverse()
        for stub in stubs:
            setattr(stub['obj'], stub['attr'], stub['old_value'])
        self._stubbed = False
        super(StubFixture, self).tearDown()
    
    def add_stub(self, obj, attr, value):
        stub = dict(obj=obj, attr=attr, value=value)
        self._stubs.append(stub)
        if self._stubbed:
            self._stub(stub)
        
    def _stub(self, stub):
        stub['old_value'] = getattr(stub['obj'], stub['attr'])
        setattr(stub['obj'], stub['attr'], stub['value'])
        
if modutil.exists('mox'):
    import mox
    class MoxFixture(Fixture):
        def __init__(self):
            super(MoxFixture, self).__init__()
            self._mox = mox.Mox()
            
        def tearDown(self):
            self._mox.ResetAll()
            self._mox.UnsetStubs()
            super(MoxFixture, self).tearDown()
        
        def create_mock(self, cls=None):
            return self._mox.CreateMockAnything() if cls is None else self._mox.CreateMock(cls)
        
        def mock(self, obj, attr):
            self._mox.StubOutWithMock(obj, attr)
        
        def run_in_mox(self, record_func):
            class _MoxContext(object):
                def __init__(self, mox):
                    self._mox = mox
                    
                def __enter__(self):
                    record_func()
                    self._mox.ReplayAll()
                    return self
                
                def __exit__(self, type, value, traceback):
                    if value is None:
                        self._mox.VerifyAll()
            return _MoxContext(self._mox)
else:
    class MoxFixture(object):
        def __init__(self, *args, **kw):
            raise ModNotFoundError('mox')
        