import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./DeviceGroup.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.AzureSphere;
/**
 * An deployment resource belonging to a device group resource.
 */
@parentResource(DeviceGroup)
model Deployment is Azure.ResourceManager.ProxyResource<DeploymentProperties> {
  ...ResourceNameParameter<
    Resource = Deployment,
    KeyName = "deploymentName",
    SegmentName = "deployments",
    NamePattern = ""
  >;
}

@armResourceOperations
interface Deployments {
  /**
   * Get a Deployment. '.default' and '.unassigned' are system defined values and cannot be used for product or device group name.
   */
  get is ArmResourceRead<Deployment>;

  /**
   * Create a Deployment. '.default' and '.unassigned' are system defined values and cannot be used for product or device group name.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Deployment>;

  /**
   * Delete a Deployment. '.default' and '.unassigned' are system defined values and cannot be used for product or device group name.
   */
  delete is ArmResourceDeleteAsync<Deployment>;

  /**
   * List Deployment resources by DeviceGroup. '.default' and '.unassigned' are system defined values and cannot be used for product or device group name.
   */
  listByDeviceGroup is ArmResourceListByParent<
    Deployment,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<Deployment>;

      /**
       * Filter the result list using the given expression
       */
      @query("$filter")
      filter?: string;

      /**
       * The number of result items to return.
       */
      @query("$top")
      top?: int32;

      /**
       * The number of result items to skip.
       */
      @query("$skip")
      skip?: int32;

      /**
       * The maximum number of result items per page.
       */
      @query("$maxpagesize")
      maxpagesize?: int32;
    }
  >;
}

@@doc(Deployment.name,
  "Deployment name. Use .default for deployment creation and to get the current deployment for the associated device group."
);
@@doc(Deployment.properties,
  "The resource-specific properties for this resource."
);
