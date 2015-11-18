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

class DurationWrapper(Model):

    _required = []

    _attribute_map = {
        'field':{'key':'field', 'type':'duration'},
    }

    def __init__(self, *args, **kwargs):

        self.field = None

        super(DurationWrapper, self).__init__(*args, **kwargs)
