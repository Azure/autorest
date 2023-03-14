import "@typespec/rest";
import "@typespec/http";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace QnAMakerRuntimeClient;

enum StrictFiltersCompoundOperationType {
  AND,
  OR,
}

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

@doc("POST body schema to query the knowledgebase.")
model QueryDTO {
  @doc("""
Exact qnaId to fetch from the knowledgebase, this field takes priority over
question.
""")
  qnaId?: string;

  @doc("User question to query against the knowledge base.")
  question?: string;

  @doc("Max number of answers to be returned for the question.")
  top?: int32;

  @doc("""
Unique identifier for the user. Optional parameter for telemetry. For more
information, refer <a href=\"http://aka.ms/qnamaker-analytics#user-traffic\"
target=\"blank\">Analytics and Telemetry</a>.
""")
  userId?: string;

  @doc("Query against the test index.")
  isTest?: boolean;

  @doc("Threshold for answers returned based on score.")
  scoreThreshold?: float32;

  @doc("Context object with previous QnA's information.")
  context?: QueryDTOContext;

  @doc("Optional field. Set to 'QuestionOnly' for using a question only Ranker.")
  rankerType?: string;

  @doc("Find only answers that contain these metadata.")
  strictFilters?: MetadataDTO[];

  @doc("Optional field. Set to OR for using OR as Operation for Strict Filters.")
  strictFiltersCompoundOperationType?: StrictFiltersCompoundOperationType;
}

@doc("Context object with previous QnA's information.")
model QueryDTOContext {
  ...QueryContextDTO;
}

@doc("Context object with previous QnA's information.")
model QueryContextDTO {
  @doc("Previous QnA Id - qnaId of the top result.")
  previousQnaId?: string;

  @doc("Previous user query.")
  previousUserQuery?: string;
}

@doc("Name - value pair of metadata.")
model MetadataDTO {
  @doc("Metadata name.")
  name: string;

  @doc("Metadata value.")
  value: string;
}

@doc("Represents List of Question Answers.")
model QnASearchResultList {
  @doc("Represents Search Result list.")
  answers?: QnASearchResult[];
}

@doc("Represents Search Result.")
model QnASearchResult {
  @doc("List of questions.")
  questions?: string[];

  @doc("Answer.")
  answer?: string;

  @doc("Search result score.")
  score?: float32;

  @doc("Id of the QnA result.")
  id?: int32;

  @doc("Source of QnA result.")
  source?: string;

  @doc("List of metadata.")
  metadata?: MetadataDTO[];

  @doc("Context object of the QnA")
  context?: QnASearchResultContext;
}

@doc("Context object of the QnA")
model QnASearchResultContext {
  ...ContextDTO;
}

@doc("Context associated with Qna.")
model ContextDTO {
  @doc("""
To mark if a prompt is relevant only with a previous question or not.
true - Do
not include this QnA as search result for queries without context
false -
ignores context and includes this QnA in search result
""")
  isContextOnly?: boolean;

  @doc("List of prompts associated with the answer.")
  prompts?: PromptDTO[];
}

@doc("Prompt for an answer.")
model PromptDTO {
  @doc("Index of the prompt - used in ordering of the prompts")
  displayOrder?: int32;

  @doc("""
Qna id corresponding to the prompt - if QnaId is present, QnADTO object is
ignored.
""")
  qnaId?: int32;

  @doc("QnADTO - Either QnaId or QnADTO needs to be present in a PromptDTO object")
  qna?: PromptDTOQna;

  @doc("Text displayed to represent a follow up question prompt")
  displayText?: string;
}

@doc("QnADTO - Either QnaId or QnADTO needs to be present in a PromptDTO object")
model PromptDTOQna {
  ...QnAdto;
}

@doc("Q-A object.")
model QnAdto {
  @doc("Unique id for the Q-A.")
  id?: int32;

  @doc("Answer text")
  answer: string;

  @doc("""
Source from which Q-A was indexed. eg.
https://docs.microsoft.com/en-us/azure/cognitive-services/QnAMaker/FAQs
""")
  source?: string;

  @doc("List of questions associated with the answer.")
  questions: string[];

  @doc("List of metadata associated with the answer.")
  metadata?: MetadataDTO[];

  @doc("Context of a QnA")
  context?: QnAdtoContext;
}

@doc("Context of a QnA")
model QnAdtoContext {
  ...ContextDTO;
}

@doc("""
Error response. As per Microsoft One API guidelines -
https://github.com/Microsoft/api-guidelines/blob/vNext/Guidelines.md#7102-error-condition-responses.
""")
@error
model ErrorResponse {
  @doc("The error object.")
  error?: ErrorResponseError;
}

@doc("The error object.")
model ErrorResponseError {
  ...Error;
}

@doc("""
The error object. As per Microsoft One API guidelines -
https://github.com/Microsoft/api-guidelines/blob/vNext/Guidelines.md#7102-error-condition-responses.
""")
model Error {
  @doc("One of a server-defined set of error codes.")
  code: ErrorCodeType;

  @doc("A human-readable representation of the error.")
  message?: string;

  @doc("The target of the error.")
  target?: string;

  @doc("An array of details about specific errors that led to this reported error.")
  details?: Error[];

  @doc("""
An object containing more specific information than the current object about
the error.
""")
  innerError?: InnerErrorModel;
}

@doc("""
An object containing more specific information about the error. As per
Microsoft One API guidelines -
https://github.com/Microsoft/api-guidelines/blob/vNext/Guidelines.md#7102-error-condition-responses.
""")
model InnerErrorModel {
  @doc("A more specific error code than was provided by the containing error.")
  code?: string;

  @doc("""
An object containing more specific information than the current object about
the error.
""")
  innerError?: InnerErrorModel;
}

@doc("Active learning feedback records.")
model FeedbackRecordsDTO {
  @doc("List of feedback records.")
  feedbackRecords?: FeedbackRecordDTO[];
}

@doc("Active learning feedback record.")
model FeedbackRecordDTO {
  @doc("Unique identifier for the user.")
  userId?: string;

  @doc("The suggested question being provided as feedback.")
  userQuestion?: string;

  @doc("The qnaId for which the suggested question is provided as feedback.")
  qnaId?: int32;
}
