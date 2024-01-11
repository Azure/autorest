import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Azure.ResourceManager.Dns;

interface DnsResourceReferenceOperations {
  @doc("Returns the DNS records specified by the referencing targetResourceIds.")
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Network/getDnsResourceReference")
  @post
  GetByTargetResources is Azure.Core.Foundations.Operation<
    {
      @doc("Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.")
      @path
      subscriptionId: string;

      @doc("Properties for dns resource reference request.")
      @body
      parameters: DnsResourceReferenceRequest;
    },
    DnsResourceReferenceResult
  >;
}
