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
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def add_pet_using_byte_array(body = nil, custom_headers = nil)
      # Construct URL
      path = "/pet"
      url = URI.join(self.base_url, path)
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Serialize Request
      request_headers['Content-Type'] = 'application/json; charset=utf-8'
      request_content = JSON.generate(body, quirks_mode: true)

      # Send Request
      promise = Concurrent::Promise.new do
        connection.post do |request|
          request.headers = request_headers
          request.body = request_content
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code == 405)
          fail MsRest::HttpOperationError.new(connection, http_response)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)

        result
      end

      promise.execute
    end

    #
    # Add a new pet to the store
    #
    # @param body [Pet] Pet object that needs to be added to the store
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def add_pet(body = nil, custom_headers = nil)
      body.validate unless body.nil?
      # Construct URL
      path = "/pet"
      url = URI.join(self.base_url, path)
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Serialize Request
      request_headers['Content-Type'] = 'application/json; charset=utf-8'
      unless body.nil?
        body = Pet.serialize_object(body)
      end
      request_content = JSON.generate(body, quirks_mode: true)

      # Send Request
      promise = Concurrent::Promise.new do
        connection.post do |request|
          request.headers = request_headers
          request.body = request_content
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code == 405)
          fail MsRest::HttpOperationError.new(connection, http_response)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)

        result
      end

      promise.execute
    end

    #
    # Update an existing pet
    #
    # @param body [Pet] Pet object that needs to be added to the store
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def update_pet(body = nil, custom_headers = nil)
      body.validate unless body.nil?
      # Construct URL
      path = "/pet"
      url = URI.join(self.base_url, path)
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Serialize Request
      request_headers['Content-Type'] = 'application/json; charset=utf-8'
      unless body.nil?
        body = Pet.serialize_object(body)
      end
      request_content = JSON.generate(body, quirks_mode: true)

      # Send Request
      promise = Concurrent::Promise.new do
        connection.put do |request|
          request.headers = request_headers
          request.body = request_content
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code == 405 || status_code == 404 || status_code == 400)
          fail MsRest::HttpOperationError.new(connection, http_response)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)

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
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def find_pets_by_status(status = nil, custom_headers = nil)
      status.each{ |e| e.validate if e.respond_to?(:validate) } unless status.nil?
      # Construct URL
      path = "/pet/findByStatus"
      url = URI.join(self.base_url, path)
      properties = { 'status' => status }
      unless url.query.nil?
        url.query.split('&').each do |url_item|
          url_items_parts = url_item.split('=')
          properties[url_items_parts[0]] = url_items_parts[1]
        end
      end
      properties.reject!{ |key, value| value.nil? }
      url.query = properties.map{ |key, value| "#{key}=#{ERB::Util.url_encode(value.to_s)}" }.compact.join('&')
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Send Request
      promise = Concurrent::Promise.new do
        connection.get do |request|
          request.headers = request_headers
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code == 200 || status_code == 400)
          fail MsRest::HttpOperationError.new(connection, http_response)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)
        # Deserialize Response
        if status_code == 200
          begin
            parsed_response = JSON.load(response_content) unless response_content.to_s.empty?
            unless parsed_response.nil?
              deserializedArray = [];
              parsed_response.each do |element|
                unless element.nil?
                  element = Pet.deserialize_object(element)
                end
                deserializedArray.push(element);
              end
              parsed_response = deserializedArray;
            end
            result.body = parsed_response
          rescue Exception => e
            fail MsRest::DeserializationError.new("Error occured in deserializing the response", e.message, e.backtrace, response_content)
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
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def find_pets_by_tags(tags = nil, custom_headers = nil)
      tags.each{ |e| e.validate if e.respond_to?(:validate) } unless tags.nil?
      # Construct URL
      path = "/pet/findByTags"
      url = URI.join(self.base_url, path)
      properties = { 'tags' => tags }
      unless url.query.nil?
        url.query.split('&').each do |url_item|
          url_items_parts = url_item.split('=')
          properties[url_items_parts[0]] = url_items_parts[1]
        end
      end
      properties.reject!{ |key, value| value.nil? }
      url.query = properties.map{ |key, value| "#{key}=#{ERB::Util.url_encode(value.to_s)}" }.compact.join('&')
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Send Request
      promise = Concurrent::Promise.new do
        connection.get do |request|
          request.headers = request_headers
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code == 200 || status_code == 400)
          fail MsRest::HttpOperationError.new(connection, http_response)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)
        # Deserialize Response
        if status_code == 200
          begin
            parsed_response = JSON.load(response_content) unless response_content.to_s.empty?
            unless parsed_response.nil?
              deserializedArray = [];
              parsed_response.each do |element|
                unless element.nil?
                  element = Pet.deserialize_object(element)
                end
                deserializedArray.push(element);
              end
              parsed_response = deserializedArray;
            end
            result.body = parsed_response
          rescue Exception => e
            fail MsRest::DeserializationError.new("Error occured in deserializing the response", e.message, e.backtrace, response_content)
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
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def find_pets_with_byte_array(pet_id, custom_headers = nil)
      fail ArgumentError, 'pet_id is nil' if pet_id.nil?
      # Construct URL
      path = "/pet/{petId}"
      path['{petId}'] = ERB::Util.url_encode(pet_id.to_s) if path.include?('{petId}')
      url = URI.join(self.base_url, path)
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Send Request
      promise = Concurrent::Promise.new do
        connection.get do |request|
          request.headers = request_headers
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code == 404 || status_code == 200 || status_code == 400)
          fail MsRest::HttpOperationError.new(connection, http_response)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)
        # Deserialize Response
        if status_code == 200
          begin
            parsed_response = JSON.load(response_content) unless response_content.to_s.empty?
            result.body = parsed_response
          rescue Exception => e
            fail MsRest::DeserializationError.new("Error occured in deserializing the response", e.message, e.backtrace, response_content)
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
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def get_pet_by_id(pet_id, custom_headers = nil)
      fail ArgumentError, 'pet_id is nil' if pet_id.nil?
      # Construct URL
      path = "/pet/{petId}"
      path['{petId}'] = ERB::Util.url_encode(pet_id.to_s) if path.include?('{petId}')
      url = URI.join(self.base_url, path)
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Send Request
      promise = Concurrent::Promise.new do
        connection.get do |request|
          request.headers = request_headers
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code == 404 || status_code == 200 || status_code == 400)
          fail MsRest::HttpOperationError.new(connection, http_response)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)
        # Deserialize Response
        if status_code == 200
          begin
            parsed_response = JSON.load(response_content) unless response_content.to_s.empty?
            unless parsed_response.nil?
              parsed_response = Pet.deserialize_object(parsed_response)
            end
            result.body = parsed_response
          rescue Exception => e
            fail MsRest::DeserializationError.new("Error occured in deserializing the response", e.message, e.backtrace, response_content)
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
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def update_pet_with_form(pet_id, name = nil, status = nil, custom_headers = nil)
      fail ArgumentError, 'pet_id is nil' if pet_id.nil?
      # Construct URL
      path = "/pet/{petId}"
      path['{petId}'] = ERB::Util.url_encode(pet_id) if path.include?('{petId}')
      url = URI.join(self.base_url, path)
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Send Request
      promise = Concurrent::Promise.new do
        connection.post do |request|
          request.headers = request_headers
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code == 405)
          fail MsRest::HttpOperationError.new(connection, http_response)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)

        result
      end

      promise.execute
    end

    #
    # Deletes a pet
    #
    # @param pet_id [Integer] Pet id to delete
    # @param api_key [String]
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def delete_pet(pet_id, api_key = nil, custom_headers = nil)
      fail ArgumentError, 'pet_id is nil' if pet_id.nil?
      # Construct URL
      path = "/pet/{petId}"
      path['{petId}'] = ERB::Util.url_encode(pet_id.to_s) if path.include?('{petId}')
      url = URI.join(self.base_url, path)
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      # Set Headers
      request_headers["api_key"] = api_key unless api_key.nil?

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Send Request
      promise = Concurrent::Promise.new do
        connection.delete do |request|
          request.headers = request_headers
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code == 400)
          fail MsRest::HttpOperationError.new(connection, http_response)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)

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
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def upload_file(pet_id, additional_metadata = nil, file = nil, custom_headers = nil)
      fail ArgumentError, 'pet_id is nil' if pet_id.nil?
      # Construct URL
      path = "/pet/{petId}/uploadImage"
      path['{petId}'] = ERB::Util.url_encode(pet_id.to_s) if path.include?('{petId}')
      url = URI.join(self.base_url, path)
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Send Request
      promise = Concurrent::Promise.new do
        connection.post do |request|
          request.headers = request_headers
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code >= 200 && status_code < 300)
          fail MsRest::HttpOperationError.new(connection, http_response)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)

        result
      end

      promise.execute
    end

    #
    # Returns pet inventories by status
    #
    # Returns a map of status codes to quantities
    #
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def get_inventory(custom_headers = nil)
      # Construct URL
      path = "/store/inventory"
      url = URI.join(self.base_url, path)
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Send Request
      promise = Concurrent::Promise.new do
        connection.get do |request|
          request.headers = request_headers
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code == 200)
          fail MsRest::HttpOperationError.new(connection, http_response)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)
        # Deserialize Response
        if status_code == 200
          begin
            parsed_response = JSON.load(response_content) unless response_content.to_s.empty?
            unless parsed_response.nil?
              parsed_response.each do |key, valueElement|
                valueElement = Integer(valueElement) unless valueElement.to_s.empty?
                parsed_response[key] = valueElement
              end
            end
            result.body = parsed_response
          rescue Exception => e
            fail MsRest::DeserializationError.new("Error occured in deserializing the response", e.message, e.backtrace, response_content)
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
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def place_order(body = nil, custom_headers = nil)
      body.validate unless body.nil?
      # Construct URL
      path = "/store/order"
      url = URI.join(self.base_url, path)
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Serialize Request
      request_headers['Content-Type'] = 'application/json; charset=utf-8'
      unless body.nil?
        body = Order.serialize_object(body)
      end
      request_content = JSON.generate(body, quirks_mode: true)

      # Send Request
      promise = Concurrent::Promise.new do
        connection.post do |request|
          request.headers = request_headers
          request.body = request_content
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code == 200 || status_code == 400)
          fail MsRest::HttpOperationError.new(connection, http_response)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)
        # Deserialize Response
        if status_code == 200
          begin
            parsed_response = JSON.load(response_content) unless response_content.to_s.empty?
            unless parsed_response.nil?
              parsed_response = Order.deserialize_object(parsed_response)
            end
            result.body = parsed_response
          rescue Exception => e
            fail MsRest::DeserializationError.new("Error occured in deserializing the response", e.message, e.backtrace, response_content)
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
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def get_order_by_id(order_id, custom_headers = nil)
      fail ArgumentError, 'order_id is nil' if order_id.nil?
      # Construct URL
      path = "/store/order/{orderId}"
      path['{orderId}'] = ERB::Util.url_encode(order_id) if path.include?('{orderId}')
      url = URI.join(self.base_url, path)
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Send Request
      promise = Concurrent::Promise.new do
        connection.get do |request|
          request.headers = request_headers
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code == 404 || status_code == 200 || status_code == 400)
          fail MsRest::HttpOperationError.new(connection, http_response)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)
        # Deserialize Response
        if status_code == 200
          begin
            parsed_response = JSON.load(response_content) unless response_content.to_s.empty?
            unless parsed_response.nil?
              parsed_response = Order.deserialize_object(parsed_response)
            end
            result.body = parsed_response
          rescue Exception => e
            fail MsRest::DeserializationError.new("Error occured in deserializing the response", e.message, e.backtrace, response_content)
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
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def delete_order(order_id, custom_headers = nil)
      fail ArgumentError, 'order_id is nil' if order_id.nil?
      # Construct URL
      path = "/store/order/{orderId}"
      path['{orderId}'] = ERB::Util.url_encode(order_id) if path.include?('{orderId}')
      url = URI.join(self.base_url, path)
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Send Request
      promise = Concurrent::Promise.new do
        connection.delete do |request|
          request.headers = request_headers
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code == 404 || status_code == 400)
          fail MsRest::HttpOperationError.new(connection, http_response)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)

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
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def create_user(body = nil, custom_headers = nil)
      body.validate unless body.nil?
      # Construct URL
      path = "/user"
      url = URI.join(self.base_url, path)
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Serialize Request
      request_headers['Content-Type'] = 'application/json; charset=utf-8'
      unless body.nil?
        body = User.serialize_object(body)
      end
      request_content = JSON.generate(body, quirks_mode: true)

      # Send Request
      promise = Concurrent::Promise.new do
        connection.post do |request|
          request.headers = request_headers
          request.body = request_content
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code >= 200 && status_code < 300)
          fail MsRest::HttpOperationError.new(connection, http_response)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)

        result
      end

      promise.execute
    end

    #
    # Creates list of users with given input array
    #
    # @param body [Array<User>] List of user object
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def create_users_with_array_input(body = nil, custom_headers = nil)
      body.each{ |e| e.validate if e.respond_to?(:validate) } unless body.nil?
      # Construct URL
      path = "/user/createWithArray"
      url = URI.join(self.base_url, path)
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

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
      request_content = JSON.generate(body, quirks_mode: true)

      # Send Request
      promise = Concurrent::Promise.new do
        connection.post do |request|
          request.headers = request_headers
          request.body = request_content
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code >= 200 && status_code < 300)
          fail MsRest::HttpOperationError.new(connection, http_response)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)

        result
      end

      promise.execute
    end

    #
    # Creates list of users with given input array
    #
    # @param body [Array<User>] List of user object
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def create_users_with_list_input(body = nil, custom_headers = nil)
      body.each{ |e| e.validate if e.respond_to?(:validate) } unless body.nil?
      # Construct URL
      path = "/user/createWithList"
      url = URI.join(self.base_url, path)
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

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
      request_content = JSON.generate(body, quirks_mode: true)

      # Send Request
      promise = Concurrent::Promise.new do
        connection.post do |request|
          request.headers = request_headers
          request.body = request_content
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code >= 200 && status_code < 300)
          fail MsRest::HttpOperationError.new(connection, http_response)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)

        result
      end

      promise.execute
    end

    #
    # Logs user into the system
    #
    # @param username [String] The user name for login
    # @param password [String] The password for login in clear text
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def login_user(username = nil, password = nil, custom_headers = nil)
      # Construct URL
      path = "/user/login"
      url = URI.join(self.base_url, path)
      properties = { 'username' => username, 'password' => password }
      unless url.query.nil?
        url.query.split('&').each do |url_item|
          url_items_parts = url_item.split('=')
          properties[url_items_parts[0]] = url_items_parts[1]
        end
      end
      properties.reject!{ |key, value| value.nil? }
      url.query = properties.map{ |key, value| "#{key}=#{ERB::Util.url_encode(value.to_s)}" }.compact.join('&')
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Send Request
      promise = Concurrent::Promise.new do
        connection.get do |request|
          request.headers = request_headers
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code == 200 || status_code == 400)
          fail MsRest::HttpOperationError.new(connection, http_response)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)
        # Deserialize Response
        if status_code == 200
          begin
            parsed_response = JSON.load(response_content) unless response_content.to_s.empty?
            result.body = parsed_response
          rescue Exception => e
            fail MsRest::DeserializationError.new("Error occured in deserializing the response", e.message, e.backtrace, response_content)
          end
        end

        result
      end

      promise.execute
    end

    #
    # Logs out current logged in user session
    #
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def logout_user(custom_headers = nil)
      # Construct URL
      path = "/user/logout"
      url = URI.join(self.base_url, path)
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Send Request
      promise = Concurrent::Promise.new do
        connection.get do |request|
          request.headers = request_headers
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code >= 200 && status_code < 300)
          fail MsRest::HttpOperationError.new(connection, http_response)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)

        result
      end

      promise.execute
    end

    #
    # Get user by user name
    #
    # @param username [String] The name that needs to be fetched. Use user1 for
    # testing.
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def get_user_by_name(username, custom_headers = nil)
      fail ArgumentError, 'username is nil' if username.nil?
      # Construct URL
      path = "/user/{username}"
      path['{username}'] = ERB::Util.url_encode(username) if path.include?('{username}')
      url = URI.join(self.base_url, path)
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Send Request
      promise = Concurrent::Promise.new do
        connection.get do |request|
          request.headers = request_headers
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code == 404 || status_code == 200 || status_code == 400)
          fail MsRest::HttpOperationError.new(connection, http_response)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)
        # Deserialize Response
        if status_code == 200
          begin
            parsed_response = JSON.load(response_content) unless response_content.to_s.empty?
            unless parsed_response.nil?
              parsed_response = User.deserialize_object(parsed_response)
            end
            result.body = parsed_response
          rescue Exception => e
            fail MsRest::DeserializationError.new("Error occured in deserializing the response", e.message, e.backtrace, response_content)
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
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def update_user(username, body = nil, custom_headers = nil)
      fail ArgumentError, 'username is nil' if username.nil?
      body.validate unless body.nil?
      # Construct URL
      path = "/user/{username}"
      path['{username}'] = ERB::Util.url_encode(username) if path.include?('{username}')
      url = URI.join(self.base_url, path)
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Serialize Request
      request_headers['Content-Type'] = 'application/json; charset=utf-8'
      unless body.nil?
        body = User.serialize_object(body)
      end
      request_content = JSON.generate(body, quirks_mode: true)

      # Send Request
      promise = Concurrent::Promise.new do
        connection.put do |request|
          request.headers = request_headers
          request.body = request_content
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code == 404 || status_code == 400)
          fail MsRest::HttpOperationError.new(connection, http_response)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)

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
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def delete_user(username, custom_headers = nil)
      fail ArgumentError, 'username is nil' if username.nil?
      # Construct URL
      path = "/user/{username}"
      path['{username}'] = ERB::Util.url_encode(username) if path.include?('{username}')
      url = URI.join(self.base_url, path)
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Send Request
      promise = Concurrent::Promise.new do
        connection.delete do |request|
          request.headers = request_headers
          self.credentials.sign_request(request) unless self.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code == 404 || status_code == 400)
          fail MsRest::HttpOperationError.new(connection, http_response)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)

        result
      end

      promise.execute
    end

  end
end
