# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRestAzure
  module AzureEnvironments
    #
    # An instance of this class describes an environment in Azure
    #
    class AzureEnvironment

      # @return [String] the Environment name
      attr_reader :name

      # @return [String] the management portal URL
      attr_reader :portal_url

      # @return [String] the publish settings file URL
      attr_reader :publishing_profile_url

      # @return [String] the management service endpoint
      attr_reader :management_endpoint_url

      # @return [String] the resource management endpoint
      attr_reader :resource_manager_endpoint_url

      # @return [String] the sql server management endpoint for mobile commands
      attr_reader :sql_management_endpoint_url

      # @return [String] the dns suffix for sql servers
      attr_reader :sql_server_hostname_suffix

      # @return [String] the template gallery endpoint
      attr_reader :gallery_endpoint_url

      # @return [String] the Active Directory login endpoint
      attr_reader :active_directory_endpoint_url

      # @return [String] the resource ID to obtain AD tokens for
      attr_reader :active_directory_resource_id

      # @return [String] the Active Directory resource ID
      attr_reader :active_directory_graph_resource_id

      # @return [String] the Active Directory resource ID
      attr_reader :active_directory_graph_api_version

      # @return [String] the endpoint suffix for storage accounts
      attr_reader :storage_endpoint_suffix

      # @return [String] the KeyVault service dns suffix
      attr_reader :key_vault_dns_suffix

      # @return [String] the data lake store filesystem service dns suffix
      attr_reader :datalake_store_filesystem_endpoint_suffix

      # @return [String] the data lake analytics job and catalog service dns suffix
      attr_reader :datalake_analytics_catalog_and_job_endpoint_suffix

      # @return [Boolean] determines whether the authentication endpoint should be validated with Azure AD. Default value is true.
      attr_reader :validate_authority

      def initialize(options)
        required_properties = [:name, :portal_url, :management_endpoint_url, :resource_manager_endpoint_url, :active_directory_endpoint_url, :active_directory_resource_id]

        required_supplied_properties = required_properties & options.keys

        if required_supplied_properties.nil? || required_supplied_properties.empty? || (required_supplied_properties & required_properties) != required_properties
          raise ArgumentError.new("#{required_properties.to_s} are the required properties but provided properties are #{options.to_s}")
        end

        required_supplied_properties.each do |prop|
          if options[prop].nil? || !options[prop].is_a?(String) || options[prop].empty?
            raise ArgumentError.new("Value of the '#{prop}' property must be of type String and non empty.")
          end
        end

        # Setting default to true
        @validate_authority = true

        options.each do |k, v|
          instance_variable_set("@#{k}", v) unless v.nil?
        end
      end
    end

    Azure = AzureEnvironments::AzureEnvironment.new({
                                                        :name => 'Azure',
                                                        :portal_url => 'http://go.microsoft.com/fwlink/?LinkId=254433',
                                                        :publishing_profile_url => 'http://go.microsoft.com/fwlink/?LinkId=254432',
                                                        :management_endpoint_url => 'https://management.core.windows.net',
                                                        :resource_manager_endpoint_url => 'https://management.azure.com/',
                                                        :sql_management_endpoint_url => 'https://management.core.windows.net:8443/',
                                                        :sql_server_hostname_suffix => '.database.windows.net',
                                                        :gallery_endpoint_url => 'https://gallery.azure.com/',
                                                        :active_directory_endpoint_url => 'https://login.microsoftonline.com/',
                                                        :active_directory_resource_id => 'https://management.core.windows.net/',
                                                        :active_directory_graph_resource_id => 'https://graph.windows.net/',
                                                        :active_directory_graph_api_version => '2013-04-05',
                                                        :storage_endpoing_suffix => '.core.windows.net',
                                                        :key_vault_dns_suffix => '.vault.azure.net',
                                                        :datalake_store_filesystem_endpoint_suffix => 'azuredatalakestore.net',
                                                        :datalake_analytics_catalog_and_job_endpoint_suffix => 'azuredatalakeanalytics.net'
                                                    })
    AzureChina = AzureEnvironments::AzureEnvironment.new({
                                                             :name => 'AzureChina',
                                                             :portal_url => 'http://go.microsoft.com/fwlink/?LinkId=301902',
                                                             :publishing_profile_url => 'http://go.microsoft.com/fwlink/?LinkID=301774',
                                                             :management_endpoint_url => 'https://management.core.chinacloudapi.cn',
                                                             :resource_manager_endpoint_url => 'https://management.chinacloudapi.cn',
                                                             :sql_management_endpoint_url => 'https://management.core.chinacloudapi.cn:8443/',
                                                             :sql_server_hostname_suffix => '.database.chinacloudapi.cn',
                                                             :gallery_endpoint_url => 'https://gallery.chinacloudapi.cn/',
                                                             :active_directory_endpoint_url => 'https://login.chinacloudapi.cn/',
                                                             :active_directory_resource_id => 'https://management.core.chinacloudapi.cn/',
                                                             :active_directory_graph_resource_id => 'https://graph.chinacloudapi.cn/',
                                                             :active_directory_graph_api_version => '2013-04-05',
                                                             :storage_endpoing_suffix => '.core.chinacloudapi.cn',
                                                             :key_vault_dns_suffix => '.vault.azure.cn',
                                                             # TODO: add dns suffixes for the china cloud for datalake store and datalake analytics once they are defined.
                                                             :datalake_store_filesystem_endpoint_suffix => 'N/A',
                                                             :datalake_analytics_catalog_and_job_endpoint_suffix => 'N/A'
                                                         })
    AzureUSGovernment = AzureEnvironments::AzureEnvironment.new({
                                                                    :name => 'AzureUSGovernment',
                                                                    :portal_url => 'https://manage.windowsazure.us',
                                                                    :publishing_profile_url => 'https://manage.windowsazure.us/publishsettings/index',
                                                                    :management_endpoint_url => 'https://management.core.usgovcloudapi.net',
                                                                    :resource_manager_endpoint_url => 'https://management.usgovcloudapi.net',
                                                                    :sql_management_endpoint_url => 'https://management.core.usgovcloudapi.net:8443/',
                                                                    :sql_server_hostname_suffix => '.database.usgovcloudapi.net',
                                                                    :gallery_endpoint_url => 'https://gallery.usgovcloudapi.net/',
                                                                    :active_directory_endpoint_url => 'https://login.microsoftonline.com/',
                                                                    :active_directory_resource_id => 'https://management.core.usgovcloudapi.net/',
                                                                    :active_directory_graph_resource_id => 'https://graph.windows.net/',
                                                                    :active_directory_graph_api_version => '2013-04-05',
                                                                    :storage_endpoing_suffix => '.core.usgovcloudapi.net',
                                                                    :key_vault_dns_suffix => '.vault.usgovcloudapi.net',
                                                                    # TODO: add dns suffixes for the US government for datalake store and datalake analytics once they are defined.
                                                                    :datalake_store_filesystem_endpoint_suffix => 'N/A',
                                                                    :datalake_analytics_catalog_and_job_endpoint_suffix => 'N/A'
                                                                })
    AzureGermanCloud = AzureEnvironments::AzureEnvironment.new({
                                                                   :name => 'AzureGermanCloud',
                                                                   :portal_url => 'http://portal.microsoftazure.de/',
                                                                   :publishing_profile_url => 'https://manage.microsoftazure.de/publishsettings/index',
                                                                   :management_endpoint_url => 'https://management.core.cloudapi.de',
                                                                   :resource_manager_endpoint_url => 'https://management.microsoftazure.de',
                                                                   :sql_management_endpoint_url => 'https://management.core.cloudapi.de:8443/',
                                                                   :sql_server_hostname_suffix => '.database.cloudapi.de',
                                                                   :gallery_endpoint_url => 'https://gallery.cloudapi.de/',
                                                                   :active_directory_endpoint_url => 'https://login.microsoftonline.de/',
                                                                   :active_directory_resource_id => 'https://management.core.cloudapi.de/',
                                                                   :active_directory_graph_resource_id => 'https://graph.cloudapi.de/',
                                                                   :active_directory_graph_api_version => '2013-04-05',
                                                                   :storage_endpoing_suffix => '.core.cloudapi.de',
                                                                   :key_vault_dns_suffix => '.vault.microsoftazure.de',
                                                                   # TODO: add dns suffixes for the US government for datalake store and datalake analytics once they are defined.
                                                                   :datalake_store_filesystem_endpoint_suffix => 'N/A',
                                                                   :datalake_analytics_catalog_and_job_endpoint_suffix => 'N/A'
                                                               })
  end
end
