import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using AutoRestUrlTestService;

@@clientLocation(pathsOperationGroup.getBooleanTrue, "paths");
@@clientName(pathsOperationGroup.getBooleanTrue, "getBooleanTrue");
@@clientLocation(pathsOperationGroup.getBooleanFalse, "paths");
@@clientName(pathsOperationGroup.getBooleanFalse, "getBooleanFalse");
@@clientLocation(pathsOperationGroup.getIntOneMillion, "paths");
@@clientName(pathsOperationGroup.getIntOneMillion, "getIntOneMillion");
@@clientLocation(pathsOperationGroup.getIntNegativeOneMillion, "paths");
@@clientName(pathsOperationGroup.getIntNegativeOneMillion,
  "getIntNegativeOneMillion"
);
@@clientLocation(pathsOperationGroup.getTenBillion, "paths");
@@clientName(pathsOperationGroup.getTenBillion, "getTenBillion");
@@clientLocation(pathsOperationGroup.getNegativeTenBillion, "paths");
@@clientName(pathsOperationGroup.getNegativeTenBillion,
  "getNegativeTenBillion"
);
@@clientLocation(pathsOperationGroup.floatScientificPositive, "paths");
@@clientName(pathsOperationGroup.floatScientificPositive,
  "floatScientificPositive"
);
@@clientLocation(pathsOperationGroup.floatScientificNegative, "paths");
@@clientName(pathsOperationGroup.floatScientificNegative,
  "floatScientificNegative"
);
@@clientLocation(pathsOperationGroup.doubleDecimalPositive, "paths");
@@clientName(pathsOperationGroup.doubleDecimalPositive,
  "doubleDecimalPositive"
);
@@clientLocation(pathsOperationGroup.doubleDecimalNegative, "paths");
@@clientName(pathsOperationGroup.doubleDecimalNegative,
  "doubleDecimalNegative"
);
@@clientLocation(pathsOperationGroup.stringUnicode, "paths");
@@clientName(pathsOperationGroup.stringUnicode, "stringUnicode");
@@clientLocation(pathsOperationGroup.stringUrlEncoded, "paths");
@@clientName(pathsOperationGroup.stringUrlEncoded, "stringUrlEncoded");
@@clientLocation(pathsOperationGroup.stringUrlNonEncoded, "paths");
@@clientName(pathsOperationGroup.stringUrlNonEncoded, "stringUrlNonEncoded");
@@clientLocation(pathsOperationGroup.stringEmpty, "paths");
@@clientName(pathsOperationGroup.stringEmpty, "stringEmpty");
@@clientLocation(pathsOperationGroup.stringNull, "paths");
@@clientName(pathsOperationGroup.stringNull, "stringNull");
@@clientLocation(pathsOperationGroup.enumValid, "paths");
@@clientName(pathsOperationGroup.enumValid, "enumValid");
@@clientLocation(pathsOperationGroup.enumNull, "paths");
@@clientName(pathsOperationGroup.enumNull, "enumNull");
@@clientLocation(pathsOperationGroup.byteMultiByte, "paths");
@@clientName(pathsOperationGroup.byteMultiByte, "byteMultiByte");
@@clientLocation(pathsOperationGroup.byteEmpty, "paths");
@@clientName(pathsOperationGroup.byteEmpty, "byteEmpty");
@@clientLocation(pathsOperationGroup.byteNull, "paths");
@@clientName(pathsOperationGroup.byteNull, "byteNull");
@@clientLocation(pathsOperationGroup.dateValid, "paths");
@@clientLocation(pathsOperationGroup.dateNull, "paths");
@@clientLocation(pathsOperationGroup.dateTimeValid, "paths");
@@clientLocation(pathsOperationGroup.dateTimeNull, "paths");
@@clientLocation(pathsOperationGroup.base64Url, "paths");
@@clientName(pathsOperationGroup.base64Url, "base64Url");
@@clientLocation(pathsOperationGroup.arrayCsvInPath, "paths");
@@clientLocation(pathsOperationGroup.unixTimeUrl, "paths");
@@clientName(pathsOperationGroup.unixTimeUrl, "unixTimeUrl");

@@clientLocation(queriesOperationGroup.getBooleanTrue, "queries");
@@clientName(queriesOperationGroup.getBooleanTrue, "getBooleanTrue");
@@clientLocation(queriesOperationGroup.getBooleanFalse, "queries");
@@clientName(queriesOperationGroup.getBooleanFalse, "getBooleanFalse");
@@clientLocation(queriesOperationGroup.getBooleanNull, "queries");
@@clientName(queriesOperationGroup.getBooleanNull, "getBooleanNull");
@@clientLocation(queriesOperationGroup.getIntOneMillion, "queries");
@@clientName(queriesOperationGroup.getIntOneMillion, "getIntOneMillion");
@@clientLocation(queriesOperationGroup.getIntNegativeOneMillion, "queries");
@@clientName(queriesOperationGroup.getIntNegativeOneMillion,
  "getIntNegativeOneMillion"
);
@@clientLocation(queriesOperationGroup.getIntNull, "queries");
@@clientName(queriesOperationGroup.getIntNull, "getIntNull");
@@clientLocation(queriesOperationGroup.getTenBillion, "queries");
@@clientName(queriesOperationGroup.getTenBillion, "getTenBillion");
@@clientLocation(queriesOperationGroup.getNegativeTenBillion, "queries");
@@clientName(queriesOperationGroup.getNegativeTenBillion,
  "getNegativeTenBillion"
);
@@clientLocation(queriesOperationGroup.getLongNull, "queries");
@@clientName(queriesOperationGroup.getLongNull, "getLongNull");
@@clientLocation(queriesOperationGroup.floatScientificPositive, "queries");
@@clientName(queriesOperationGroup.floatScientificPositive,
  "floatScientificPositive"
);
@@clientLocation(queriesOperationGroup.floatScientificNegative, "queries");
@@clientName(queriesOperationGroup.floatScientificNegative,
  "floatScientificNegative"
);
@@clientLocation(queriesOperationGroup.floatNull, "queries");
@@clientName(queriesOperationGroup.floatNull, "floatNull");
@@clientLocation(queriesOperationGroup.doubleDecimalPositive, "queries");
@@clientName(queriesOperationGroup.doubleDecimalPositive,
  "doubleDecimalPositive"
);
@@clientLocation(queriesOperationGroup.doubleDecimalNegative, "queries");
@@clientName(queriesOperationGroup.doubleDecimalNegative,
  "doubleDecimalNegative"
);
@@clientLocation(queriesOperationGroup.doubleNull, "queries");
@@clientName(queriesOperationGroup.doubleNull, "doubleNull");
@@clientLocation(queriesOperationGroup.stringUnicode, "queries");
@@clientName(queriesOperationGroup.stringUnicode, "stringUnicode");
@@clientLocation(queriesOperationGroup.stringUrlEncoded, "queries");
@@clientName(queriesOperationGroup.stringUrlEncoded, "stringUrlEncoded");
@@clientLocation(queriesOperationGroup.stringEmpty, "queries");
@@clientName(queriesOperationGroup.stringEmpty, "stringEmpty");
@@clientLocation(queriesOperationGroup.stringNull, "queries");
@@clientName(queriesOperationGroup.stringNull, "stringNull");
@@clientLocation(queriesOperationGroup.enumValid, "queries");
@@clientName(queriesOperationGroup.enumValid, "enumValid");
@@clientLocation(queriesOperationGroup.enumNull, "queries");
@@clientName(queriesOperationGroup.enumNull, "enumNull");
@@clientLocation(queriesOperationGroup.byteMultiByte, "queries");
@@clientName(queriesOperationGroup.byteMultiByte, "byteMultiByte");
@@clientLocation(queriesOperationGroup.byteEmpty, "queries");
@@clientName(queriesOperationGroup.byteEmpty, "byteEmpty");
@@clientLocation(queriesOperationGroup.byteNull, "queries");
@@clientName(queriesOperationGroup.byteNull, "byteNull");
@@clientLocation(queriesOperationGroup.dateValid, "queries");
@@clientLocation(queriesOperationGroup.dateNull, "queries");
@@clientLocation(queriesOperationGroup.dateTimeValid, "queries");
@@clientLocation(queriesOperationGroup.dateTimeNull, "queries");
@@clientLocation(queriesOperationGroup.arrayStringCsvValid, "queries");
@@clientLocation(queriesOperationGroup.arrayStringCsvNull, "queries");
@@clientLocation(queriesOperationGroup.arrayStringCsvEmpty, "queries");
@@clientLocation(queriesOperationGroup.arrayStringNoCollectionFormatEmpty,
  "queries"
);
@@clientLocation(queriesOperationGroup.arrayStringSsvValid, "queries");
@@clientLocation(queriesOperationGroup.arrayStringTsvValid, "queries");
@@clientLocation(queriesOperationGroup.arrayStringPipesValid, "queries");

@@clientLocation(pathItemsOperationGroup.getAllWithValues, "pathItems");
@@clientName(pathItemsOperationGroup.getAllWithValues, "getAllWithValues");
@@clientLocation(pathItemsOperationGroup.getGlobalQueryNull, "pathItems");
@@clientName(pathItemsOperationGroup.getGlobalQueryNull, "getGlobalQueryNull");
@@clientLocation(pathItemsOperationGroup.getGlobalAndLocalQueryNull,
  "pathItems"
);
@@clientName(pathItemsOperationGroup.getGlobalAndLocalQueryNull,
  "getGlobalAndLocalQueryNull"
);
@@clientLocation(pathItemsOperationGroup.getLocalPathItemQueryNull,
  "pathItems"
);
@@clientName(pathItemsOperationGroup.getLocalPathItemQueryNull,
  "getLocalPathItemQueryNull"
);
