# --------------------------------------------------------------------------
#
# Copyright (c) Microsoft Corporation. All rights reserved.
#
# The MIT License (MIT)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the ""Software""), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
#
# --------------------------------------------------------------------------

import unittest
import subprocess
import sys
import isodate
import tempfile
import json
from datetime import date, datetime, timedelta
import os
from os.path import dirname, pardir, join, realpath

cwd = dirname(realpath(__file__))
log_level = int(os.environ.get('PythonLogLevel', 10))

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "Validation"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError, ValidationError

from auto_rest_validation_test import AutoRestValidationTest
from auto_rest_validation_test.models import (
    Product,
    ConstantProduct,
    ChildProduct)


class ValidationTests(unittest.TestCase):

    def test_constant_values(self):
        client = AutoRestValidationTest(
            "abc123",
            base_url="http://localhost:3000")
        client.api_version = "12-34-5678"

        client.get_with_constant_in_path()

        body = Product(child=ChildProduct())
        product = client.post_with_constant_in_body(body=body)
        self.assertIsNotNone(product)

    def test_validation(self):
        client = AutoRestValidationTest(
            "abc123",
            base_url="http://localhost:3000")
        client.api_version = "12-34-5678"

        try:
            client.validation_of_method_parameters("1", 100)
        except ValidationError as err:
            self.assertEqual(err.rule, "min_length")
            self.assertEqual(err.target, "resource_group_name")

        try:
            client.validation_of_method_parameters("1234567890A", 100)
        except ValidationError as err:
            self.assertEqual(err.rule, "max_length")
            self.assertEqual(err.target, "resource_group_name")

        try:
            client.validation_of_method_parameters("!@#$", 100)
        except ValidationError as err:
            self.assertEqual(err.rule, "pattern")
            self.assertEqual(err.target, "resource_group_name")

        try:
            client.validation_of_method_parameters("123", 105)
        except ValidationError as err:
            self.assertEqual(err.rule, "multiple")
            self.assertEqual(err.target, "id")

        try:
            client.validation_of_method_parameters("123", 0)
        except ValidationError as err:
            self.assertEqual(err.rule, "minimum")
            self.assertEqual(err.target, "id")

        try:
            client.validation_of_method_parameters("123", 2000)
        except ValidationError as err:
            self.assertEqual(err.rule, "maximum")
            self.assertEqual(err.target, "id")

        try:
            tempproduct=Product(child=ChildProduct(), capacity=0)
            client.validation_of_body("123", 150, tempproduct)
        except ValidationError as err:
            self.assertEqual(err.rule, "minimum_ex")
            self.assertIn("capacity", err.target)

        try:
            tempproduct=Product(child=ChildProduct(), capacity=100)
            client.validation_of_body("123", 150, tempproduct)
        except ValidationError as err:
            self.assertEqual(err.rule, "maximum_ex")
            self.assertIn("capacity", err.target)

        try:
            tempproduct=Product(child=ChildProduct(),
                display_names=["item1","item2","item3","item4","item5","item6","item7"])
            client.validation_of_body("123", 150, tempproduct)
        except ValidationError as err:
            self.assertEqual(err.rule, "max_items")
            self.assertIn("display_names", err.target)

        client2 = AutoRestValidationTest(
            "abc123",
            base_url="http://localhost:3000")
        client2.api_version = "abc"

        try:
            client2.validation_of_method_parameters("123", 150)
        except ValidationError as err:
            self.assertEqual(err.rule, "pattern")
            self.assertEqual(err.target, "self.api_version")


if __name__ == '__main__':
    unittest.main()
