import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace AutoRestUrlTestService;

interface pathsOperations {
  /**
   * Get true Boolean value on path
   */
  @route("/paths/bool/true/{boolPath}")
  @get
  getBooleanTrue is Azure.Core.Foundations.Operation<
    {
      /**
       * true boolean value
       */
      @path
      boolPath: true;
    },
    void
  >;

  /**
   * Get false Boolean value on path
   */
  @route("/paths/bool/false/{boolPath}")
  @get
  getBooleanFalse is Azure.Core.Foundations.Operation<
    {
      /**
       * false boolean value
       */
      @path
      boolPath: false;
    },
    void
  >;

  /**
   * Get '1000000' integer value
   */
  @route("/paths/int/1000000/{intPath}")
  @get
  getIntOneMillion is Azure.Core.Foundations.Operation<
    {
      /**
       * '1000000' integer value
       */
      @path
      intPath: 1000000;
    },
    void
  >;

  /**
   * Get '-1000000' integer value
   */
  @route("/paths/int/-1000000/{intPath}")
  @get
  getIntNegativeOneMillion is Azure.Core.Foundations.Operation<
    {
      /**
       * '-1000000' integer value
       */
      @path
      intPath: -1000000;
    },
    void
  >;

  /**
   * Get '10000000000' 64 bit integer value
   */
  @route("/paths/long/10000000000/{longPath}")
  @get
  getTenBillion is Azure.Core.Foundations.Operation<
    {
      /**
       * '10000000000' 64 bit integer value
       */
      @path
      longPath: 10000000000;
    },
    void
  >;

  /**
   * Get '-10000000000' 64 bit integer value
   */
  @route("/paths/long/-10000000000/{longPath}")
  @get
  getNegativeTenBillion is Azure.Core.Foundations.Operation<
    {
      /**
       * '-10000000000' 64 bit integer value
       */
      @path
      longPath: -10000000000;
    },
    void
  >;

  /**
   * Get '1.034E+20' numeric value
   */
  @route("/paths/float/1.034E+20/{floatPath}")
  @get
  floatScientificPositive is Azure.Core.Foundations.Operation<
    {
      /**
       * '1.034E+20'numeric value
       */
      @path
      floatPath: 103400000000000000000;
    },
    void
  >;

  /**
   * Get '-1.034E-20' numeric value
   */
  @route("/paths/float/-1.034E-20/{floatPath}")
  @get
  floatScientificNegative is Azure.Core.Foundations.Operation<
    {
      /**
       * '-1.034E-20'numeric value
       */
      @path
      floatPath: -1.034e-20;
    },
    void
  >;

  /**
   * Get '9999999.999' numeric value
   */
  @route("/paths/double/9999999.999/{doublePath}")
  @get
  doubleDecimalPositive is Azure.Core.Foundations.Operation<
    {
      /**
       * '9999999.999'numeric value
       */
      @path
      doublePath: 9999999.999;
    },
    void
  >;

  /**
   * Get '-9999999.999' numeric value
   */
  @route("/paths/double/-9999999.999/{doublePath}")
  @get
  doubleDecimalNegative is Azure.Core.Foundations.Operation<
    {
      /**
       * '-9999999.999'numeric value
       */
      @path
      doublePath: -9999999.999;
    },
    void
  >;

  /**
   * Get '啊齄丂狛狜隣郎隣兀﨩' multi-byte string value
   */
  @route("/paths/string/unicode/{stringPath}")
  @get
  stringUnicode is Azure.Core.Foundations.Operation<
    {
      /**
       * '啊齄丂狛狜隣郎隣兀﨩'multi-byte string value
       */
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

  /**
   * https://tools.ietf.org/html/rfc3986#appendix-A 'path' accept any 'pchar' not
   * encoded
   */
  @summary("Get 'begin!*'();:@&=+$,end")
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

  /**
   * Get ''
   */
  @route("/paths/string/empty/{stringPath}")
  @get
  stringEmpty is Azure.Core.Foundations.Operation<
    {
      /**
       * '' string value
       */
      @path
      stringPath: "";
    },
    void
  >;

  /**
   * Get null (should throw)
   */
  @route("/paths/string/null/{stringPath}")
  @get
  stringNull is Azure.Core.Foundations.Operation<
    {
      /**
       * null string value
       */
      @path
      stringPath: string;
    },
    void
  >;

  /**
   * Get using uri with 'green color' in path parameter
   */
  @route("/paths/enum/green%20color/{enumPath}")
  @get
  enumValid is Azure.Core.Foundations.Operation<
    {
      /**
       * send the value green
       */
      @path
      enumPath: UriColor;
    },
    void
  >;

  /**
   * Get null (should throw on the client before the request is sent on wire)
   */
  @route("/paths/string/null/{enumPath}")
  @get
  enumNull is Azure.Core.Foundations.Operation<
    {
      /**
       * send null should throw
       */
      @path
      enumPath: UriColor;
    },
    void
  >;

  /**
   * Get '啊齄丂狛狜隣郎隣兀﨩' multibyte value as utf-8 encoded byte array
   */
  @route("/paths/byte/multibyte/{bytePath}")
  @get
  byteMultiByte is Azure.Core.Foundations.Operation<
    {
      /**
       * '啊齄丂狛狜隣郎隣兀﨩' multibyte value as utf-8 encoded byte array
       */
      @path
      bytePath: bytes;
    },
    void
  >;

  /**
   * Get '' as byte array
   */
  @route("/paths/byte/empty/{bytePath}")
  @get
  byteEmpty is Azure.Core.Foundations.Operation<
    {
      /**
       * '' as byte array
       */
      @path
      bytePath: "";
    },
    void
  >;

  /**
   * Get null as byte array (should throw)
   */
  @route("/paths/byte/null/{bytePath}")
  @get
  byteNull is Azure.Core.Foundations.Operation<
    {
      /**
       * null as byte array (should throw)
       */
      @path
      bytePath: bytes;
    },
    void
  >;

  /**
   * Get '2012-01-01' as date
   */
  @route("/paths/date/2012-01-01/{datePath}")
  @get
  dateValid is Azure.Core.Foundations.Operation<
    {
      /**
       * '2012-01-01' as date
       */
      @path
      datePath: "2012-01-01";
    },
    void
  >;

  /**
   * Get null as date - this should throw or be unusable on the client side,
   * depending on date representation
   */
  @route("/paths/date/null/{datePath}")
  @get
  dateNull is Azure.Core.Foundations.Operation<
    {
      /**
       * null as date (should throw)
       */
      @path
      datePath: plainDate;
    },
    void
  >;

  /**
   * Get '2012-01-01T01:01:01Z' as date-time
   */
  @route("/paths/datetime/2012-01-01T01%3A01%3A01Z/{dateTimePath}")
  @get
  dateTimeValid is Azure.Core.Foundations.Operation<
    {
      /**
       * '2012-01-01T01:01:01Z' as date-time
       */
      @path
      dateTimePath: "2012-01-01T01:01:01Z";
    },
    void
  >;

  /**
   * Get null as date-time, should be disallowed or throw depending on
   * representation of date-time
   */
  @route("/paths/datetime/null/{dateTimePath}")
  @get
  dateTimeNull is Azure.Core.Foundations.Operation<
    {
      /**
       * null as date-time
       */
      @path
      dateTimePath: utcDateTime;
    },
    void
  >;

  /**
   * Get 'lorem' encoded value as 'bG9yZW0' (base64url)
   */
  @route("/paths/string/bG9yZW0/{base64UrlPath}")
  @get
  base64Url is Azure.Core.Foundations.Operation<
    {
      /**
       * base64url encoded value
       */
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
  arrayCsvInPath is Azure.Core.Foundations.Operation<
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

  /**
   * Get the date 2016-04-13 encoded value as '1460505600' (Unix time)
   */
  @route("/paths/int/1460505600/{unixTimeUrlPath}")
  @get
  unixTimeUrl is Azure.Core.Foundations.Operation<
    {
      /**
       * Unix time encoded value
       */
      @path
      unixTimeUrlPath: plainTime;
    },
    void
  >;
}

interface queriesOperations {
  /**
   * Get true Boolean value on path
   */
  @route("/queries/bool/true")
  @get
  getBooleanTrue is Azure.Core.Foundations.Operation<
    {
      /**
       * true boolean value
       */
      @query("boolQuery")
      boolQuery: true;
    },
    void
  >;

  /**
   * Get false Boolean value on path
   */
  @route("/queries/bool/false")
  @get
  getBooleanFalse is Azure.Core.Foundations.Operation<
    {
      /**
       * false boolean value
       */
      @query("boolQuery")
      boolQuery: false;
    },
    void
  >;

  /**
   * Get null Boolean value on query (query string should be absent)
   */
  @route("/queries/bool/null")
  @get
  getBooleanNull is Azure.Core.Foundations.Operation<
    {
      /**
       * null boolean value
       */
      @query("boolQuery")
      boolQuery?: boolean;
    },
    void
  >;

  /**
   * Get '1000000' integer value
   */
  @route("/queries/int/1000000")
  @get
  getIntOneMillion is Azure.Core.Foundations.Operation<
    {
      /**
       * '1000000' integer value
       */
      @query("intQuery")
      intQuery: 1000000;
    },
    void
  >;

  /**
   * Get '-1000000' integer value
   */
  @route("/queries/int/-1000000")
  @get
  getIntNegativeOneMillion is Azure.Core.Foundations.Operation<
    {
      /**
       * '-1000000' integer value
       */
      @query("intQuery")
      intQuery: -1000000;
    },
    void
  >;

  /**
   * Get null integer value (no query parameter)
   */
  @route("/queries/int/null")
  @get
  getIntNull is Azure.Core.Foundations.Operation<
    {
      /**
       * null integer value
       */
      @query("intQuery")
      intQuery?: int32;
    },
    void
  >;

  /**
   * Get '10000000000' 64 bit integer value
   */
  @route("/queries/long/10000000000")
  @get
  getTenBillion is Azure.Core.Foundations.Operation<
    {
      /**
       * '10000000000' 64 bit integer value
       */
      @query("longQuery")
      longQuery: 10000000000;
    },
    void
  >;

  /**
   * Get '-10000000000' 64 bit integer value
   */
  @route("/queries/long/-10000000000")
  @get
  getNegativeTenBillion is Azure.Core.Foundations.Operation<
    {
      /**
       * '-10000000000' 64 bit integer value
       */
      @query("longQuery")
      longQuery: -10000000000;
    },
    void
  >;

  /**
   * Get 'null 64 bit integer value (no query param in uri)
   */
  @route("/queries/long/null")
  @get
  getLongNull is Azure.Core.Foundations.Operation<
    {
      /**
       * null 64 bit integer value
       */
      @query("longQuery")
      longQuery?: int64;
    },
    void
  >;

  /**
   * Get '1.034E+20' numeric value
   */
  @route("/queries/float/1.034E+20")
  @get
  floatScientificPositive is Azure.Core.Foundations.Operation<
    {
      /**
       * '1.034E+20'numeric value
       */
      @query("floatQuery")
      floatQuery: 103400000000000000000;
    },
    void
  >;

  /**
   * Get '-1.034E-20' numeric value
   */
  @route("/queries/float/-1.034E-20")
  @get
  floatScientificNegative is Azure.Core.Foundations.Operation<
    {
      /**
       * '-1.034E-20'numeric value
       */
      @query("floatQuery")
      floatQuery: -1.034e-20;
    },
    void
  >;

  /**
   * Get null numeric value (no query parameter)
   */
  @route("/queries/float/null")
  @get
  floatNull is Azure.Core.Foundations.Operation<
    {
      /**
       * null numeric value
       */
      @query("floatQuery")
      floatQuery?: float32;
    },
    void
  >;

  /**
   * Get '9999999.999' numeric value
   */
  @route("/queries/double/9999999.999")
  @get
  doubleDecimalPositive is Azure.Core.Foundations.Operation<
    {
      /**
       * '9999999.999'numeric value
       */
      @query("doubleQuery")
      doubleQuery: 9999999.999;
    },
    void
  >;

  /**
   * Get '-9999999.999' numeric value
   */
  @route("/queries/double/-9999999.999")
  @get
  doubleDecimalNegative is Azure.Core.Foundations.Operation<
    {
      /**
       * '-9999999.999'numeric value
       */
      @query("doubleQuery")
      doubleQuery: -9999999.999;
    },
    void
  >;

  /**
   * Get null numeric value (no query parameter)
   */
  @route("/queries/double/null")
  @get
  doubleNull is Azure.Core.Foundations.Operation<
    {
      /**
       * null numeric value
       */
      @query("doubleQuery")
      doubleQuery?: float64;
    },
    void
  >;

  /**
   * Get '啊齄丂狛狜隣郎隣兀﨩' multi-byte string value
   */
  @route("/queries/string/unicode/")
  @get
  stringUnicode is Azure.Core.Foundations.Operation<
    {
      /**
       * '啊齄丂狛狜隣郎隣兀﨩'multi-byte string value
       */
      @query("stringQuery")
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
      @query("stringQuery")
      stringQuery: "begin!*'();:@ &=+$,/?#[]end";
    },
    void
  >;

  /**
   * Get ''
   */
  @route("/queries/string/empty")
  @get
  stringEmpty is Azure.Core.Foundations.Operation<
    {
      /**
       * '' string value
       */
      @query("stringQuery")
      stringQuery: "";
    },
    void
  >;

  /**
   * Get null (no query parameter in url)
   */
  @route("/queries/string/null")
  @get
  stringNull is Azure.Core.Foundations.Operation<
    {
      /**
       * null string value
       */
      @query("stringQuery")
      stringQuery?: string;
    },
    void
  >;

  /**
   * Get using uri with query parameter 'green color'
   */
  @route("/queries/enum/green%20color")
  @get
  enumValid is Azure.Core.Foundations.Operation<
    {
      /**
       * 'green color' enum value
       */
      @query("enumQuery")
      enumQuery?: UriColor;
    },
    void
  >;

  /**
   * Get null (no query parameter in url)
   */
  @route("/queries/enum/null")
  @get
  enumNull is Azure.Core.Foundations.Operation<
    {
      /**
       * null string value
       */
      @query("enumQuery")
      enumQuery?: UriColor;
    },
    void
  >;

  /**
   * Get '啊齄丂狛狜隣郎隣兀﨩' multibyte value as utf-8 encoded byte array
   */
  @route("/queries/byte/multibyte")
  @get
  byteMultiByte is Azure.Core.Foundations.Operation<
    {
      /**
       * '啊齄丂狛狜隣郎隣兀﨩' multibyte value as utf-8 encoded byte array
       */
      @query("byteQuery")
      byteQuery?: bytes;
    },
    void
  >;

  /**
   * Get '' as byte array
   */
  @route("/queries/byte/empty")
  @get
  byteEmpty is Azure.Core.Foundations.Operation<
    {
      /**
       * '' as byte array
       */
      @query("byteQuery")
      byteQuery: "";
    },
    void
  >;

  /**
   * Get null as byte array (no query parameters in uri)
   */
  @route("/queries/byte/null")
  @get
  byteNull is Azure.Core.Foundations.Operation<
    {
      /**
       * null as byte array (no query parameters in uri)
       */
      @query("byteQuery")
      byteQuery?: bytes;
    },
    void
  >;

  /**
   * Get '2012-01-01' as date
   */
  @route("/queries/date/2012-01-01")
  @get
  dateValid is Azure.Core.Foundations.Operation<
    {
      /**
       * '2012-01-01' as date
       */
      @query("dateQuery")
      dateQuery: "2012-01-01";
    },
    void
  >;

  /**
   * Get null as date - this should result in no query parameters in uri
   */
  @route("/queries/date/null")
  @get
  dateNull is Azure.Core.Foundations.Operation<
    {
      /**
       * null as date (no query parameters in uri)
       */
      @query("dateQuery")
      dateQuery?: plainDate;
    },
    void
  >;

  /**
   * Get '2012-01-01T01:01:01Z' as date-time
   */
  @route("/queries/datetime/2012-01-01T01%3A01%3A01Z")
  @get
  dateTimeValid is Azure.Core.Foundations.Operation<
    {
      /**
       * '2012-01-01T01:01:01Z' as date-time
       */
      @query("dateTimeQuery")
      dateTimeQuery: "2012-01-01T01:01:01Z";
    },
    void
  >;

  /**
   * Get null as date-time, should result in no query parameters in uri
   */
  @route("/queries/datetime/null")
  @get
  dateTimeNull is Azure.Core.Foundations.Operation<
    {
      /**
       * null as date-time (no query parameters)
       */
      @query("dateTimeQuery")
      dateTimeQuery?: utcDateTime;
    },
    void
  >;

  @doc("""
Get an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' , null,
''] using the csv-array format
""")
  @route("/queries/array/csv/string/valid")
  @get
  arrayStringCsvValid is Azure.Core.Foundations.Operation<
    {
      @doc("""
an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' , null, '']
using the csv-array format
""")
      @query({
        name: "arrayQuery",
        format: "csv",
      })
      arrayQuery?: string[];
    },
    void
  >;

  /**
   * Get a null array of string using the csv-array format
   */
  @route("/queries/array/csv/string/null")
  @get
  arrayStringCsvNull is Azure.Core.Foundations.Operation<
    {
      /**
       * a null array of string using the csv-array format
       */
      @query({
        name: "arrayQuery",
        format: "csv",
      })
      arrayQuery?: string[];
    },
    void
  >;

  /**
   * Get an empty array [] of string using the csv-array format
   */
  @route("/queries/array/csv/string/empty")
  @get
  arrayStringCsvEmpty is Azure.Core.Foundations.Operation<
    {
      /**
       * an empty array [] of string using the csv-array format
       */
      @query({
        name: "arrayQuery",
        format: "csv",
      })
      arrayQuery?: string[];
    },
    void
  >;

  /**
   * Array query has no defined collection format, should default to csv. Pass in
   * ['hello', 'nihao', 'bonjour'] for the 'arrayQuery' parameter to the service
   */
  @route("/queries/array/none/string/empty")
  @get
  arrayStringNoCollectionFormatEmpty is Azure.Core.Foundations.Operation<
    {
      /**
       * Array-typed query parameter. Pass in ['hello', 'nihao', 'bonjour'].
       */
      @query({
        name: "arrayQuery",
        format: "csv",
      })
      arrayQuery?: string[];
    },
    void
  >;

  @doc("""
Get an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' , null,
''] using the ssv-array format
""")
  @route("/queries/array/ssv/string/valid")
  @get
  arrayStringSsvValid is Azure.Core.Foundations.Operation<
    {
      @doc("""
an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' , null, '']
using the ssv-array format
""")
      @query({
        name: "arrayQuery",
        format: "ssv",
      })
      arrayQuery?: string[];
    },
    void
  >;

  @doc("""
Get an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' , null,
''] using the tsv-array format
""")
  @route("/queries/array/tsv/string/valid")
  @get
  arrayStringTsvValid is Azure.Core.Foundations.Operation<
    {
      @doc("""
an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' , null, '']
using the tsv-array format
""")
      @query({
        name: "arrayQuery",
        format: "tsv",
      })
      arrayQuery?: string[];
    },
    void
  >;

  @doc("""
Get an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' , null,
''] using the pipes-array format
""")
  @route("/queries/array/pipes/string/valid")
  @get
  arrayStringPipesValid is Azure.Core.Foundations.Operation<
    {
      @doc("""
an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' , null, '']
using the pipes-array format
""")
      @query({
        name: "arrayQuery",
        format: "pipes",
      })
      arrayQuery?: string[];
    },
    void
  >;
}

interface pathItemsOperations {
  /**
   * send globalStringPath='globalStringPath',
   * pathItemStringPath='pathItemStringPath', localStringPath='localStringPath',
   * globalStringQuery='globalStringQuery',
   * pathItemStringQuery='pathItemStringQuery', localStringQuery='localStringQuery'
   */
  @route("/pathitem/nullable/globalStringPath/{globalStringPath}/pathItemStringPath/{pathItemStringPath}/localStringPath/{localStringPath}/globalStringQuery/pathItemStringQuery/localStringQuery")
  @get
  getAllWithValues is Azure.Core.Foundations.Operation<
    {
      /**
       * A string value 'pathItemStringPath' that appears in the path
       */
      @path
      pathItemStringPath: string;

      /**
       * A string value 'pathItemStringQuery' that appears as a query parameter
       */
      @query("pathItemStringQuery")
      pathItemStringQuery?: string;

      /**
       * A string value 'globalItemStringPath' that appears in the path
       */
      @path
      globalStringPath: string;

      /**
       * should contain value null
       */
      @query("globalStringQuery")
      globalStringQuery?: string;

      /**
       * should contain value 'localStringPath'
       */
      @path
      localStringPath: string;

      /**
       * should contain value 'localStringQuery'
       */
      @query("localStringQuery")
      localStringQuery?: string;
    },
    void
  >;

  /**
   * send globalStringPath='globalStringPath',
   * pathItemStringPath='pathItemStringPath', localStringPath='localStringPath',
   * globalStringQuery=null, pathItemStringQuery='pathItemStringQuery',
   * localStringQuery='localStringQuery'
   */
  @route("/pathitem/nullable/globalStringPath/{globalStringPath}/pathItemStringPath/{pathItemStringPath}/localStringPath/{localStringPath}/null/pathItemStringQuery/localStringQuery")
  @get
  getGlobalQueryNull is Azure.Core.Foundations.Operation<
    {
      /**
       * A string value 'pathItemStringPath' that appears in the path
       */
      @path
      pathItemStringPath: string;

      /**
       * A string value 'pathItemStringQuery' that appears as a query parameter
       */
      @query("pathItemStringQuery")
      pathItemStringQuery?: string;

      /**
       * A string value 'globalItemStringPath' that appears in the path
       */
      @path
      globalStringPath: string;

      /**
       * should contain value null
       */
      @query("globalStringQuery")
      globalStringQuery?: string;

      /**
       * should contain value 'localStringPath'
       */
      @path
      localStringPath: string;

      /**
       * should contain value 'localStringQuery'
       */
      @query("localStringQuery")
      localStringQuery?: string;
    },
    void
  >;

  /**
   * send globalStringPath=globalStringPath,
   * pathItemStringPath='pathItemStringPath', localStringPath='localStringPath',
   * globalStringQuery=null, pathItemStringQuery='pathItemStringQuery',
   * localStringQuery=null
   */
  @route("/pathitem/nullable/globalStringPath/{globalStringPath}/pathItemStringPath/{pathItemStringPath}/localStringPath/{localStringPath}/null/pathItemStringQuery/null")
  @get
  getGlobalAndLocalQueryNull is Azure.Core.Foundations.Operation<
    {
      /**
       * A string value 'pathItemStringPath' that appears in the path
       */
      @path
      pathItemStringPath: string;

      /**
       * A string value 'pathItemStringQuery' that appears as a query parameter
       */
      @query("pathItemStringQuery")
      pathItemStringQuery?: string;

      /**
       * A string value 'globalItemStringPath' that appears in the path
       */
      @path
      globalStringPath: string;

      /**
       * should contain value null
       */
      @query("globalStringQuery")
      globalStringQuery?: string;

      /**
       * should contain value 'localStringPath'
       */
      @path
      localStringPath: string;

      /**
       * should contain null value
       */
      @query("localStringQuery")
      localStringQuery?: string;
    },
    void
  >;

  /**
   * send globalStringPath='globalStringPath',
   * pathItemStringPath='pathItemStringPath', localStringPath='localStringPath',
   * globalStringQuery='globalStringQuery', pathItemStringQuery=null,
   * localStringQuery=null
   */
  @route("/pathitem/nullable/globalStringPath/{globalStringPath}/pathItemStringPath/{pathItemStringPath}/localStringPath/{localStringPath}/globalStringQuery/null/null")
  @get
  getLocalPathItemQueryNull is Azure.Core.Foundations.Operation<
    {
      /**
       * A string value 'pathItemStringPath' that appears in the path
       */
      @path
      pathItemStringPath: string;

      /**
       * should contain value null
       */
      @query("pathItemStringQuery")
      pathItemStringQuery?: string;

      /**
       * A string value 'globalItemStringPath' that appears in the path
       */
      @path
      globalStringPath: string;

      /**
       * should contain value null
       */
      @query("globalStringQuery")
      globalStringQuery?: string;

      /**
       * should contain value 'localStringPath'
       */
      @path
      localStringPath: string;

      /**
       * should contain value null
       */
      @query("localStringQuery")
      localStringQuery?: string;
    },
    void
  >;
}
