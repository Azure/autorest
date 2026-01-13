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
 * Pipeline resource type.
 */
@parentResource(Factory)
model PipelineResource is Azure.ResourceManager.ProxyResource<Pipeline, false> {
  ...ResourceNameParameter<
    Resource = PipelineResource,
    KeyName = "pipelineName",
    SegmentName = "pipelines",
    NamePattern = "^[A-Za-z0-9_][^<>*#.%&:\\\\+?/]*$"
  >;
  ...Azure.ResourceManager.Legacy.EntityTagProperty;
}

@armResourceOperations
interface PipelineResources {
  /**
   * Gets a pipeline.
   */
  get is ArmResourceRead<
    PipelineResource,
    Parameters = {
      /**
       * ETag of the pipeline entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
       */
      @header
      `If-None-Match`?: string;
    }
  >;

  /**
   * Creates or updates a pipeline.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    PipelineResource,
    Parameters = {
      /**
       * ETag of the pipeline entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
       */
      @header
      `If-Match`?: string;
    },
    Response = ArmResourceUpdatedResponse<PipelineResource>
  >;

  /**
   * Deletes a pipeline.
   */
  delete is ArmResourceDeleteSync<PipelineResource>;

  /**
   * Lists pipelines.
   */
  listByFactory is ArmResourceListByParent<
    PipelineResource,
    Response = ArmResponse<PipelineListResponse>
  >;

  /**
   * Creates a run of a pipeline.
   */
  createRun is ArmResourceActionSync<
    PipelineResource,
    Record<unknown>,
    ArmResponse<CreateRunResponse>,
    Parameters = {
      /**
       * The pipeline run identifier. If run ID is specified the parameters of the specified run will be used to create a new run.
       */
      @query("referencePipelineRunId")
      referencePipelineRunId?: string;

      /**
       * Recovery mode flag. If recovery mode is set to true, the specified referenced pipeline run and the new run will be grouped under the same groupId.
       */
      @query("isRecovery")
      isRecovery?: boolean;

      /**
       * In recovery mode, the rerun will start from this activity. If not specified, all activities will run.
       */
      @query("startActivityName")
      startActivityName?: string;

      /**
       * In recovery mode, if set to true, the rerun will start from failed activities. The property will be used only if startActivityName is not specified.
       */
      @query("startFromFailure")
      startFromFailure?: boolean;
    },
    OptionalRequestBody = true
  >;
}

@@maxLength(PipelineResource.name, 260);
@@minLength(PipelineResource.name, 1);
@@doc(PipelineResource.name, "The pipeline name.");
@@doc(PipelineResource.properties, "Properties of the pipeline.");
@@doc(PipelineResources.createOrUpdate::parameters.resource,
  "Pipeline resource definition."
);
@@doc(PipelineResources.createRun::parameters.body,
  "Parameters of the pipeline run. These parameters will be used only if the runId is not specified."
);
