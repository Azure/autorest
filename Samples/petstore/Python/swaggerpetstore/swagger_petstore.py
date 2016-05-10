# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.service_client import ServiceClient
from msrest import Configuration, Serializer, Deserializer
from .version import VERSION
from msrest.pipeline import ClientRawResponse
from msrest.exceptions import HttpOperationError
from . import models


class SwaggerPetstoreConfiguration(Configuration):
    """Configuration for SwaggerPetstore
    Note that all parameters used to create this instance are saved as instance
    attributes.

    :param str base_url: Service URL
    :param str filepath: Existing config
    """

    def __init__(
            self, base_url=None, filepath=None):

        if not base_url:
            base_url = 'http://petstore.swagger.io/v2'

        super(SwaggerPetstoreConfiguration, self).__init__(base_url, filepath)

        self.add_user_agent('swaggerpetstore/{}'.format(VERSION))


class SwaggerPetstore(object):
    """This is a sample server Petstore server.  You can find out more about Swagger at &lt;a href="http://swagger.io"&gt;http://swagger.io&lt;/a&gt; or on irc.freenode.net, #swagger.  For this sample, you can use the api key "special-key" to test the authorization filters

    :ivar config: Configuration for client.
    :vartype config: SwaggerPetstoreConfiguration

    :param str base_url: Service URL
    :param str filepath: Existing config
    """

    def __init__(
            self, base_url=None, filepath=None):

        self.config = SwaggerPetstoreConfiguration(base_url, filepath)
        self._client = ServiceClient(None, self.config)

        client_models = {k: v for k, v in models.__dict__.items() if isinstance(v, type)}
        self._serialize = Serializer(client_models)
        self._deserialize = Deserializer(client_models)


    def add_pet_using_byte_array(
            self, body=None, custom_headers={}, raw=False, **operation_config):
        """
        Fake endpoint to test byte array in body parameter for adding a new
        pet to the store

        :param body: Pet object in the form of byte array
        :type body: str
        :param dict custom_headers: headers that will be added to the request
        :param bool raw: returns the direct response alongside the
         deserialized response
        :param operation_config: :ref:`Operation configuration
         overrides<msrest:optionsforoperations>`.
        :rtype: None
        :rtype: :class:`ClientRawResponse<msrest.pipeline.ClientRawResponse>`
         if raw=true
        """
        # Construct URL
        url = '/pet'

        # Construct parameters
        query_parameters = {}

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct body
        if body is not None:
            body_content = self._serialize.body(body, 'str')
        else:
            body_content = None

        # Construct and send request
        request = self._client.post(url, query_parameters)
        response = self._client.send(
            request, header_parameters, body_content, **operation_config)

        if response.status_code not in [405]:
            raise HttpOperationError(self._deserialize, response)

        if raw:
            client_raw_response = ClientRawResponse(None, response)
            return client_raw_response

    def add_pet(
            self, body=None, custom_headers={}, raw=False, **operation_config):
        """
        Add a new pet to the store

        :param body: Pet object that needs to be added to the store
        :type body: :class:`Pet <petstore.models.Pet>`
        :param dict custom_headers: headers that will be added to the request
        :param bool raw: returns the direct response alongside the
         deserialized response
        :param operation_config: :ref:`Operation configuration
         overrides<msrest:optionsforoperations>`.
        :rtype: None
        :rtype: :class:`ClientRawResponse<msrest.pipeline.ClientRawResponse>`
         if raw=true
        """
        # Construct URL
        url = '/pet'

        # Construct parameters
        query_parameters = {}

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct body
        if body is not None:
            body_content = self._serialize.body(body, 'Pet')
        else:
            body_content = None

        # Construct and send request
        request = self._client.post(url, query_parameters)
        response = self._client.send(
            request, header_parameters, body_content, **operation_config)

        if response.status_code not in [405]:
            raise HttpOperationError(self._deserialize, response)

        if raw:
            client_raw_response = ClientRawResponse(None, response)
            return client_raw_response

    def update_pet(
            self, body=None, custom_headers={}, raw=False, **operation_config):
        """
        Update an existing pet

        :param body: Pet object that needs to be added to the store
        :type body: :class:`Pet <petstore.models.Pet>`
        :param dict custom_headers: headers that will be added to the request
        :param bool raw: returns the direct response alongside the
         deserialized response
        :param operation_config: :ref:`Operation configuration
         overrides<msrest:optionsforoperations>`.
        :rtype: None
        :rtype: :class:`ClientRawResponse<msrest.pipeline.ClientRawResponse>`
         if raw=true
        """
        # Construct URL
        url = '/pet'

        # Construct parameters
        query_parameters = {}

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct body
        if body is not None:
            body_content = self._serialize.body(body, 'Pet')
        else:
            body_content = None

        # Construct and send request
        request = self._client.put(url, query_parameters)
        response = self._client.send(
            request, header_parameters, body_content, **operation_config)

        if response.status_code not in [405, 404, 400]:
            raise HttpOperationError(self._deserialize, response)

        if raw:
            client_raw_response = ClientRawResponse(None, response)
            return client_raw_response

    def find_pets_by_status(
            self, status=None, custom_headers={}, raw=False, **operation_config):
        """
        Finds Pets by status
        Multiple status values can be provided with comma seperated strings

        :param status: Status values that need to be considered for filter
        :type status: list of str
        :param dict custom_headers: headers that will be added to the request
        :param bool raw: returns the direct response alongside the
         deserialized response
        :param operation_config: :ref:`Operation configuration
         overrides<msrest:optionsforoperations>`.
        :rtype: list of :class:`Pet <petstore.models.Pet>`
        :rtype: :class:`ClientRawResponse<msrest.pipeline.ClientRawResponse>`
         if raw=true
        """
        # Construct URL
        url = '/pet/findByStatus'

        # Construct parameters
        query_parameters = {}
        if status is not None:
            query_parameters['status'] = self._serialize.query("status", status, '[str]', div=',')

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct and send request
        request = self._client.get(url, query_parameters)
        response = self._client.send(request, header_parameters, **operation_config)

        if response.status_code not in [200, 400]:
            raise HttpOperationError(self._deserialize, response)

        deserialized = None

        if response.status_code == 200:
            deserialized = self._deserialize('[Pet]', response)

        if raw:
            client_raw_response = ClientRawResponse(deserialized, response)
            return client_raw_response

        return deserialized

    def find_pets_by_tags(
            self, tags=None, custom_headers={}, raw=False, **operation_config):
        """
        Finds Pets by tags
        Muliple tags can be provided with comma seperated strings. Use tag1,
        tag2, tag3 for testing.

        :param tags: Tags to filter by
        :type tags: list of str
        :param dict custom_headers: headers that will be added to the request
        :param bool raw: returns the direct response alongside the
         deserialized response
        :param operation_config: :ref:`Operation configuration
         overrides<msrest:optionsforoperations>`.
        :rtype: list of :class:`Pet <petstore.models.Pet>`
        :rtype: :class:`ClientRawResponse<msrest.pipeline.ClientRawResponse>`
         if raw=true
        """
        # Construct URL
        url = '/pet/findByTags'

        # Construct parameters
        query_parameters = {}
        if tags is not None:
            query_parameters['tags'] = self._serialize.query("tags", tags, '[str]', div=',')

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct and send request
        request = self._client.get(url, query_parameters)
        response = self._client.send(request, header_parameters, **operation_config)

        if response.status_code not in [200, 400]:
            raise HttpOperationError(self._deserialize, response)

        deserialized = None

        if response.status_code == 200:
            deserialized = self._deserialize('[Pet]', response)

        if raw:
            client_raw_response = ClientRawResponse(deserialized, response)
            return client_raw_response

        return deserialized

    def find_pets_with_byte_array(
            self, pet_id, custom_headers={}, raw=False, **operation_config):
        """
        Fake endpoint to test byte array return by 'Find pet by ID'
        Returns a pet when ID < 10.  ID > 10 or nonintegers will simulate API
        error conditions

        :param pet_id: ID of pet that needs to be fetched
        :type pet_id: long
        :param dict custom_headers: headers that will be added to the request
        :param bool raw: returns the direct response alongside the
         deserialized response
        :param operation_config: :ref:`Operation configuration
         overrides<msrest:optionsforoperations>`.
        :rtype: str
        :rtype: :class:`ClientRawResponse<msrest.pipeline.ClientRawResponse>`
         if raw=true
        """
        # Construct URL
        url = '/pet/{petId}'
        path_format_arguments = {
            'petId': self._serialize.url("pet_id", pet_id, 'long')
        }
        url = self._client.format_url(url, **path_format_arguments)

        # Construct parameters
        query_parameters = {}

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct and send request
        request = self._client.get(url, query_parameters)
        response = self._client.send(request, header_parameters, **operation_config)

        if response.status_code not in [404, 200, 400]:
            raise HttpOperationError(self._deserialize, response)

        deserialized = None

        if response.status_code == 200:
            deserialized = self._deserialize('str', response)

        if raw:
            client_raw_response = ClientRawResponse(deserialized, response)
            return client_raw_response

        return deserialized

    def get_pet_by_id(
            self, pet_id, custom_headers={}, raw=False, **operation_config):
        """
        Find pet by ID
        Returns a pet when ID < 10.  ID > 10 or nonintegers will simulate API
        error conditions

        :param pet_id: ID of pet that needs to be fetched
        :type pet_id: long
        :param dict custom_headers: headers that will be added to the request
        :param bool raw: returns the direct response alongside the
         deserialized response
        :param operation_config: :ref:`Operation configuration
         overrides<msrest:optionsforoperations>`.
        :rtype: :class:`Pet <petstore.models.Pet>`
        :rtype: :class:`ClientRawResponse<msrest.pipeline.ClientRawResponse>`
         if raw=true
        """
        # Construct URL
        url = '/pet/{petId}'
        path_format_arguments = {
            'petId': self._serialize.url("pet_id", pet_id, 'long')
        }
        url = self._client.format_url(url, **path_format_arguments)

        # Construct parameters
        query_parameters = {}

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct and send request
        request = self._client.get(url, query_parameters)
        response = self._client.send(request, header_parameters, **operation_config)

        if response.status_code not in [404, 200, 400]:
            raise HttpOperationError(self._deserialize, response)

        deserialized = None

        if response.status_code == 200:
            deserialized = self._deserialize('Pet', response)

        if raw:
            client_raw_response = ClientRawResponse(deserialized, response)
            return client_raw_response

        return deserialized

    def update_pet_with_form(
            self, pet_id, name=None, status=None, custom_headers={}, raw=False, **operation_config):
        """
        Updates a pet in the store with form data

        :param pet_id: ID of pet that needs to be updated
        :type pet_id: str
        :param name: Updated name of the pet
        :type name: str
        :param status: Updated status of the pet
        :type status: str
        :param dict custom_headers: headers that will be added to the request
        :param bool raw: returns the direct response alongside the
         deserialized response
        :param operation_config: :ref:`Operation configuration
         overrides<msrest:optionsforoperations>`.
        :rtype: None
        :rtype: :class:`ClientRawResponse<msrest.pipeline.ClientRawResponse>`
         if raw=true
        """
        # Construct URL
        url = '/pet/{petId}'
        path_format_arguments = {
            'petId': self._serialize.url("pet_id", pet_id, 'str')
        }
        url = self._client.format_url(url, **path_format_arguments)

        # Construct parameters
        query_parameters = {}

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/x-www-form-urlencoded'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct form data
        form_data_content = {
            'name': name,
            'status': status,
        }

        # Construct and send request
        request = self._client.post(url, query_parameters)
        response = self._client.send_formdata(
            request, header_parameters, form_data_content, **operation_config)

        if response.status_code not in [405]:
            raise HttpOperationError(self._deserialize, response)

        if raw:
            client_raw_response = ClientRawResponse(None, response)
            return client_raw_response

    def delete_pet(
            self, pet_id, api_key=None, custom_headers={}, raw=False, **operation_config):
        """
        Deletes a pet

        :param pet_id: Pet id to delete
        :type pet_id: long
        :param api_key:
        :type api_key: str
        :param dict custom_headers: headers that will be added to the request
        :param bool raw: returns the direct response alongside the
         deserialized response
        :param operation_config: :ref:`Operation configuration
         overrides<msrest:optionsforoperations>`.
        :rtype: None
        :rtype: :class:`ClientRawResponse<msrest.pipeline.ClientRawResponse>`
         if raw=true
        """
        # Construct URL
        url = '/pet/{petId}'
        path_format_arguments = {
            'petId': self._serialize.url("pet_id", pet_id, 'long')
        }
        url = self._client.format_url(url, **path_format_arguments)

        # Construct parameters
        query_parameters = {}

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)
        if api_key is not None:
            header_parameters['api_key'] = self._serialize.header("api_key", api_key, 'str')

        # Construct and send request
        request = self._client.delete(url, query_parameters)
        response = self._client.send(request, header_parameters, **operation_config)

        if response.status_code not in [400]:
            raise HttpOperationError(self._deserialize, response)

        if raw:
            client_raw_response = ClientRawResponse(None, response)
            return client_raw_response

    def upload_file(
            self, pet_id, additional_metadata=None, file=None, custom_headers={}, raw=False, **operation_config):
        """
        uploads an image

        :param pet_id: ID of pet to update
        :type pet_id: long
        :param additional_metadata: Additional data to pass to server
        :type additional_metadata: str
        :param file: file to upload
        :type file: Generator
        :param dict custom_headers: headers that will be added to the request
        :param bool raw: returns the direct response alongside the
         deserialized response
        :param operation_config: :ref:`Operation configuration
         overrides<msrest:optionsforoperations>`.
        :rtype: None
        :rtype: :class:`ClientRawResponse<msrest.pipeline.ClientRawResponse>`
         if raw=true
        """
        # Construct URL
        url = '/pet/{petId}/uploadImage'
        path_format_arguments = {
            'petId': self._serialize.url("pet_id", pet_id, 'long')
        }
        url = self._client.format_url(url, **path_format_arguments)

        # Construct parameters
        query_parameters = {}

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'multipart/form-data'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct form data
        form_data_content = {
            'additionalMetadata': additional_metadata,
            'file': file,
        }

        # Construct and send request
        request = self._client.post(url, query_parameters)
        response = self._client.send_formdata(
            request, header_parameters, form_data_content, **operation_config)

        if response.status_code < 200 or response.status_code >= 300:
            raise HttpOperationError(self._deserialize, response)

        if raw:
            client_raw_response = ClientRawResponse(None, response)
            return client_raw_response

    def get_inventory(
            self, custom_headers={}, raw=False, **operation_config):
        """
        Returns pet inventories by status
        Returns a map of status codes to quantities

        :param dict custom_headers: headers that will be added to the request
        :param bool raw: returns the direct response alongside the
         deserialized response
        :param operation_config: :ref:`Operation configuration
         overrides<msrest:optionsforoperations>`.
        :rtype: dict
        :rtype: :class:`ClientRawResponse<msrest.pipeline.ClientRawResponse>`
         if raw=true
        """
        # Construct URL
        url = '/store/inventory'

        # Construct parameters
        query_parameters = {}

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct and send request
        request = self._client.get(url, query_parameters)
        response = self._client.send(request, header_parameters, **operation_config)

        if response.status_code not in [200]:
            raise HttpOperationError(self._deserialize, response)

        deserialized = None

        if response.status_code == 200:
            deserialized = self._deserialize('{int}', response)

        if raw:
            client_raw_response = ClientRawResponse(deserialized, response)
            return client_raw_response

        return deserialized

    def place_order(
            self, body=None, custom_headers={}, raw=False, **operation_config):
        """
        Place an order for a pet

        :param body: order placed for purchasing the pet
        :type body: :class:`Order <petstore.models.Order>`
        :param dict custom_headers: headers that will be added to the request
        :param bool raw: returns the direct response alongside the
         deserialized response
        :param operation_config: :ref:`Operation configuration
         overrides<msrest:optionsforoperations>`.
        :rtype: :class:`Order <petstore.models.Order>`
        :rtype: :class:`ClientRawResponse<msrest.pipeline.ClientRawResponse>`
         if raw=true
        """
        # Construct URL
        url = '/store/order'

        # Construct parameters
        query_parameters = {}

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct body
        if body is not None:
            body_content = self._serialize.body(body, 'Order')
        else:
            body_content = None

        # Construct and send request
        request = self._client.post(url, query_parameters)
        response = self._client.send(
            request, header_parameters, body_content, **operation_config)

        if response.status_code not in [200, 400]:
            raise HttpOperationError(self._deserialize, response)

        deserialized = None

        if response.status_code == 200:
            deserialized = self._deserialize('Order', response)

        if raw:
            client_raw_response = ClientRawResponse(deserialized, response)
            return client_raw_response

        return deserialized

    def get_order_by_id(
            self, order_id, custom_headers={}, raw=False, **operation_config):
        """
        Find purchase order by ID
        For valid response try integer IDs with value <= 5 or > 10. Other
        values will generated exceptions

        :param order_id: ID of pet that needs to be fetched
        :type order_id: str
        :param dict custom_headers: headers that will be added to the request
        :param bool raw: returns the direct response alongside the
         deserialized response
        :param operation_config: :ref:`Operation configuration
         overrides<msrest:optionsforoperations>`.
        :rtype: :class:`Order <petstore.models.Order>`
        :rtype: :class:`ClientRawResponse<msrest.pipeline.ClientRawResponse>`
         if raw=true
        """
        # Construct URL
        url = '/store/order/{orderId}'
        path_format_arguments = {
            'orderId': self._serialize.url("order_id", order_id, 'str')
        }
        url = self._client.format_url(url, **path_format_arguments)

        # Construct parameters
        query_parameters = {}

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct and send request
        request = self._client.get(url, query_parameters)
        response = self._client.send(request, header_parameters, **operation_config)

        if response.status_code not in [404, 200, 400]:
            raise HttpOperationError(self._deserialize, response)

        deserialized = None

        if response.status_code == 200:
            deserialized = self._deserialize('Order', response)

        if raw:
            client_raw_response = ClientRawResponse(deserialized, response)
            return client_raw_response

        return deserialized

    def delete_order(
            self, order_id, custom_headers={}, raw=False, **operation_config):
        """
        Delete purchase order by ID
        For valid response try integer IDs with value < 1000. Anything above
        1000 or nonintegers will generate API errors

        :param order_id: ID of the order that needs to be deleted
        :type order_id: str
        :param dict custom_headers: headers that will be added to the request
        :param bool raw: returns the direct response alongside the
         deserialized response
        :param operation_config: :ref:`Operation configuration
         overrides<msrest:optionsforoperations>`.
        :rtype: None
        :rtype: :class:`ClientRawResponse<msrest.pipeline.ClientRawResponse>`
         if raw=true
        """
        # Construct URL
        url = '/store/order/{orderId}'
        path_format_arguments = {
            'orderId': self._serialize.url("order_id", order_id, 'str')
        }
        url = self._client.format_url(url, **path_format_arguments)

        # Construct parameters
        query_parameters = {}

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct and send request
        request = self._client.delete(url, query_parameters)
        response = self._client.send(request, header_parameters, **operation_config)

        if response.status_code not in [404, 400]:
            raise HttpOperationError(self._deserialize, response)

        if raw:
            client_raw_response = ClientRawResponse(None, response)
            return client_raw_response

    def create_user(
            self, body=None, custom_headers={}, raw=False, **operation_config):
        """
        Create user
        This can only be done by the logged in user.

        :param body: Created user object
        :type body: :class:`User <petstore.models.User>`
        :param dict custom_headers: headers that will be added to the request
        :param bool raw: returns the direct response alongside the
         deserialized response
        :param operation_config: :ref:`Operation configuration
         overrides<msrest:optionsforoperations>`.
        :rtype: None
        :rtype: :class:`ClientRawResponse<msrest.pipeline.ClientRawResponse>`
         if raw=true
        """
        # Construct URL
        url = '/user'

        # Construct parameters
        query_parameters = {}

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct body
        if body is not None:
            body_content = self._serialize.body(body, 'User')
        else:
            body_content = None

        # Construct and send request
        request = self._client.post(url, query_parameters)
        response = self._client.send(
            request, header_parameters, body_content, **operation_config)

        if response.status_code < 200 or response.status_code >= 300:
            raise HttpOperationError(self._deserialize, response)

        if raw:
            client_raw_response = ClientRawResponse(None, response)
            return client_raw_response

    def create_users_with_array_input(
            self, body=None, custom_headers={}, raw=False, **operation_config):
        """
        Creates list of users with given input array

        :param body: List of user object
        :type body: list of :class:`User <petstore.models.User>`
        :param dict custom_headers: headers that will be added to the request
        :param bool raw: returns the direct response alongside the
         deserialized response
        :param operation_config: :ref:`Operation configuration
         overrides<msrest:optionsforoperations>`.
        :rtype: None
        :rtype: :class:`ClientRawResponse<msrest.pipeline.ClientRawResponse>`
         if raw=true
        """
        # Construct URL
        url = '/user/createWithArray'

        # Construct parameters
        query_parameters = {}

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct body
        if body is not None:
            body_content = self._serialize.body(body, '[User]')
        else:
            body_content = None

        # Construct and send request
        request = self._client.post(url, query_parameters)
        response = self._client.send(
            request, header_parameters, body_content, **operation_config)

        if response.status_code < 200 or response.status_code >= 300:
            raise HttpOperationError(self._deserialize, response)

        if raw:
            client_raw_response = ClientRawResponse(None, response)
            return client_raw_response

    def create_users_with_list_input(
            self, body=None, custom_headers={}, raw=False, **operation_config):
        """
        Creates list of users with given input array

        :param body: List of user object
        :type body: list of :class:`User <petstore.models.User>`
        :param dict custom_headers: headers that will be added to the request
        :param bool raw: returns the direct response alongside the
         deserialized response
        :param operation_config: :ref:`Operation configuration
         overrides<msrest:optionsforoperations>`.
        :rtype: None
        :rtype: :class:`ClientRawResponse<msrest.pipeline.ClientRawResponse>`
         if raw=true
        """
        # Construct URL
        url = '/user/createWithList'

        # Construct parameters
        query_parameters = {}

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct body
        if body is not None:
            body_content = self._serialize.body(body, '[User]')
        else:
            body_content = None

        # Construct and send request
        request = self._client.post(url, query_parameters)
        response = self._client.send(
            request, header_parameters, body_content, **operation_config)

        if response.status_code < 200 or response.status_code >= 300:
            raise HttpOperationError(self._deserialize, response)

        if raw:
            client_raw_response = ClientRawResponse(None, response)
            return client_raw_response

    def login_user(
            self, username=None, password=None, custom_headers={}, raw=False, **operation_config):
        """
        Logs user into the system

        :param username: The user name for login
        :type username: str
        :param password: The password for login in clear text
        :type password: str
        :param dict custom_headers: headers that will be added to the request
        :param bool raw: returns the direct response alongside the
         deserialized response
        :param operation_config: :ref:`Operation configuration
         overrides<msrest:optionsforoperations>`.
        :rtype: str
        :rtype: :class:`ClientRawResponse<msrest.pipeline.ClientRawResponse>`
         if raw=true
        """
        # Construct URL
        url = '/user/login'

        # Construct parameters
        query_parameters = {}
        if username is not None:
            query_parameters['username'] = self._serialize.query("username", username, 'str')
        if password is not None:
            query_parameters['password'] = self._serialize.query("password", password, 'str')

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct and send request
        request = self._client.get(url, query_parameters)
        response = self._client.send(request, header_parameters, **operation_config)

        if response.status_code not in [200, 400]:
            raise HttpOperationError(self._deserialize, response)

        deserialized = None

        if response.status_code == 200:
            deserialized = self._deserialize('str', response)

        if raw:
            client_raw_response = ClientRawResponse(deserialized, response)
            return client_raw_response

        return deserialized

    def logout_user(
            self, custom_headers={}, raw=False, **operation_config):
        """
        Logs out current logged in user session

        :param dict custom_headers: headers that will be added to the request
        :param bool raw: returns the direct response alongside the
         deserialized response
        :param operation_config: :ref:`Operation configuration
         overrides<msrest:optionsforoperations>`.
        :rtype: None
        :rtype: :class:`ClientRawResponse<msrest.pipeline.ClientRawResponse>`
         if raw=true
        """
        # Construct URL
        url = '/user/logout'

        # Construct parameters
        query_parameters = {}

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct and send request
        request = self._client.get(url, query_parameters)
        response = self._client.send(request, header_parameters, **operation_config)

        if response.status_code < 200 or response.status_code >= 300:
            raise HttpOperationError(self._deserialize, response)

        if raw:
            client_raw_response = ClientRawResponse(None, response)
            return client_raw_response

    def get_user_by_name(
            self, username, custom_headers={}, raw=False, **operation_config):
        """
        Get user by user name

        :param username: The name that needs to be fetched. Use user1 for
         testing.
        :type username: str
        :param dict custom_headers: headers that will be added to the request
        :param bool raw: returns the direct response alongside the
         deserialized response
        :param operation_config: :ref:`Operation configuration
         overrides<msrest:optionsforoperations>`.
        :rtype: :class:`User <petstore.models.User>`
        :rtype: :class:`ClientRawResponse<msrest.pipeline.ClientRawResponse>`
         if raw=true
        """
        # Construct URL
        url = '/user/{username}'
        path_format_arguments = {
            'username': self._serialize.url("username", username, 'str')
        }
        url = self._client.format_url(url, **path_format_arguments)

        # Construct parameters
        query_parameters = {}

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct and send request
        request = self._client.get(url, query_parameters)
        response = self._client.send(request, header_parameters, **operation_config)

        if response.status_code not in [404, 200, 400]:
            raise HttpOperationError(self._deserialize, response)

        deserialized = None

        if response.status_code == 200:
            deserialized = self._deserialize('User', response)

        if raw:
            client_raw_response = ClientRawResponse(deserialized, response)
            return client_raw_response

        return deserialized

    def update_user(
            self, username, body=None, custom_headers={}, raw=False, **operation_config):
        """
        Updated user
        This can only be done by the logged in user.

        :param username: name that need to be deleted
        :type username: str
        :param body: Updated user object
        :type body: :class:`User <petstore.models.User>`
        :param dict custom_headers: headers that will be added to the request
        :param bool raw: returns the direct response alongside the
         deserialized response
        :param operation_config: :ref:`Operation configuration
         overrides<msrest:optionsforoperations>`.
        :rtype: None
        :rtype: :class:`ClientRawResponse<msrest.pipeline.ClientRawResponse>`
         if raw=true
        """
        # Construct URL
        url = '/user/{username}'
        path_format_arguments = {
            'username': self._serialize.url("username", username, 'str')
        }
        url = self._client.format_url(url, **path_format_arguments)

        # Construct parameters
        query_parameters = {}

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct body
        if body is not None:
            body_content = self._serialize.body(body, 'User')
        else:
            body_content = None

        # Construct and send request
        request = self._client.put(url, query_parameters)
        response = self._client.send(
            request, header_parameters, body_content, **operation_config)

        if response.status_code not in [404, 400]:
            raise HttpOperationError(self._deserialize, response)

        if raw:
            client_raw_response = ClientRawResponse(None, response)
            return client_raw_response

    def delete_user(
            self, username, custom_headers={}, raw=False, **operation_config):
        """
        Delete user
        This can only be done by the logged in user.

        :param username: The name that needs to be deleted
        :type username: str
        :param dict custom_headers: headers that will be added to the request
        :param bool raw: returns the direct response alongside the
         deserialized response
        :param operation_config: :ref:`Operation configuration
         overrides<msrest:optionsforoperations>`.
        :rtype: None
        :rtype: :class:`ClientRawResponse<msrest.pipeline.ClientRawResponse>`
         if raw=true
        """
        # Construct URL
        url = '/user/{username}'
        path_format_arguments = {
            'username': self._serialize.url("username", username, 'str')
        }
        url = self._client.format_url(url, **path_format_arguments)

        # Construct parameters
        query_parameters = {}

        # Construct headers
        header_parameters = {}
        header_parameters['Content-Type'] = 'application/json; charset=utf-8'
        if custom_headers:
            header_parameters.update(custom_headers)

        # Construct and send request
        request = self._client.delete(url, query_parameters)
        response = self._client.send(request, header_parameters, **operation_config)

        if response.status_code not in [404, 400]:
            raise HttpOperationError(self._deserialize, response)

        if raw:
            client_raw_response = ClientRawResponse(None, response)
            return client_raw_response
