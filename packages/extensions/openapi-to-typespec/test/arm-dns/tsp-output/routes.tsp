// FIXME: Operations in this file are not detected as a resource operation, please confirm the conversion result manually

import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Azure.ResourceManager.Dns;

interface DnsResourceReferenceOperations {
  /**
   * Returns the DNS records specified by the referencing targetResourceIds.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Network/getDnsResourceReference")
  @post
  getByTargetResources(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,

    /**
     * Properties for dns resource reference request.
     */
    @body
    parameters: DnsResourceReferenceRequest,
  ): ArmResponse<DnsResourceReferenceResult> | ErrorResponse;
}
