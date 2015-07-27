# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRestAzure
  #
  # Class which represents an Azure token credentials.
  #
  class AzureApplicationCredentials < MsRest::ServiceClientCredentials

    TOKEN_ACQUIRE_URL = 'https://login.windows.net/{tenant_id}/oauth2/token'
    REQUEST_BODY_PATTERN = 'resource={resource_uri}&client_id={client_id}&client_secret={client_secret}&grant_type=client_credentials'
    RESOURCE_URI = 'https://management.core.windows.net/'
  	DEFAULT_SCHEME = 'Bearer'

    # @return [String] auth token.
    attr_accessor :token

    # @return [String] tenant id (also known as domain).
    attr_accessor :tenant_id

    # @return [String] application id.
    attr_accessor :client_id

    # @return [String] application secret key.
    attr_accessor :client_secret

    #
    # Creates and initialize new instance of the ServiceClient class.
    # @param token [tenant_id] tenant id (also known as domain).
    # @param token [client_id] client id.
    # @param token [client_secret] client secret.
    def initialize(tenant_id, client_id, client_secret)
      fail ArgumentError, 'Tenant id cannot be nil' if tenant_id.nil?
      fail ArgumentError, 'Client id cannot be nil' if client_id.nil?
      fail ArgumentError, 'Client secret key cannot be nil' if client_secret.nil?

      @tenant_id = tenant_id
      @client_id = client_id
      @client_secret = client_secret
    end

    #
    # Retrieves a new authenticaion token.
    #
    # @return [String] new authentication token.
    def acquire_token
      token_acquire_url = TOKEN_ACQUIRE_URL
      token_acquire_url['{tenant_id}'] = @tenant_id

      url = URI.parse(token_acquire_url)
      request = Net::HTTP::Get.new(url.request_uri)

      request['content-type'] = 'application/x-www-form-urlencoded'

      request_body = REQUEST_BODY_PATTERN
      request_body['{resource_uri}'] = ERB::Util.url_encode(RESOURCE_URI)
      request_body['{client_id}'] = ERB::Util.url_encode(@client_id)
      request_body['{client_secret}'] = ERB::Util.url_encode(@client_secret)

      request.body = request_body

      http = Net::HTTP.new(url.host, url.port)

      if url.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      end

      response = http.request(request)
      fail CloudError, 'Could login to Azure, please verify your tenant id, client id and client secret' unless response.is_a?(Net::HTTPOK)

      @token = JSON.load(response.body)['access_token']
    end

    #
    # Attaches OAuth authentication header to the given HTTP request.
    # @param request [Net::HTTPRequest] the request authentication header needs to be attached to.
    #
    # @return [Net::HTTPRequest] request with attached authentication header
    def sign_request(request)
      super(request)
      credentials = "#{DEFAULT_SCHEME} #{token}"
      request[AUTHORIZATION] = credentials
    end
  end
end
