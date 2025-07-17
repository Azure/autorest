import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using AutoRestPagingTestService;

@@clientName(OdataProductResult.`odata.nextLink`, "odataNextLink");

@@clientName(ProductResultValueWithXMSClientName.values, "indexes");

@@clientLocation(PagingOperationGroup.getNoItemNamePages, "Paging");
@@clientName(PagingOperationGroup.getNoItemNamePages, "getNoItemNamePages");
@@clientLocation(PagingOperationGroup.getNullNextLinkNamePages, "Paging");
@@clientName(PagingOperationGroup.getNullNextLinkNamePages,
  "getNullNextLinkNamePages"
);
@@clientLocation(PagingOperationGroup.getSinglePages, "Paging");
@@clientName(PagingOperationGroup.getSinglePages, "getSinglePages");
@@clientLocation(PagingOperationGroup.firstResponseEmpty, "Paging");
@@clientName(PagingOperationGroup.firstResponseEmpty, "firstResponseEmpty");
@@clientLocation(PagingOperationGroup.getMultiplePages, "Paging");
@@clientName(PagingOperationGroup.getMultiplePages, "getMultiplePages");
@@clientLocation(PagingOperationGroup.getWithQueryParams, "Paging");
@@clientName(PagingOperationGroup.getWithQueryParams, "getWithQueryParams");
@@clientLocation(PagingOperationGroup.duplicateParams, "Paging");
@@clientName(PagingOperationGroup.duplicateParams, "duplicateParams");
@@clientLocation(PagingOperationGroup.pageWithMaxPageSize, "Paging");
@@clientName(PagingOperationGroup.pageWithMaxPageSize, "pageWithMaxPageSize");
@@clientLocation(PagingOperationGroup.nextOperationWithQueryParams, "Paging");
@@clientName(PagingOperationGroup.nextOperationWithQueryParams,
  "nextOperationWithQueryParams"
);
@@clientLocation(PagingOperationGroup.getOdataMultiplePages, "Paging");
@@clientName(PagingOperationGroup.getOdataMultiplePages,
  "getOdataMultiplePages"
);
@@clientLocation(PagingOperationGroup.getMultiplePagesWithOffset, "Paging");
@@clientName(PagingOperationGroup.getMultiplePagesWithOffset,
  "getMultiplePagesWithOffset"
);
@@clientLocation(PagingOperationGroup.getMultiplePagesRetryFirst, "Paging");
@@clientName(PagingOperationGroup.getMultiplePagesRetryFirst,
  "getMultiplePagesRetryFirst"
);
@@clientLocation(PagingOperationGroup.getMultiplePagesRetrySecond, "Paging");
@@clientName(PagingOperationGroup.getMultiplePagesRetrySecond,
  "getMultiplePagesRetrySecond"
);
@@clientLocation(PagingOperationGroup.getSinglePagesFailure, "Paging");
@@clientName(PagingOperationGroup.getSinglePagesFailure,
  "getSinglePagesFailure"
);
@@clientLocation(PagingOperationGroup.getMultiplePagesFailure, "Paging");
@@clientName(PagingOperationGroup.getMultiplePagesFailure,
  "getMultiplePagesFailure"
);
@@clientLocation(PagingOperationGroup.getMultiplePagesFailureUri, "Paging");
@@clientName(PagingOperationGroup.getMultiplePagesFailureUri,
  "getMultiplePagesFailureUri"
);
@@clientLocation(PagingOperationGroup.getMultiplePagesFragmentNextLink,
  "Paging"
);
@@clientName(PagingOperationGroup.getMultiplePagesFragmentNextLink,
  "getMultiplePagesFragmentNextLink"
);
@@clientLocation(PagingOperationGroup.getMultiplePagesFragmentWithGroupingNextLink,
  "Paging"
);
@@clientName(PagingOperationGroup.getMultiplePagesFragmentWithGroupingNextLink,
  "getMultiplePagesFragmentWithGroupingNextLink"
);
@@clientLocation(PagingOperationGroup.getMultiplePagesLRO, "Paging");
@@clientLocation(PagingOperationGroup.appendApiVersion, "Paging");
@@clientName(PagingOperationGroup.appendApiVersion, "appendApiVersion");
@@clientLocation(PagingOperationGroup.replaceApiVersion, "Paging");
@@clientName(PagingOperationGroup.replaceApiVersion, "replaceApiVersion");
@@clientLocation(PagingOperationGroup.nextFragment, "Paging");
@@clientName(PagingOperationGroup.nextFragment, "nextFragment");
@@clientLocation(PagingOperationGroup.nextFragmentWithGrouping, "Paging");
@@clientName(PagingOperationGroup.nextFragmentWithGrouping,
  "nextFragmentWithGrouping"
);
@@clientLocation(PagingOperationGroup.getPagingModelWithItemNameWithXMSClientName,
  "Paging"
);
@@clientName(PagingOperationGroup.getPagingModelWithItemNameWithXMSClientName,
  "getPagingModelWithItemNameWithXMSClientName"
);
