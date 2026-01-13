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
 * Change data capture resource type.
 */
@parentResource(Factory)
model ChangeDataCaptureResource
  is Azure.ResourceManager.ProxyResource<ChangeDataCapture, false> {
  ...ResourceNameParameter<
    Resource = ChangeDataCaptureResource,
    KeyName = "changeDataCaptureName",
    SegmentName = "adfcdcs",
    NamePattern = "^[A-Za-z0-9_][^<>*#.%&:\\\\+?/]*$"
  >;
  ...Azure.ResourceManager.Legacy.EntityTagProperty;
}

@armResourceOperations
interface ChangeDataCaptureResources {
  /**
   * Gets a change data capture.
   */
  get is ArmResourceRead<
    ChangeDataCaptureResource,
    Parameters = {
      /**
       * ETag of the change data capture entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
       */
      @header
      `If-None-Match`?: string;
    }
  >;

  /**
   * Creates or updates a change data capture resource.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ChangeDataCaptureResource,
    Parameters = {
      /**
       * ETag of the change data capture entity. Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
       */
      @header
      `If-Match`?: string;
    },
    Response = ArmResourceUpdatedResponse<ChangeDataCaptureResource>
  >;

  /**
   * Deletes a change data capture.
   */
  delete is ArmResourceDeleteSync<ChangeDataCaptureResource>;

  /**
   * Lists all resources of type change data capture.
   */
  listByFactory is ArmResourceListByParent<
    ChangeDataCaptureResource,
    Response = ArmResponse<ChangeDataCaptureListResponse>
  >;

  /**
   * Starts a change data capture.
   */
  start is ArmResourceActionSync<ChangeDataCaptureResource, void, OkResponse>;

  /**
   * Stops a change data capture.
   */
  stop is ArmResourceActionSync<ChangeDataCaptureResource, void, OkResponse>;

  /**
   * Gets the current status for the change data capture resource.
   */
  @get
  status is ArmResourceActionSync<
    ChangeDataCaptureResource,
    void,
    ArmResponse<ChangeDataCaptureStatusResponse>
  >;
}

@@maxLength(ChangeDataCaptureResource.name, 260);
@@minLength(ChangeDataCaptureResource.name, 1);
@@doc(ChangeDataCaptureResource.name, "The change data capture name.");
@@doc(ChangeDataCaptureResource.properties,
  "Properties of the change data capture."
);
@@doc(ChangeDataCaptureResources.createOrUpdate::parameters.resource,
  "Change data capture resource definition."
);
