# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class Order(Model):
    """Order.

    Variables are only populated by the server, and will be ignored when
    sending a request.

    :ivar id:
    :vartype id: long
    :param pet_id:
    :type pet_id: long
    :param quantity:
    :type quantity: int
    :param ship_date:
    :type ship_date: datetime
    :param status: Order Status. Possible values include: 'placed',
     'approved', 'delivered'
    :type status: str
    :param complete:
    :type complete: bool
    """ 

    _validation = {
        'id': {'readonly': True},
    }

    _attribute_map = {
        'id': {'key': 'id', 'type': 'long'},
        'pet_id': {'key': 'petId', 'type': 'long'},
        'quantity': {'key': 'quantity', 'type': 'int'},
        'ship_date': {'key': 'shipDate', 'type': 'iso-8601'},
        'status': {'key': 'status', 'type': 'str'},
        'complete': {'key': 'complete', 'type': 'bool'},
    }

    def __init__(self, pet_id=None, quantity=None, ship_date=None, status=None, complete=None):
        self.id = None
        self.pet_id = pet_id
        self.quantity = quantity
        self.ship_date = ship_date
        self.status = status
        self.complete = complete
