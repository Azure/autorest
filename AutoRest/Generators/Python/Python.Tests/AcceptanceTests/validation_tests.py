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
from os.path import dirname, pardir, join, realpath, sep, pardir

cwd = dirname(realpath(__file__))
root = realpath(join(cwd , pardir, pardir, pardir, pardir, pardir))
sys.path.append(join(root, "ClientRuntimes" , "Python", "msrest"))
log_level = int(os.environ.get('PythonLogLevel', 10))

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "Validation"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError

from autorestvalidationtest import (
    AutoRestValidationTest,
    AutoRestValidationTestConfiguration)
from autorestvalidationtest.models import Product


class ValidationTests(unittest.TestCase):

    def test_constant_values(self):

        config = AutoRestValidationTestConfiguration(
            "abc123",
            "12-34-5678",
            base_url="http://localhost:3000")
        config.log_level = log_level
        client = AutoRestValidationTest(config)

        client.get_with_constant_in_path()
        product = client.post_with_constant_in_body(body=Product())
        self.assertIsNotNone(product)

    def test_validation(self):

        config = AutoRestValidationTestConfiguration(
            "abc123",
            "12-34-5678",
            base_url="http://localhost:3000")
        config.log_level = log_level
        client = AutoRestValidationTest(config)

        with self.assertRaises(ValueError):
            client.validation_of_method_parameters("1", 100)
    #public void ValidationTests()
    #    {
    #        SwaggerSpecRunner.RunTests(
    #            SwaggerPath("validation.json"),
    #            ExpectedPath("Validation"));
    #        var client = new AutoRestValidationTest(Fixture.Uri);
    #        client.SubscriptionId = "abc123";
    #        client.ApiVersion = "12-34-5678";
    #        var exception = Assert.Throws<ValidationException>(() => client.ValidationOfMethodParameters("1", 100));
    #        Assert.Equal(ValidationRules.MinLength, exception.Rule);
    #        Assert.Equal("resourceGroupName", exception.Target);
    #        exception = Assert.Throws<ValidationException>(() => client.ValidationOfMethodParameters("1234567890A", 100));
    #        Assert.Equal(ValidationRules.MaxLength, exception.Rule);
    #        Assert.Equal("resourceGroupName", exception.Target);
    #        exception = Assert.Throws<ValidationException>(() => client.ValidationOfMethodParameters("!@#$", 100));
    #        Assert.Equal(ValidationRules.Pattern, exception.Rule);
    #        Assert.Equal("resourceGroupName", exception.Target);
    #        exception = Assert.Throws<ValidationException>(() => client.ValidationOfMethodParameters("123", 105));
    #        Assert.Equal(ValidationRules.MultipleOf, exception.Rule);
    #        Assert.Equal("id", exception.Target);
    #        exception = Assert.Throws<ValidationException>(() => client.ValidationOfMethodParameters("123", 0));
    #        Assert.Equal(ValidationRules.InclusiveMinimum, exception.Rule);
    #        Assert.Equal("id", exception.Target);
    #        exception = Assert.Throws<ValidationException>(() => client.ValidationOfMethodParameters("123", 2000));
    #        Assert.Equal(ValidationRules.InclusiveMaximum, exception.Rule);
    #        Assert.Equal("id", exception.Target);

    #        exception = Assert.Throws<ValidationException>(() => client.ValidationOfBody("123", 150, new Fixtures.AcceptanceTestsValidation.Models.Product
    #        {
    #            Capacity = 0
    #        }));
    #        Assert.Equal(ValidationRules.ExclusiveMinimum, exception.Rule);
    #        Assert.Equal("Capacity", exception.Target);
    #        exception = Assert.Throws<ValidationException>(() => client.ValidationOfBody("123", 150, new Fixtures.AcceptanceTestsValidation.Models.Product
    #        {
    #            Capacity = 100
    #        }));
    #        Assert.Equal(ValidationRules.ExclusiveMaximum, exception.Rule);
    #        Assert.Equal("Capacity", exception.Target);
    #        exception = Assert.Throws<ValidationException>(() => client.ValidationOfBody("123", 150, new Fixtures.AcceptanceTestsValidation.Models.Product
    #        {
    #            DisplayNames = new List<string>
    #            {
    #                "item1","item2","item3","item4","item5","item6","item7"
    #            }
    #        }));
    #        Assert.Equal(ValidationRules.MaxItems, exception.Rule);
    #        Assert.Equal("DisplayNames", exception.Target);

    #        var client2 = new AutoRestValidationTest(Fixture.Uri);
    #        client2.SubscriptionId = "abc123";
    #        client2.ApiVersion = "abc";
    #        exception = Assert.Throws<ValidationException>(() => client2.ValidationOfMethodParameters("123", 150));
    #        Assert.Equal(ValidationRules.Pattern, exception.Rule);
    #        Assert.Equal("ApiVersion", exception.Target);
    #    }