import "@typespec/rest";
import "@typespec/http";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace QnAMakerRuntimeClient;

/**
 * Optional field. Set to OR for using OR as Operation for Strict Filters.
 */
enum StrictFiltersCompoundOperationType {
  AND,
  OR,
}

/**
 * Human readable error code.
 */
enum ErrorCodeType {
  BadArgument,
  Forbidden,
  NotFound,
  KbNotFound,
  Unauthorized,
  Unspecified,
  EndpointKeysError,
  QuotaExceeded,
  QnaRuntimeError,
  SKULimitExceeded,
  OperationNotFound,
  ServiceError,
  ValidationFailure,
  ExtractionFailure,
}

/**
 * POST body schema to query the knowledgebase.
 */
model QueryDTO {
  /**
   * Exact qnaId to fetch from the knowledgebase, this field takes priority over
   * question.
   */
  qnaId?: string;

  /**
   * User question to query against the knowledge base.
   */
  question?: string;

  /**
   * Max number of answers to be returned for the question.
   */
  top?: int32;

  /**
   * Unique identifier for the user. Optional parameter for telemetry. For more
   * information, refer <a href="http://aka.ms/qnamaker-analytics#user-traffic"
   * target="blank">Analytics and Telemetry</a>.
   */
  userId?: string;

  /**
   * Query against the test index.
   */
  isTest?: boolean;

  /**
   * Threshold for answers returned based on score.
   */
  scoreThreshold?: float32;

  /**
   * Context object with previous QnA's information.
   */
  context?: QueryDTOContext;

  /**
   * Optional field. Set to 'QuestionOnly' for using a question only Ranker.
   */
  rankerType?: string;

  /**
   * Find only answers that contain these metadata.
   */
  strictFilters?: MetadataDTO[];

  /**
   * Optional field. Set to OR for using OR as Operation for Strict Filters.
   */
  strictFiltersCompoundOperationType?: StrictFiltersCompoundOperationType;
}

/**
 * Context object with previous QnA's information.
 */
model QueryDTOContext extends QueryContextDTO {}

/**
 * Context object with previous QnA's information.
 */
model QueryContextDTO {
  /**
   * Previous QnA Id - qnaId of the top result.
   */
  previousQnaId?: string;

  /**
   * Previous user query.
   */
  previousUserQuery?: string;
}

/**
 * Name - value pair of metadata.
 */
model MetadataDTO {
  /**
   * Metadata name.
   */
  @maxLength(100)
  @minLength(1)
  name: string;

  /**
   * Metadata value.
   */
  @maxLength(500)
  @minLength(1)
  value: string;
}

/**
 * Represents List of Question Answers.
 */
model QnASearchResultList {
  /**
   * Represents Search Result list.
   */
  answers?: QnASearchResult[];
}

/**
 * Represents Search Result.
 */
model QnASearchResult {
  /**
   * List of questions.
   */
  questions?: string[];

  /**
   * Answer.
   */
  answer?: string;

  /**
   * Search result score.
   */
  score?: float32;

  /**
   * Id of the QnA result.
   */
  id?: int32;

  /**
   * Source of QnA result.
   */
  source?: string;

  /**
   * List of metadata.
   */
  metadata?: MetadataDTO[];

  /**
   * Context object of the QnA
   */
  context?: QnASearchResultContext;
}

/**
 * Context object of the QnA
 */
model QnASearchResultContext extends ContextDTO {}

/**
 * Context associated with Qna.
 */
model ContextDTO {
  /**
   * To mark if a prompt is relevant only with a previous question or not.
   * true - Do not include this QnA as search result for queries without context
   * false - ignores context and includes this QnA in search result
   */
  isContextOnly?: boolean;

  /**
   * List of prompts associated with the answer.
   */
  prompts?: PromptDTO[];
}

/**
 * Prompt for an answer.
 */
model PromptDTO {
  /**
   * Index of the prompt - used in ordering of the prompts
   */
  displayOrder?: int32;

  /**
   * Qna id corresponding to the prompt - if QnaId is present, QnADTO object is
   * ignored.
   */
  qnaId?: int32;

  /**
   * QnADTO - Either QnaId or QnADTO needs to be present in a PromptDTO object
   */
  qna?: PromptDTOQna;

  /**
   * Text displayed to represent a follow up question prompt
   */
  @maxLength(200)
  displayText?: string;
}

/**
 * QnADTO - Either QnaId or QnADTO needs to be present in a PromptDTO object
 */
model PromptDTOQna extends QnAdto {}

/**
 * Q-A object.
 */
model QnAdto {
  /**
   * Unique id for the Q-A.
   */
  id?: int32;

  /**
   * Answer text
   */
  @maxLength(25000)
  @minLength(1)
  answer: string;

  /**
   * Source from which Q-A was indexed. eg.
   * https://docs.microsoft.com/en-us/azure/cognitive-services/QnAMaker/FAQs
   */
  @maxLength(300)
  source?: string;

  /**
   * List of questions associated with the answer.
   */
  questions: string[];

  /**
   * List of metadata associated with the answer.
   */
  metadata?: MetadataDTO[];

  /**
   * Context of a QnA
   */
  context?: QnAdtoContext;
}

/**
 * Context of a QnA
 */
model QnAdtoContext extends ContextDTO {}

/**
 * Error response. As per Microsoft One API guidelines -
 * https://github.com/Microsoft/api-guidelines/blob/vNext/Guidelines.md#7102-error-condition-responses.
 */
@error
model ErrorResponse {
  /**
   * The error object.
   */
  error?: ErrorResponseError;
}

/**
 * The error object.
 */
model ErrorResponseError extends Error {}

/**
 * The error object. As per Microsoft One API guidelines -
 * https://github.com/Microsoft/api-guidelines/blob/vNext/Guidelines.md#7102-error-condition-responses.
 */
model Error {
  /**
   * One of a server-defined set of error codes.
   */
  code: ErrorCodeType;

  /**
   * A human-readable representation of the error.
   */
  message?: string;

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
  innerError?: InnerErrorModel;
}

/**
 * An object containing more specific information about the error. As per
 * Microsoft One API guidelines -
 * https://github.com/Microsoft/api-guidelines/blob/vNext/Guidelines.md#7102-error-condition-responses.
 */
model InnerErrorModel {
  /**
   * A more specific error code than was provided by the containing error.
   */
  code?: string;

  /**
   * An object containing more specific information than the current object about
   * the error.
   */
  innerError?: InnerErrorModel;
}

/**
 * Active learning feedback records.
 */
model FeedbackRecordsDTO {
  /**
   * List of feedback records.
   */
  feedbackRecords?: FeedbackRecordDTO[];
}

/**
 * Active learning feedback record.
 */
model FeedbackRecordDTO {
  /**
   * Unique identifier for the user.
   */
  userId?: string;

  /**
   * The suggested question being provided as feedback.
   */
  @maxLength(1000)
  userQuestion?: string;

  /**
   * The qnaId for which the suggested question is provided as feedback.
   */
  qnaId?: int32;
}
