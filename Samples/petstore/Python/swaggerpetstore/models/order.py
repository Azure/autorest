# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class Order(Model):
    """Order

    :param long id:
    :param long pet_id:
    :param int quantity:
    :param datetime ship_date:
    :param str status: Order Status. Possible values include: 'placed',
     'approved', 'delivered'
    :param bool complete:
    """ 

    _attribute_map = {
        'id': {'key': 'id', 'type': 'long'},
        'pet_id': {'key': 'petId', 'type': 'long'},
        'quantity': {'key': 'quantity', 'type': 'int'},
        'ship_date': {'key': 'shipDate', 'type': 'iso-8601'},
        'status': {'key': 'status', 'type': 'str'},
        'complete': {'key': 'complete', 'type': 'bool'},
    }

    def __init__(self, id=None, pet_id=None, quantity=None, ship_date=None, status=None, complete=None, **kwargs):
        self.id = id
        self.pet_id = pet_id
        self.quantity = quantity
        self.ship_date = ship_date
        self.status = status
        self.complete = complete
