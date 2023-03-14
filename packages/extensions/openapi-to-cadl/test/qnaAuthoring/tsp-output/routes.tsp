import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace MicrosoftCognitiveLanguageServiceQuestionAnsweringAuthoring;

interface QuestionAnsweringProjectsOperations {
  @summary("Gets all projects for a user.")
  @doc("Gets all projects for a user.")
  @route("/authoring/query-knowledgebases/projects")
  @get
  ListProjects is Azure.Core.Foundations.Operation<
    {
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
    ProjectsMetadata
  >;

  @summary("Get the requested project metadata.")
  @doc("Get the requested project metadata.")
  @route("/authoring/query-knowledgebases/projects/{projectName}")
  @get
  GetProjectDetails is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @path
      projectName: string;
    },
    ProjectMetadata
  >;

  @summary("Create or update a project.")
  @doc("Create or update a project.")
  @route("/authoring/query-knowledgebases/projects/{projectName}")
  @patch
  CreateProject is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @path
      projectName: string;

      @doc("Parameters needed to create the project.")
      @body
      body: CreateProjectOptions;
    },
    ProjectMetadata
  >;

  @summary("Delete the project.")
  @doc("Delete the project.")
  @route("/authoring/query-knowledgebases/projects/{projectName}")
  @delete
  DeleteProject is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @path
      projectName: string;
    },
    void
  >;

  @summary("Gets the status of a Project delete job.")
  @doc("Gets the status of a Project delete job.")
  @route("/authoring/query-knowledgebases/projects/deletion-jobs/{jobId}")
  @get
  GetDeleteStatus is Azure.Core.Foundations.Operation<
    {
      @doc("Job ID.")
      @path
      jobId: string;
    },
    JobState
  >;

  @summary("Export project metadata and assets.")
  @doc("Export project metadata and assets.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/:export")
  @post
  Export is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @path
      projectName: string;

      @doc("Knowledge base Import or Export format.")
      @query
      format: Format;

      @doc("Kind of the asset of the project.")
      @query
      assetKind: AssetKind;
    },
    ExportJobState | void
  >;

  @summary("""
Gets the status of an Export job, once job completes, returns the project
metadata, and assets.
""")
  @doc("""
Gets the status of an Export job, once job completes, returns the project
metadata, and assets.
""")
  @route("/authoring/query-knowledgebases/projects/{projectName}/export/jobs/{jobId}")
  @get
  GetExportStatus is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @path
      projectName: string;

      @doc("Job ID.")
      @path
      jobId: string;
    },
    ExportJobState
  >;

  @summary("Import project assets.")
  @doc("Import project assets.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/:import")
  @post
  Import is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @path
      projectName: string;

      @doc("Knowledge base Import or Export format.")
      @query
      format: Format;

      @doc("Kind of the asset of the project.")
      @query
      assetKind: AssetKind;

      @doc("Project assets the needs to be imported.")
      @body
      body: ImportJobOptions;
    },
    void
  >;

  @summary("Gets the status of an Import job.")
  @doc("Gets the status of an Import job.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/import/jobs/{jobId}")
  @get
  GetImportStatus is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @path
      projectName: string;

      @doc("Job ID.")
      @path
      jobId: string;
    },
    JobState
  >;

  @summary("Deploy project to production.")
  @doc("Deploy project to production.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/deployments/{deploymentName}")
  @put
  DeployProject is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @path
      projectName: string;

      @doc("The name of the specific deployment of the project to use.")
      @path
      deploymentName: string;
    },
    void
  >;

  @summary("Gets the status of a Deploy job.")
  @doc("Gets the status of a Deploy job.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/deployments/{deploymentName}/jobs/{jobId}")
  @get
  GetDeployStatus is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @path
      projectName: string;

      @doc("The name of the specific deployment of the project to use.")
      @path
      deploymentName: string;

      @doc("Job ID.")
      @path
      jobId: string;
    },
    JobState
  >;

  @summary("List all deployments of a project.")
  @doc("List all deployments of a project.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/deployments")
  @get
  ListDeployments is Azure.Core.Foundations.Operation<
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
    ProjectDeployments
  >;

  @summary("Gets all the synonyms of a project.")
  @doc("Gets all the synonyms of a project.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/synonyms")
  @get
  GetSynonyms is Azure.Core.Foundations.Operation<
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
    SynonymAssets
  >;

  @summary("Updates all the synonyms of a project.")
  @doc("Updates all the synonyms of a project.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/synonyms")
  @put
  UpdateSynonyms is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @path
      projectName: string;

      @doc("All the synonyms of a project.")
      @body
      body: SynonymAssets;
    },
    void
  >;

  @summary("Gets all the sources of a project.")
  @doc("Gets all the sources of a project.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/sources")
  @get
  GetSources is Azure.Core.Foundations.Operation<
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
    QnaSources
  >;

  @summary("Updates the sources of a project.")
  @doc("Updates the sources of a project.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/sources")
  @patch
  UpdateSources is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @path
      projectName: string;

      @doc("Update sources parameters of a project.")
      @body
      body: UpdateSourceRecord[];
    },
    void
  >;

  @summary("Gets the status of update sources job.")
  @doc("Gets the status of update sources job.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/sources/jobs/{jobId}")
  @get
  GetUpdateSourcesStatus is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @path
      projectName: string;

      @doc("Job ID.")
      @path
      jobId: string;
    },
    JobState
  >;

  @summary("Gets all the QnAs of a project.")
  @doc("Gets all the QnAs of a project.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/qnas")
  @get
  GetQnas is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @path
      projectName: string;

      @doc("Source of the QnA.")
      @query
      source: string;

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
    QnaAssets
  >;

  @summary("Updates the QnAs of a project.")
  @doc("Updates the QnAs of a project.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/qnas")
  @patch
  UpdateQnas is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @path
      projectName: string;

      @doc("Update QnAs parameters of a project.")
      @body
      body: UpdateQnaRecord[];
    },
    void
  >;

  @summary("Gets the status of update QnAs job.")
  @doc("Gets the status of update QnAs job.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/qnas/jobs/{jobId}")
  @get
  GetUpdateQnasStatus is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @path
      projectName: string;

      @doc("Job ID.")
      @path
      jobId: string;
    },
    JobState
  >;

  @summary("Update Active Learning feedback.")
  @doc("Update Active Learning feedback.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/feedback")
  @post
  AddFeedback is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @path
      projectName: string;

      @doc("Feedback for Active Learning.")
      @body
      body: ActiveLearningFeedback;
    },
    void
  >;
}
