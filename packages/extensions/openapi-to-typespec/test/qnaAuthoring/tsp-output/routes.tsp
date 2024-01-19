import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace MicrosoftCognitiveLanguageServiceQuestionAnsweringAuthoring;

interface QuestionAnsweringProjectsOperations {
  /**
   * Gets all projects for a user.
   */
  @summary("Gets all projects for a user.")
  @route("/authoring/query-knowledgebases/projects")
  @get
  listProjects is Azure.Core.Foundations.Operation<
    {
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
    ProjectsMetadata
  >;

  /**
   * Get the requested project metadata.
   */
  @summary("Get the requested project metadata.")
  @route("/authoring/query-knowledgebases/projects/{projectName}")
  @get
  getProjectDetails is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;
    },
    ProjectMetadata
  >;

  /**
   * Create or update a project.
   */
  @summary("Create or update a project.")
  @route("/authoring/query-knowledgebases/projects/{projectName}")
  @patch
  createProject is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;

      /**
       * Parameters needed to create the project.
       */
      @body
      body: CreateProjectOptions;
    },
    ProjectMetadata
  >;

  /**
   * Delete the project.
   */
  @summary("Delete the project.")
  @route("/authoring/query-knowledgebases/projects/{projectName}")
  @delete
  deleteProject is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;
    },
    void
  >;

  /**
   * Gets the status of a Project delete job.
   */
  @summary("Gets the status of a Project delete job.")
  @route("/authoring/query-knowledgebases/projects/deletion-jobs/{jobId}")
  @get
  getDeleteStatus is Azure.Core.Foundations.Operation<
    {
      /**
       * Job ID.
       */
      @path
      jobId: string;
    },
    JobState
  >;

  /**
   * Export project metadata and assets.
   */
  @summary("Export project metadata and assets.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/:export")
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
       * Knowledge base Import or Export format.
       */
      @query("format")
      format?: Format = Format.json;

      /**
       * Kind of the asset of the project.
       */
      @query("assetKind")
      assetKind?: AssetKind;
    },
    ExportJobState | void
  >;

  /**
   * Gets the status of an Export job, once job completes, returns the project
   * metadata, and assets.
   */
  @summary("""
Gets the status of an Export job, once job completes, returns the project
metadata, and assets.
""")
  @route("/authoring/query-knowledgebases/projects/{projectName}/export/jobs/{jobId}")
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
       * Job ID.
       */
      @path
      jobId: string;
    },
    ExportJobState
  >;

  /**
   * Import project assets.
   */
  @summary("Import project assets.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/:import")
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
       * Knowledge base Import or Export format.
       */
      @query("format")
      format?: Format = Format.json;

      /**
       * Kind of the asset of the project.
       */
      @query("assetKind")
      assetKind?: AssetKind;

      /**
       * Project assets the needs to be imported.
       */
      @body
      body?: ImportJobOptions;
    },
    void
  >;

  /**
   * Gets the status of an Import job.
   */
  @summary("Gets the status of an Import job.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/import/jobs/{jobId}")
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
       * Job ID.
       */
      @path
      jobId: string;
    },
    JobState
  >;

  /**
   * Deploy project to production.
   */
  @summary("Deploy project to production.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/deployments/{deploymentName}")
  @put
  deployProject is Azure.Core.Foundations.Operation<
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
    },
    void
  >;

  /**
   * Gets the status of a Deploy job.
   */
  @summary("Gets the status of a Deploy job.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/deployments/{deploymentName}/jobs/{jobId}")
  @get
  getDeployStatus is Azure.Core.Foundations.Operation<
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
       * Job ID.
       */
      @path
      jobId: string;
    },
    JobState
  >;

  /**
   * List all deployments of a project.
   */
  @summary("List all deployments of a project.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/deployments")
  @get
  listDeployments is Azure.Core.Foundations.Operation<
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
    ProjectDeployments
  >;

  /**
   * Gets all the synonyms of a project.
   */
  @summary("Gets all the synonyms of a project.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/synonyms")
  @get
  getSynonyms is Azure.Core.Foundations.Operation<
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
    SynonymAssets
  >;

  /**
   * Updates all the synonyms of a project.
   */
  @summary("Updates all the synonyms of a project.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/synonyms")
  @put
  updateSynonyms is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;

      /**
       * All the synonyms of a project.
       */
      @body
      body: SynonymAssets;
    },
    void
  >;

  /**
   * Gets all the sources of a project.
   */
  @summary("Gets all the sources of a project.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/sources")
  @get
  getSources is Azure.Core.Foundations.Operation<
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
    QnaSources
  >;

  /**
   * Updates the sources of a project.
   */
  @summary("Updates the sources of a project.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/sources")
  @patch
  updateSources is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;

      /**
       * Update sources parameters of a project.
       */
      @body
      body: UpdateSourceRecord[];
    },
    void
  >;

  /**
   * Gets the status of update sources job.
   */
  @summary("Gets the status of update sources job.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/sources/jobs/{jobId}")
  @get
  getUpdateSourcesStatus is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;

      /**
       * Job ID.
       */
      @path
      jobId: string;
    },
    JobState
  >;

  /**
   * Gets all the QnAs of a project.
   */
  @summary("Gets all the QnAs of a project.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/qnas")
  @get
  getQnas is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;

      /**
       * Source of the QnA.
       */
      @query("source")
      source?: string;

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
    QnaAssets
  >;

  /**
   * Updates the QnAs of a project.
   */
  @summary("Updates the QnAs of a project.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/qnas")
  @patch
  updateQnas is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;

      /**
       * Update QnAs parameters of a project.
       */
      @body
      body: UpdateQnaRecord[];
    },
    void
  >;

  /**
   * Gets the status of update QnAs job.
   */
  @summary("Gets the status of update QnAs job.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/qnas/jobs/{jobId}")
  @get
  getUpdateQnasStatus is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;

      /**
       * Job ID.
       */
      @path
      jobId: string;
    },
    JobState
  >;

  /**
   * Update Active Learning feedback.
   */
  @summary("Update Active Learning feedback.")
  @route("/authoring/query-knowledgebases/projects/{projectName}/feedback")
  @post
  addFeedback is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @maxLength(100)
      @path
      projectName: string;

      /**
       * Feedback for Active Learning.
       */
      @body
      body: ActiveLearningFeedback;
    },
    void
  >;
}
