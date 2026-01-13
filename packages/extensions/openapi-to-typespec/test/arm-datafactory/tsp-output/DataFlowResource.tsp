import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Factory.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.DataFactory;
/**
 * Data flow resource type.
 */
@parentResource(Factory)
model DataFlowResource is Azure.ResourceManager.ProxyResource<DataFlow, false> {
  ...ResourceNameParameter<
    Resource = DataFlowResource,
    KeyName = "dataFlowName",
    SegmentName = "dataflows",
    NamePattern = "^[A-Za-z0-9_][^<>*#.%&:\\\\+?/]*$"
  >;
  ...Azure.ResourceManager.Legacy.EntityTagProperty;
}

@armResourceOperations
interface DataFlowResources {
  /**
   * Gets a data flow.
   */
  get is ArmResourceRead<
    DataFlowResource,
    Parameters = {
      /**
       * ETag of the data flow entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
       */
      @header
      `If-None-Match`?: string;
    }
  >;

  /**
   * Creates or updates a data flow.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    DataFlowResource,
    Parameters = {
      /**
       * ETag of the data flow entity. Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
       */
      @header
      `If-Match`?: string;
    },
    Response = ArmResourceUpdatedResponse<DataFlowResource>
  >;

  /**
   * Deletes a data flow.
   */
  delete is ArmResourceDeleteSync<DataFlowResource>;

  /**
   * Lists data flows.
   */
  listByFactory is ArmResourceListByParent<
    DataFlowResource,
    Response = ArmResponse<DataFlowListResponse>
  >;
}

@@maxLength(DataFlowResource.name, 260);
@@minLength(DataFlowResource.name, 1);
@@doc(DataFlowResource.name, "The data flow name.");
@@doc(DataFlowResource.properties, "Data flow properties.");
@@doc(DataFlowResources.createOrUpdate::parameters.resource,
  "Data flow resource definition."
);
