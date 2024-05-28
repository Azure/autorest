import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace MicrosoftCognitiveLanguageServiceQuestionAnsweringAuthoring;

/**
 * Human-readable error code.
 */
enum ErrorCode {
  InvalidRequest,
  InvalidArgument,
  Unauthorized,
  Forbidden,
  NotFound,
  ProjectNotFound,
  OperationNotFound,
  AzureCognitiveSearchNotFound,
  AzureCognitiveSearchIndexNotFound,
  TooManyRequests,
  AzureCognitiveSearchThrottling,
  AzureCognitiveSearchIndexLimitReached,
  InternalServerError,
  ServiceUnavailable,
  Timeout,
  QuotaExceeded,
  Conflict,
  Warning,
}

/**
 * Human-readable error code.
 */
enum InnerErrorCode {
  InvalidRequest,
  InvalidParameterValue,
  KnowledgeBaseNotFound,
  AzureCognitiveSearchNotFound,
  AzureCognitiveSearchThrottling,
  ExtractionFailure,
  InvalidRequestBodyFormat,
  EmptyRequest,
  MissingInputDocuments,
  InvalidDocument,
  ModelVersionIncorrect,
  InvalidDocumentBatch,
  UnsupportedLanguageCode,
  InvalidCountryHint,
}

/**
 * Job Status.
 */
enum JobStatus {
  notStarted,
  running,
  succeeded,
  failed,
  cancelled,
  cancelling,
  partiallyCompleted,
}

enum Format {
  /**
   * Export or Import QnA assets in JSON format.
   */
  json,

  /**
   * Export or Import knowledge base replica including all assets and metadata in
   * Excel format.
   */
  tsv,

  /**
   * Export or Import knowledge base replica including all assets and metadata in
   * Tsv format.
   */
  excel,
}

enum AssetKind {
  qnas,
  synonyms,
}

/**
 * Supported source types.
 */
enum SourceKind {
  file,
  url,
}

/**
 * Content structure type for sources.
 */
enum SourceContentStructureKind {
  unstructured,
}

/**
 * Update operation type for assets.
 */
enum UpdateOperationKind {
  add,
  delete,
  replace,
}

/**
 * Collection of projects metadata and global settings.
 */
model ProjectsMetadata is Azure.Core.Page<ProjectMetadata>;

/**
 * Represents the project.
 */
model ProjectMetadata {
  /**
   * Name of the project.
   */
  projectName?: string;

  /**
   * Description of the project.
   */
  description?: string;

  /**
   * Language of the text records. This is BCP-47 representation of a language. For
   * example, use "en" for English; "es" for Spanish etc. If not set, use "en" for
   * English as default.
   */
  language?: string;

  /**
   * Resource enabled for multiple languages across projects or not.
   */
  multilingualResource?: boolean;

  /**
   * Configurable settings of the Project.
   */
  settings?: ProjectSettings;

  /**
   * Project creation date-time.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  /**
   * Represents the project last modified date-time.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  /**
   * Represents the project last deployment date-time.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastDeployedDateTime?: utcDateTime;
}

/**
 * Configurable settings of the Project.
 */
model ProjectSettings {
  /**
   * Default Answer response when no good match is found in the knowledge base.
   */
  defaultAnswer?: string;
}

/**
 * Error response.
 */
@error
model ErrorResponse {
  /**
   * The error object.
   */
  error: Error;
}

/**
 * The error object.
 */
model Error {
  ...Record<unknown>;

  /**
   * One of a server-defined set of error codes.
   */
  code: ErrorCode;

  /**
   * A human-readable representation of the error.
   */
  message: string;

  /**
   * The target of the error.
   */
  target?: string;

  /**
   * An array of details about specific errors that led to this reported error.
   */
  details?: Error[];

  /**
   * An object containing more specific information than the current object about
   * the error.
   */
  innererror?: InnerErrorModel;
}

/**
 * An object containing more specific information about the error. As per
 * Microsoft One API guidelines -
 * https://github.com/Microsoft/api-guidelines/blob/vNext/Guidelines.md#7102-error-condition-responses.
 */
model InnerErrorModel {
  /**
   * One of a server-defined set of error codes.
   */
  code: InnerErrorCode;

  /**
   * Error message.
   */
  message: string;

  /**
   * Error details.
   */
  details?: Record<string>;

  /**
   * Error target.
   */
  target?: string;

  /**
   * An object containing more specific information than the current object about
   * the error.
   */
  innererror?: InnerErrorModel;
}

/**
 * Parameters needed to create the project.
 */
model CreateProjectOptions {
  /**
   * Description of the project.
   */
  description?: string;

  /**
   * Language of the text records. This is BCP-47 representation of a language. For
   * example, use "en" for English; "es" for Spanish etc. If not set, use "en" for
   * English as default.
   */
  language: string;

  /**
   * Set to true to enable creating knowledgebases in different languages for the
   * same resource.
   */
  multilingualResource?: boolean;

  /**
   * Configurable settings of the Project.
   */
  settings?: ProjectSettings;
}

/**
 * Job state represents the job metadata and any errors.
 */
model JobState {
  ...JobMetadata;
  ...Errors;
}

/**
 * Represents the job metadata.
 */
model JobMetadata {
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime: utcDateTime;

  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expirationDateTime?: utcDateTime;

  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  jobId: string;

  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastUpdatedDateTime: utcDateTime;

  /**
   * Job Status.
   */
  status: JobStatus;
}

/**
 * Collection of Error types.
 */
model Errors {
  errors?: Error[];
}

/**
 * Export job status, project metadata, and assets.
 */
model ExportJobState {
  ...JobState;
  ...ExportJobResultUrl;
}

/**
 * URL to download the result of the Export Job.
 */
model ExportJobResultUrl {
  /**
   * URL to download the result of the Export Job.
   */
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  resultUrl: string;
}

/**
 * Project assets the needs to be imported.
 */
model ImportJobOptions {
  /**
   * Parameters needed to create the project.
   */
  metadata?: CreateProjectOptions;

  /**
   * All assets for this project.
   */
  assets?: Assets;

  /**
   * Import data File URI.
   */
  fileUri?: string;
}

/**
 * All assets for this project.
 */
model Assets {
  /**
   * Collection of synonyms.
   */
  synonyms?: WordAlterations[];

  /**
   * List of QnA records to import.
   */
  qnas?: ImportQnaRecord[];
}

/**
 * Collection of word alterations.
 */
model WordAlterations {
  /**
   * Collection of word alterations.
   */
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  alterations: string[];
}

/**
 * Import QnA Record.
 */
model ImportQnaRecord {
  ...RetrieveQnaRecord;
  ...SourceDisplayNameParameter;
}

/**
 * QnA Record with last updated date-time.
 */
model RetrieveQnaRecord {
  ...QnaRecord;
  ...LastUpdatedDateTimeParameter;
}

/**
 * QnA record.
 */
model QnaRecord {
  /**
   * Unique ID for the QnA.
   */
  id?: int32;

  /**
   * Answer text.
   */
  @maxLength(25000)
  @minLength(1)
  answer?: string;

  /**
   * Source from which QnA was indexed e.g.
   * https://docs.microsoft.com/en-us/azure/cognitive-services/QnAMaker/FAQs .
   */
  @maxLength(300)
  source?: string;

  /**
   * List of questions associated with the answer.
   */
  questions?: string[];

  /**
   * Metadata associated with the answer, useful to categorize or filter question
   * answers.
   */
  metadata?: Record<string>;

  /**
   * Context of a QnA.
   */
  dialog?: QnaDialog;

  /**
   * List of Active Learning suggestions for the QnA.
   */
  activeLearningSuggestions?: SuggestedQuestionsCluster[];
}

/**
 * Dialog associated with QnA Record.
 */
model QnaDialog {
  /**
   * To mark if a prompt is relevant only with a previous question or not. If true,
   * do not include this QnA as answer for queries without context; otherwise,
   * ignores context and includes this QnA in answers.
   */
  isContextOnly?: boolean;

  /**
   * List of prompts associated with the answer.
   */
  prompts?: QnaPrompt[];
}

/**
 * Prompt for an answer.
 */
model QnaPrompt {
  /**
   * Index of the prompt. It is used for ordering of the prompts.
   */
  displayOrder?: int32;

  /**
   * ID of the QnA corresponding to the prompt.
   */
  qnaId?: int32;

  /**
   * QnA record. Either QnAId or QnA record needs to be present in a Prompt.
   */
  qna?: QnaRecord;

  /**
   * Text displayed to represent a follow up question prompt.
   */
  @maxLength(200)
  displayText?: string;
}

/**
 * Active Learning suggested questions cluster details.
 */
model SuggestedQuestionsCluster {
  /**
   * Question chosen as the head of suggested questions cluster by Active Learning
   * clustering algorithm.
   */
  clusterHead?: string;

  /**
   * List of all suggested questions for the QnA.
   */
  suggestedQuestions?: SuggestedQuestion[];
}

/**
 * Question suggested by the Active Learning feature.
 */
model SuggestedQuestion {
  /**
   * Question suggested by the Active Learning feature.
   */
  question?: string;

  /**
   * The number of times the question was suggested explicitly by the user.
   */
  userSuggestedCount?: int32;

  /**
   * The number of times the question was suggested automatically by the Active
   * Learning algorithm.
   */
  autoSuggestedCount?: int32;
}

/**
 * Last updated date-time parameter.
 */
model LastUpdatedDateTimeParameter {
  /**
   * Date-time when the QnA was last updated.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastUpdatedDateTime?: utcDateTime;
}

model SourceDisplayNameParameter {
  /**
   * Friendly name of the Source.
   */
  @maxLength(200)
  @minLength(1)
  sourceDisplayName?: string;
}

/**
 * All deployments of a project.
 */
model ProjectDeployments is Azure.Core.Page<ProjectDeployment>;

/**
 * Project deployment details.
 */
model ProjectDeployment {
  /**
   * Name of the deployment.
   */
  deploymentName?: string;

  /**
   * Represents the project last deployment date-time.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastDeployedDateTime?: utcDateTime;
}

/**
 * All synonym assets for this project.
 */
model SynonymAssets is Azure.Core.Page<WordAlterations>;

/**
 * All QnA sources for the project.
 */
model QnaSources is Azure.Core.Page<QnaSourceRecord>;

/**
 * Custom source record with last updated date-time.
 */
model QnaSourceRecord {
  ...QnaSourceMetadata;
  ...LastUpdatedDateTimeParameter;
}

/**
 * Input source file or url details.
 */
model QnaSourceMetadata {
  /**
   * Friendly name of the Source.
   */
  @maxLength(200)
  @minLength(1)
  displayName?: string;

  /**
   * Unique source identifier. Name of the file if it's a 'file' source; otherwise,
   * the complete URL if it's a 'url' source.
   */
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  source: string;

  /**
   * URI location for the file or url.
   */
  sourceUri: url;

  /**
   * Supported source types.
   */
  sourceKind: SourceKind;

  /**
   * Content structure type for sources.
   */
  contentStructureKind?: SourceContentStructureKind;
}

/**
 * Source to be updated.
 */
model UpdateSourceRecord {
  /**
   * Update operation type for assets.
   */
  `op`: UpdateOperationKind;

  /**
   * Update source record.
   */
  value: UpdateQnaSourceRecord;
}

/**
 * Update source record.
 */
model UpdateQnaSourceRecord {
  ...QnaSourceMetadata;
  ...RefreshSourceOptions;
}

/**
 * Boolean flag used to refresh data from the Source.
 */
model RefreshSourceOptions {
  /**
   * Boolean flag used to refresh data from the Source.
   */
  refresh?: boolean;
}

/**
 * All QnA assets for the project.
 */
model QnaAssets is Azure.Core.Page<RetrieveQnaRecord>;

/**
 * QnA record to be updated.
 */
model UpdateQnaRecord {
  /**
   * Update operation type for assets.
   */
  `op`: UpdateOperationKind;

  /**
   * QnA record.
   */
  value: QnaRecord;
}

/**
 * Feedback for Active Learning.
 */
model ActiveLearningFeedback {
  /**
   * A list of Feedback Records for Active Learning.
   */
  records?: FeedbackRecord[];
}

/**
 * Feedback Record for Active Learning.
 */
model FeedbackRecord {
  /**
   * Unique identifier of the user.
   */
  userId?: string;

  /**
   * User suggested question for the QnA.
   */
  userQuestion?: string;

  /**
   * Unique ID of the QnA.
   */
  qnaId?: int32;
}
