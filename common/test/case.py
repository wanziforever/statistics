#!/usr/bin/python
# -*- coding: UTF-8 -*-

'''
Created on 2011-10-29

@author: mengchen
'''
from common import settings
from common.test.fixtures import StubFixture
from common.util import modutil, fileutil
import datetime
import doctest
import os
import re
import shutil
import tempfile
import unittest

class TestCase(unittest.TestCase):
    def __init__(self, methodName='runTest'):
        super(TestCase, self).__init__(methodName)
        self._test_dir = os.path.join(tempfile.gettempdir(), 'test')
        self._fixtures = []
        self._stub_fixture = StubFixture()
        self._fixtures.append(self._stub_fixture)
        if modutil.exists('mox'):
            from fixtures import MoxFixture
            self._mox_fixture = MoxFixture()
            self._fixtures.append(self._mox_fixture)
        self._stub_fixture.add_stub(settings, 'FILESTORE_DIR', self._test_dir)
        
    def setUp(self):
        super(TestCase, self).setUp()
        fileutil.make_empty_dir(self._test_dir)
        for f in self._fixtures:
            f.setUp()
    
    def tearDown(self):
        for f in self._fixtures:
            f.tearDown()
        super(TestCase, self).tearDown()
        
    def assertAlmostNow(self, time, msg=None):
        '''
        >>> class FakeTest(TestCase):
        ...     def test(self):
        ...         pass
        >>> case = FakeTest('test')
        
        should do nothing if time is almost now
        >>> case.assertAlmostNow(datetime.datetime.now())
        
        should throw assertion error if time is not almost now
        >>> case.assertAlmostNow(datetime.datetime(2000, 1, 1))
        Traceback (most recent call last):
        ...
        AssertionError: "2000-01-01 00:00:00" is not almost now
        '''
        delta = abs(datetime.datetime.now() - time)
        if delta.seconds > 10:
            raise self.failureException(msg or '"%s" is not almost now' % (time.strftime('%Y-%m-%d %H:%M:%S')))
        
    def assertFileExists(self, path):
        '''
        >>> class FakeTest(TestCase):
        ...     def test(self):
        ...         pass
        >>> case = FakeTest('test')
        
        should do nothing if file exists
        >>> case.assertFileExists('.')
        
        should raise assertion error if file not exist
        >>> case.assertFileExists('not_exist')
        Traceback (most recent call last):
        ...
        AssertionError: File "not_exist" not exist.
        '''
        if not os.path.exists(path):
            raise self.failureException('File "%s" not exist.' % path)
        
    def assertFileNotExists(self, path):
        '''
        >>> class FakeTest(TestCase):
        ...     def test(self):
        ...         pass
        >>> case = FakeTest('test')
        
        should do nothing if file not exists
        >>> case.assertFileNotExists('not_exist')
        
        should raise assertion error if file exists
        '''
        if os.path.exists(path):
            raise self.failureException('File "%s" exist.' % path)
        
    def assertFsFileExists(self, filekey):
        file = os.path.join(settings.FILESTORE_DIR, filekey)
        self.assertFileExists(file)
        
    def assertFsFileNotExists(self, filekey):
        file = os.path.join(settings.FILESTORE_DIR, filekey)
        self.assertFileNotExists(file)
        
    def assertIsType(self, obj, types):
        '''
        >>> class FakeTest(TestCase):
        ...     def test(self):
        ...         pass
        >>> case = FakeTest('test')
        
        should do nothing if obj is of type
        >>> case.assertIsType('abc', str)
        >>> case.assertIsType('abc', (str, unicode))
        
        should throw assertion error if obj is not of type
        >>> case.assertIsType(1, str)
        Traceback (most recent call last):
        ...
        AssertionError: "1" is not of type <type 'str'>.
        >>> case.assertIsType(1, (str, unicode))
        Traceback (most recent call last):
        ...
        AssertionError: "1" is not of type (<type 'str'>, <type 'unicode'>).
        '''
        if not isinstance(obj, types):
            raise self.failureException('"%s" is not of type %s.' % (obj, types))
        
    def assertMatches(self, pattern, value):
        '''
        >>> class FakeTest(TestCase):
        ...     def test(self):
        ...         pass
        >>> case = FakeTest('test')
        
        should do nothing if matches
        >>> case.assertMatches('\\d{3}', '111')
        
        should raise error if not matches
        >>> case.assertMatches('\\d{3}', 'aaa')
        Traceback (most recent call last):
        ...
        AssertionError: "aaa" does not match "\\d{3}".
        '''
        if not re.match(pattern, value):
            raise self.failureException('"%s" does not match "%s".' % (value, pattern))
        
    def assertNone(self, value):
        '''
        >>> class FakeTest(TestCase):
        ...     def test(self):
        ...         pass
        >>> case = FakeTest('test')
        
        pass
        >>> case.assertNone(None)
        
        failed
        >>> case.assertNone(1)
        Traceback (most recent call last):
        ...
        AssertionError: Expected None, but is 1.
        '''
        if value is not None:
            raise self.failureException('Expected None, but is %s.' % value)
        
    def assertNotNone(self, value):
        '''
        >>> class FakeTest(TestCase):
        ...     def test(self):
        ...         pass
        >>> case = FakeTest('test')
        
        pass
        >>> case.assertNotNone(1)
        
        failed
        >>> case.assertNotNone(None)
        Traceback (most recent call last):
        ...
        AssertionError: Expected not None, but is None.
        '''
        if value is None:
            raise self.failureException('Expected not None, but is None.')
        
    def _copy_to_test_dir(self, file):
        dest = os.path.join(self._test_dir, os.path.basename(file))
        shutil.copy(file, dest)
        return dest
    
if __name__ == '__main__':
    doctest.testmod()
    