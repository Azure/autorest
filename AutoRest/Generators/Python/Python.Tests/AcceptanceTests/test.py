import sys

#sys.path.append("D:\\Github\\autorest\\ClientRuntimes\\Python\\msrest")
#sys.path.append("D:\\Github\\autorest\\AutoRest\\Generators\\Python\\Python.Tests\\Expected\\AcceptanceTests\\BodyBoolean\\auto_rest_bool_test_service")

from auto_rest_swagger_bat_array_service import AutoRestSwaggerBATArrayService, AutoRestSwaggerBATArrayServiceConfiguration

from auto_rest_bool_test_service import (
    AutoRestBoolTestService,
    AutoRestBoolTestServiceConfiguration
    )

from auto_rest_bool_test_service.models import ErrorException

c = AutoRestBoolTestServiceConfiguration("http://localhost:3000")
c.log_level = 10

client = AutoRestBoolTestService(c)
print("getting false")
client.bool_model.put_false(False)
print(client.bool_model.put_true(True))

config = AutoRestSwaggerBATArrayServiceConfiguration("http://localhost:3000")
config.log_level = 10
client = AutoRestSwaggerBATArrayService(config)
a = client.array.get_array_empty()
b = client.array.get_array_null()
client.array.put_empty([])
cc = client.array.get_boolean_tfft()
client.array.put_boolean_tfft([True, False, False, True])
d = client.array.get_integer_valid()

print('Hello World')
