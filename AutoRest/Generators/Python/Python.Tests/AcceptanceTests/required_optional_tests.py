import unittest
import subprocess
import sys
import isodate
from datetime import date, datetime, timedelta
from os.path import dirname, pardir, join, realpath, sep, pardir

cwd = dirname(realpath(__file__))
sys.path.append(cwd + sep + pardir + sep + pardir + sep + pardir + sep + pardir + sep + pardir + sep + "ClientRuntimes" + sep + "Python" + sep + "msrest")

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "RequiredOptional"))

from msrest.exceptions import DeserializationError

from auto_rest_required_optional_test_service import (
    AutoRestRequiredOptionalTestService,
    AutoRestRequiredOptionalTestServiceConfiguration)

from auto_rest_required_optional_test_service.models import (
    ArrayOptionalWrapper,
    ArrayWrapper,
    ClassOptionalWrapper,
    ClassWrapper,
    ErrorException,
    IntOptionalWrapper,
    IntWrapper,
    Product,
    StringOptionalWrapper,
    StringWrapper)


class RequiredOptionalTests(unittest.TestCase):

    def test_required_optional(self):

        config = AutoRestRequiredOptionalTestServiceConfiguration(
            "required_path",
            "required_query",
            "http://localhost:3000")

        config.log_level = 10
        client = AutoRestRequiredOptionalTestService(config)

        client.implicit.put_optional_query(None)
        client.implicit.put_optional_body(None)
        client.implicit.put_optional_header(None)

        # TODO
        #client.implicit.get_optional_global_query(None)

        client.explicit.post_optional_integer_parameter(None)
        client.explicit.post_optional_integer_property(None)
        client.explicit.post_optional_integer_header(None)

        client.explicit.post_optional_string_parameter(None)
        client.explicit.post_optional_string_property(None)
        client.explicit.post_optional_string_header(None)

        client.explicit.post_optional_class_parameter(None)
        client.explicit.post_optional_class_property(None)

        client.explicit.post_optional_array_parameter(None)
        client.explicit.post_optional_array_property(None)
        client.explicit.post_optional_array_header(None)

    def test_required_optional_negative(self):

        config = AutoRestRequiredOptionalTestServiceConfiguration(
            None,
            None,
            "http://localhost:3000")

        config.log_level = 10
        client = AutoRestRequiredOptionalTestService(config)

        with self.assertRaises(ValueError):
            client.implicit.get_required_path(None)

        # TODO
        #with self.assertRaises(ValueError):
        #    client.explicit.post_required_string_header(None)

        # TODO
        #with self.assertRaises(ValueError):
        #    client.explicit.post_required_string_parameter(None)

        # TODO
        #with self.assertRaises(ValueError):
        #    client.explicit.post_required_string_property(None)

        # TODO
        #with self.assertRaises(ValueError):
        #    client.explicit.post_required_array_header(None)

        # TODO
        #with self.assertRaises(ValueError):
        #    client.explicit.post_required_array_parameter(None)

        # TODO
        #with self.assertRaises(ValueError):
        #    client.explicit.post_required_array_property(None)

        # TODO
        #with self.assertRaises(ValueError):
        #    client.explicit.post_required_class_parameter(None)

        # TODO
        #with self.assertRaises(ValueError):
        #    client.explicit.post_required_class_property(None)

        with self.assertRaises(ValueError):
            client.implicit.get_required_global_path()

        with self.assertRaises(ValueError):
            client.implicit.get_required_global_query()


if __name__ == '__main__':
    
    
    unittest.main()