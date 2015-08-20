# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRest
  #
  # Class that provides access to authentication token.
  #
  class TokenProvider

    #
    # Returns the string value which needs to be attached
    # to HTTP request header in order to be authorized.
    #
    # @return [String] authentication headers.
    def get_authentication_header
    end
  end
end
