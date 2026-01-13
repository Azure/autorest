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
 * Linked service resource type.
 */
@parentResource(Factory)
model LinkedServiceResource
  is Azure.ResourceManager.ProxyResource<LinkedService, false> {
  ...ResourceNameParameter<
    Resource = LinkedServiceResource,
    KeyName = "linkedServiceName",
    SegmentName = "linkedservices",
    NamePattern = "^[A-Za-z0-9_][^<>*#.%&:\\\\+?/]*$"
  >;
  ...Azure.ResourceManager.Legacy.EntityTagProperty;
}

@armResourceOperations
interface LinkedServiceResources {
  /**
   * Gets a linked service.
   */
  get is ArmResourceRead<
    LinkedServiceResource,
    Parameters = {
      /**
       * ETag of the linked service entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
       */
      @header
      `If-None-Match`?: string;
    }
  >;

  /**
   * Creates or updates a linked service.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    LinkedServiceResource,
    Parameters = {
      /**
       * ETag of the linkedService entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
       */
      @header
      `If-Match`?: string;
    },
    Response = ArmResourceUpdatedResponse<LinkedServiceResource>
  >;

  /**
   * Deletes a linked service.
   */
  delete is ArmResourceDeleteSync<LinkedServiceResource>;

  /**
   * Lists linked services.
   */
  listByFactory is ArmResourceListByParent<
    LinkedServiceResource,
    Response = ArmResponse<LinkedServiceListResponse>
  >;
}

@@maxLength(LinkedServiceResource.name, 260);
@@minLength(LinkedServiceResource.name, 1);
@@doc(LinkedServiceResource.name, "The linked service name.");
@@doc(LinkedServiceResource.properties, "Properties of linked service.");
@@doc(LinkedServiceResources.createOrUpdate::parameters.resource,
  "Linked service resource definition."
);
