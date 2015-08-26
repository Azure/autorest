# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRestAzure
  #
  # Class which represents an settings for Azure AD authentication.
  #
  class ActiveDirectoryServiceSettings

    # @return [String] auth token.
    attr_accessor :authentication_endpoint

    # @return [String] auth token.
    attr_accessor :token_audience

    #
    # Returns a set of properties required to login into regular Azure.
    #
    # @return [ActiveDirectoryServiceSettings] settings required for authentication.
    def self.get_azure_settings
      settings = ActiveDirectoryServiceSettings.new
      settings.authentication_endpoint = 'https://login.windows.net/'
      settings.token_audience = 'https://management.core.windows.net/'
      settings
    end

    #
    # Returns a set of properties required to login into Azure China.
    #
    # @return [ActiveDirectoryServiceSettings] settings required for authentication.
    def self.get_azure_china_settings
      settings = ActiveDirectoryServiceSettings.new
      settings.authentication_endpoint = 'https://login.chinacloudapi.cn/'
      settings.token_audience = 'https://management.core.chinacloudapi.cn/'
      settings
    end
  end
end
