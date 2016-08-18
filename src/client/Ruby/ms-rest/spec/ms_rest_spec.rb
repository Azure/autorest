# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'rspec'
require 'ms_rest'

module MsRest
  describe 'Ms Rest' do
    it 'should not use any ssl options by default' do
      expect(MsRest.ssl_options).to be_nil
    end

    it 'should use bundled ssl certificate' do
      MsRest.use_ssl_cert
      expect(MsRest.ssl_options).to be_truthy
      expect(MsRest.ssl_options[:ca_file]).to match(/.*ca-cert.pem$/)
    end

    it 'should use user supplied ssl options' do
      MsRest.use_ssl_cert({:ca_file => 'cert_file', :cert_store => 'cert_store'})
      expect(MsRest.ssl_options).to be_truthy
      expect(MsRest.ssl_options[:ca_file]).to eq('cert_file')
      expect(MsRest.ssl_options[:cert_store]).to eq('cert_store')
    end
  end
end
