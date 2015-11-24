import unittest
import subprocess
import sys
import isodate
from datetime import date, datetime, timedelta
from os.path import dirname, pardir, join, realpath, sep, pardir

cwd = dirname(realpath(__file__))
root = realpath(join(cwd , pardir, pardir, pardir, pardir, pardir))
sys.path.append(join(root, "ClientRuntimes" , "Python", "msrest"))

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "RequiredOptional"))

from msrest.exceptions import DeserializationError, SerializationError

from auto_rest_required_optional_test_service import (
    AutoRestRequiredOptionalTestService,
    AutoRestRequiredOptionalTestServiceConfiguration)

from auto_rest_required_optional_test_service.models import StringWrapper, ArrayWrapper, ClassWrapper


class RequiredOptionalTests(unittest.TestCase):

    @classmethod
    def setUpClass(cls):

        config = AutoRestRequiredOptionalTestServiceConfiguration(
            "required_path",
            "required_query",
            base_url="http://localhost:3000")

        config.log_level = 10
        cls.client = AutoRestRequiredOptionalTestService(config)
        return super(RequiredOptionalTests, cls).setUpClass()

    def test_required_optional(self):

        self.client.config.required_global_path = "required_path"
        self.client.config.required_global_query = "required_query"

        self.client.implicit.put_optional_query(None)
        self.client.implicit.put_optional_body(None)
        self.client.implicit.put_optional_header(None)

        self.client.implicit.get_optional_global_query(None)

        self.client.explicit.post_optional_integer_parameter(None)
        self.client.explicit.post_optional_integer_property(None)
        self.client.explicit.post_optional_integer_header(None)

        self.client.explicit.post_optional_string_parameter(None)
        self.client.explicit.post_optional_string_property(None)
        self.client.explicit.post_optional_string_header(None)

        self.client.explicit.post_optional_class_parameter(None)
        self.client.explicit.post_optional_class_property(None)

        self.client.explicit.post_optional_array_parameter(None)
        self.client.explicit.post_optional_array_property(None)
        self.client.explicit.post_optional_array_header(None)

    def test_required_optional_negative(self):

        self.client.config.required_global_path = None
        self.client.config.required_global_query = None

        with self.assertRaises(ValueError):
            self.client.implicit.get_required_path(None)

        with self.assertRaises(ValueError):
            self.client.explicit.post_required_string_header(None)

        # TODO need check body parameter
        #with self.assertRaises(ValueError):
        #    self.client.explicit.post_required_string_parameter(None)

        with self.assertRaises(SerializationError):
            self.client.explicit.post_required_string_property(None)

        # TODO, is ValueError or TypeError, should check the None first
        with self.assertRaises(TypeError):
            self.client.explicit.post_required_array_header(None)

        # TODO, need check body parameter
        #with self.assertRaises(TypeError):
        #    self.client.explicit.post_required_array_parameter(None)

        with self.assertRaises(SerializationError):
            self.client.explicit.post_required_array_property(None)

        # TODO need check body parameter
        #with self.assertRaises(ValueError):
        #    self.client.explicit.post_required_class_parameter(None)

        cw = ClassWrapper(value = None)
        with self.assertRaises(SerializationError):
            self.client.explicit.post_required_class_property(cw)

        with self.assertRaises(ValueError):
            self.client.implicit.get_required_global_path()

        with self.assertRaises(ValueError):
            self.client.implicit.get_required_global_query()


if __name__ == '__main__':
    
    
    unittest.main()