import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace MicrosoftCognitiveLanguageServiceQuestionAnsweringAuthoring;

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
  @doc("Export or Import QnA assets in JSON format.") json,
  @doc("""
Export or Import knowledge base replica including all assets and metadata in
Excel format.
""")
  tsv,
  @doc("""
Export or Import knowledge base replica including all assets and metadata in
Tsv format.
""")
  excel,
}

enum AssetKind {
  qnas,
  synonyms,
}

enum SourceKind {
  file,
  url,
}

enum SourceContentStructureKind {
  unstructured,
}

enum UpdateOperationKind {
  add,
  delete,
  replace,
}

@doc("Collection of projects metadata and global settings.")
model ProjectsMetadata is Azure.Core.Page<ProjectMetadata>;

@doc("Represents the project.")
model ProjectMetadata {
  @doc("Name of the project.")
  projectName?: string;

  @doc("Description of the project.")
  description?: string;

  @doc("""
Language of the text records. This is BCP-47 representation of a language. For
example, use \"en\" for English; \"es\" for Spanish etc. If not set, use \"en\"
for English as default.
""")
  language?: string;

  @doc("Resource enabled for multiple languages across projects or not.")
  multilingualResource?: boolean;

  @doc("Configurable settings of the Project.")
  settings?: ProjectSettings;

  @doc("Project creation date-time.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  @doc("Represents the project last modified date-time.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  @doc("Represents the project last deployment date-time.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastDeployedDateTime?: utcDateTime;
}

@doc("Configurable settings of the Project.")
model ProjectSettings {
  @doc("Default Answer response when no good match is found in the knowledge base.")
  defaultAnswer?: string;
}

@doc("Error response.")
@error
model ErrorResponse {
  @doc("The error object.")
  error: Error;
}

@doc("The error object.")
model Error {
  ...Record<unknown>;

  @doc("One of a server-defined set of error codes.")
  code: ErrorCode;

  @doc("A human-readable representation of the error.")
  message: string;

  @doc("The target of the error.")
  target?: string;

  @doc("An array of details about specific errors that led to this reported error.")
  details?: Error[];

  @doc("""
An object containing more specific information than the current object about
the error.
""")
  innererror?: InnerErrorModel;
}

@doc("""
An object containing more specific information about the error. As per
Microsoft One API guidelines -
https://github.com/Microsoft/api-guidelines/blob/vNext/Guidelines.md#7102-error-condition-responses.
""")
model InnerErrorModel {
  @doc("One of a server-defined set of error codes.")
  code: InnerErrorCode;

  @doc("Error message.")
  message: string;

  @doc("Error details.")
  details?: Record<string>;

  @doc("Error target.")
  target?: string;

  @doc("""
An object containing more specific information than the current object about
the error.
""")
  innererror?: InnerErrorModel;
}

@doc("Parameters needed to create the project.")
model CreateProjectOptions {
  @doc("Description of the project.")
  description?: string;

  @doc("""
Language of the text records. This is BCP-47 representation of a language. For
example, use \"en\" for English; \"es\" for Spanish etc. If not set, use \"en\"
for English as default.
""")
  language: string;

  @doc("""
Set to true to enable creating knowledgebases in different languages for the
same resource.
""")
  multilingualResource?: boolean;

  @doc("Configurable settings of the Project.")
  settings?: ProjectSettings;
}

@doc("Job state represents the job metadata and any errors.")
model JobState {
  ...JobMetadata;
  ...Errors;
}

@doc("Represents the job metadata.")
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

  @doc("Job Status.")
  status: JobStatus;
}

@doc("Collection of Error types.")
model Errors {
  errors?: Error[];
}

@doc("Export job status, project metadata, and assets.")
model ExportJobState {
  ...JobState;
  ...ExportJobResultUrl;
}

@doc("URL to download the result of the Export Job.")
model ExportJobResultUrl {
  @doc("URL to download the result of the Export Job.")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  resultUrl: string;
}

@doc("Project assets the needs to be imported.")
model ImportJobOptions {
  @doc("Parameters needed to create the project.")
  metadata?: CreateProjectOptions;

  @doc("All assets for this project.")
  assets?: Assets;

  @doc("Import data File URI.")
  fileUri?: string;
}

@doc("All assets for this project.")
model Assets {
  @doc("Collection of synonyms.")
  synonyms?: WordAlterations[];

  @doc("List of QnA records to import.")
  qnas?: ImportQnaRecord[];
}

@doc("Collection of word alterations.")
model WordAlterations {
  @doc("Collection of word alterations.")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  alterations: string[];
}

@doc("Import QnA Record.")
model ImportQnaRecord {
  ...RetrieveQnaRecord;
  ...SourceDisplayNameParameter;
}

@doc("QnA Record with last updated date-time.")
model RetrieveQnaRecord {
  ...QnaRecord;
  ...LastUpdatedDateTimeParameter;
}

@doc("QnA record.")
model QnaRecord {
  @doc("Unique ID for the QnA.")
  id?: int32;

  @doc("Answer text.")
  answer?: string;

  @doc("""
Source from which QnA was indexed e.g.
https://docs.microsoft.com/en-us/azure/cognitive-services/QnAMaker/FAQs .
""")
  source?: string;

  @doc("List of questions associated with the answer.")
  questions?: string[];

  @doc("""
Metadata associated with the answer, useful to categorize or filter question
answers.
""")
  metadata?: Record<string>;

  @doc("Context of a QnA.")
  dialog?: QnaDialog;

  @doc("List of Active Learning suggestions for the QnA.")
  activeLearningSuggestions?: SuggestedQuestionsCluster[];
}

@doc("Dialog associated with QnA Record.")
model QnaDialog {
  @doc("""
To mark if a prompt is relevant only with a previous question or not. If true,
do not include this QnA as answer for queries without context; otherwise,
ignores context and includes this QnA in answers.
""")
  isContextOnly?: boolean;

  @doc("List of prompts associated with the answer.")
  prompts?: QnaPrompt[];
}

@doc("Prompt for an answer.")
model QnaPrompt {
  @doc("Index of the prompt. It is used for ordering of the prompts.")
  displayOrder?: int32;

  @doc("ID of the QnA corresponding to the prompt.")
  qnaId?: int32;

  @doc("QnA record. Either QnAId or QnA record needs to be present in a Prompt.")
  qna?: QnaRecord;

  @doc("Text displayed to represent a follow up question prompt.")
  displayText?: string;
}

@doc("Active Learning suggested questions cluster details.")
model SuggestedQuestionsCluster {
  @doc("""
Question chosen as the head of suggested questions cluster by Active Learning
clustering algorithm.
""")
  clusterHead?: string;

  @doc("List of all suggested questions for the QnA.")
  suggestedQuestions?: SuggestedQuestion[];
}

@doc("Question suggested by the Active Learning feature.")
model SuggestedQuestion {
  @doc("Question suggested by the Active Learning feature.")
  question?: string;

  @doc("The number of times the question was suggested explicitly by the user.")
  userSuggestedCount?: int32;

  @doc("""
The number of times the question was suggested automatically by the Active
Learning algorithm.
""")
  autoSuggestedCount?: int32;
}

@doc("Last updated date-time parameter.")
model LastUpdatedDateTimeParameter {
  @doc("Date-time when the QnA was last updated.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastUpdatedDateTime?: utcDateTime;
}

model SourceDisplayNameParameter {
  @doc("Friendly name of the Source.")
  sourceDisplayName?: string;
}

@doc("All deployments of a project.")
model ProjectDeployments is Azure.Core.Page<ProjectDeployment>;

@doc("Project deployment details.")
model ProjectDeployment {
  @doc("Name of the deployment.")
  deploymentName?: string;

  @doc("Represents the project last deployment date-time.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastDeployedDateTime?: utcDateTime;
}

@doc("All synonym assets for this project.")
model SynonymAssets is Azure.Core.Page<WordAlterations>;

@doc("All QnA sources for the project.")
model QnaSources is Azure.Core.Page<QnaSourceRecord>;

@doc("Custom source record with last updated date-time.")
model QnaSourceRecord {
  ...QnaSourceMetadata;
  ...LastUpdatedDateTimeParameter;
}

@doc("Input source file or url details.")
model QnaSourceMetadata {
  @doc("Friendly name of the Source.")
  displayName?: string;

  @doc("""
Unique source identifier. Name of the file if it's a 'file' source; otherwise,
the complete URL if it's a 'url' source.
""")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  source: string;

  @doc("URI location for the file or url.")
  sourceUri: string;

  @doc("Supported source types.")
  sourceKind: SourceKind;

  @doc("Content structure type for sources.")
  contentStructureKind?: SourceContentStructureKind;
}

@doc("Source to be updated.")
model UpdateSourceRecord {
  @doc("Update operation type for assets.")
  `op`: UpdateOperationKind;

  @doc("Update source record.")
  value: UpdateQnaSourceRecord;
}

@doc("Update source record.")
model UpdateQnaSourceRecord {
  ...QnaSourceMetadata;
  ...RefreshSourceOptions;
}

@doc("Boolean flag used to refresh data from the Source.")
model RefreshSourceOptions {
  @doc("Boolean flag used to refresh data from the Source.")
  refresh?: boolean;
}

@doc("All QnA assets for the project.")
model QnaAssets is Azure.Core.Page<RetrieveQnaRecord>;

@doc("QnA record to be updated.")
model UpdateQnaRecord {
  @doc("Update operation type for assets.")
  `op`: UpdateOperationKind;

  @doc("QnA record.")
  value: QnaRecord;
}

@doc("Feedback for Active Learning.")
model ActiveLearningFeedback {
  @doc("A list of Feedback Records for Active Learning.")
  records?: FeedbackRecord[];
}

@doc("Feedback Record for Active Learning.")
model FeedbackRecord {
  @doc("Unique identifier of the user.")
  userId?: string;

  @doc("User suggested question for the QnA.")
  userQuestion?: string;

  @doc("Unique ID of the QnA.")
  qnaId?: int32;
}
