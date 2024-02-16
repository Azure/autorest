import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Space.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.IntegrationSpaces;
/**
 * An integration application under space.
 */
@parentResource(Space)
model Application is TrackedResource<ApplicationProperties> {
  /**
   * The name of the Application
   */
  @pattern("[a-zA-Z0-9_.()-]{0,79}$")
  @path
  @key("applicationName")
  @segment("applications")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface Applications {
  /**
   * Get a Application
   */
  get is ArmResourceRead<Application>;

  /**
   * Create a Application
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<Application>;

  /**
   * Update a Application
   */
  @parameterVisibility("read")
  patch is ArmCustomPatchSync<Application, ApplicationUpdate>;

  /**
   * Delete a Application
   */
  delete is ArmResourceDeleteSync<Application>;

  /**
   * List Application resources by Space
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Applications_ListBySpace")
  listBySpace is ArmResourceListByParent<
    Application,
    {
      ...BaseParameters<Application>;

      /**
       * The number of result items to return.
       */
      @query("top")
      top?: int32;

      /**
       * The number of result items to skip.
       */
      @query("skip")
      skip?: int32;

      /**
       * The maximum number of result items per page.
       */
      @query("maxpagesize")
      maxpagesize?: int32;

      /**
       * Filter the result list using the given expression.
       */
      @query("filter")
      filter?: string;

      /**
       * Select the specified fields to be included in the response.
       */
      @query({
        name: "select",
        format: "multi",
      })
      select?: string[];

      /**
       * Expand the indicated resources into the response.
       */
      @query({
        name: "expand",
        format: "multi",
      })
      expand?: string[];

      /**
       * Expressions that specify the order of returned results.
       */
      @query({
        name: "orderby",
        format: "multi",
      })
      orderby?: string[];
    }
  >;

  /**
   * The delete business process development artifact action.
   */
  deleteBusinessProcessDevelopmentArtifact is ArmResourceActionSync<
    Application,
    GetOrDeleteBusinessProcessDevelopmentArtifactRequest,
    void
  >;

  /**
   * The get business process development artifact action.
   */
  getBusinessProcessDevelopmentArtifact is ArmResourceActionSync<
    Application,
    GetOrDeleteBusinessProcessDevelopmentArtifactRequest,
    SaveOrGetBusinessProcessDevelopmentArtifactResponse
  >;

  /**
   * The list business process development artifacts action.
   */
  listBusinessProcessDevelopmentArtifacts is ArmResourceActionSync<
    Application,
    void,
    ListBusinessProcessDevelopmentArtifactsResponse
  >;

  /**
   * The save business process development artifact action.
   */
  saveBusinessProcessDevelopmentArtifact is ArmResourceActionSync<
    Application,
    SaveOrValidateBusinessProcessDevelopmentArtifactRequest,
    SaveOrGetBusinessProcessDevelopmentArtifactResponse
  >;

  /**
   * The validate business process development artifact action.
   */
  validateBusinessProcessDevelopmentArtifact is ArmResourceActionSync<
    Application,
    SaveOrValidateBusinessProcessDevelopmentArtifactRequest,
    void
  >;
}
