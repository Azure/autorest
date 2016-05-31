# encoding: utf-8

module Petstore
  #
  # A service client - single point of access to the REST API.
  #
  class SwaggerPetstore < MsRest::ServiceClient

    # @return [String] the base URI of the service.
    attr_accessor :base_url

    #
    # Creates initializes a new instance of the SwaggerPetstore class.
    # @param credentials [MsRest::ServiceClientCredentials] credentials to authorize HTTP requests made by the service client.
    # @param base_url [String] the base URI of the service.
    # @param options [Array] filters to be applied to the HTTP requests.
    #
    def initialize(credentials, base_url = nil, options = nil)
      super(credentials, options)
      @base_url = base_url || 'http://petstore.swagger.io/v2'

      fail ArgumentError, 'credentials is nil' if credentials.nil?
      fail ArgumentError, 'invalid type of credentials input parameter' unless credentials.is_a?(MsRest::ServiceClientCredentials)
      @credentials = credentials

    end

    #
    # Fake endpoint to test byte array in body parameter for adding a new pet to
    # the store
    #
    # @param body [String] Pet object in the form of byte array
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    #
    def add_pet_using_byte_array(body = nil, custom_headers = nil)
      response = add_pet_using_byte_array_async(body, custom_headers).value!
      nil
    end

    #
    # Fake endpoint to test byte array in body parameter for adding a new pet to
    # the store
    #
    # @param body [String] Pet object in the form of byte array
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] HTTP response information.
    #
    def add_pet_using_byte_array_with_http_info(body = nil, custom_headers = nil)
      add_pet_using_byte_array_async(body, custom_headers).value!
    end

    #
    # Fake endpoint to test byte array in body parameter for adding a new pet to
    # the store
    #
    # @param body [String] Pet object in the form of byte array
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def add_pet_using_byte_array_async(body = nil, custom_headers = nil)
      request_headers = {}

      # Serialize Request
      request_headers['Content-Type'] = 'application/json; charset=utf-8'
      request_content = body != nil ? JSON.generate(body, quirks_mode: true) : nil
      path_template = '/pet'
      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          body: request_content,
          headers: request_headers.merge(custom_headers || {})
      }

      request_url = @base_url || self.base_url

      request = MsRest::HttpOperationRequest.new(request_url, path_template, :post, options)
      promise = request.run_promise do |req|
        self.credentials.sign_request(req) unless self.credentials.nil?
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 405
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(request, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(request, http_response)

        result
      end

      promise.execute
    end

    #
    # Add a new pet to the store
    #
    # @param body [Pet] Pet object that needs to be added to the store
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    #
    def add_pet(body = nil, custom_headers = nil)
      response = add_pet_async(body, custom_headers).value!
      nil
    end

    #
    # Add a new pet to the store
    #
    # @param body [Pet] Pet object that needs to be added to the store
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] HTTP response information.
    #
    def add_pet_with_http_info(body = nil, custom_headers = nil)
      add_pet_async(body, custom_headers).value!
    end

    #
    # Add a new pet to the store
    #
    # @param body [Pet] Pet object that needs to be added to the store
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def add_pet_async(body = nil, custom_headers = nil)
      body.validate unless body.nil?
      request_headers = {}

      # Serialize Request
      request_headers['Content-Type'] = 'application/json; charset=utf-8'
      unless body.nil?
        body = Pet.serialize_object(body)
      end
      request_content = body != nil ? JSON.generate(body, quirks_mode: true) : nil
      path_template = '/pet'
      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          body: request_content,
          headers: request_headers.merge(custom_headers || {})
      }

      request_url = @base_url || self.base_url

      request = MsRest::HttpOperationRequest.new(request_url, path_template, :post, options)
      promise = request.run_promise do |req|
        self.credentials.sign_request(req) unless self.credentials.nil?
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 405
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(request, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(request, http_response)

        result
      end

      promise.execute
    end

    #
    # Update an existing pet
    #
    # @param body [Pet] Pet object that needs to be added to the store
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    #
    def update_pet(body = nil, custom_headers = nil)
      response = update_pet_async(body, custom_headers).value!
      nil
    end

    #
    # Update an existing pet
    #
    # @param body [Pet] Pet object that needs to be added to the store
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] HTTP response information.
    #
    def update_pet_with_http_info(body = nil, custom_headers = nil)
      update_pet_async(body, custom_headers).value!
    end

    #
    # Update an existing pet
    #
    # @param body [Pet] Pet object that needs to be added to the store
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def update_pet_async(body = nil, custom_headers = nil)
      body.validate unless body.nil?
      request_headers = {}

      # Serialize Request
      request_headers['Content-Type'] = 'application/json; charset=utf-8'
      unless body.nil?
        body = Pet.serialize_object(body)
      end
      request_content = body != nil ? JSON.generate(body, quirks_mode: true) : nil
      path_template = '/pet'
      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          body: request_content,
          headers: request_headers.merge(custom_headers || {})
      }

      request_url = @base_url || self.base_url

      request = MsRest::HttpOperationRequest.new(request_url, path_template, :put, options)
      promise = request.run_promise do |req|
        self.credentials.sign_request(req) unless self.credentials.nil?
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 405 || status_code == 404 || status_code == 400
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(request, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(request, http_response)

        result
      end

      promise.execute
    end

    #
    # Finds Pets by status
    #
    # Multiple status values can be provided with comma seperated strings
    #
    # @param status [Array<String>] Status values that need to be considered for
    # filter
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [Array] operation results.
    #
    def find_pets_by_status(status = nil, custom_headers = nil)
      response = find_pets_by_status_async(status, custom_headers).value!
      response.body unless response.nil?
    end

    #
    # Finds Pets by status
    #
    # Multiple status values can be provided with comma seperated strings
    #
    # @param status [Array<String>] Status values that need to be considered for
    # filter
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] HTTP response information.
    #
    def find_pets_by_status_with_http_info(status = nil, custom_headers = nil)
      find_pets_by_status_async(status, custom_headers).value!
    end

    #
    # Finds Pets by status
    #
    # Multiple status values can be provided with comma seperated strings
    #
    # @param status [Array<String>] Status values that need to be considered for
    # filter
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def find_pets_by_status_async(status = nil, custom_headers = nil)
      status.each{ |e| e.validate if e.respond_to?(:validate) } unless status.nil?
      request_headers = {}
      path_template = '/pet/findByStatus'
      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          query_params: {'status' => status.join(',')},
          headers: request_headers.merge(custom_headers || {})
      }

      request_url = @base_url || self.base_url

      request = MsRest::HttpOperationRequest.new(request_url, path_template, :get, options)
      promise = request.run_promise do |req|
        self.credentials.sign_request(req) unless self.credentials.nil?
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 200 || status_code == 400
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(request, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(request, http_response)
        # Deserialize Response
        if status_code == 200
          begin
            parsed_response = response_content.to_s.empty? ? nil : JSON.load(response_content)
            unless parsed_response.nil?
              deserialized_array = []
              parsed_response.each do |element|
                unless element.nil?
                  element = Pet.deserialize_object(element)
                end
                deserialized_array.push(element)
              end
              parsed_response = deserialized_array
            end
            result.body = parsed_response
          rescue Exception => e
            fail MsRest::DeserializationError.new('Error occurred in deserializing the response', e.message, e.backtrace, result)
          end
        end

        result
      end

      promise.execute
    end

    #
    # Finds Pets by tags
    #
    # Muliple tags can be provided with comma seperated strings. Use tag1, tag2,
    # tag3 for testing.
    #
    # @param tags [Array<String>] Tags to filter by
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [Array] operation results.
    #
    def find_pets_by_tags(tags = nil, custom_headers = nil)
      response = find_pets_by_tags_async(tags, custom_headers).value!
      response.body unless response.nil?
    end

    #
    # Finds Pets by tags
    #
    # Muliple tags can be provided with comma seperated strings. Use tag1, tag2,
    # tag3 for testing.
    #
    # @param tags [Array<String>] Tags to filter by
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] HTTP response information.
    #
    def find_pets_by_tags_with_http_info(tags = nil, custom_headers = nil)
      find_pets_by_tags_async(tags, custom_headers).value!
    end

    #
    # Finds Pets by tags
    #
    # Muliple tags can be provided with comma seperated strings. Use tag1, tag2,
    # tag3 for testing.
    #
    # @param tags [Array<String>] Tags to filter by
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def find_pets_by_tags_async(tags = nil, custom_headers = nil)
      tags.each{ |e| e.validate if e.respond_to?(:validate) } unless tags.nil?
      request_headers = {}
      path_template = '/pet/findByTags'
      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          query_params: {'tags' => tags.join(',')},
          headers: request_headers.merge(custom_headers || {})
      }

      request_url = @base_url || self.base_url

      request = MsRest::HttpOperationRequest.new(request_url, path_template, :get, options)
      promise = request.run_promise do |req|
        self.credentials.sign_request(req) unless self.credentials.nil?
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 200 || status_code == 400
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(request, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(request, http_response)
        # Deserialize Response
        if status_code == 200
          begin
            parsed_response = response_content.to_s.empty? ? nil : JSON.load(response_content)
            unless parsed_response.nil?
              deserialized_array = []
              parsed_response.each do |element|
                unless element.nil?
                  element = Pet.deserialize_object(element)
                end
                deserialized_array.push(element)
              end
              parsed_response = deserialized_array
            end
            result.body = parsed_response
          rescue Exception => e
            fail MsRest::DeserializationError.new('Error occurred in deserializing the response', e.message, e.backtrace, result)
          end
        end

        result
      end

      promise.execute
    end

    #
    # Fake endpoint to test byte array return by 'Find pet by ID'
    #
    # Returns a pet when ID < 10.  ID > 10 or nonintegers will simulate API error
    # conditions
    #
    # @param pet_id [Integer] ID of pet that needs to be fetched
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [String] operation results.
    #
    def find_pets_with_byte_array(pet_id, custom_headers = nil)
      response = find_pets_with_byte_array_async(pet_id, custom_headers).value!
      response.body unless response.nil?
    end

    #
    # Fake endpoint to test byte array return by 'Find pet by ID'
    #
    # Returns a pet when ID < 10.  ID > 10 or nonintegers will simulate API error
    # conditions
    #
    # @param pet_id [Integer] ID of pet that needs to be fetched
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] HTTP response information.
    #
    def find_pets_with_byte_array_with_http_info(pet_id, custom_headers = nil)
      find_pets_with_byte_array_async(pet_id, custom_headers).value!
    end

    #
    # Fake endpoint to test byte array return by 'Find pet by ID'
    #
    # Returns a pet when ID < 10.  ID > 10 or nonintegers will simulate API error
    # conditions
    #
    # @param pet_id [Integer] ID of pet that needs to be fetched
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def find_pets_with_byte_array_async(pet_id, custom_headers = nil)
      fail ArgumentError, 'pet_id is nil' if pet_id.nil?
      request_headers = {}
      path_template = '/pet/{petId}'
      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          path_params: {'petId' => pet_id},
          headers: request_headers.merge(custom_headers || {})
      }

      request_url = @base_url || self.base_url

      request = MsRest::HttpOperationRequest.new(request_url, path_template, :get, options)
      promise = request.run_promise do |req|
        self.credentials.sign_request(req) unless self.credentials.nil?
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 404 || status_code == 200 || status_code == 400
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(request, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(request, http_response)
        # Deserialize Response
        if status_code == 200
          begin
            parsed_response = response_content.to_s.empty? ? nil : JSON.load(response_content)
            result.body = parsed_response
          rescue Exception => e
            fail MsRest::DeserializationError.new('Error occurred in deserializing the response', e.message, e.backtrace, result)
          end
        end

        result
      end

      promise.execute
    end

    #
    # Find pet by ID
    #
    # Returns a pet when ID < 10.  ID > 10 or nonintegers will simulate API error
    # conditions
    #
    # @param pet_id [Integer] ID of pet that needs to be fetched
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [Pet] operation results.
    #
    def get_pet_by_id(pet_id, custom_headers = nil)
      response = get_pet_by_id_async(pet_id, custom_headers).value!
      response.body unless response.nil?
    end

    #
    # Find pet by ID
    #
    # Returns a pet when ID < 10.  ID > 10 or nonintegers will simulate API error
    # conditions
    #
    # @param pet_id [Integer] ID of pet that needs to be fetched
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] HTTP response information.
    #
    def get_pet_by_id_with_http_info(pet_id, custom_headers = nil)
      get_pet_by_id_async(pet_id, custom_headers).value!
    end

    #
    # Find pet by ID
    #
    # Returns a pet when ID < 10.  ID > 10 or nonintegers will simulate API error
    # conditions
    #
    # @param pet_id [Integer] ID of pet that needs to be fetched
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def get_pet_by_id_async(pet_id, custom_headers = nil)
      fail ArgumentError, 'pet_id is nil' if pet_id.nil?
      request_headers = {}
      path_template = '/pet/{petId}'
      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          path_params: {'petId' => pet_id},
          headers: request_headers.merge(custom_headers || {})
      }

      request_url = @base_url || self.base_url

      request = MsRest::HttpOperationRequest.new(request_url, path_template, :get, options)
      promise = request.run_promise do |req|
        self.credentials.sign_request(req) unless self.credentials.nil?
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 404 || status_code == 200 || status_code == 400
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(request, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(request, http_response)
        # Deserialize Response
        if status_code == 200
          begin
            parsed_response = response_content.to_s.empty? ? nil : JSON.load(response_content)
            unless parsed_response.nil?
              parsed_response = Pet.deserialize_object(parsed_response)
            end
            result.body = parsed_response
          rescue Exception => e
            fail MsRest::DeserializationError.new('Error occurred in deserializing the response', e.message, e.backtrace, result)
          end
        end

        result
      end

      promise.execute
    end

    #
    # Updates a pet in the store with form data
    #
    # @param pet_id [String] ID of pet that needs to be updated
    # @param name [String] Updated name of the pet
    # @param status [String] Updated status of the pet
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    #
    def update_pet_with_form(pet_id, name = nil, status = nil, custom_headers = nil)
      response = update_pet_with_form_async(pet_id, name, status, custom_headers).value!
      nil
    end

    #
    # Updates a pet in the store with form data
    #
    # @param pet_id [String] ID of pet that needs to be updated
    # @param name [String] Updated name of the pet
    # @param status [String] Updated status of the pet
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] HTTP response information.
    #
    def update_pet_with_form_with_http_info(pet_id, name = nil, status = nil, custom_headers = nil)
      update_pet_with_form_async(pet_id, name, status, custom_headers).value!
    end

    #
    # Updates a pet in the store with form data
    #
    # @param pet_id [String] ID of pet that needs to be updated
    # @param name [String] Updated name of the pet
    # @param status [String] Updated status of the pet
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def update_pet_with_form_async(pet_id, name = nil, status = nil, custom_headers = nil)
      fail ArgumentError, 'pet_id is nil' if pet_id.nil?
      request_headers = {}
      path_template = '/pet/{petId}'
      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          path_params: {'petId' => pet_id},
          headers: request_headers.merge(custom_headers || {})
      }

      request_url = @base_url || self.base_url

      request = MsRest::HttpOperationRequest.new(request_url, path_template, :post, options)
      promise = request.run_promise do |req|
        self.credentials.sign_request(req) unless self.credentials.nil?
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 405
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(request, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(request, http_response)

        result
      end

      promise.execute
    end

    #
    # Deletes a pet
    #
    # @param pet_id [Integer] Pet id to delete
    # @param api_key [String]
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    #
    def delete_pet(pet_id, api_key = nil, custom_headers = nil)
      response = delete_pet_async(pet_id, api_key, custom_headers).value!
      nil
    end

    #
    # Deletes a pet
    #
    # @param pet_id [Integer] Pet id to delete
    # @param api_key [String]
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] HTTP response information.
    #
    def delete_pet_with_http_info(pet_id, api_key = nil, custom_headers = nil)
      delete_pet_async(pet_id, api_key, custom_headers).value!
    end

    #
    # Deletes a pet
    #
    # @param pet_id [Integer] Pet id to delete
    # @param api_key [String]
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def delete_pet_async(pet_id, api_key = nil, custom_headers = nil)
      fail ArgumentError, 'pet_id is nil' if pet_id.nil?
      request_headers = {}

      # Set Headers
      request_headers['api_key'] = api_key unless api_key.nil?
      path_template = '/pet/{petId}'
      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          path_params: {'petId' => pet_id},
          headers: request_headers.merge(custom_headers || {})
      }

      request_url = @base_url || self.base_url

      request = MsRest::HttpOperationRequest.new(request_url, path_template, :delete, options)
      promise = request.run_promise do |req|
        self.credentials.sign_request(req) unless self.credentials.nil?
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 400
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(request, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(request, http_response)

        result
      end

      promise.execute
    end

    #
    # uploads an image
    #
    # @param pet_id [Integer] ID of pet to update
    # @param additional_metadata [String] Additional data to pass to server
    # @param file file to upload
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    #
    def upload_file(pet_id, additional_metadata = nil, file = nil, custom_headers = nil)
      response = upload_file_async(pet_id, additional_metadata, file, custom_headers).value!
      nil
    end

    #
    # uploads an image
    #
    # @param pet_id [Integer] ID of pet to update
    # @param additional_metadata [String] Additional data to pass to server
    # @param file file to upload
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] HTTP response information.
    #
    def upload_file_with_http_info(pet_id, additional_metadata = nil, file = nil, custom_headers = nil)
      upload_file_async(pet_id, additional_metadata, file, custom_headers).value!
    end

    #
    # uploads an image
    #
    # @param pet_id [Integer] ID of pet to update
    # @param additional_metadata [String] Additional data to pass to server
    # @param file file to upload
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def upload_file_async(pet_id, additional_metadata = nil, file = nil, custom_headers = nil)
      fail ArgumentError, 'pet_id is nil' if pet_id.nil?
      request_headers = {}
      path_template = '/pet/{petId}/uploadImage'
      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          path_params: {'petId' => pet_id},
          headers: request_headers.merge(custom_headers || {})
      }

      request_url = @base_url || self.base_url

      request = MsRest::HttpOperationRequest.new(request_url, path_template, :post, options)
      promise = request.run_promise do |req|
        self.credentials.sign_request(req) unless self.credentials.nil?
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code >= 200 && status_code < 300
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(request, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(request, http_response)

        result
      end

      promise.execute
    end

    #
    # Returns pet inventories by status
    #
    # Returns a map of status codes to quantities
    #
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [Hash] operation results.
    #
    def get_inventory(custom_headers = nil)
      response = get_inventory_async(custom_headers).value!
      response.body unless response.nil?
    end

    #
    # Returns pet inventories by status
    #
    # Returns a map of status codes to quantities
    #
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] HTTP response information.
    #
    def get_inventory_with_http_info(custom_headers = nil)
      get_inventory_async(custom_headers).value!
    end

    #
    # Returns pet inventories by status
    #
    # Returns a map of status codes to quantities
    #
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def get_inventory_async(custom_headers = nil)
      request_headers = {}
      path_template = '/store/inventory'
      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          headers: request_headers.merge(custom_headers || {})
      }

      request_url = @base_url || self.base_url

      request = MsRest::HttpOperationRequest.new(request_url, path_template, :get, options)
      promise = request.run_promise do |req|
        self.credentials.sign_request(req) unless self.credentials.nil?
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 200
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(request, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(request, http_response)
        # Deserialize Response
        if status_code == 200
          begin
            parsed_response = response_content.to_s.empty? ? nil : JSON.load(response_content)
            unless parsed_response.nil?
              parsed_response.each do |key, valueElement|
                valueElement = Integer(valueElement) unless valueElement.to_s.empty?
                parsed_response[key] = valueElement
              end
            end
            result.body = parsed_response
          rescue Exception => e
            fail MsRest::DeserializationError.new('Error occurred in deserializing the response', e.message, e.backtrace, result)
          end
        end

        result
      end

      promise.execute
    end

    #
    # Place an order for a pet
    #
    # @param body [Order] order placed for purchasing the pet
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [Order] operation results.
    #
    def place_order(body = nil, custom_headers = nil)
      response = place_order_async(body, custom_headers).value!
      response.body unless response.nil?
    end

    #
    # Place an order for a pet
    #
    # @param body [Order] order placed for purchasing the pet
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] HTTP response information.
    #
    def place_order_with_http_info(body = nil, custom_headers = nil)
      place_order_async(body, custom_headers).value!
    end

    #
    # Place an order for a pet
    #
    # @param body [Order] order placed for purchasing the pet
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def place_order_async(body = nil, custom_headers = nil)
      body.validate unless body.nil?
      request_headers = {}

      # Serialize Request
      request_headers['Content-Type'] = 'application/json; charset=utf-8'
      unless body.nil?
        body = Order.serialize_object(body)
      end
      request_content = body != nil ? JSON.generate(body, quirks_mode: true) : nil
      path_template = '/store/order'
      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          body: request_content,
          headers: request_headers.merge(custom_headers || {})
      }

      request_url = @base_url || self.base_url

      request = MsRest::HttpOperationRequest.new(request_url, path_template, :post, options)
      promise = request.run_promise do |req|
        self.credentials.sign_request(req) unless self.credentials.nil?
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 200 || status_code == 400
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(request, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(request, http_response)
        # Deserialize Response
        if status_code == 200
          begin
            parsed_response = response_content.to_s.empty? ? nil : JSON.load(response_content)
            unless parsed_response.nil?
              parsed_response = Order.deserialize_object(parsed_response)
            end
            result.body = parsed_response
          rescue Exception => e
            fail MsRest::DeserializationError.new('Error occurred in deserializing the response', e.message, e.backtrace, result)
          end
        end

        result
      end

      promise.execute
    end

    #
    # Find purchase order by ID
    #
    # For valid response try integer IDs with value <= 5 or > 10. Other values
    # will generated exceptions
    #
    # @param order_id [String] ID of pet that needs to be fetched
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [Order] operation results.
    #
    def get_order_by_id(order_id, custom_headers = nil)
      response = get_order_by_id_async(order_id, custom_headers).value!
      response.body unless response.nil?
    end

    #
    # Find purchase order by ID
    #
    # For valid response try integer IDs with value <= 5 or > 10. Other values
    # will generated exceptions
    #
    # @param order_id [String] ID of pet that needs to be fetched
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] HTTP response information.
    #
    def get_order_by_id_with_http_info(order_id, custom_headers = nil)
      get_order_by_id_async(order_id, custom_headers).value!
    end

    #
    # Find purchase order by ID
    #
    # For valid response try integer IDs with value <= 5 or > 10. Other values
    # will generated exceptions
    #
    # @param order_id [String] ID of pet that needs to be fetched
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def get_order_by_id_async(order_id, custom_headers = nil)
      fail ArgumentError, 'order_id is nil' if order_id.nil?
      request_headers = {}
      path_template = '/store/order/{orderId}'
      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          path_params: {'orderId' => order_id},
          headers: request_headers.merge(custom_headers || {})
      }

      request_url = @base_url || self.base_url

      request = MsRest::HttpOperationRequest.new(request_url, path_template, :get, options)
      promise = request.run_promise do |req|
        self.credentials.sign_request(req) unless self.credentials.nil?
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 404 || status_code == 200 || status_code == 400
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(request, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(request, http_response)
        # Deserialize Response
        if status_code == 200
          begin
            parsed_response = response_content.to_s.empty? ? nil : JSON.load(response_content)
            unless parsed_response.nil?
              parsed_response = Order.deserialize_object(parsed_response)
            end
            result.body = parsed_response
          rescue Exception => e
            fail MsRest::DeserializationError.new('Error occurred in deserializing the response', e.message, e.backtrace, result)
          end
        end

        result
      end

      promise.execute
    end

    #
    # Delete purchase order by ID
    #
    # For valid response try integer IDs with value < 1000. Anything above 1000 or
    # nonintegers will generate API errors
    #
    # @param order_id [String] ID of the order that needs to be deleted
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    #
    def delete_order(order_id, custom_headers = nil)
      response = delete_order_async(order_id, custom_headers).value!
      nil
    end

    #
    # Delete purchase order by ID
    #
    # For valid response try integer IDs with value < 1000. Anything above 1000 or
    # nonintegers will generate API errors
    #
    # @param order_id [String] ID of the order that needs to be deleted
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] HTTP response information.
    #
    def delete_order_with_http_info(order_id, custom_headers = nil)
      delete_order_async(order_id, custom_headers).value!
    end

    #
    # Delete purchase order by ID
    #
    # For valid response try integer IDs with value < 1000. Anything above 1000 or
    # nonintegers will generate API errors
    #
    # @param order_id [String] ID of the order that needs to be deleted
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def delete_order_async(order_id, custom_headers = nil)
      fail ArgumentError, 'order_id is nil' if order_id.nil?
      request_headers = {}
      path_template = '/store/order/{orderId}'
      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          path_params: {'orderId' => order_id},
          headers: request_headers.merge(custom_headers || {})
      }

      request_url = @base_url || self.base_url

      request = MsRest::HttpOperationRequest.new(request_url, path_template, :delete, options)
      promise = request.run_promise do |req|
        self.credentials.sign_request(req) unless self.credentials.nil?
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 404 || status_code == 400
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(request, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(request, http_response)

        result
      end

      promise.execute
    end

    #
    # Create user
    #
    # This can only be done by the logged in user.
    #
    # @param body [User] Created user object
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    #
    def create_user(body = nil, custom_headers = nil)
      response = create_user_async(body, custom_headers).value!
      nil
    end

    #
    # Create user
    #
    # This can only be done by the logged in user.
    #
    # @param body [User] Created user object
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] HTTP response information.
    #
    def create_user_with_http_info(body = nil, custom_headers = nil)
      create_user_async(body, custom_headers).value!
    end

    #
    # Create user
    #
    # This can only be done by the logged in user.
    #
    # @param body [User] Created user object
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def create_user_async(body = nil, custom_headers = nil)
      body.validate unless body.nil?
      request_headers = {}

      # Serialize Request
      request_headers['Content-Type'] = 'application/json; charset=utf-8'
      unless body.nil?
        body = User.serialize_object(body)
      end
      request_content = body != nil ? JSON.generate(body, quirks_mode: true) : nil
      path_template = '/user'
      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          body: request_content,
          headers: request_headers.merge(custom_headers || {})
      }

      request_url = @base_url || self.base_url

      request = MsRest::HttpOperationRequest.new(request_url, path_template, :post, options)
      promise = request.run_promise do |req|
        self.credentials.sign_request(req) unless self.credentials.nil?
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code >= 200 && status_code < 300
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(request, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(request, http_response)

        result
      end

      promise.execute
    end

    #
    # Creates list of users with given input array
    #
    # @param body [Array<User>] List of user object
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    #
    def create_users_with_array_input(body = nil, custom_headers = nil)
      response = create_users_with_array_input_async(body, custom_headers).value!
      nil
    end

    #
    # Creates list of users with given input array
    #
    # @param body [Array<User>] List of user object
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] HTTP response information.
    #
    def create_users_with_array_input_with_http_info(body = nil, custom_headers = nil)
      create_users_with_array_input_async(body, custom_headers).value!
    end

    #
    # Creates list of users with given input array
    #
    # @param body [Array<User>] List of user object
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def create_users_with_array_input_async(body = nil, custom_headers = nil)
      body.each{ |e| e.validate if e.respond_to?(:validate) } unless body.nil?
      request_headers = {}

      # Serialize Request
      request_headers['Content-Type'] = 'application/json; charset=utf-8'
      unless body.nil?
        serializedArray = []
        body.each do |element|
          unless element.nil?
            element = User.serialize_object(element)
          end
          serializedArray.push(element)
        end
        body = serializedArray
      end
      request_content = body != nil ? JSON.generate(body, quirks_mode: true) : nil
      path_template = '/user/createWithArray'
      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          body: request_content,
          headers: request_headers.merge(custom_headers || {})
      }

      request_url = @base_url || self.base_url

      request = MsRest::HttpOperationRequest.new(request_url, path_template, :post, options)
      promise = request.run_promise do |req|
        self.credentials.sign_request(req) unless self.credentials.nil?
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code >= 200 && status_code < 300
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(request, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(request, http_response)

        result
      end

      promise.execute
    end

    #
    # Creates list of users with given input array
    #
    # @param body [Array<User>] List of user object
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    #
    def create_users_with_list_input(body = nil, custom_headers = nil)
      response = create_users_with_list_input_async(body, custom_headers).value!
      nil
    end

    #
    # Creates list of users with given input array
    #
    # @param body [Array<User>] List of user object
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] HTTP response information.
    #
    def create_users_with_list_input_with_http_info(body = nil, custom_headers = nil)
      create_users_with_list_input_async(body, custom_headers).value!
    end

    #
    # Creates list of users with given input array
    #
    # @param body [Array<User>] List of user object
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def create_users_with_list_input_async(body = nil, custom_headers = nil)
      body.each{ |e| e.validate if e.respond_to?(:validate) } unless body.nil?
      request_headers = {}

      # Serialize Request
      request_headers['Content-Type'] = 'application/json; charset=utf-8'
      unless body.nil?
        serializedArray = []
        body.each do |element|
          unless element.nil?
            element = User.serialize_object(element)
          end
          serializedArray.push(element)
        end
        body = serializedArray
      end
      request_content = body != nil ? JSON.generate(body, quirks_mode: true) : nil
      path_template = '/user/createWithList'
      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          body: request_content,
          headers: request_headers.merge(custom_headers || {})
      }

      request_url = @base_url || self.base_url

      request = MsRest::HttpOperationRequest.new(request_url, path_template, :post, options)
      promise = request.run_promise do |req|
        self.credentials.sign_request(req) unless self.credentials.nil?
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code >= 200 && status_code < 300
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(request, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(request, http_response)

        result
      end

      promise.execute
    end

    #
    # Logs user into the system
    #
    # @param username [String] The user name for login
    # @param password [String] The password for login in clear text
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [String] operation results.
    #
    def login_user(username = nil, password = nil, custom_headers = nil)
      response = login_user_async(username, password, custom_headers).value!
      response.body unless response.nil?
    end

    #
    # Logs user into the system
    #
    # @param username [String] The user name for login
    # @param password [String] The password for login in clear text
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] HTTP response information.
    #
    def login_user_with_http_info(username = nil, password = nil, custom_headers = nil)
      login_user_async(username, password, custom_headers).value!
    end

    #
    # Logs user into the system
    #
    # @param username [String] The user name for login
    # @param password [String] The password for login in clear text
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def login_user_async(username = nil, password = nil, custom_headers = nil)
      request_headers = {}
      path_template = '/user/login'
      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          query_params: {'username' => username,'password' => password},
          headers: request_headers.merge(custom_headers || {})
      }

      request_url = @base_url || self.base_url

      request = MsRest::HttpOperationRequest.new(request_url, path_template, :get, options)
      promise = request.run_promise do |req|
        self.credentials.sign_request(req) unless self.credentials.nil?
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 200 || status_code == 400
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(request, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(request, http_response)
        # Deserialize Response
        if status_code == 200
          begin
            parsed_response = response_content.to_s.empty? ? nil : JSON.load(response_content)
            result.body = parsed_response
          rescue Exception => e
            fail MsRest::DeserializationError.new('Error occurred in deserializing the response', e.message, e.backtrace, result)
          end
        end

        result
      end

      promise.execute
    end

    #
    # Logs out current logged in user session
    #
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    #
    def logout_user(custom_headers = nil)
      response = logout_user_async(custom_headers).value!
      nil
    end

    #
    # Logs out current logged in user session
    #
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] HTTP response information.
    #
    def logout_user_with_http_info(custom_headers = nil)
      logout_user_async(custom_headers).value!
    end

    #
    # Logs out current logged in user session
    #
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def logout_user_async(custom_headers = nil)
      request_headers = {}
      path_template = '/user/logout'
      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          headers: request_headers.merge(custom_headers || {})
      }

      request_url = @base_url || self.base_url

      request = MsRest::HttpOperationRequest.new(request_url, path_template, :get, options)
      promise = request.run_promise do |req|
        self.credentials.sign_request(req) unless self.credentials.nil?
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code >= 200 && status_code < 300
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(request, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(request, http_response)

        result
      end

      promise.execute
    end

    #
    # Get user by user name
    #
    # @param username [String] The name that needs to be fetched. Use user1 for
    # testing.
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [User] operation results.
    #
    def get_user_by_name(username, custom_headers = nil)
      response = get_user_by_name_async(username, custom_headers).value!
      response.body unless response.nil?
    end

    #
    # Get user by user name
    #
    # @param username [String] The name that needs to be fetched. Use user1 for
    # testing.
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] HTTP response information.
    #
    def get_user_by_name_with_http_info(username, custom_headers = nil)
      get_user_by_name_async(username, custom_headers).value!
    end

    #
    # Get user by user name
    #
    # @param username [String] The name that needs to be fetched. Use user1 for
    # testing.
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def get_user_by_name_async(username, custom_headers = nil)
      fail ArgumentError, 'username is nil' if username.nil?
      request_headers = {}
      path_template = '/user/{username}'
      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          path_params: {'username' => username},
          headers: request_headers.merge(custom_headers || {})
      }

      request_url = @base_url || self.base_url

      request = MsRest::HttpOperationRequest.new(request_url, path_template, :get, options)
      promise = request.run_promise do |req|
        self.credentials.sign_request(req) unless self.credentials.nil?
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 404 || status_code == 200 || status_code == 400
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(request, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(request, http_response)
        # Deserialize Response
        if status_code == 200
          begin
            parsed_response = response_content.to_s.empty? ? nil : JSON.load(response_content)
            unless parsed_response.nil?
              parsed_response = User.deserialize_object(parsed_response)
            end
            result.body = parsed_response
          rescue Exception => e
            fail MsRest::DeserializationError.new('Error occurred in deserializing the response', e.message, e.backtrace, result)
          end
        end

        result
      end

      promise.execute
    end

    #
    # Updated user
    #
    # This can only be done by the logged in user.
    #
    # @param username [String] name that need to be deleted
    # @param body [User] Updated user object
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    #
    def update_user(username, body = nil, custom_headers = nil)
      response = update_user_async(username, body, custom_headers).value!
      nil
    end

    #
    # Updated user
    #
    # This can only be done by the logged in user.
    #
    # @param username [String] name that need to be deleted
    # @param body [User] Updated user object
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] HTTP response information.
    #
    def update_user_with_http_info(username, body = nil, custom_headers = nil)
      update_user_async(username, body, custom_headers).value!
    end

    #
    # Updated user
    #
    # This can only be done by the logged in user.
    #
    # @param username [String] name that need to be deleted
    # @param body [User] Updated user object
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def update_user_async(username, body = nil, custom_headers = nil)
      fail ArgumentError, 'username is nil' if username.nil?
      body.validate unless body.nil?
      request_headers = {}

      # Serialize Request
      request_headers['Content-Type'] = 'application/json; charset=utf-8'
      unless body.nil?
        body = User.serialize_object(body)
      end
      request_content = body != nil ? JSON.generate(body, quirks_mode: true) : nil
      path_template = '/user/{username}'
      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          path_params: {'username' => username},
          body: request_content,
          headers: request_headers.merge(custom_headers || {})
      }

      request_url = @base_url || self.base_url

      request = MsRest::HttpOperationRequest.new(request_url, path_template, :put, options)
      promise = request.run_promise do |req|
        self.credentials.sign_request(req) unless self.credentials.nil?
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 404 || status_code == 400
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(request, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(request, http_response)

        result
      end

      promise.execute
    end

    #
    # Delete user
    #
    # This can only be done by the logged in user.
    #
    # @param username [String] The name that needs to be deleted
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    #
    def delete_user(username, custom_headers = nil)
      response = delete_user_async(username, custom_headers).value!
      nil
    end

    #
    # Delete user
    #
    # This can only be done by the logged in user.
    #
    # @param username [String] The name that needs to be deleted
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] HTTP response information.
    #
    def delete_user_with_http_info(username, custom_headers = nil)
      delete_user_async(username, custom_headers).value!
    end

    #
    # Delete user
    #
    # This can only be done by the logged in user.
    #
    # @param username [String] The name that needs to be deleted
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def delete_user_async(username, custom_headers = nil)
      fail ArgumentError, 'username is nil' if username.nil?
      request_headers = {}
      path_template = '/user/{username}'
      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          path_params: {'username' => username},
          headers: request_headers.merge(custom_headers || {})
      }

      request_url = @base_url || self.base_url

      request = MsRest::HttpOperationRequest.new(request_url, path_template, :delete, options)
      promise = request.run_promise do |req|
        self.credentials.sign_request(req) unless self.credentials.nil?
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 404 || status_code == 400
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(request, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(request, http_response)

        result
      end

      promise.execute
    end

  end
end
