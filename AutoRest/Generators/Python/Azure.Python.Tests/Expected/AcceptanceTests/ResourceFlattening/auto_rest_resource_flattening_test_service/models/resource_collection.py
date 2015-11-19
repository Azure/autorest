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

class ResourceCollection(Model):

    _required = []

    _attribute_map = {
        'productresource':{'key':'productresource', 'type':'FlattenedProduct'},
        'arrayofresources':{'key':'arrayofresources', 'type':'[FlattenedProduct]'},
        'dictionaryofresources':{'key':'dictionaryofresources', 'type':'{FlattenedProduct}'},
    }

    def __init__(self, *args, **kwargs):

        self.productresource = None
        self.arrayofresources = []
        self.dictionaryofresources = {}

        super(ResourceCollection, self).__init__(*args, **kwargs)
