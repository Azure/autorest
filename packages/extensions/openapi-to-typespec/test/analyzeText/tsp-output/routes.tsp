import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@typespec/openapi";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.Language.Authoring;

interface TextAnalysisAuthoringOperations {
  /**
   * Lists the existing projects.
   */
  @operationId("TextAnalysisAuthoring_ListProjects")
  listProjects is Azure.Core.ResourceList<
    ProjectMetadata,
    {
      parameters: {
        /**
         * The maximum number of resources to return from the collection.
         */
        @query("top")
        top?: int32;

        /**
         * An offset into the collection of the first resource to be returned.
         */
        @query("skip")
        skip?: int32;

        /**
         * The maximum number of resources to include in a single response.
         */
        @query("maxpagesize")
        maxpagesize?: int32;
      };
    }
  >;

  /**
   * Creates a new project or updates an existing one.
   */
  @operationId("TextAnalysisAuthoring_CreateProject")
  createProject is Azure.Core.ResourceCreateOrUpdate<ProjectMetadata>;

  /**
   * Gets the details of a project.
   */
  @operationId("TextAnalysisAuthoring_GetProject")
  getProject is Azure.Core.ResourceRead<ProjectMetadata>;

  /**
   * Deletes a project.
   */
  @operationId("TextAnalysisAuthoring_DeleteProject")
  deleteProject is Azure.Core.LongRunningResourceDelete<ProjectMetadata>;

  /**
   * Triggers a job to export a project's data.
   */
  @operationId("TextAnalysisAuthoring_Export")
  @route("/authoring/analyze-text/projects/{projectName}/:export")
  @post
  export is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;

      /**
       * Specifies the method used to interpret string offsets. For additional
       * information see https://aka.ms/text-analytics-offsets.
       */
      @query("stringIndexType")
      stringIndexType: StringIndexType;

      /**
       * Kind of asset to export.
       */
      @query("assetKind")
      assetKind?: string;
    },
    void
  >;

  /**
   * Triggers a job to import a project. If a project with the same name already
   * exists, the data of that project is replaced.
   */
  @operationId("TextAnalysisAuthoring_Import")
  @route("/authoring/analyze-text/projects/{projectName}/:import")
  @post
  `import` is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;

      /**
       * The project data to import.
       */
      @bodyRoot
      body: ExportedProject;
    },
    void
  >;

  /**
   * Triggers a training job for a project.
   */
  @operationId("TextAnalysisAuthoring_Train")
  @route("/authoring/analyze-text/projects/{projectName}/:train")
  @post
  train is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;

      /**
       * The training input parameters.
       */
      @bodyRoot
      body: TrainingJobOptions;
    },
    void
  >;

  /**
   * Lists the deployments belonging to a project.
   */
  @operationId("TextAnalysisAuthoring_ListDeployments")
  listDeployments is Azure.Core.ResourceList<
    ProjectDeployment,
    {
      parameters: {
        /**
         * The maximum number of resources to return from the collection.
         */
        @query("top")
        top?: int32;

        /**
         * An offset into the collection of the first resource to be returned.
         */
        @query("skip")
        skip?: int32;

        /**
         * The maximum number of resources to include in a single response.
         */
        @query("maxpagesize")
        maxpagesize?: int32;
      };
    }
  >;

  /**
   * Swaps two existing deployments with each other.
   */
  @operationId("TextAnalysisAuthoring_SwapDeployments")
  @route("/authoring/analyze-text/projects/{projectName}/deployments/:swap")
  @post
  swapDeployments is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;

      /**
       * The job object to swap two deployments.
       */
      @bodyRoot
      body: SwapDeploymentsOptions;
    },
    void
  >;

  /**
   * Gets the details of a deployment.
   */
  @operationId("TextAnalysisAuthoring_GetDeployment")
  getDeployment is Azure.Core.ResourceRead<ProjectDeployment>;

  /**
   * Creates a new deployment or replaces an existing one.
   */
  @operationId("TextAnalysisAuthoring_DeployProject")
  deployProject is Azure.Core.LongRunningResourceCreateOrReplace<ProjectDeployment>;

  /**
   * Deletes a project deployment.
   */
  @operationId("TextAnalysisAuthoring_DeleteDeployment")
  deleteDeployment is Azure.Core.LongRunningResourceDelete<ProjectDeployment>;

  /**
   * Gets the status of an existing deployment job.
   */
  @operationId("TextAnalysisAuthoring_GetDeploymentStatus")
  @route("/authoring/analyze-text/projects/{projectName}/deployments/{deploymentName}/jobs/{jobId}")
  @get
  getDeploymentStatus is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;

      /**
       * The name of the specific deployment of the project to use.
       */
      @path
      deploymentName: string;

      /**
       * The job ID.
       */
      @path
      jobId: string;
    },
    DeploymentJobState
  >;

  /**
   * Gets the status of an existing swap deployment job.
   */
  @operationId("TextAnalysisAuthoring_GetSwapDeploymentsStatus")
  @route("/authoring/analyze-text/projects/{projectName}/deployments/swap/jobs/{jobId}")
  @get
  getSwapDeploymentsStatus is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;

      /**
       * The job ID.
       */
      @path
      jobId: string;
    },
    DeploymentJobState
  >;

  /**
   * Gets the status of an export job. Once job completes, returns the project
   * metadata, and assets.
   */
  @operationId("TextAnalysisAuthoring_GetExportStatus")
  @route("/authoring/analyze-text/projects/{projectName}/export/jobs/{jobId}")
  @get
  getExportStatus is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;

      /**
       * The job ID.
       */
      @path
      jobId: string;
    },
    ExportProjectJobState
  >;

  /**
   * Gets the status for an import.
   */
  @operationId("TextAnalysisAuthoring_GetImportStatus")
  @route("/authoring/analyze-text/projects/{projectName}/import/jobs/{jobId}")
  @get
  getImportStatus is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;

      /**
       * The job ID.
       */
      @path
      jobId: string;
    },
    ImportProjectJobState
  >;

  /**
   * Lists the trained models belonging to a project.
   */
  @operationId("TextAnalysisAuthoring_ListTrainedModels")
  listTrainedModels is Azure.Core.ResourceList<
    ProjectTrainedModel,
    {
      parameters: {
        /**
         * The maximum number of resources to return from the collection.
         */
        @query("top")
        top?: int32;

        /**
         * An offset into the collection of the first resource to be returned.
         */
        @query("skip")
        skip?: int32;

        /**
         * The maximum number of resources to include in a single response.
         */
        @query("maxpagesize")
        maxpagesize?: int32;
      };
    }
  >;

  /**
   * Gets the details of a trained model.
   */
  @operationId("TextAnalysisAuthoring_GetTrainedModel")
  getTrainedModel is Azure.Core.ResourceRead<ProjectTrainedModel>;

  /**
   * Deletes an existing trained model.
   */
  @operationId("TextAnalysisAuthoring_DeleteTrainedModel")
  deleteTrainedModel is Azure.Core.ResourceDelete<ProjectTrainedModel>;

  /**
   * Gets the detailed results of the evaluation for a trained model. This includes
   * the raw inference results for the data included in the evaluation process.
   */
  @operationId("TextAnalysisAuthoring_GetModelEvaluationResults")
  @route("/authoring/analyze-text/projects/{projectName}/models/{trainedModelLabel}/evaluation/result")
  @get
  getModelEvaluationResults is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;

      /**
       * The trained model label.
       */
      @path
      trainedModelLabel: string;

      /**
       * Specifies the method used to interpret string offsets. For additional
       * information see https://aka.ms/text-analytics-offsets.
       */
      @query("stringIndexType")
      stringIndexType: StringIndexType;

      /**
       * The maximum number of resources to return from the collection.
       */
      @query("top")
      top?: int32;

      /**
       * An offset into the collection of the first resource to be returned.
       */
      @query("skip")
      skip?: int32;

      /**
       * The maximum number of resources to include in a single response.
       */
      @query("maxpagesize")
      maxpagesize?: int32;
    },
    EvaluationResults
  >;

  /**
   * Gets the evaluation summary of a trained model. The summary includes high level
   * performance measurements of the model e.g., F1, Precision, Recall, etc.
   */
  @operationId("TextAnalysisAuthoring_GetModelEvaluationSummary")
  @route("/authoring/analyze-text/projects/{projectName}/models/{trainedModelLabel}/evaluation/summary-result")
  @get
  getModelEvaluationSummary is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;

      /**
       * The trained model label.
       */
      @path
      trainedModelLabel: string;
    },
    EvaluationSummary
  >;

  /**
   * Lists the non-expired training jobs created for a project.
   */
  @operationId("TextAnalysisAuthoring_ListTrainingJobs")
  @route("/authoring/analyze-text/projects/{projectName}/train/jobs")
  @get
  listTrainingJobs is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;

      /**
       * The maximum number of resources to return from the collection.
       */
      @query("top")
      top?: int32;

      /**
       * An offset into the collection of the first resource to be returned.
       */
      @query("skip")
      skip?: int32;

      /**
       * The maximum number of resources to include in a single response.
       */
      @query("maxpagesize")
      maxpagesize?: int32;
    },
    TrainingJobs
  >;

  /**
   * Gets the status for a training job.
   */
  @operationId("TextAnalysisAuthoring_GetTrainingStatus")
  @route("/authoring/analyze-text/projects/{projectName}/train/jobs/{jobId}")
  @get
  getTrainingStatus is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;

      /**
       * The job ID.
       */
      @path
      jobId: string;
    },
    TrainingJobState
  >;

  /**
   * Triggers a cancellation for a running training job.
   */
  @operationId("TextAnalysisAuthoring_CancelTrainingJob")
  @route("/authoring/analyze-text/projects/{projectName}/train/jobs/{jobId}/:cancel")
  @post
  cancelTrainingJob is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;

      /**
       * The job ID.
       */
      @path
      jobId: string;
    },
    void
  >;

  /**
   * Gets the status for a project deletion job.
   */
  @operationId("TextAnalysisAuthoring_GetProjectDeletionStatus")
  @route("/authoring/analyze-text/projects/global/deletion-jobs/{jobId}")
  @get
  getProjectDeletionStatus is Azure.Core.Foundations.Operation<
    {
      /**
       * The job ID.
       */
      @path
      jobId: string;
    },
    ProjectDeletionJobState
  >;

  /**
   * Lists the supported languages.
   */
  @operationId("TextAnalysisAuthoring_GetSupportedLanguages")
  getSupportedLanguages is Azure.Core.ResourceList<
    SupportedLanguage,
    {
      parameters: {
        /**
         * The maximum number of resources to return from the collection.
         */
        @query("top")
        top?: int32;

        /**
         * An offset into the collection of the first resource to be returned.
         */
        @query("skip")
        skip?: int32;

        /**
         * The maximum number of resources to include in a single response.
         */
        @query("maxpagesize")
        maxpagesize?: int32;
      };
    }
  >;

  /**
   * Lists the support training config version for a given project type.
   */
  @operationId("TextAnalysisAuthoring_ListTrainingConfigVersions")
  @route("/authoring/analyze-text/projects/global/training-config-versions")
  @get
  listTrainingConfigVersions is Azure.Core.Foundations.Operation<
    {
      /**
       * The project kind.
       */
      @query("projectKind")
      projectKind: ProjectKind;

      /**
       * The maximum number of resources to return from the collection.
       */
      @query("top")
      top?: int32;

      /**
       * An offset into the collection of the first resource to be returned.
       */
      @query("skip")
      skip?: int32;

      /**
       * The maximum number of resources to include in a single response.
       */
      @query("maxpagesize")
      maxpagesize?: int32;
    },
    TrainingConfigVersions
  >;
}
