#--------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for
# license information.
# 
# Code generated by Microsoft (R) AutoRest Code Generator 0.13.0.0
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.
#--------------------------------------------------------------------------

from msrest.serialization import Model
from .resource import Resource

class StorageAccount(Resource):

    _required = []

    _attribute_map = {
        'properties':{'key':'properties', 'type':'StorageAccountProperties'},
    }

    def __init__(self, *args, **kwargs):

        self.properties = None

        super(StorageAccount, self).__init__(*args, **kwargs)
