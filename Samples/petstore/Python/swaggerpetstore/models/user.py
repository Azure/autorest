# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class User(Model):
    """User.

    :param id:
    :type id: long
    :param username:
    :type username: str
    :param first_name:
    :type first_name: str
    :param last_name:
    :type last_name: str
    :param email:
    :type email: str
    :param password:
    :type password: str
    :param phone:
    :type phone: str
    :param user_status: User Status
    :type user_status: int
    """ 

    _attribute_map = {
        'id': {'key': 'id', 'type': 'long'},
        'username': {'key': 'username', 'type': 'str'},
        'first_name': {'key': 'firstName', 'type': 'str'},
        'last_name': {'key': 'lastName', 'type': 'str'},
        'email': {'key': 'email', 'type': 'str'},
        'password': {'key': 'password', 'type': 'str'},
        'phone': {'key': 'phone', 'type': 'str'},
        'user_status': {'key': 'userStatus', 'type': 'int'},
    }

    def __init__(self, id=None, username=None, first_name=None, last_name=None, email=None, password=None, phone=None, user_status=None):
        self.id = id
        self.username = username
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
        self.password = password
        self.phone = phone
        self.user_status = user_status
