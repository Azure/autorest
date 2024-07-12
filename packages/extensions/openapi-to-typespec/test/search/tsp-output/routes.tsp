import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";


using TypeSpec.Rest;
using TypeSpec.Http;


namespace Azure.Search;



interface DataSourcesOperations {
/**
* Creates a new datasource or updates a datasource if it already exists.
*/

`createOrUpdate` is Azure.Core.ResourceCreateOrReplace<SearchIndexerDataSource , { parameters: {/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string
/**
* Defines the If-Match condition. The operation will be performed only if the
* ETag on the server matches this value.
*/
@header
"If-Match"?: string
/**
* Defines the If-None-Match condition. The operation will be performed only if
* the ETag on the server does not match this value.
*/
@header
"If-None-Match"?: string
/**
* For HTTP PUT requests, instructs the service to return the created/updated
* resource on success.
*/
@header
"Prefer": }}>;



/**
* Deletes a datasource.
*/

`delete` is Azure.Core.ResourceDelete<SearchIndexerDataSource , { parameters: {/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string
/**
* Defines the If-Match condition. The operation will be performed only if the
* ETag on the server matches this value.
*/
@header
"If-Match"?: string
/**
* Defines the If-None-Match condition. The operation will be performed only if
* the ETag on the server does not match this value.
*/
@header
"If-None-Match"?: string}}>;



/**
* Retrieves a datasource definition.
*/

`get` is Azure.Core.ResourceRead<SearchIndexerDataSource , { parameters: {/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}}>;



/**
* Lists all datasources available for a search service.
*/
@route("/datasources")
@get op `list` is Azure.Core.Foundations.Operation<{/**
* Selects which top-level properties of the data sources to retrieve. Specified
* as a comma-separated list of JSON property names, or '*' for all properties.
* The default is all properties.
*/
@query("$select")
"$select"?: string
/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}, ListDataSourcesResult>;



/**
* Creates a new datasource.
*/

`create` is Azure.Core.ResourceCreateWithServiceProvidedName<SearchIndexerDataSource , { parameters: {/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}}>;



}

interface IndexersOperations {
/**
* Resets the change tracking state associated with an indexer.
*/
@route("/indexers('{indexerName}')/search.reset")
@post op `reset` is Azure.Core.Foundations.Operation<{/**
* The name of the indexer to reset.
*/
@path
"indexerName": string
/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}, void>;



/**
* Runs an indexer on-demand.
*/
@route("/indexers('{indexerName}')/search.run")
@post op `run` is Azure.Core.Foundations.Operation<{/**
* The name of the indexer to run.
*/
@path
"indexerName": string
/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}, void>;



/**
* Creates a new indexer or updates an indexer if it already exists.
*/

`createOrUpdate` is Azure.Core.ResourceCreateOrReplace<SearchIndexer , { parameters: {/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string
/**
* Defines the If-Match condition. The operation will be performed only if the
* ETag on the server matches this value.
*/
@header
"If-Match"?: string
/**
* Defines the If-None-Match condition. The operation will be performed only if
* the ETag on the server does not match this value.
*/
@header
"If-None-Match"?: string
/**
* For HTTP PUT requests, instructs the service to return the created/updated
* resource on success.
*/
@header
"Prefer": }}>;



/**
* Deletes an indexer.
*/

`delete` is Azure.Core.ResourceDelete<SearchIndexer , { parameters: {/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string
/**
* Defines the If-Match condition. The operation will be performed only if the
* ETag on the server matches this value.
*/
@header
"If-Match"?: string
/**
* Defines the If-None-Match condition. The operation will be performed only if
* the ETag on the server does not match this value.
*/
@header
"If-None-Match"?: string}}>;



/**
* Retrieves an indexer definition.
*/

`get` is Azure.Core.ResourceRead<SearchIndexer , { parameters: {/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}}>;



/**
* Lists all indexers available for a search service.
*/
@route("/indexers")
@get op `list` is Azure.Core.Foundations.Operation<{/**
* Selects which top-level properties of the indexers to retrieve. Specified as a
* comma-separated list of JSON property names, or '*' for all properties. The
* default is all properties.
*/
@query("$select")
"$select"?: string
/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}, ListIndexersResult>;



/**
* Creates a new indexer.
*/

`create` is Azure.Core.ResourceCreateWithServiceProvidedName<SearchIndexer , { parameters: {/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}}>;



/**
* Returns the current status and execution history of an indexer.
*/
@route("/indexers('{indexerName}')/search.status")
@get op `getStatus` is Azure.Core.Foundations.Operation<{/**
* The name of the indexer for which to retrieve status.
*/
@path
"indexerName": string
/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}, SearchIndexerStatus>;



}

interface SkillsetsOperations {
/**
* Creates a new skillset in a search service or updates the skillset if it
* already exists.
*/

`createOrUpdate` is Azure.Core.ResourceCreateOrReplace<SearchIndexerSkillset , { parameters: {/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string
/**
* Defines the If-Match condition. The operation will be performed only if the
* ETag on the server matches this value.
*/
@header
"If-Match"?: string
/**
* Defines the If-None-Match condition. The operation will be performed only if
* the ETag on the server does not match this value.
*/
@header
"If-None-Match"?: string
/**
* For HTTP PUT requests, instructs the service to return the created/updated
* resource on success.
*/
@header
"Prefer": }}>;



/**
* Deletes a skillset in a search service.
*/

`delete` is Azure.Core.ResourceDelete<SearchIndexerSkillset , { parameters: {/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string
/**
* Defines the If-Match condition. The operation will be performed only if the
* ETag on the server matches this value.
*/
@header
"If-Match"?: string
/**
* Defines the If-None-Match condition. The operation will be performed only if
* the ETag on the server does not match this value.
*/
@header
"If-None-Match"?: string}}>;



/**
* Retrieves a skillset in a search service.
*/

`get` is Azure.Core.ResourceRead<SearchIndexerSkillset , { parameters: {/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}}>;



/**
* List all skillsets in a search service.
*/
@route("/skillsets")
@get op `list` is Azure.Core.Foundations.Operation<{/**
* Selects which top-level properties of the skillsets to retrieve. Specified as a
* comma-separated list of JSON property names, or '*' for all properties. The
* default is all properties.
*/
@query("$select")
"$select"?: string
/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}, ListSkillsetsResult>;



/**
* Creates a new skillset in a search service.
*/

`create` is Azure.Core.ResourceCreateWithServiceProvidedName<SearchIndexerSkillset , { parameters: {/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}}>;



}

interface SynonymMapsOperations {
/**
* Creates a new synonym map or updates a synonym map if it already exists.
*/

`createOrUpdate` is Azure.Core.ResourceCreateOrReplace<SynonymMap , { parameters: {/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string
/**
* Defines the If-Match condition. The operation will be performed only if the
* ETag on the server matches this value.
*/
@header
"If-Match"?: string
/**
* Defines the If-None-Match condition. The operation will be performed only if
* the ETag on the server does not match this value.
*/
@header
"If-None-Match"?: string
/**
* For HTTP PUT requests, instructs the service to return the created/updated
* resource on success.
*/
@header
"Prefer": }}>;



/**
* Deletes a synonym map.
*/

`delete` is Azure.Core.ResourceDelete<SynonymMap , { parameters: {/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string
/**
* Defines the If-Match condition. The operation will be performed only if the
* ETag on the server matches this value.
*/
@header
"If-Match"?: string
/**
* Defines the If-None-Match condition. The operation will be performed only if
* the ETag on the server does not match this value.
*/
@header
"If-None-Match"?: string}}>;



/**
* Retrieves a synonym map definition.
*/

`get` is Azure.Core.ResourceRead<SynonymMap , { parameters: {/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}}>;



/**
* Lists all synonym maps available for a search service.
*/
@route("/synonymmaps")
@get op `list` is Azure.Core.Foundations.Operation<{/**
* Selects which top-level properties of the synonym maps to retrieve. Specified
* as a comma-separated list of JSON property names, or '*' for all properties.
* The default is all properties.
*/
@query("$select")
"$select"?: string
/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}, ListSynonymMapsResult>;



/**
* Creates a new synonym map.
*/

`create` is Azure.Core.ResourceCreateWithServiceProvidedName<SynonymMap , { parameters: {/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}}>;



}

interface IndexesOperations {
/**
* Creates a new search index.
*/

`create` is Azure.Core.ResourceCreateWithServiceProvidedName<SearchIndex , { parameters: {/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}}>;



/**
* Lists all indexes available for a search service.
*/

`list` is Azure.Core.ResourceList<SearchIndex , { parameters: {/**
* Selects which top-level properties of the index definitions to retrieve.
* Specified as a comma-separated list of JSON property names, or '*' for all
* properties. The default is all properties.
*/
@query("$select")
"$select"?: string
/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}}>;



/**
* Creates a new search index or updates an index if it already exists.
*/

`createOrUpdate` is Azure.Core.ResourceCreateOrReplace<SearchIndex , { parameters: {/**
* Allows new analyzers, tokenizers, token filters, or char filters to be added to
* an index by taking the index offline for at least a few seconds. This
* temporarily causes indexing and query requests to fail. Performance and write
* availability of the index can be impaired for several minutes after the index
* is updated, or longer for very large indexes.
*/
@query("allowIndexDowntime")
"allowIndexDowntime"?: boolean
/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string
/**
* Defines the If-Match condition. The operation will be performed only if the
* ETag on the server matches this value.
*/
@header
"If-Match"?: string
/**
* Defines the If-None-Match condition. The operation will be performed only if
* the ETag on the server does not match this value.
*/
@header
"If-None-Match"?: string
/**
* For HTTP PUT requests, instructs the service to return the created/updated
* resource on success.
*/
@header
"Prefer": }}>;



/**
* Deletes a search index and all the documents it contains. This operation is
* permanent, with no recovery option. Make sure you have a master copy of your
* index definition, data ingestion code, and a backup of the primary data source
* in case you need to re-build the index.
*/

`delete` is Azure.Core.ResourceDelete<SearchIndex , { parameters: {/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string
/**
* Defines the If-Match condition. The operation will be performed only if the
* ETag on the server matches this value.
*/
@header
"If-Match"?: string
/**
* Defines the If-None-Match condition. The operation will be performed only if
* the ETag on the server does not match this value.
*/
@header
"If-None-Match"?: string}}>;



/**
* Retrieves an index definition.
*/

`get` is Azure.Core.ResourceRead<SearchIndex , { parameters: {/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}}>;



/**
* Returns statistics for the given index, including a document count and storage
* usage.
*/
@route("/indexes('{indexName}')/search.stats")
@get op `getStatistics` is Azure.Core.Foundations.Operation<{/**
* The name of the index for which to retrieve statistics.
*/
@path
"indexName": string
/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}, GetIndexStatisticsResult>;



/**
* Shows how an analyzer breaks text into tokens.
*/
@route("/indexes('{indexName}')/search.analyze")
@post op `analyze` is Azure.Core.Foundations.Operation<{/**
* The name of the index for which to test an analyzer.
*/
@path
"indexName": string
/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string
/**
* The text and analyzer or analysis components to test.
*/
@body
"request": AnalyzeRequest}, AnalyzeResult>;



}

/**
* Gets service level statistics for a search service.
*/
@route("/servicestats")
@get op `getServiceStatistics` is Azure.Core.Foundations.Operation<{/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}, ServiceStatistics>;




interface DocumentsOperations {
/**
* Queries the number of documents in the index.
*/
@route("/docs/$count")
@get op `count` is Azure.Core.Foundations.Operation<{/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}, void>;



/**
* Searches for documents in the index.
*/
@route("/docs")
@get op `searchGet` is Azure.Core.Foundations.Operation<{/**
* A full-text search query expression; Use "*" or omit this parameter to match
* all documents.
*/
@query("search")
"SearchText"?: string
/**
* A value that specifies whether to fetch the total count of results. Default is
* false. Setting this value to true may have a performance impact. Note that the
* count returned is an approximation.
*/
@query("$count")
"IncludeTotalResultCount"?: boolean
/**
* The list of facet expressions to apply to the search query. Each facet
* expression contains a field name, optionally followed by a comma-separated list
* of name:value pairs.
*/
@query({name: "facet", format: "multi"})
"Facets"?: string[]
/**
* The OData $filter expression to apply to the search query.
*/
@query("$filter")
"$filter"?: string
/**
* The list of field names to use for hit highlights. Only searchable fields can
* be used for hit highlighting.
*/
@query({name: "highlight", format: "csv"})
"HighlightFields"?: string[]
/**
* A string tag that is appended to hit highlights. Must be set with
* highlightPreTag. Default is &lt;/em&gt;.
*/
@query("highlightPostTag")
"highlightPostTag"?: string
/**
* A string tag that is prepended to hit highlights. Must be set with
* highlightPostTag. Default is &lt;em&gt;.
*/
@query("highlightPreTag")
"highlightPreTag"?: string
/**
* A number between 0 and 100 indicating the percentage of the index that must be
* covered by a search query in order for the query to be reported as a success.
* This parameter can be useful for ensuring search availability even for services
* with only one replica. The default is 100.
*/
@query("minimumCoverage")
"minimumCoverage"?: float64
/**
* The list of OData $orderby expressions by which to sort the results. Each
* expression can be either a field name or a call to either the geo.distance() or
* the search.score() functions. Each expression can be followed by asc to
* indicate ascending, and desc to indicate descending. The default is ascending
* order. Ties will be broken by the match scores of documents. If no OrderBy is
* specified, the default sort order is descending by document match score. There
* can be at most 32 $orderby clauses.
*/
@query({name: "$orderby", format: "csv"})
"OrderBy"?: string[]
/**
* A value that specifies the syntax of the search query. The default is 'simple'.
* Use 'full' if your query uses the Lucene query syntax.
*/
@query("queryType")
"queryType"?: QueryType
/**
* The list of parameter values to be used in scoring functions (for example,
* referencePointParameter) using the format name-values. For example, if the
* scoring profile defines a function with a parameter called 'mylocation' the
* parameter string would be "mylocation--122.2,44.8" (without the quotes).
*/
@query({name: "scoringParameter", format: "multi"})
"ScoringParameters"?: string[]
/**
* The name of a scoring profile to evaluate match scores for matching documents
* in order to sort the results.
*/
@query("scoringProfile")
"scoringProfile"?: string
/**
* The list of field names to which to scope the full-text search. When using
* fielded search (fieldName:searchExpression) in a full Lucene query, the field
* names of each fielded search expression take precedence over any field names
* listed in this parameter.
*/
@query({name: "searchFields", format: "csv"})
"searchFields"?: string[]
/**
* A value that specifies whether any or all of the search terms must be matched
* in order to count the document as a match.
*/
@query("searchMode")
"searchMode"?: SearchMode
/**
* A value that specifies whether we want to calculate scoring statistics (such as
* document frequency) globally for more consistent scoring, or locally, for lower
* latency.
*/
@query("scoringStatistics")
"scoringStatistics"?: ScoringStatistics
/**
* A value to be used to create a sticky session, which can help to get more
* consistent results. As long as the same sessionId is used, a best-effort
* attempt will be made to target the same replica set. Be wary that reusing the
* same sessionID values repeatedly can interfere with the load balancing of the
* requests across replicas and adversely affect the performance of the search
* service. The value used as sessionId cannot start with a '_' character.
*/
@query("sessionId")
"sessionId"?: string
/**
* The list of fields to retrieve. If unspecified, all fields marked as
* retrievable in the schema are included.
*/
@query({name: "$select", format: "csv"})
"$select"?: string[]
/**
* The number of search results to skip. This value cannot be greater than
* 100,000. If you need to scan documents in sequence, but cannot use $skip due to
* this limitation, consider using $orderby on a totally-ordered key and $filter
* with a range query instead.
*/
@query("$skip")
"$skip"?: int32
/**
* The number of search results to retrieve. This can be used in conjunction with
* $skip to implement client-side paging of search results. If results are
* truncated due to server-side paging, the response will include a continuation
* token that can be used to issue another Search request for the next page of
* results.
*/
@query("$top")
"$top"?: int32
/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string
/**
* The name of the semantic configuration that lists which fields should be used
* for semantic ranking, captions, highlights, and answers
*/
@query("semanticConfiguration")
"semanticConfiguration"?: string
/**
* Allows the user to choose whether a semantic call should fail completely, or to
* return partial results (default).
*/
@query("semanticErrorHandling")
"semanticErrorHandling"?: SemanticErrorMode
/**
* Allows the user to set an upper bound on the amount of time it takes for
* semantic enrichment to finish processing before the request fails.
*/
@minValue(700)
@query("semanticMaxWaitInMilliseconds")
"semanticMaxWaitInMilliseconds"?: int32
/**
* This parameter is only valid if the query type is `semantic`. If set, the query
* returns answers extracted from key passages in the highest ranked documents.
* The number of answers returned can be configured by appending the pipe
* character `|` followed by the `count-<number of answers>` option after the
* answers parameter value, such as `extractive|count-3`. Default count is 1. The
* confidence threshold can be configured by appending the pipe character `|`
* followed by the `threshold-<confidence threshold>` option after the answers
* parameter value, such as `extractive|threshold-0.9`. Default threshold is 0.7.
*/
@query("answers")
"answers"?: QueryAnswerType
/**
* This parameter is only valid if the query type is `semantic`. If set, the query
* returns captions extracted from key passages in the highest ranked documents.
* When Captions is set to `extractive`, highlighting is enabled by default, and
* can be configured by appending the pipe character `|` followed by the
* `highlight-<true/false>` option, such as `extractive|highlight-true`. Defaults
* to `None`.
*/
@query("captions")
"captions"?: QueryCaptionType
/**
* Allows setting a separate search query that will be solely used for semantic
* reranking, semantic captions and semantic answers. Is useful for scenarios
* where there is a need to use different queries between the base retrieval and
* ranking phase, and the L2 semantic phase.
*/
@query("semanticQuery")
"semanticQuery"?: string}, SearchDocumentsResult>;



/**
* Searches for documents in the index.
*/
@route("/docs/search.post.search")
@post op `searchPost` is Azure.Core.Foundations.Operation<{/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string
/**
* The definition of the Search request.
*/
@body
"searchRequest": SearchRequest}, SearchDocumentsResult>;



/**
* Retrieves a document from the index.
*/
@route("/docs('{key}')")
@get op `get` is Azure.Core.Foundations.Operation<{/**
* The key of the document to retrieve.
*/
@path
"key": string
/**
* List of field names to retrieve for the document; Any field not retrieved will
* be missing from the returned document.
*/
@query({name: "$select", format: "csv"})
"SelectedFields"?: string[]
/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}, void>;



/**
* Suggests documents in the index that match the given partial query text.
*/
@route("/docs/search.suggest")
@get op `suggestGet` is Azure.Core.Foundations.Operation<{/**
* The search text to use to suggest documents. Must be at least 1 character, and
* no more than 100 characters.
*/
@query("search")
"SearchText": string
/**
* The name of the suggester as specified in the suggesters collection that's part
* of the index definition.
*/
@query("suggesterName")
"suggesterName": string
/**
* An OData expression that filters the documents considered for suggestions.
*/
@query("$filter")
"$filter"?: string
/**
* A value indicating whether to use fuzzy matching for the suggestions query.
* Default is false. When set to true, the query will find terms even if there's a
* substituted or missing character in the search text. While this provides a
* better experience in some scenarios, it comes at a performance cost as fuzzy
* suggestions queries are slower and consume more resources.
*/
@query("fuzzy")
"UseFuzzyMatching"?: boolean
/**
* A string tag that is appended to hit highlights. Must be set with
* highlightPreTag. If omitted, hit highlighting of suggestions is disabled.
*/
@query("highlightPostTag")
"highlightPostTag"?: string
/**
* A string tag that is prepended to hit highlights. Must be set with
* highlightPostTag. If omitted, hit highlighting of suggestions is disabled.
*/
@query("highlightPreTag")
"highlightPreTag"?: string
/**
* A number between 0 and 100 indicating the percentage of the index that must be
* covered by a suggestions query in order for the query to be reported as a
* success. This parameter can be useful for ensuring search availability even for
* services with only one replica. The default is 80.
*/
@query("minimumCoverage")
"minimumCoverage"?: float64
/**
* The list of OData $orderby expressions by which to sort the results. Each
* expression can be either a field name or a call to either the geo.distance() or
* the search.score() functions. Each expression can be followed by asc to
* indicate ascending, or desc to indicate descending. The default is ascending
* order. Ties will be broken by the match scores of documents. If no $orderby is
* specified, the default sort order is descending by document match score. There
* can be at most 32 $orderby clauses.
*/
@query({name: "$orderby", format: "csv"})
"OrderBy"?: string[]
/**
* The list of field names to search for the specified search text. Target fields
* must be included in the specified suggester.
*/
@query({name: "searchFields", format: "csv"})
"searchFields"?: string[]
/**
* The list of fields to retrieve. If unspecified, only the key field will be
* included in the results.
*/
@query({name: "$select", format: "csv"})
"$select"?: string[]
/**
* The number of suggestions to retrieve. The value must be a number between 1 and
* 100. The default is 5.
*/
@query("$top")
"$top"?: int32
/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string}, SuggestDocumentsResult>;



/**
* Suggests documents in the index that match the given partial query text.
*/
@route("/docs/search.post.suggest")
@post op `suggestPost` is Azure.Core.Foundations.Operation<{/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string
/**
* The Suggest request.
*/
@body
"suggestRequest": SuggestRequest}, SuggestDocumentsResult>;



/**
* Sends a batch of document write actions to the index.
*/
@route("/docs/search.index")
@post op `index` is Azure.Core.Foundations.Operation<{/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string
/**
* The batch of index actions.
*/
@body
"batch": IndexBatch}, IndexDocumentsResult>;



/**
* Autocompletes incomplete query terms based on input text and matching terms in
* the index.
*/
@route("/docs/search.autocomplete")
@get op `autocompleteGet` is Azure.Core.Foundations.Operation<{/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string
/**
* The incomplete term which should be auto-completed.
*/
@query("search")
"SearchText": string
/**
* The name of the suggester as specified in the suggesters collection that's part
* of the index definition.
*/
@query("suggesterName")
"suggesterName": string
/**
* Specifies the mode for Autocomplete. The default is 'oneTerm'. Use 'twoTerms'
* to get shingles and 'oneTermWithContext' to use the current context while
* producing auto-completed terms.
*/
@query("autocompleteMode")
"autocompleteMode"?: AutocompleteMode
/**
* An OData expression that filters the documents used to produce completed terms
* for the Autocomplete result.
*/
@query("$filter")
"$filter"?: string
/**
* A value indicating whether to use fuzzy matching for the autocomplete query.
* Default is false. When set to true, the query will find terms even if there's a
* substituted or missing character in the search text. While this provides a
* better experience in some scenarios, it comes at a performance cost as fuzzy
* autocomplete queries are slower and consume more resources.
*/
@query("fuzzy")
"UseFuzzyMatching"?: boolean
/**
* A string tag that is appended to hit highlights. Must be set with
* highlightPreTag. If omitted, hit highlighting is disabled.
*/
@query("highlightPostTag")
"highlightPostTag"?: string
/**
* A string tag that is prepended to hit highlights. Must be set with
* highlightPostTag. If omitted, hit highlighting is disabled.
*/
@query("highlightPreTag")
"highlightPreTag"?: string
/**
* A number between 0 and 100 indicating the percentage of the index that must be
* covered by an autocomplete query in order for the query to be reported as a
* success. This parameter can be useful for ensuring search availability even for
* services with only one replica. The default is 80.
*/
@query("minimumCoverage")
"minimumCoverage"?: float64
/**
* The list of field names to consider when querying for auto-completed terms.
* Target fields must be included in the specified suggester.
*/
@query({name: "searchFields", format: "csv"})
"searchFields"?: string[]
/**
* The number of auto-completed terms to retrieve. This must be a value between 1
* and 100. The default is 5.
*/
@query("$top")
"$top"?: int32}, AutocompleteResult>;



/**
* Autocompletes incomplete query terms based on input text and matching terms in
* the index.
*/
@route("/docs/search.post.autocomplete")
@post op `autocompletePost` is Azure.Core.Foundations.Operation<{/**
* The tracking ID sent with the request to help with debugging.
*/
@header
"x-ms-client-request-id"?: string
/**
* The definition of the Autocomplete request.
*/
@body
"autocompleteRequest": AutocompleteRequest}, AutocompleteResult>;



}