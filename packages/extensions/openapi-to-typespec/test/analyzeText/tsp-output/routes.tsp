import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.Language.Authoring;

interface TextAnalysisAuthoringOperations {
  /**
   * Lists the existing projects.
   */
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
  createProject is Azure.Core.ResourceCreateOrUpdate<ProjectMetadata>;

  /**
   * Gets the details of a project.
   */
  getProject is Azure.Core.ResourceRead<ProjectMetadata>;

  /**
   * Deletes a project.
   */
  deleteProject is Azure.Core.LongRunningResourceDelete<ProjectMetadata>;

  /**
   * Triggers a job to export a project's data.
   */
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
      @body
      body: ExportedProject;
    },
    void
  >;

  /**
   * Triggers a training job for a project.
   */
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
      @body
      body: TrainingJobOptions;
    },
    void
  >;

  /**
   * Lists the deployments belonging to a project.
   */
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
      @body
      body: SwapDeploymentsOptions;
    },
    void
  >;

  /**
   * Gets the details of a deployment.
   */
  getDeployment is Azure.Core.ResourceRead<ProjectDeployment>;

  /**
   * Creates a new deployment or replaces an existing one.
   */
  deployProject is Azure.Core.LongRunningResourceCreateOrReplace<ProjectDeployment>;

  /**
   * Deletes a project deployment.
   */
  deleteDeployment is Azure.Core.LongRunningResourceDelete<ProjectDeployment>;

  /**
   * Gets the status of an existing deployment job.
   */
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
  getTrainedModel is Azure.Core.ResourceRead<ProjectTrainedModel>;

  /**
   * Deletes an existing trained model.
   */
  deleteTrainedModel is Azure.Core.ResourceDelete<ProjectTrainedModel>;

  /**
   * Gets the detailed results of the evaluation for a trained model. This includes
   * the raw inference results for the data included in the evaluation process.
   */
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
