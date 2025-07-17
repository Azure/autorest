import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.Search;

@@clientName(SearchDocumentsResult.`@odata.count`, "count");
@@clientName(SearchDocumentsResult.`@search.coverage`, "coverage");
@@clientName(SearchDocumentsResult.`@search.facets`, "facets");
@@clientName(SearchDocumentsResult.`@search.answers`, "answers");
@@clientName(SearchDocumentsResult.`@search.debug`, "debug");
@@clientName(SearchDocumentsResult.`@search.nextPageParameters`,
  "nextPageParameters"
);
@@clientName(SearchDocumentsResult.value, "results");
@@clientName(SearchDocumentsResult.`@odata.nextLink`, "nextLink");
@@clientName(SearchDocumentsResult.`@search.semanticPartialResponseReason`,
  "semanticPartialResponseReason"
);
@@clientName(SearchDocumentsResult.`@search.semanticPartialResponseType`,
  "semanticPartialResponseType"
);
@@clientName(SearchDocumentsResult.`@search.semanticQueryRewritesResultType`,
  "semanticQueryRewritesResultType"
);

@@clientName(FacetResult.`@search.facets`, "facets");

@@clientName(SearchRequest.count, "includeTotalResultCount");
@@clientName(SearchRequest.highlight, "highlightFields");
@@clientName(SearchRequest.orderby, "orderBy");
@@clientName(SearchRequest.search, "searchText");

@@clientName(SearchResult.`@search.score`, "score");
@@clientName(SearchResult.`@search.rerankerScore`, "rerankerScore");
@@clientName(SearchResult.`@search.highlights`, "highlights");
@@clientName(SearchResult.`@search.captions`, "captions");
@@clientName(SearchResult.`@search.documentDebugInfo`, "documentDebugInfo");

@@clientName(SuggestDocumentsResult.value, "results");
@@clientName(SuggestDocumentsResult.`@search.coverage`, "coverage");

@@clientName(SuggestResult.`@search.text`, "text");

@@clientName(SuggestRequest.fuzzy, "useFuzzyMatching");
@@clientName(SuggestRequest.orderby, "orderBy");
@@clientName(SuggestRequest.search, "searchText");

@@clientName(IndexBatch.value, "actions");

@@clientName(IndexAction.`@search.action`, "actionType");

@@clientName(IndexDocumentsResult.value, "results");

@@clientName(IndexingResult.status, "succeeded");

@@clientName(AutocompleteResult.`@search.coverage`, "coverage");
@@clientName(AutocompleteResult.value, "results");

@@clientName(AutocompleteRequest.search, "searchText");
@@clientName(AutocompleteRequest.fuzzy, "useFuzzyMatching");

@@clientLocation(DocumentsOperationGroup.count, "Documents");
@@clientLocation(DocumentsOperationGroup.searchGet, "Documents");
@@clientLocation(DocumentsOperationGroup.searchPost, "Documents");
@@clientLocation(DocumentsOperationGroup.get, "Documents");
@@clientLocation(DocumentsOperationGroup.suggestGet, "Documents");
@@clientLocation(DocumentsOperationGroup.suggestPost, "Documents");
@@clientLocation(DocumentsOperationGroup.index, "Documents");
@@clientLocation(DocumentsOperationGroup.autocompleteGet, "Documents");
@@clientLocation(DocumentsOperationGroup.autocompletePost, "Documents");
