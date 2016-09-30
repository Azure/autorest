# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRest
  #
  # Class which represents the data received and deserialized from server.
  #
  class HttpOperationRequest

    # @return [Hash] path parameters to be ERB::Util.url_encode encoded
    attr_accessor :path_params
    
    # @return [Hash] path parameters not to be ERB::Util.url_encode encoded
    attr_accessor :skip_encoding_path_params
    
    # @return [Hash] query parameters to be ERB::Util.url_encode encoded
    attr_accessor :query_params
    
    # @return [Hash] query parameters to be ERB::Util.url_encode encoded
    attr_accessor :skip_encoding_query_params
    
    # @return [String] base uri of the request
    attr_accessor :base_uri
    
    # @return [String] path template /{replace}/{url_param}
    attr_accessor :path_template
    
    # @return [Hash] request headers
    attr_accessor :headers
    
    # @return [String] http request method
    attr_accessor :method

    # @return [String] the HTTP response body.
    attr_accessor :body
    
    # @return [Array] the list of middlewares to apply to the Request
    attr_accessor :middlewares
    
    # @return [String] full - to log requests, responses and bodies, partial - just requests and responses without body
    attr_accessor :log
    
    # @return [Array] strings to be appended to the user agent in the request
    attr_accessor :user_agent_extended
    
    # Creates and initialize new instance of the HttpOperationResponse class.
    # @param [String|URI] base uri for requests
    # @param [String] path template /{replace}/{url_param}
    # @param [String] http method for the request
    # @param [Hash] body the HTTP response body.
    def initialize(base_uri, path_template, method, options = {})
      fail 'path_template must not be nil' if path_template.nil?
      fail 'method must not be nil' if method.nil?
      
      @base_uri = base_uri || ''
      @path_template = path_template
      @method = method
      @headers = {}
      @user_agent_extended = []
      
      options.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end
    
    # Creates a promise which will execute the request. Block will yield the request for customization.
    # @return [URI] body the HTTP response body.
    def run_promise(&block)
      Concurrent::Promise.new do
        @connection ||= Faraday.new(:url => base_uri, :ssl => MsRest.ssl_options) do |faraday|
          middlewares.each{ |args| faraday.use(*args) } unless middlewares.nil?
          faraday.adapter Faraday.default_adapter
          logging = ENV['AZURE_HTTP_LOGGING'] || log
          if logging
            faraday.response :logger, nil, { :bodies => logging == 'full' }
          end
        end

        @connection.run_request(:"#{method}", build_path, body, {'User-Agent' => user_agent}.merge(headers)) do |req|
          req.params = req.params.merge(query_params.reject{|_, v| v.nil?}) unless query_params.nil?
          yield(req) if block_given?
        end
      end
    end
    
    
    # Creates a path from the path template and the path_params and skip_encoding_path_params
    # @return [URI] body the HTTP response body.
    def build_path
      template = path_template.dup
      path_params.each{ |key, value| template["{#{key}}"] = ERB::Util.url_encode(value) if template.include?("{#{key}}") } unless path_params.nil?
      skip_encoding_path_params.each{ |key, value| template["{#{key}}"] = value } unless skip_encoding_path_params.nil?
      path = URI.parse(template.gsub(/([^:])\/\//, '\1/'))
      unless skip_encoding_query_params.nil?
        path.query = [(path.query || ""), skip_encoding_query_params.reject{|_, v| v.nil?}.map{|k,v| "#{k}=#{v}"}].join('&')
      end
      path
    end
    
    def full_uri
      URI.join(base_uri || '', build_path)
    end
    
    def user_agent
      "Azure-SDK-For-Ruby/#{MsRest::VERSION}/#{user_agent_extended.join('/')}"
    end
    
    def to_json(*a)
      {
        base_uri: base_uri,
        path_template: path_template,
        method: method, 
        path_params: path_params,
        skip_encoding_path_params: skip_encoding_path_params,
        query_params: query_params,
        skip_encoding_query_params: skip_encoding_query_params,
        headers: headers,
        body: body,
        middlewares: middlewares,
        log: log  
      }.to_json(*a)
    end
    
  end
  
end
