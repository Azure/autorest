import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.Language.Authoring;

interface TextAnalysisAuthoringOperations {
  @doc("Lists the existing projects.")
  listProjects is Azure.Core.ResourceList<
    ProjectMetadata,
    {
      parameters: {
        @doc("The maximum number of resources to return from the collection.")
        @query("top")
        top?: int32;

        @doc("An offset into the collection of the first resource to be returned.")
        @query("skip")
        skip?: int32;

        @doc("The maximum number of resources to include in a single response.")
        @query("maxpagesize")
        maxpagesize?: int32;
      };
    }
  >;

  @doc("Creates a new project or updates an existing one.")
  createProject is Azure.Core.ResourceCreateOrUpdate<ProjectMetadata>;

  @doc("Gets the details of a project.")
  getProject is Azure.Core.ResourceRead<ProjectMetadata>;

  @doc("Deletes a project.")
  deleteProject is Azure.Core.LongRunningResourceDelete<ProjectMetadata>;

  @doc("Triggers a job to export a project's data.")
  @route("/authoring/analyze-text/projects/{projectName}/:export")
  @post
  export is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @maxLength(100)
      @path
      projectName: string;

      @doc("""
Specifies the method used to interpret string offsets. For additional
information see https://aka.ms/text-analytics-offsets.
""")
      @query("stringIndexType")
      stringIndexType: StringIndexType;

      @doc("Kind of asset to export.")
      @query("assetKind")
      assetKind?: string;
    },
    void
  >;

  @doc("""
Triggers a job to import a project. If a project with the same name already
exists, the data of that project is replaced.
""")
  @route("/authoring/analyze-text/projects/{projectName}/:import")
  @post
  `import` is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @maxLength(100)
      @path
      projectName: string;

      @doc("The project data to import.")
      @body
      body: ExportedProject;
    },
    void
  >;

  @doc("Triggers a training job for a project.")
  @route("/authoring/analyze-text/projects/{projectName}/:train")
  @post
  train is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @maxLength(100)
      @path
      projectName: string;

      @doc("The training input parameters.")
      @body
      body: TrainingJobOptions;
    },
    void
  >;

  @doc("Lists the deployments belonging to a project.")
  listDeployments is Azure.Core.ResourceList<
    ProjectDeployment,
    {
      parameters: {
        @doc("The maximum number of resources to return from the collection.")
        @query("top")
        top?: int32;

        @doc("An offset into the collection of the first resource to be returned.")
        @query("skip")
        skip?: int32;

        @doc("The maximum number of resources to include in a single response.")
        @query("maxpagesize")
        maxpagesize?: int32;
      };
    }
  >;

  @doc("Swaps two existing deployments with each other.")
  @route("/authoring/analyze-text/projects/{projectName}/deployments/:swap")
  @post
  swapDeployments is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @maxLength(100)
      @path
      projectName: string;

      @doc("The job object to swap two deployments.")
      @body
      body: SwapDeploymentsOptions;
    },
    void
  >;

  @doc("Gets the details of a deployment.")
  getDeployment is Azure.Core.ResourceRead<ProjectDeployment>;

  @doc("Creates a new deployment or replaces an existing one.")
  deployProject is Azure.Core.LongRunningResourceCreateOrReplace<ProjectDeployment>;

  @doc("Deletes a project deployment.")
  deleteDeployment is Azure.Core.LongRunningResourceDelete<ProjectDeployment>;

  @doc("Gets the status of an existing deployment job.")
  @route("/authoring/analyze-text/projects/{projectName}/deployments/{deploymentName}/jobs/{jobId}")
  @get
  getDeploymentStatus is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @maxLength(100)
      @path
      projectName: string;

      @doc("The name of the specific deployment of the project to use.")
      @path
      deploymentName: string;

      @doc("The job ID.")
      @path
      jobId: string;
    },
    DeploymentJobState
  >;

  @doc("Gets the status of an existing swap deployment job.")
  @route("/authoring/analyze-text/projects/{projectName}/deployments/swap/jobs/{jobId}")
  @get
  getSwapDeploymentsStatus is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @maxLength(100)
      @path
      projectName: string;

      @doc("The job ID.")
      @path
      jobId: string;
    },
    DeploymentJobState
  >;

  @doc("""
Gets the status of an export job. Once job completes, returns the project
metadata, and assets.
""")
  @route("/authoring/analyze-text/projects/{projectName}/export/jobs/{jobId}")
  @get
  getExportStatus is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @maxLength(100)
      @path
      projectName: string;

      @doc("The job ID.")
      @path
      jobId: string;
    },
    ExportProjectJobState
  >;

  @doc("Gets the status for an import.")
  @route("/authoring/analyze-text/projects/{projectName}/import/jobs/{jobId}")
  @get
  getImportStatus is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @maxLength(100)
      @path
      projectName: string;

      @doc("The job ID.")
      @path
      jobId: string;
    },
    ImportProjectJobState
  >;

  @doc("Lists the trained models belonging to a project.")
  listTrainedModels is Azure.Core.ResourceList<
    ProjectTrainedModel,
    {
      parameters: {
        @doc("The maximum number of resources to return from the collection.")
        @query("top")
        top?: int32;

        @doc("An offset into the collection of the first resource to be returned.")
        @query("skip")
        skip?: int32;

        @doc("The maximum number of resources to include in a single response.")
        @query("maxpagesize")
        maxpagesize?: int32;
      };
    }
  >;

  @doc("Gets the details of a trained model.")
  getTrainedModel is Azure.Core.ResourceRead<ProjectTrainedModel>;

  @doc("Deletes an existing trained model.")
  deleteTrainedModel is Azure.Core.ResourceDelete<ProjectTrainedModel>;

  @doc("""
Gets the detailed results of the evaluation for a trained model. This includes
the raw inference results for the data included in the evaluation process.
""")
  @route("/authoring/analyze-text/projects/{projectName}/models/{trainedModelLabel}/evaluation/result")
  @get
  getModelEvaluationResults is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @maxLength(100)
      @path
      projectName: string;

      @doc("The trained model label.")
      @path
      trainedModelLabel: string;

      @doc("""
Specifies the method used to interpret string offsets. For additional
information see https://aka.ms/text-analytics-offsets.
""")
      @query("stringIndexType")
      stringIndexType: StringIndexType;

      @doc("The maximum number of resources to return from the collection.")
      @query("top")
      top?: int32;

      @doc("An offset into the collection of the first resource to be returned.")
      @query("skip")
      skip?: int32;

      @doc("The maximum number of resources to include in a single response.")
      @query("maxpagesize")
      maxpagesize?: int32;
    },
    EvaluationResults
  >;

  @doc("""
Gets the evaluation summary of a trained model. The summary includes high level
performance measurements of the model e.g., F1, Precision, Recall, etc.
""")
  @route("/authoring/analyze-text/projects/{projectName}/models/{trainedModelLabel}/evaluation/summary-result")
  @get
  getModelEvaluationSummary is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @maxLength(100)
      @path
      projectName: string;

      @doc("The trained model label.")
      @path
      trainedModelLabel: string;
    },
    EvaluationSummary
  >;

  @doc("Lists the non-expired training jobs created for a project.")
  @route("/authoring/analyze-text/projects/{projectName}/train/jobs")
  @get
  listTrainingJobs is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @maxLength(100)
      @path
      projectName: string;

      @doc("The maximum number of resources to return from the collection.")
      @query("top")
      top?: int32;

      @doc("An offset into the collection of the first resource to be returned.")
      @query("skip")
      skip?: int32;

      @doc("The maximum number of resources to include in a single response.")
      @query("maxpagesize")
      maxpagesize?: int32;
    },
    TrainingJobs
  >;

  @doc("Gets the status for a training job.")
  @route("/authoring/analyze-text/projects/{projectName}/train/jobs/{jobId}")
  @get
  getTrainingStatus is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @maxLength(100)
      @path
      projectName: string;

      @doc("The job ID.")
      @path
      jobId: string;
    },
    TrainingJobState
  >;

  @doc("Triggers a cancellation for a running training job.")
  @route("/authoring/analyze-text/projects/{projectName}/train/jobs/{jobId}/:cancel")
  @post
  cancelTrainingJob is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @maxLength(100)
      @path
      projectName: string;

      @doc("The job ID.")
      @path
      jobId: string;
    },
    void
  >;

  @doc("Gets the status for a project deletion job.")
  @route("/authoring/analyze-text/projects/global/deletion-jobs/{jobId}")
  @get
  getProjectDeletionStatus is Azure.Core.Foundations.Operation<
    {
      @doc("The job ID.")
      @path
      jobId: string;
    },
    ProjectDeletionJobState
  >;

  @doc("Lists the supported languages.")
  getSupportedLanguages is Azure.Core.ResourceList<
    SupportedLanguage,
    {
      parameters: {
        @doc("The maximum number of resources to return from the collection.")
        @query("top")
        top?: int32;

        @doc("An offset into the collection of the first resource to be returned.")
        @query("skip")
        skip?: int32;

        @doc("The maximum number of resources to include in a single response.")
        @query("maxpagesize")
        maxpagesize?: int32;
      };
    }
  >;

  @doc("Lists the support training config version for a given project type.")
  @route("/authoring/analyze-text/projects/global/training-config-versions")
  @get
  listTrainingConfigVersions is Azure.Core.Foundations.Operation<
    {
      @doc("The project kind.")
      @query("projectKind")
      projectKind: ProjectKind;

      @doc("The maximum number of resources to return from the collection.")
      @query("top")
      top?: int32;

      @doc("An offset into the collection of the first resource to be returned.")
      @query("skip")
      skip?: int32;

      @doc("The maximum number of resources to include in a single response.")
      @query("maxpagesize")
      maxpagesize?: int32;
    },
    TrainingConfigVersions
  >;
}
