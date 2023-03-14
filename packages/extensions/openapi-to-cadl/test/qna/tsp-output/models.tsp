import "@typespec/rest";
import "@typespec/http";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.Language.QnAMaker;

enum RankerKind {
  @doc("Question only ranker.") QuestionOnly,
  @doc("Default ranker.") Default,
}

enum LogicalOperationKind {
  AND,
  OR,
}

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

enum StringIndexType {
  @doc("""
Returned offset and length values will correspond to TextElements (Graphemes
and Grapheme clusters) confirming to the Unicode 8.0.0 standard. Use this
option if your application is written in .Net Framework or .Net Core and you
will be using StringInfo.
""")
  TextElements_v8,
  @doc("""
Returned offset and length values will correspond to Unicode code points. Use
this option if your application is written in a language that support Unicode,
for example Python.
""")
  UnicodeCodePoint,
  @doc("""
Returned offset and length values will correspond to UTF-16 code units. Use
this option if your application is written in a language that support Unicode,
for example Java, JavaScript.
""")
  Utf16CodeUnit,
}

@doc("Parameters to query a knowledge base.")
model AnswersOptions {
  @doc("""
Exact QnA ID to fetch from the knowledge base, this field takes priority over
question.
""")
  qnaId?: int32;

  @doc("User question to query against the knowledge base.")
  question?: string;

  @doc("Max number of answers to be returned for the question.")
  top?: int32;

  @doc("Unique identifier for the user.")
  userId?: string;

  @doc("Minimum threshold score for answers, value ranges from 0 to 1.")
  @projectedName("json", "confidenceScoreThreshold")
  confidenceThreshold?: float32;

  @doc("Context object with previous QnA's information.")
  @projectedName("json", "context")
  answerContext?: KnowledgeBaseAnswerContext;

  @doc("Type of ranker to be used.")
  @projectedName("json", "rankerType")
  rankerKind?: RankerKind;

  @doc("Filter QnAs based on given metadata list and knowledge base sources.")
  filters?: QueryFilters;

  @doc("To configure Answer span prediction feature.")
  @projectedName("json", "answerSpanRequest")
  shortAnswerOptions?: ShortAnswerOptions;

  @doc("(Optional) Flag to enable Query over Unstructured Sources.")
  includeUnstructuredSources?: boolean;
}

@doc("Context object with previous QnA's information.")
model KnowledgeBaseAnswerContext {
  @doc("Previous turn top answer result QnA ID.")
  previousQnaId: int32;

  @doc("Previous user query.")
  @projectedName("json", "previousUserQuery")
  previousQuestion?: string;
}

@doc("filters over knowledge base.")
model QueryFilters {
  @doc("Find QnAs that are associated with the given list of metadata.")
  metadataFilter?: MetadataFilter;

  @doc("""
Find QnAs that are associated with any of the given list of sources in
knowledge base.
""")
  sourceFilter?: string[];

  @doc("Logical operation used to join metadata filter with source filter.")
  logicalOperation?: LogicalOperationKind;
}

@doc("Find QnAs that are associated with the given list of metadata.")
model MetadataFilter {
  metadata?: MetadataRecord[];

  @doc("Operation used to join metadata filters.")
  logicalOperation?: LogicalOperationKind;
}

@doc("Object to provide the key value pair for each metadata.")
model MetadataRecord {
  @doc("Metadata Key from Metadata dictionary used in the QnA.")
  key: string;

  @doc("Metadata Value from Metadata dictionary used in the QnA.")
  value: string;
}

@doc("To configure Answer span prediction feature.")
model ShortAnswerOptions {
  @doc("Enable or disable Answer Span prediction.")
  enable: true;

  @doc("""
Minimum threshold score required to include an answer span, value ranges from 0
to 1.
""")
  @projectedName("json", "confidenceScoreThreshold")
  confidenceThreshold?: float32;

  @doc("Number of Top answers to be considered for span prediction from 1 to 10.")
  @projectedName("json", "topAnswersWithSpan")
  top?: int32;
}

@doc("Represents List of Question Answers.")
model AnswersResult {
  @doc("Represents Answer Result list.")
  answers?: KnowledgeBaseAnswer[];
}

@doc("Represents knowledge base answer.")
model KnowledgeBaseAnswer {
  @doc("List of questions associated with the answer.")
  questions?: string[];

  @doc("Answer text.")
  answer?: string;

  @doc("Answer confidence score, value ranges from 0 to 1.")
  @projectedName("json", "confidenceScore")
  confidence?: float32;

  @doc("ID of the QnA result.")
  @projectedName("json", "id")
  qnaId?: int32;

  @doc("Source of QnA result.")
  source?: string;

  @doc("""
Metadata associated with the answer, useful to categorize or filter question
answers.
""")
  metadata?: Record<string>;

  @doc("Dialog associated with Answer.")
  dialog?: KnowledgeBaseAnswerDialog;

  @doc("Answer span object of QnA with respect to user's question.")
  @projectedName("json", "answerSpan")
  shortAnswer?: AnswerSpan;
}

@doc("Dialog associated with Answer.")
model KnowledgeBaseAnswerDialog {
  @doc("""
To mark if a prompt is relevant only with a previous question or not. If true,
do not include this QnA as search result for queries without context;
otherwise, if false, ignores context and includes this QnA in search result.
""")
  isContextOnly?: boolean;

  @doc("List of prompts associated with the answer.")
  prompts?: KnowledgeBaseAnswerPrompt[];
}

@doc("Prompt for an answer.")
model KnowledgeBaseAnswerPrompt {
  @doc("Index of the prompt - used in ordering of the prompts.")
  displayOrder?: int32;

  @doc("QnA ID corresponding to the prompt.")
  qnaId?: int32;

  @doc("Text displayed to represent a follow up question prompt.")
  displayText?: string;
}

@doc("Answer span object of QnA.")
model AnswerSpan {
  @doc("Predicted text of answer span.")
  text?: string;

  @doc("Predicted score of answer span, value ranges from 0 to 1.")
  @projectedName("json", "confidenceScore")
  confidence?: float32;

  @doc("The answer span offset from the start of answer.")
  offset?: int32;

  @doc("The length of the answer span.")
  length?: int32;
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

@doc("The question and text record parameters to answer.")
model AnswersFromTextOptions {
  @doc("User question to query against the given text records.")
  question: string;

  @doc("Text records to be searched for given question.")
  @projectedName("json", "records")
  textDocuments: TextDocument[];

  @doc("""
Language of the text records. This is BCP-47 representation of a language. For
example, use \"en\" for English; \"es\" for Spanish etc. If not set, use \"en\"
for English as default.
""")
  language?: string;

  @doc("""
Specifies the method used to interpret string offsets.  Defaults to Text
Elements (Graphemes) according to Unicode v8.0.0. For additional information
see https://aka.ms/text-analytics-offsets.
""")
  stringIndexType?: StringIndexType;
}

@doc("Represent input text record to be queried.")
model TextDocument {
  @doc("Unique identifier for the text record.")
  id: string;

  @doc("Text contents of the record.")
  text: string;
}

@doc("Represents the answer results.")
model AnswersFromTextResult {
  @doc("Represents the answer results.")
  answers?: TextAnswer[];
}

@doc("Represents answer result.")
model TextAnswer {
  @doc("Answer.")
  answer?: string;

  @doc("answer confidence score, value ranges from 0 to 1.")
  @projectedName("json", "confidenceScore")
  confidence?: float32;

  @doc("record ID.")
  id?: string;

  @doc("Answer span object with respect to user's question.")
  @projectedName("json", "answerSpan")
  shortAnswer?: AnswerSpan;

  @doc("The sentence offset from the start of the document.")
  offset?: int32;

  @doc("The length of the sentence.")
  length?: int32;
}
