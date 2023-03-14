import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.Language.Authoring;

interface TextAnalysisAuthoringOperations {
  @doc("Lists the existing projects.")
  ListProjects is Azure.Core.ResourceList<
    ProjectMetadata,
    {
      parameters: {
        @doc("The maximum number of resources to return from the collection.")
        @query
        top: int32;

        @doc("An offset into the collection of the first resource to be returned.")
        @query
        skip: int32;

        @doc("The maximum number of resources to include in a single response.")
        @query
        maxpagesize: int32;
      };
    }
  >;

  @doc("Creates a new project or updates an existing one.")
  CreateProject is Azure.Core.ResourceCreateOrUpdate<ProjectMetadata>;

  @doc("Gets the details of a project.")
  GetProject is Azure.Core.ResourceRead<ProjectMetadata>;

  @doc("Deletes a project.")
  DeleteProject is Azure.Core.LongRunningResourceDelete<ProjectMetadata>;

  @doc("Triggers a job to export a project's data.")
  @route("/authoring/analyze-text/projects/{projectName}/:export")
  @post
  Export is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @path
      projectName: string;

      @doc("""
Specifies the method used to interpret string offsets. For additional
information see https://aka.ms/text-analytics-offsets.
""")
      @query
      stringIndexType: StringIndexType;

      @doc("Kind of asset to export.")
      @query
      assetKind: string;
    },
    void
  >;

  @doc("""
Triggers a job to import a project. If a project with the same name already
exists, the data of that project is replaced.
""")
  @route("/authoring/analyze-text/projects/{projectName}/:import")
  @post
  Import is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
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
  Train is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @path
      projectName: string;

      @doc("The training input parameters.")
      @body
      body: TrainingJobOptions;
    },
    void
  >;

  @doc("Lists the deployments belonging to a project.")
  ListDeployments is Azure.Core.ResourceList<
    ProjectDeployment,
    {
      parameters: {
        @doc("The maximum number of resources to return from the collection.")
        @query
        top: int32;

        @doc("An offset into the collection of the first resource to be returned.")
        @query
        skip: int32;

        @doc("The maximum number of resources to include in a single response.")
        @query
        maxpagesize: int32;
      };
    }
  >;

  @doc("Swaps two existing deployments with each other.")
  @route("/authoring/analyze-text/projects/{projectName}/deployments/:swap")
  @post
  SwapDeployments is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @path
      projectName: string;

      @doc("The job object to swap two deployments.")
      @body
      body: SwapDeploymentsOptions;
    },
    void
  >;

  @doc("Gets the details of a deployment.")
  GetDeployment is Azure.Core.ResourceRead<ProjectDeployment>;

  @doc("Creates a new deployment or replaces an existing one.")
  DeployProject is Azure.Core.LongRunningResourceCreateOrReplace<ProjectDeployment>;

  @doc("Deletes a project deployment.")
  DeleteDeployment is Azure.Core.LongRunningResourceDelete<ProjectDeployment>;

  @doc("Gets the status of an existing deployment job.")
  @route("/authoring/analyze-text/projects/{projectName}/deployments/{deploymentName}/jobs/{jobId}")
  @get
  GetDeploymentStatus is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
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
  GetSwapDeploymentsStatus is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
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
  GetExportStatus is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
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
  GetImportStatus is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @path
      projectName: string;

      @doc("The job ID.")
      @path
      jobId: string;
    },
    ImportProjectJobState
  >;

  @doc("Lists the trained models belonging to a project.")
  ListTrainedModels is Azure.Core.ResourceList<
    ProjectTrainedModel,
    {
      parameters: {
        @doc("The maximum number of resources to return from the collection.")
        @query
        top: int32;

        @doc("An offset into the collection of the first resource to be returned.")
        @query
        skip: int32;

        @doc("The maximum number of resources to include in a single response.")
        @query
        maxpagesize: int32;
      };
    }
  >;

  @doc("Gets the details of a trained model.")
  GetTrainedModel is Azure.Core.ResourceRead<ProjectTrainedModel>;

  @doc("Deletes an existing trained model.")
  DeleteTrainedModel is Azure.Core.ResourceDelete<ProjectTrainedModel>;

  @doc("""
Gets the detailed results of the evaluation for a trained model. This includes
the raw inference results for the data included in the evaluation process.
""")
  @route("/authoring/analyze-text/projects/{projectName}/models/{trainedModelLabel}/evaluation/result")
  @get
  GetModelEvaluationResults is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @path
      projectName: string;

      @doc("The trained model label.")
      @path
      trainedModelLabel: string;

      @doc("""
Specifies the method used to interpret string offsets. For additional
information see https://aka.ms/text-analytics-offsets.
""")
      @query
      stringIndexType: StringIndexType;

      @doc("The maximum number of resources to return from the collection.")
      @query
      top: int32;

      @doc("An offset into the collection of the first resource to be returned.")
      @query
      skip: int32;

      @doc("The maximum number of resources to include in a single response.")
      @query
      maxpagesize: int32;
    },
    EvaluationResults
  >;

  @doc("""
Gets the evaluation summary of a trained model. The summary includes high level
performance measurements of the model e.g., F1, Precision, Recall, etc.
""")
  @route("/authoring/analyze-text/projects/{projectName}/models/{trainedModelLabel}/evaluation/summary-result")
  @get
  GetModelEvaluationSummary is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
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
  ListTrainingJobs is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @path
      projectName: string;

      @doc("The maximum number of resources to return from the collection.")
      @query
      top: int32;

      @doc("An offset into the collection of the first resource to be returned.")
      @query
      skip: int32;

      @doc("The maximum number of resources to include in a single response.")
      @query
      maxpagesize: int32;
    },
    TrainingJobs
  >;

  @doc("Gets the status for a training job.")
  @route("/authoring/analyze-text/projects/{projectName}/train/jobs/{jobId}")
  @get
  GetTrainingStatus is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
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
  CancelTrainingJob is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
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
  GetProjectDeletionStatus is Azure.Core.Foundations.Operation<
    {
      @doc("The job ID.")
      @path
      jobId: string;
    },
    ProjectDeletionJobState
  >;

  @doc("Lists the supported languages.")
  GetSupportedLanguages is Azure.Core.ResourceList<
    SupportedLanguage,
    {
      parameters: {
        @doc("The maximum number of resources to return from the collection.")
        @query
        top: int32;

        @doc("An offset into the collection of the first resource to be returned.")
        @query
        skip: int32;

        @doc("The maximum number of resources to include in a single response.")
        @query
        maxpagesize: int32;
      };
    }
  >;

  @doc("Lists the support training config version for a given project type.")
  @route("/authoring/analyze-text/projects/global/training-config-versions")
  @get
  ListTrainingConfigVersions is Azure.Core.Foundations.Operation<
    {
      @doc("The project kind.")
      @query
      projectKind: ProjectKind;

      @doc("The maximum number of resources to return from the collection.")
      @query
      top: int32;

      @doc("An offset into the collection of the first resource to be returned.")
      @query
      skip: int32;

      @doc("The maximum number of resources to include in a single response.")
      @query
      maxpagesize: int32;
    },
    TrainingConfigVersions
  >;
}
