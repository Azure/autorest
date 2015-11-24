import unittest
import subprocess
import sys
import isodate
import tempfile
import json
from uuid import uuid4
from datetime import date, datetime, timedelta
import os
from os.path import dirname, pardir, join, realpath, sep, pardir

cwd = dirname(realpath(__file__))
root = realpath(join(cwd , pardir, pardir, pardir, pardir, pardir))
sys.path.append(join(root, "ClientRuntimes" , "Python", "msrest"))
sys.path.append(join(root, "ClientRuntimes" , "Python", "msrestazure"))

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "Paging"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError
from msrestazure.azure_active_directory import UserPassCredentials
from msrestazure.azure_exceptions import CloudError

from auto_rest_paging_test_service import (
    AutoRestPagingTestService, 
    AutoRestPagingTestServiceConfiguration)


class PagingTests(unittest.TestCase):

    def setUp(self):
        config = AutoRestPagingTestServiceConfiguration(None, base_url="http://localhost:3000")
        config.log_level = 10
        self.client = AutoRestPagingTestService(config)

        return super(PagingTests, self).setUp()

    def test_paging_happy_path(self):
        
        pages = self.client.paging.get_single_pages()
        self.assertIsNone(pages.next_link)
        items = [i for i in pages]
        self.assertEqual(len(items), 1)
        self.assertEqual(items[0].id, 1)
        self.assertEqual(items[0].name, "Product")

        pages = self.client.paging.get_multiple_pages()
        self.assertIsNotNone(pages.next_link)
        items = [i for i in pages]
        self.assertEqual(len(items), 10)

        # TODO - Retry does not return correct status
        #pages = self.client.paging.get_multiple_pages_retry_first()
        #self.assertIsNotNone(pages.next_link)
        #items = [i for i in pages]
        #self.assertEqual(len(items), 10)

        # TODO - Retry does not return correct status
        pages = self.client.paging.get_multiple_pages_retry_second()
        self.assertIsNotNone(pages.next_link)
        #items = [i for i in pages]
        #self.assertEqual(len(items), 10)

    def test_paging_sad_path(self):

        with self.assertRaises(CloudError):
            self.client.paging.get_single_pages_failure()
        
        pages = self.client.paging.get_multiple_pages_failure()
        self.assertIsNotNone(pages.next_link)

        with self.assertRaises(CloudError):
            items = [i for i in pages]

        pages = self.client.paging.get_multiple_pages_failure_uri()

        # TODO - need to check for invalid url
        #with self.assertRaises(ValueError):
        #    items = [i for i in pages]
        

if __name__ == '__main__':
    unittest.main()