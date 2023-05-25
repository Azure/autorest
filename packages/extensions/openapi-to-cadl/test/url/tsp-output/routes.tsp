import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace AutoRestUrlTestService;

interface pathsOperations {
  @doc("Get true Boolean value on path")
  @route("/paths/bool/true/{boolPath}")
  @get
  getBooleanTrue is Azure.Core.Foundations.Operation<
    {
      @doc("true boolean value")
      @path
      boolPath: true;
    },
    void
  >;

  @doc("Get false Boolean value on path")
  @route("/paths/bool/false/{boolPath}")
  @get
  getBooleanFalse is Azure.Core.Foundations.Operation<
    {
      @doc("false boolean value")
      @path
      boolPath: false;
    },
    void
  >;

  @doc("Get '1000000' integer value")
  @route("/paths/int/1000000/{intPath}")
  @get
  getIntOneMillion is Azure.Core.Foundations.Operation<
    {
      @doc("'1000000' integer value")
      @path
      intPath: 1000000;
    },
    void
  >;

  @doc("Get '-1000000' integer value")
  @route("/paths/int/-1000000/{intPath}")
  @get
  getIntNegativeOneMillion is Azure.Core.Foundations.Operation<
    {
      @doc("'-1000000' integer value")
      @path
      intPath: -1000000;
    },
    void
  >;

  @doc("Get '10000000000' 64 bit integer value")
  @route("/paths/long/10000000000/{longPath}")
  @get
  getTenBillion is Azure.Core.Foundations.Operation<
    {
      @doc("'10000000000' 64 bit integer value")
      @path
      longPath: 10000000000;
    },
    void
  >;

  @doc("Get '-10000000000' 64 bit integer value")
  @route("/paths/long/-10000000000/{longPath}")
  @get
  getNegativeTenBillion is Azure.Core.Foundations.Operation<
    {
      @doc("'-10000000000' 64 bit integer value")
      @path
      longPath: -10000000000;
    },
    void
  >;

  @doc("Get '1.034E+20' numeric value")
  @route("/paths/float/1.034E+20/{floatPath}")
  @get
  floatScientificPositive is Azure.Core.Foundations.Operation<
    {
      @doc("'1.034E+20'numeric value")
      @path
      floatPath: 103400000000000000000;
    },
    void
  >;

  @doc("Get '-1.034E-20' numeric value")
  @route("/paths/float/-1.034E-20/{floatPath}")
  @get
  floatScientificNegative is Azure.Core.Foundations.Operation<
    {
      @doc("'-1.034E-20'numeric value")
      @path
      floatPath: -1.034e-20;
    },
    void
  >;

  @doc("Get '9999999.999' numeric value")
  @route("/paths/double/9999999.999/{doublePath}")
  @get
  doubleDecimalPositive is Azure.Core.Foundations.Operation<
    {
      @doc("'9999999.999'numeric value")
      @path
      doublePath: 9999999.999;
    },
    void
  >;

  @doc("Get '-9999999.999' numeric value")
  @route("/paths/double/-9999999.999/{doublePath}")
  @get
  doubleDecimalNegative is Azure.Core.Foundations.Operation<
    {
      @doc("'-9999999.999'numeric value")
      @path
      doublePath: -9999999.999;
    },
    void
  >;

  @doc("Get '啊齄丂狛狜隣郎隣兀﨩' multi-byte string value")
  @route("/paths/string/unicode/{stringPath}")
  @get
  stringUnicode is Azure.Core.Foundations.Operation<
    {
      @doc("'啊齄丂狛狜隣郎隣兀﨩'multi-byte string value")
      @path
      stringPath: "啊齄丂狛狜隣郎隣兀﨩";
    },
    void
  >;

  @doc("Get 'begin!*'();:@ &=+$,/?#[]end")
  @route("/paths/string/begin%21%2A%27%28%29%3B%3A%40%20%26%3D%2B%24%2C%2F%3F%23%5B%5Dend/{stringPath}")
  @get
  stringUrlEncoded is Azure.Core.Foundations.Operation<
    {
      @doc("'begin!*'();:@ &=+$,/?#[]end' url encoded string value")
      @path
      stringPath: "begin!*'();:@ &=+$,/?#[]end";
    },
    void
  >;

  @summary("Get 'begin!*'();:@&=+$,end")
  @doc("""
https://tools.ietf.org/html/rfc3986#appendix-A 'path' accept any 'pchar' not
encoded
""")
  @route("/paths/string/begin!*'();:@&=+$,end/{stringPath}")
  @get
  stringUrlNonEncoded is Azure.Core.Foundations.Operation<
    {
      @doc("'begin!*'();:@&=+$,end' url encoded string value")
      @path
      stringPath: "begin!*'();:@&=+$,end";
    },
    void
  >;

  @doc("Get ''")
  @route("/paths/string/empty/{stringPath}")
  @get
  stringEmpty is Azure.Core.Foundations.Operation<
    {
      @doc("'' string value")
      @path
      stringPath: "";
    },
    void
  >;

  @doc("Get null (should throw)")
  @route("/paths/string/null/{stringPath}")
  @get
  stringNull is Azure.Core.Foundations.Operation<
    {
      @doc("null string value")
      @path
      stringPath: string;
    },
    void
  >;

  @doc("Get using uri with 'green color' in path parameter")
  @route("/paths/enum/green%20color/{enumPath}")
  @get
  enumValid is Azure.Core.Foundations.Operation<
    {
      @doc("send the value green")
      @path
      enumPath: UriColor;
    },
    void
  >;

  @doc("Get null (should throw on the client before the request is sent on wire)")
  @route("/paths/string/null/{enumPath}")
  @get
  enumNull is Azure.Core.Foundations.Operation<
    {
      @doc("send null should throw")
      @path
      enumPath: UriColor;
    },
    void
  >;

  @doc("Get '啊齄丂狛狜隣郎隣兀﨩' multibyte value as utf-8 encoded byte array")
  @route("/paths/byte/multibyte/{bytePath}")
  @get
  byteMultiByte is Azure.Core.Foundations.Operation<
    {
      @doc("'啊齄丂狛狜隣郎隣兀﨩' multibyte value as utf-8 encoded byte array")
      @path
      bytePath: bytes;
    },
    void
  >;

  @doc("Get '' as byte array")
  @route("/paths/byte/empty/{bytePath}")
  @get
  byteEmpty is Azure.Core.Foundations.Operation<
    {
      @doc("'' as byte array")
      @path
      bytePath: "";
    },
    void
  >;

  @doc("Get null as byte array (should throw)")
  @route("/paths/byte/null/{bytePath}")
  @get
  byteNull is Azure.Core.Foundations.Operation<
    {
      @doc("null as byte array (should throw)")
      @path
      bytePath: bytes;
    },
    void
  >;

  @doc("Get '2012-01-01' as date")
  @route("/paths/date/2012-01-01/{datePath}")
  @get
  DateValid is Azure.Core.Foundations.Operation<
    {
      @doc("'2012-01-01' as date")
      @path
      datePath: "2012-01-01";
    },
    void
  >;

  @doc("""
Get null as date - this should throw or be unusable on the client side,
depending on date representation
""")
  @route("/paths/date/null/{datePath}")
  @get
  DateNull is Azure.Core.Foundations.Operation<
    {
      @doc("null as date (should throw)")
      @path
      datePath: plainDate;
    },
    void
  >;

  @doc("Get '2012-01-01T01:01:01Z' as date-time")
  @route("/paths/datetime/2012-01-01T01%3A01%3A01Z/{dateTimePath}")
  @get
  DateTimeValid is Azure.Core.Foundations.Operation<
    {
      @doc("'2012-01-01T01:01:01Z' as date-time")
      @path
      dateTimePath: "2012-01-01T01:01:01Z";
    },
    void
  >;

  @doc("""
Get null as date-time, should be disallowed or throw depending on
representation of date-time
""")
  @route("/paths/datetime/null/{dateTimePath}")
  @get
  DateTimeNull is Azure.Core.Foundations.Operation<
    {
      @doc("null as date-time")
      @path
      dateTimePath: utcDateTime;
    },
    void
  >;

  @doc("Get 'lorem' encoded value as 'bG9yZW0' (base64url)")
  @route("/paths/string/bG9yZW0/{base64UrlPath}")
  @get
  base64Url is Azure.Core.Foundations.Operation<
    {
      @doc("base64url encoded value")
      @path
      base64UrlPath: bytes;
    },
    void
  >;

  @doc("""
Get an array of string ['ArrayPath1', 'begin!*'();:@ &=+$,/?#[]end' , null, '']
using the csv-array format
""")
  @route("/paths/array/ArrayPath1%2cbegin%21%2A%27%28%29%3B%3A%40%20%26%3D%2B%24%2C%2F%3F%23%5B%5Dend%2c%2c/{arrayPath}")
  @get
  ArrayCsvInPath is Azure.Core.Foundations.Operation<
    {
      @doc("""
an array of string ['ArrayPath1', 'begin!*'();:@ &=+$,/?#[]end' , null, '']
using the csv-array format
""")
      @path
      arrayPath: string[];
    },
    void
  >;

  @doc("Get the date 2016-04-13 encoded value as '1460505600' (Unix time)")
  @route("/paths/int/1460505600/{unixTimeUrlPath}")
  @get
  unixTimeUrl is Azure.Core.Foundations.Operation<
    {
      @doc("Unix time encoded value")
      @path
      unixTimeUrlPath: plainTime;
    },
    void
  >;
}

interface queriesOperations {
  @doc("Get true Boolean value on path")
  @route("/queries/bool/true")
  @get
  getBooleanTrue is Azure.Core.Foundations.Operation<
    {
      @doc("true boolean value")
      @query
      boolQuery: true;
    },
    void
  >;

  @doc("Get false Boolean value on path")
  @route("/queries/bool/false")
  @get
  getBooleanFalse is Azure.Core.Foundations.Operation<
    {
      @doc("false boolean value")
      @query
      boolQuery: false;
    },
    void
  >;

  @doc("Get null Boolean value on query (query string should be absent)")
  @route("/queries/bool/null")
  @get
  getBooleanNull is Azure.Core.Foundations.Operation<
    {
      @doc("null boolean value")
      @query
      boolQuery: boolean;
    },
    void
  >;

  @doc("Get '1000000' integer value")
  @route("/queries/int/1000000")
  @get
  getIntOneMillion is Azure.Core.Foundations.Operation<
    {
      @doc("'1000000' integer value")
      @query
      intQuery: 1000000;
    },
    void
  >;

  @doc("Get '-1000000' integer value")
  @route("/queries/int/-1000000")
  @get
  getIntNegativeOneMillion is Azure.Core.Foundations.Operation<
    {
      @doc("'-1000000' integer value")
      @query
      intQuery: -1000000;
    },
    void
  >;

  @doc("Get null integer value (no query parameter)")
  @route("/queries/int/null")
  @get
  getIntNull is Azure.Core.Foundations.Operation<
    {
      @doc("null integer value")
      @query
      intQuery: int32;
    },
    void
  >;

  @doc("Get '10000000000' 64 bit integer value")
  @route("/queries/long/10000000000")
  @get
  getTenBillion is Azure.Core.Foundations.Operation<
    {
      @doc("'10000000000' 64 bit integer value")
      @query
      longQuery: 10000000000;
    },
    void
  >;

  @doc("Get '-10000000000' 64 bit integer value")
  @route("/queries/long/-10000000000")
  @get
  getNegativeTenBillion is Azure.Core.Foundations.Operation<
    {
      @doc("'-10000000000' 64 bit integer value")
      @query
      longQuery: -10000000000;
    },
    void
  >;

  @doc("Get 'null 64 bit integer value (no query param in uri)")
  @route("/queries/long/null")
  @get
  getLongNull is Azure.Core.Foundations.Operation<
    {
      @doc("null 64 bit integer value")
      @query
      longQuery: int32;
    },
    void
  >;

  @doc("Get '1.034E+20' numeric value")
  @route("/queries/float/1.034E+20")
  @get
  floatScientificPositive is Azure.Core.Foundations.Operation<
    {
      @doc("'1.034E+20'numeric value")
      @query
      floatQuery: 103400000000000000000;
    },
    void
  >;

  @doc("Get '-1.034E-20' numeric value")
  @route("/queries/float/-1.034E-20")
  @get
  floatScientificNegative is Azure.Core.Foundations.Operation<
    {
      @doc("'-1.034E-20'numeric value")
      @query
      floatQuery: -1.034e-20;
    },
    void
  >;

  @doc("Get null numeric value (no query parameter)")
  @route("/queries/float/null")
  @get
  floatNull is Azure.Core.Foundations.Operation<
    {
      @doc("null numeric value")
      @query
      floatQuery: float32;
    },
    void
  >;

  @doc("Get '9999999.999' numeric value")
  @route("/queries/double/9999999.999")
  @get
  doubleDecimalPositive is Azure.Core.Foundations.Operation<
    {
      @doc("'9999999.999'numeric value")
      @query
      doubleQuery: 9999999.999;
    },
    void
  >;

  @doc("Get '-9999999.999' numeric value")
  @route("/queries/double/-9999999.999")
  @get
  doubleDecimalNegative is Azure.Core.Foundations.Operation<
    {
      @doc("'-9999999.999'numeric value")
      @query
      doubleQuery: -9999999.999;
    },
    void
  >;

  @doc("Get null numeric value (no query parameter)")
  @route("/queries/double/null")
  @get
  doubleNull is Azure.Core.Foundations.Operation<
    {
      @doc("null numeric value")
      @query
      doubleQuery: float32;
    },
    void
  >;

  @doc("Get '啊齄丂狛狜隣郎隣兀﨩' multi-byte string value")
  @route("/queries/string/unicode/")
  @get
  stringUnicode is Azure.Core.Foundations.Operation<
    {
      @doc("'啊齄丂狛狜隣郎隣兀﨩'multi-byte string value")
      @query
      stringQuery: "啊齄丂狛狜隣郎隣兀﨩";
    },
    void
  >;

  @doc("Get 'begin!*'();:@ &=+$,/?#[]end")
  @route("/queries/string/begin%21%2A%27%28%29%3B%3A%40%20%26%3D%2B%24%2C%2F%3F%23%5B%5Dend")
  @get
  stringUrlEncoded is Azure.Core.Foundations.Operation<
    {
      @doc("'begin!*'();:@ &=+$,/?#[]end' url encoded string value")
      @query
      stringQuery: "begin!*'();:@ &=+$,/?#[]end";
    },
    void
  >;

  @doc("Get ''")
  @route("/queries/string/empty")
  @get
  stringEmpty is Azure.Core.Foundations.Operation<
    {
      @doc("'' string value")
      @query
      stringQuery: "";
    },
    void
  >;

  @doc("Get null (no query parameter in url)")
  @route("/queries/string/null")
  @get
  stringNull is Azure.Core.Foundations.Operation<
    {
      @doc("null string value")
      @query
      stringQuery: string;
    },
    void
  >;

  @doc("Get using uri with query parameter 'green color'")
  @route("/queries/enum/green%20color")
  @get
  enumValid is Azure.Core.Foundations.Operation<
    {
      @doc("'green color' enum value")
      @query
      enumQuery: UriColor;
    },
    void
  >;

  @doc("Get null (no query parameter in url)")
  @route("/queries/enum/null")
  @get
  enumNull is Azure.Core.Foundations.Operation<
    {
      @doc("null string value")
      @query
      enumQuery: UriColor;
    },
    void
  >;

  @doc("Get '啊齄丂狛狜隣郎隣兀﨩' multibyte value as utf-8 encoded byte array")
  @route("/queries/byte/multibyte")
  @get
  byteMultiByte is Azure.Core.Foundations.Operation<
    {
      @doc("'啊齄丂狛狜隣郎隣兀﨩' multibyte value as utf-8 encoded byte array")
      @query
      byteQuery: bytes;
    },
    void
  >;

  @doc("Get '' as byte array")
  @route("/queries/byte/empty")
  @get
  byteEmpty is Azure.Core.Foundations.Operation<
    {
      @doc("'' as byte array")
      @query
      byteQuery: "";
    },
    void
  >;

  @doc("Get null as byte array (no query parameters in uri)")
  @route("/queries/byte/null")
  @get
  byteNull is Azure.Core.Foundations.Operation<
    {
      @doc("null as byte array (no query parameters in uri)")
      @query
      byteQuery: bytes;
    },
    void
  >;

  @doc("Get '2012-01-01' as date")
  @route("/queries/date/2012-01-01")
  @get
  DateValid is Azure.Core.Foundations.Operation<
    {
      @doc("'2012-01-01' as date")
      @query
      dateQuery: "2012-01-01";
    },
    void
  >;

  @doc("Get null as date - this should result in no query parameters in uri")
  @route("/queries/date/null")
  @get
  DateNull is Azure.Core.Foundations.Operation<
    {
      @doc("null as date (no query parameters in uri)")
      @query
      dateQuery: plainDate;
    },
    void
  >;

  @doc("Get '2012-01-01T01:01:01Z' as date-time")
  @route("/queries/datetime/2012-01-01T01%3A01%3A01Z")
  @get
  DateTimeValid is Azure.Core.Foundations.Operation<
    {
      @doc("'2012-01-01T01:01:01Z' as date-time")
      @query
      dateTimeQuery: "2012-01-01T01:01:01Z";
    },
    void
  >;

  @doc("Get null as date-time, should result in no query parameters in uri")
  @route("/queries/datetime/null")
  @get
  DateTimeNull is Azure.Core.Foundations.Operation<
    {
      @doc("null as date-time (no query parameters)")
      @query
      dateTimeQuery: utcDateTime;
    },
    void
  >;

  @doc("""
Get an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' , null,
''] using the csv-array format
""")
  @route("/queries/array/csv/string/valid")
  @get
  ArrayStringCsvValid is Azure.Core.Foundations.Operation<
    {
      @doc("""
an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' , null, '']
using the csv-array format
""")
      @query
      arrayQuery: string[];
    },
    void
  >;

  @doc("Get a null array of string using the csv-array format")
  @route("/queries/array/csv/string/null")
  @get
  ArrayStringCsvNull is Azure.Core.Foundations.Operation<
    {
      @doc("a null array of string using the csv-array format")
      @query
      arrayQuery: string[];
    },
    void
  >;

  @doc("Get an empty array [] of string using the csv-array format")
  @route("/queries/array/csv/string/empty")
  @get
  ArrayStringCsvEmpty is Azure.Core.Foundations.Operation<
    {
      @doc("an empty array [] of string using the csv-array format")
      @query
      arrayQuery: string[];
    },
    void
  >;

  @doc("""
Array query has no defined collection format, should default to csv. Pass in
['hello', 'nihao', 'bonjour'] for the 'arrayQuery' parameter to the service
""")
  @route("/queries/array/none/string/empty")
  @get
  ArrayStringNoCollectionFormatEmpty is Azure.Core.Foundations.Operation<
    {
      @doc("Array-typed query parameter. Pass in ['hello', 'nihao', 'bonjour'].")
      @query
      arrayQuery: string[];
    },
    void
  >;

  @doc("""
Get an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' , null,
''] using the ssv-array format
""")
  @route("/queries/array/ssv/string/valid")
  @get
  ArrayStringSsvValid is Azure.Core.Foundations.Operation<
    {
      @doc("""
an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' , null, '']
using the ssv-array format
""")
      @query
      arrayQuery: string[];
    },
    void
  >;

  @doc("""
Get an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' , null,
''] using the tsv-array format
""")
  @route("/queries/array/tsv/string/valid")
  @get
  ArrayStringTsvValid is Azure.Core.Foundations.Operation<
    {
      @doc("""
an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' , null, '']
using the tsv-array format
""")
      @query
      arrayQuery: string[];
    },
    void
  >;

  @doc("""
Get an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' , null,
''] using the pipes-array format
""")
  @route("/queries/array/pipes/string/valid")
  @get
  ArrayStringPipesValid is Azure.Core.Foundations.Operation<
    {
      @doc("""
an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' , null, '']
using the pipes-array format
""")
      @query
      arrayQuery: string[];
    },
    void
  >;
}

interface pathItemsOperations {
  @doc("""
send globalStringPath='globalStringPath',
pathItemStringPath='pathItemStringPath', localStringPath='localStringPath',
globalStringQuery='globalStringQuery',
pathItemStringQuery='pathItemStringQuery', localStringQuery='localStringQuery'
""")
  @route("/pathitem/nullable/globalStringPath/{globalStringPath}/pathItemStringPath/{pathItemStringPath}/localStringPath/{localStringPath}/globalStringQuery/pathItemStringQuery/localStringQuery")
  @get
  getAllWithValues is Azure.Core.Foundations.Operation<
    {
      @doc("A string value 'pathItemStringPath' that appears in the path")
      @path
      pathItemStringPath: string;

      @doc("A string value 'pathItemStringQuery' that appears as a query parameter")
      @query
      pathItemStringQuery: string;

      @doc("A string value 'globalItemStringPath' that appears in the path")
      @path
      globalStringPath: string;

      @doc("should contain value null")
      @query
      globalStringQuery: string;

      @doc("should contain value 'localStringPath'")
      @path
      localStringPath: string;

      @doc("should contain value 'localStringQuery'")
      @query
      localStringQuery: string;
    },
    void
  >;

  @doc("""
send globalStringPath='globalStringPath',
pathItemStringPath='pathItemStringPath', localStringPath='localStringPath',
globalStringQuery=null, pathItemStringQuery='pathItemStringQuery',
localStringQuery='localStringQuery'
""")
  @route("/pathitem/nullable/globalStringPath/{globalStringPath}/pathItemStringPath/{pathItemStringPath}/localStringPath/{localStringPath}/null/pathItemStringQuery/localStringQuery")
  @get
  getGlobalQueryNull is Azure.Core.Foundations.Operation<
    {
      @doc("A string value 'pathItemStringPath' that appears in the path")
      @path
      pathItemStringPath: string;

      @doc("A string value 'pathItemStringQuery' that appears as a query parameter")
      @query
      pathItemStringQuery: string;

      @doc("A string value 'globalItemStringPath' that appears in the path")
      @path
      globalStringPath: string;

      @doc("should contain value null")
      @query
      globalStringQuery: string;

      @doc("should contain value 'localStringPath'")
      @path
      localStringPath: string;

      @doc("should contain value 'localStringQuery'")
      @query
      localStringQuery: string;
    },
    void
  >;

  @doc("""
send globalStringPath=globalStringPath,
pathItemStringPath='pathItemStringPath', localStringPath='localStringPath',
globalStringQuery=null, pathItemStringQuery='pathItemStringQuery',
localStringQuery=null
""")
  @route("/pathitem/nullable/globalStringPath/{globalStringPath}/pathItemStringPath/{pathItemStringPath}/localStringPath/{localStringPath}/null/pathItemStringQuery/null")
  @get
  getGlobalAndLocalQueryNull is Azure.Core.Foundations.Operation<
    {
      @doc("A string value 'pathItemStringPath' that appears in the path")
      @path
      pathItemStringPath: string;

      @doc("A string value 'pathItemStringQuery' that appears as a query parameter")
      @query
      pathItemStringQuery: string;

      @doc("A string value 'globalItemStringPath' that appears in the path")
      @path
      globalStringPath: string;

      @doc("should contain value null")
      @query
      globalStringQuery: string;

      @doc("should contain value 'localStringPath'")
      @path
      localStringPath: string;

      @doc("should contain null value")
      @query
      localStringQuery: string;
    },
    void
  >;

  @doc("""
send globalStringPath='globalStringPath',
pathItemStringPath='pathItemStringPath', localStringPath='localStringPath',
globalStringQuery='globalStringQuery', pathItemStringQuery=null,
localStringQuery=null
""")
  @route("/pathitem/nullable/globalStringPath/{globalStringPath}/pathItemStringPath/{pathItemStringPath}/localStringPath/{localStringPath}/globalStringQuery/null/null")
  @get
  getLocalPathItemQueryNull is Azure.Core.Foundations.Operation<
    {
      @doc("A string value 'pathItemStringPath' that appears in the path")
      @path
      pathItemStringPath: string;

      @doc("should contain value null")
      @query
      pathItemStringQuery: string;

      @doc("A string value 'globalItemStringPath' that appears in the path")
      @path
      globalStringPath: string;

      @doc("should contain value null")
      @query
      globalStringQuery: string;

      @doc("should contain value 'localStringPath'")
      @path
      localStringPath: string;

      @doc("should contain value null")
      @query
      localStringQuery: string;
    },
    void
  >;
}
