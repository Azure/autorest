import "@typespec/rest";
import "@typespec/http";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.Language.QnAMaker;

/**
 * Type of ranker to be used.
 */
enum RankerKind {
  /**
   * Question only ranker.
   */
  QuestionOnly,

  /**
   * Default ranker.
   */
  Default,
}

/**
 * Set to 'OR' or 'AND' for using corresponding logical operation.
 */
enum LogicalOperationKind {
  AND,
  OR,
}

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
 * Specifies the method used to interpret string offsets.  Defaults to Text
 * Elements (Graphemes) according to Unicode v8.0.0. For additional information
 * see https://aka.ms/text-analytics-offsets.
 */
enum StringIndexType {
  /**
   * Returned offset and length values will correspond to TextElements (Graphemes
   * and Grapheme clusters) confirming to the Unicode 8.0.0 standard. Use this
   * option if your application is written in .Net Framework or .Net Core and you
   * will be using StringInfo.
   */
  TextElements_v8,

  /**
   * Returned offset and length values will correspond to Unicode code points. Use
   * this option if your application is written in a language that support Unicode,
   * for example Python.
   */
  UnicodeCodePoint,

  /**
   * Returned offset and length values will correspond to UTF-16 code units. Use
   * this option if your application is written in a language that support Unicode,
   * for example Java, JavaScript.
   */
  Utf16CodeUnit,
}

/**
 * Parameters to query a knowledge base.
 */
model AnswersOptions {
  /**
   * Exact QnA ID to fetch from the knowledge base, this field takes priority over
   * question.
   */
  qnaId?: int32;

  /**
   * User question to query against the knowledge base.
   */
  question?: string;

  /**
   * Max number of answers to be returned for the question.
   */
  top?: int32;

  /**
   * Unique identifier for the user.
   */
  userId?: string;

  /**
   * Minimum threshold score for answers, value ranges from 0 to 1.
   */
  @maxValue(1)
  @encodedName("application/json", "confidenceScoreThreshold")
  confidenceThreshold?: float64;

  /**
   * Context object with previous QnA's information.
   */
  @encodedName("application/json", "context")
  answerContext?: KnowledgeBaseAnswerContext;

  /**
   * Type of ranker to be used.
   */
  @encodedName("application/json", "rankerType")
  rankerKind?: RankerKind;

  /**
   * Filter QnAs based on given metadata list and knowledge base sources.
   */
  filters?: QueryFilters;

  /**
   * To configure Answer span prediction feature.
   */
  @encodedName("application/json", "answerSpanRequest")
  shortAnswerOptions?: ShortAnswerOptions;

  /**
   * (Optional) Flag to enable Query over Unstructured Sources.
   */
  includeUnstructuredSources?: boolean;
}

/**
 * Context object with previous QnA's information.
 */
model KnowledgeBaseAnswerContext {
  /**
   * Previous turn top answer result QnA ID.
   */
  previousQnaId: int32;

  /**
   * Previous user query.
   */
  @encodedName("application/json", "previousUserQuery")
  previousQuestion?: string;
}

/**
 * filters over knowledge base.
 */
model QueryFilters {
  /**
   * Find QnAs that are associated with the given list of metadata.
   */
  metadataFilter?: MetadataFilter;

  /**
   * Find QnAs that are associated with any of the given list of sources in
   * knowledge base.
   */
  sourceFilter?: string[];

  /**
   * Logical operation used to join metadata filter with source filter.
   */
  logicalOperation?: LogicalOperationKind;
}

/**
 * Find QnAs that are associated with the given list of metadata.
 */
model MetadataFilter {
  metadata?: MetadataRecord[];

  /**
   * Operation used to join metadata filters.
   */
  logicalOperation?: LogicalOperationKind;
}

/**
 * Object to provide the key value pair for each metadata.
 */
model MetadataRecord {
  /**
   * Metadata Key from Metadata dictionary used in the QnA.
   */
  key: string;

  /**
   * Metadata Value from Metadata dictionary used in the QnA.
   */
  value: string;
}

/**
 * To configure Answer span prediction feature.
 */
model ShortAnswerOptions {
  /**
   * Enable or disable Answer Span prediction.
   */
  enable: true;

  /**
   * Minimum threshold score required to include an answer span, value ranges from 0
   * to 1.
   */
  @maxValue(1)
  @encodedName("application/json", "confidenceScoreThreshold")
  confidenceThreshold?: float64;

  /**
   * Number of Top answers to be considered for span prediction from 1 to 10.
   */
  @maxValue(10)
  @minValue(1)
  @encodedName("application/json", "topAnswersWithSpan")
  top?: int32;
}

/**
 * Represents List of Question Answers.
 */
model AnswersResult {
  /**
   * Represents Answer Result list.
   */
  answers?: KnowledgeBaseAnswer[];
}

/**
 * Represents knowledge base answer.
 */
model KnowledgeBaseAnswer {
  /**
   * List of questions associated with the answer.
   */
  questions?: string[];

  /**
   * Answer text.
   */
  answer?: string;

  /**
   * Answer confidence score, value ranges from 0 to 1.
   */
  @maxValue(1)
  @encodedName("application/json", "confidenceScore")
  confidence?: float64;

  /**
   * ID of the QnA result.
   */
  @encodedName("application/json", "id")
  qnaId?: int32;

  /**
   * Source of QnA result.
   */
  source?: string;

  /**
   * Metadata associated with the answer, useful to categorize or filter question
   * answers.
   */
  metadata?: Record<string>;

  /**
   * Dialog associated with Answer.
   */
  dialog?: KnowledgeBaseAnswerDialog;

  /**
   * Answer span object of QnA with respect to user's question.
   */
  @encodedName("application/json", "answerSpan")
  shortAnswer?: AnswerSpan;
}

/**
 * Dialog associated with Answer.
 */
model KnowledgeBaseAnswerDialog {
  /**
   * To mark if a prompt is relevant only with a previous question or not. If true,
   * do not include this QnA as search result for queries without context;
   * otherwise, if false, ignores context and includes this QnA in search result.
   */
  isContextOnly?: boolean;

  /**
   * List of prompts associated with the answer.
   */
  prompts?: KnowledgeBaseAnswerPrompt[];
}

/**
 * Prompt for an answer.
 */
model KnowledgeBaseAnswerPrompt {
  /**
   * Index of the prompt - used in ordering of the prompts.
   */
  displayOrder?: int32;

  /**
   * QnA ID corresponding to the prompt.
   */
  qnaId?: int32;

  /**
   * Text displayed to represent a follow up question prompt.
   */
  @maxLength(200)
  displayText?: string;
}

/**
 * Answer span object of QnA.
 */
model AnswerSpan {
  /**
   * Predicted text of answer span.
   */
  text?: string;

  /**
   * Predicted score of answer span, value ranges from 0 to 1.
   */
  @maxValue(1)
  @encodedName("application/json", "confidenceScore")
  confidence?: float64;

  /**
   * The answer span offset from the start of answer.
   */
  offset?: int32;

  /**
   * The length of the answer span.
   */
  length?: int32;
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
 * The question and text record parameters to answer.
 */
model AnswersFromTextOptions {
  /**
   * User question to query against the given text records.
   */
  question: string;

  /**
   * Text records to be searched for given question.
   */
  @encodedName("application/json", "records")
  textDocuments: TextDocument[];

  /**
   * Language of the text records. This is BCP-47 representation of a language. For
   * example, use "en" for English; "es" for Spanish etc. If not set, use "en" for
   * English as default.
   */
  language?: string;

  /**
   * Specifies the method used to interpret string offsets.  Defaults to Text
   * Elements (Graphemes) according to Unicode v8.0.0. For additional information
   * see https://aka.ms/text-analytics-offsets.
   */
  stringIndexType?: StringIndexType = StringIndexType.TextElements_v8;
}

/**
 * Represent input text record to be queried.
 */
model TextDocument {
  /**
   * Unique identifier for the text record.
   */
  id: string;

  /**
   * Text contents of the record.
   */
  text: string;
}

/**
 * Represents the answer results.
 */
model AnswersFromTextResult {
  /**
   * Represents the answer results.
   */
  answers?: TextAnswer[];
}

/**
 * Represents answer result.
 */
model TextAnswer {
  /**
   * Answer.
   */
  answer?: string;

  /**
   * answer confidence score, value ranges from 0 to 1.
   */
  @maxValue(1)
  @encodedName("application/json", "confidenceScore")
  confidence?: float64;

  /**
   * record ID.
   */
  id?: string;

  /**
   * Answer span object with respect to user's question.
   */
  @encodedName("application/json", "answerSpan")
  shortAnswer?: AnswerSpan;

  /**
   * The sentence offset from the start of the document.
   */
  offset?: int32;

  /**
   * The length of the sentence.
   */
  length?: int32;
}
