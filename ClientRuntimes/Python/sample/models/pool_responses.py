
from ..batch_response import BatchOperationResponse

class BatchPoolAddResponse(BatchOperationResponse):
    accept_status = [201]


class BatchPoolDeleteResponse(BatchOperationResponse):
    accept_status = [202]


class BatchPoolDisableAutoScaleResponse(BatchOperationResponse):
    accept_status = [202]


class BatchPoolEnableAutoScaleResponse(BatchOperationResponse):
    accept_status = [202]


class BatchPoolEvaluateAutoScaleResponse(BatchOperationResponse):
    accept_status = [202]


class BatchPoolGetResponse(BatchOperationResponse):
    accept_status = [200]

    def __init__(self, **kwargs):

        super(BatchPoolGetResponse, self).__init__()

        self.body_map.update({
            'pool': {'key':'.', 'type':'Pool'},
        })

        self.pool = None


class BatchPoolListResponse(BatchOperationResponse):
    accept_status = [200]

    def __init__(self, **kwargs):

        super(BatchPoolListResponse, self).__init__()

        self.body_map.update({
            'pools': {'key':'value', 'type':'[Pool]'},
            'next_link': {'key':'odata.nextLink', 'type':'str'},
        })

        self.pools = []
        self.next_link = None


class BatchPoolPatchResponse(BatchOperationResponse):
    accept_status = [200]


class BatchPoolResizeResponse(BatchOperationResponse):
    accept_status = [202]


class BatchPoolStopResizeResponse(BatchOperationResponse):
    accept_status = [202]


class BatchPoolUpdatePropertiesResponse(BatchOperationResponse):
    accept_status = [204]


class BatchPoolUpgradeOSResponse(BatchOperationResponse):
    accept_status = [202]