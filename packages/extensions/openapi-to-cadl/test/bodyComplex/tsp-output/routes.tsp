import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace AutoRestComplexTestService;

interface basicOperations {
  @doc("Get complex type {id: 2, name: 'abc', color: 'YELLOW'}")
  @route("/complex/basic/valid")
  @get
  getValid is Azure.Core.Foundations.Operation<{}, Basic>;

  @doc("Please put {id: 2, name: 'abc', color: 'Magenta'}")
  @route("/complex/basic/valid")
  @put
  putValid is Azure.Core.Foundations.Operation<
    {
      @doc("Please put {id: 2, name: 'abc', color: 'Magenta'}")
      @body
      complexBody: Basic;
    },
    void
  >;

  @doc("Get a basic complex type that is invalid for the local strong type")
  @route("/complex/basic/invalid")
  @get
  getInvalid is Azure.Core.Foundations.Operation<{}, Basic>;

  @doc("Get a basic complex type that is empty")
  @route("/complex/basic/empty")
  @get
  getEmpty is Azure.Core.Foundations.Operation<{}, Basic>;

  @doc("Get a basic complex type whose properties are null")
  @route("/complex/basic/null")
  @get
  getNull is Azure.Core.Foundations.Operation<{}, Basic>;

  @doc("Get a basic complex type while the server doesn't provide a response payload")
  @route("/complex/basic/notprovided")
  @get
  getNotProvided is Azure.Core.Foundations.Operation<{}, Basic>;
}

interface primitiveOperations {
  @doc("Get complex types with integer properties")
  @route("/complex/primitive/integer")
  @get
  getInt is Azure.Core.Foundations.Operation<{}, IntWrapper>;

  @doc("Put complex types with integer properties")
  @route("/complex/primitive/integer")
  @put
  putInt is Azure.Core.Foundations.Operation<
    {
      @doc("Please put -1 and 2")
      @body
      complexBody: IntWrapper;
    },
    void
  >;

  @doc("Get complex types with long properties")
  @route("/complex/primitive/long")
  @get
  getLong is Azure.Core.Foundations.Operation<{}, LongWrapper>;

  @doc("Put complex types with long properties")
  @route("/complex/primitive/long")
  @put
  putLong is Azure.Core.Foundations.Operation<
    {
      @doc("Please put 1099511627775 and -999511627788")
      @body
      complexBody: LongWrapper;
    },
    void
  >;

  @doc("Get complex types with float properties")
  @route("/complex/primitive/float")
  @get
  getFloat is Azure.Core.Foundations.Operation<{}, FloatWrapper>;

  @doc("Put complex types with float properties")
  @route("/complex/primitive/float")
  @put
  putFloat is Azure.Core.Foundations.Operation<
    {
      @doc("Please put 1.05 and -0.003")
      @body
      complexBody: FloatWrapper;
    },
    void
  >;

  @doc("Get complex types with double properties")
  @route("/complex/primitive/double")
  @get
  getDouble is Azure.Core.Foundations.Operation<{}, DoubleWrapper>;

  @doc("Put complex types with double properties")
  @route("/complex/primitive/double")
  @put
  putDouble is Azure.Core.Foundations.Operation<
    {
      @doc("""
Please put 3e-100 and
-0.000000000000000000000000000000000000000000000000000000005
""")
      @body
      complexBody: DoubleWrapper;
    },
    void
  >;

  @doc("Get complex types with bool properties")
  @route("/complex/primitive/bool")
  @get
  getBool is Azure.Core.Foundations.Operation<{}, BooleanWrapper>;

  @doc("Put complex types with bool properties")
  @route("/complex/primitive/bool")
  @put
  putBool is Azure.Core.Foundations.Operation<
    {
      @doc("Please put true and false")
      @body
      complexBody: BooleanWrapper;
    },
    void
  >;

  @doc("Get complex types with string properties")
  @route("/complex/primitive/string")
  @get
  getString is Azure.Core.Foundations.Operation<{}, StringWrapper>;

  @doc("Put complex types with string properties")
  @route("/complex/primitive/string")
  @put
  putString is Azure.Core.Foundations.Operation<
    {
      @doc("Please put 'goodrequest', '', and null")
      @body
      complexBody: StringWrapper;
    },
    void
  >;

  @doc("Get complex types with date properties")
  @route("/complex/primitive/date")
  @get
  getDate is Azure.Core.Foundations.Operation<{}, DateWrapper>;

  @doc("Put complex types with date properties")
  @route("/complex/primitive/date")
  @put
  putDate is Azure.Core.Foundations.Operation<
    {
      @doc("Please put '0001-01-01' and '2016-02-29'")
      @body
      complexBody: DateWrapper;
    },
    void
  >;

  @doc("Get complex types with datetime properties")
  @route("/complex/primitive/datetime")
  @get
  getDateTime is Azure.Core.Foundations.Operation<{}, DatetimeWrapper>;

  @doc("Put complex types with datetime properties")
  @route("/complex/primitive/datetime")
  @put
  putDateTime is Azure.Core.Foundations.Operation<
    {
      @doc("Please put '0001-01-01T12:00:00-04:00' and '2015-05-18T11:38:00-08:00'")
      @body
      complexBody: DatetimeWrapper;
    },
    void
  >;

  @doc("Get complex types with datetimeRfc1123 properties")
  @route("/complex/primitive/datetimerfc1123")
  @get
  getDateTimeRfc1123 is Azure.Core.Foundations.Operation<
    {},
    Datetimerfc1123Wrapper
  >;

  @doc("Put complex types with datetimeRfc1123 properties")
  @route("/complex/primitive/datetimerfc1123")
  @put
  putDateTimeRfc1123 is Azure.Core.Foundations.Operation<
    {
      @doc("Please put 'Mon, 01 Jan 0001 12:00:00 GMT' and 'Mon, 18 May 2015 11:38:00 GMT'")
      @body
      complexBody: Datetimerfc1123Wrapper;
    },
    void
  >;

  @doc("Get complex types with duration properties")
  @route("/complex/primitive/duration")
  @get
  getDuration is Azure.Core.Foundations.Operation<{}, DurationWrapper>;

  @doc("Put complex types with duration properties")
  @route("/complex/primitive/duration")
  @put
  putDuration is Azure.Core.Foundations.Operation<
    {
      @doc("Please put 'P123DT22H14M12.011S'")
      @body
      complexBody: DurationWrapper;
    },
    void
  >;

  @doc("Get complex types with byte properties")
  @route("/complex/primitive/byte")
  @get
  getByte is Azure.Core.Foundations.Operation<{}, ByteWrapper>;

  @doc("Put complex types with byte properties")
  @route("/complex/primitive/byte")
  @put
  putByte is Azure.Core.Foundations.Operation<
    {
      @doc("Please put non-ascii byte string hex(FF FE FD FC 00 FA F9 F8 F7 F6)")
      @body
      complexBody: ByteWrapper;
    },
    void
  >;
}

interface arrayOperations {
  @doc("Get complex types with array property")
  @route("/complex/array/valid")
  @get
  getValid is Azure.Core.Foundations.Operation<{}, ArrayWrapper>;

  @doc("Put complex types with array property")
  @route("/complex/array/valid")
  @put
  putValid is Azure.Core.Foundations.Operation<
    {
      @doc("""
Please put an array with 4 items: \"1, 2, 3, 4\", \"\", null, \"&S#$(*Y\",
\"The quick brown fox jumps over the lazy dog\"
""")
      @body
      complexBody: ArrayWrapper;
    },
    void
  >;

  @doc("Get complex types with array property which is empty")
  @route("/complex/array/empty")
  @get
  getEmpty is Azure.Core.Foundations.Operation<{}, ArrayWrapper>;

  @doc("Put complex types with array property which is empty")
  @route("/complex/array/empty")
  @put
  putEmpty is Azure.Core.Foundations.Operation<
    {
      @doc("Please put an empty array")
      @body
      complexBody: ArrayWrapper;
    },
    void
  >;

  @doc("""
Get complex types with array property while server doesn't provide a response
payload
""")
  @route("/complex/array/notprovided")
  @get
  getNotProvided is Azure.Core.Foundations.Operation<{}, ArrayWrapper>;
}

interface dictionaryOperations {
  @doc("Get complex types with dictionary property")
  @route("/complex/dictionary/typed/valid")
  @get
  getValid is Azure.Core.Foundations.Operation<{}, DictionaryWrapper>;

  @doc("Put complex types with dictionary property")
  @route("/complex/dictionary/typed/valid")
  @put
  putValid is Azure.Core.Foundations.Operation<
    {
      @doc("""
Please put a dictionary with 5 key-value pairs: \"txt\":\"notepad\",
\"bmp\":\"mspaint\", \"xls\":\"excel\", \"exe\":\"\", \"\":null
""")
      @body
      complexBody: DictionaryWrapper;
    },
    void
  >;

  @doc("Get complex types with dictionary property which is empty")
  @route("/complex/dictionary/typed/empty")
  @get
  getEmpty is Azure.Core.Foundations.Operation<{}, DictionaryWrapper>;

  @doc("Put complex types with dictionary property which is empty")
  @route("/complex/dictionary/typed/empty")
  @put
  putEmpty is Azure.Core.Foundations.Operation<
    {
      @doc("Please put an empty dictionary")
      @body
      complexBody: DictionaryWrapper;
    },
    void
  >;

  @doc("Get complex types with dictionary property which is null")
  @route("/complex/dictionary/typed/null")
  @get
  getNull is Azure.Core.Foundations.Operation<{}, DictionaryWrapper>;

  @doc("""
Get complex types with dictionary property while server doesn't provide a
response payload
""")
  @route("/complex/dictionary/typed/notprovided")
  @get
  getNotProvided is Azure.Core.Foundations.Operation<{}, DictionaryWrapper>;
}

interface inheritanceOperations {
  @doc("Get complex types that extend others")
  @route("/complex/inheritance/valid")
  @get
  getValid is Azure.Core.Foundations.Operation<{}, Siamese>;

  @doc("Put complex types that extend others")
  @route("/complex/inheritance/valid")
  @put
  putValid is Azure.Core.Foundations.Operation<
    {
      @doc("""
Please put a siamese with id=2, name=\"Siameee\", color=green, breed=persion,
which hates 2 dogs, the 1st one named \"Potato\" with id=1 and food=\"tomato\",
and the 2nd one named \"Tomato\" with id=-1 and food=\"french fries\".
""")
      @body
      complexBody: Siamese;
    },
    void
  >;
}

interface polymorphismOperations {
  @doc("Get complex types that are polymorphic")
  @route("/complex/polymorphism/valid")
  @get
  getValid is Azure.Core.Foundations.Operation<{}, Fish>;

  @doc("Put complex types that are polymorphic")
  @route("/complex/polymorphism/valid")
  @put
  putValid is Azure.Core.Foundations.Operation<
    {
      @doc("""
Please put a salmon that looks like this:
{
        'fishtype':'Salmon',
      
 'location':'alaska',
        'iswild':true,
        'species':'king',
       
'length':1.0,
        'siblings':[
          {
            'fishtype':'Shark',

           'age':6,
            'birthday': '2012-01-05T01:00:00Z',
           
'length':20.0,
            'species':'predator',
          },
          {
     
      'fishtype':'Sawshark',
            'age':105,
            'birthday':
'1900-01-05T01:00:00Z',
            'length':10.0,
            'picture': new
Buffer([255, 255, 255, 255, 254]).toString('base64'),
           
'species':'dangerous',
          },
          {
            'fishtype':
'goblin',
            'age': 1,
            'birthday':
'2015-08-08T00:00:00Z',
            'length': 30.0,
            'species':
'scary',
            'jawsize': 5
          }
        ]
      };
""")
      @body
      complexBody: Fish;
    },
    void
  >;

  @doc("Get complex types that are polymorphic, JSON key contains a dot")
  @route("/complex/polymorphism/dotsyntax")
  @get
  getDotSyntax is Azure.Core.Foundations.Operation<{}, DotFish>;

  @doc("""
Get complex object composing a polymorphic scalar property and array property
with polymorphic element type, with discriminator specified. Deserialization
must NOT fail and use the discriminator type specified on the wire.
""")
  @route("/complex/polymorphism/composedWithDiscriminator")
  @get
  getComposedWithDiscriminator is Azure.Core.Foundations.Operation<
    {},
    DotFishMarket
  >;

  @doc("""
Get complex object composing a polymorphic scalar property and array property
with polymorphic element type, without discriminator specified on wire.
Deserialization must NOT fail and use the explicit type of the property.
""")
  @route("/complex/polymorphism/composedWithoutDiscriminator")
  @get
  getComposedWithoutDiscriminator is Azure.Core.Foundations.Operation<
    {},
    DotFishMarket
  >;

  @doc("""
Get complex types that are polymorphic, but not at the root of the hierarchy;
also have additional properties
""")
  @route("/complex/polymorphism/complicated")
  @get
  getComplicated is Azure.Core.Foundations.Operation<{}, Salmon>;

  @doc("""
Put complex types that are polymorphic, but not at the root of the hierarchy;
also have additional properties
""")
  @route("/complex/polymorphism/complicated")
  @put
  putComplicated is Azure.Core.Foundations.Operation<
    {
      @body complexBody: Salmon;
    },
    void
  >;

  @doc("Put complex types that are polymorphic, omitting the discriminator")
  @route("/complex/polymorphism/missingdiscriminator")
  @put
  putMissingDiscriminator is Azure.Core.Foundations.Operation<
    {
      @body complexBody: Salmon;
    },
    Salmon
  >;

  @doc("""
Put complex types that are polymorphic, attempting to omit required 'birthday'
field - the request should not be allowed from the client
""")
  @route("/complex/polymorphism/missingrequired/invalid")
  @put
  putValidMissingRequired is Azure.Core.Foundations.Operation<
    {
      @doc("""
Please attempt put a sawshark that looks like this, the client should not allow
this data to be sent:
{
    \"fishtype\": \"sawshark\",
    \"species\":
\"snaggle toothed\",
    \"length\": 18.5,
    \"age\": 2,
    \"birthday\":
\"2013-06-01T01:00:00Z\",
    \"location\": \"alaska\",
    \"picture\":
base64(FF FF FF FF FE),
    \"siblings\": [
        {
            \"fishtype\":
\"shark\",
            \"species\": \"predator\",
            \"birthday\":
\"2012-01-05T01:00:00Z\",
            \"length\": 20,
            \"age\": 6
  
     },
        {
            \"fishtype\": \"sawshark\",
           
\"species\": \"dangerous\",
            \"picture\": base64(FF FF FF FF FE),
  
         \"length\": 10,
            \"age\": 105
        }
    ]
}
""")
      @body
      complexBody: Fish;
    },
    void
  >;
}

interface polymorphicrecursiveOperations {
  @doc("Get complex types that are polymorphic and have recursive references")
  @route("/complex/polymorphicrecursive/valid")
  @get
  getValid is Azure.Core.Foundations.Operation<{}, Fish>;

  @doc("Put complex types that are polymorphic and have recursive references")
  @route("/complex/polymorphicrecursive/valid")
  @put
  putValid is Azure.Core.Foundations.Operation<
    {
      @doc("""
Please put a salmon that looks like this:
{
    \"fishtype\": \"salmon\",
   
\"species\": \"king\",
    \"length\": 1,
    \"age\": 1,
    \"location\":
\"alaska\",
    \"iswild\": true,
    \"siblings\": [
        {
           
\"fishtype\": \"shark\",
            \"species\": \"predator\",
           
\"length\": 20,
            \"age\": 6,
            \"siblings\": [
           
    {
                    \"fishtype\": \"salmon\",
                   
\"species\": \"coho\",
                    \"length\": 2,
                   
\"age\": 2,
                    \"location\": \"atlantic\",
                   
\"iswild\": true,
                    \"siblings\": [
                       
{
                            \"fishtype\": \"shark\",
                        
   \"species\": \"predator\",
                            \"length\": 20,
     
                      \"age\": 6
                        },
                   
    {
                            \"fishtype\": \"sawshark\",
                 
          \"species\": \"dangerous\",
                            \"length\":
10,
                            \"age\": 105
                        }
        
           ]
                },
                {
                   
\"fishtype\": \"sawshark\",
                    \"species\": \"dangerous\",
   
                \"length\": 10,
                    \"age\": 105
              
 }
            ]
        },
        {
            \"fishtype\": \"sawshark\",
 
          \"species\": \"dangerous\",
            \"length\": 10,
           
\"age\": 105
        }
    ]
}
""")
      @body
      complexBody: Fish;
    },
    void
  >;
}

interface readonlypropertyOperations {
  @doc("Get complex types that have readonly properties")
  @route("/complex/readonlyproperty/valid")
  @get
  getValid is Azure.Core.Foundations.Operation<{}, ReadonlyObj>;

  @doc("Put complex types that have readonly properties")
  @route("/complex/readonlyproperty/valid")
  @put
  putValid is Azure.Core.Foundations.Operation<
    {
      @body complexBody: ReadonlyObj;
    },
    void
  >;
}

interface flattencomplexOperations {
  @route("/complex/flatten/valid")
  @get
  getValid is Azure.Core.Foundations.Operation<{}, MyBaseType>;
}
