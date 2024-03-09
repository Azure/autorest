import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.ResourceManager.Dns;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DnsResourceReferenceRequest.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DnsResourceReferenceResult.properties);
