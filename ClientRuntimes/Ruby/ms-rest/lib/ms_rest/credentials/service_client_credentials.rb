# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRest
  #
  # Class that serves as a base for all authentications classes.
  #
  class ServiceClientCredentials

    AUTHORIZATION = 'authorization'

    #
    # Base method for performing authentication of HTTP requests.
    # @param request [Net::HTTPRequest] HTTP request to authenticate
    #
    # @return [Net::HTTPRequest] authenticated HTTP request
    def sign_request(request)
      fail ArgumentError, 'request is nil.' if request.nil?
    end
  end
end
