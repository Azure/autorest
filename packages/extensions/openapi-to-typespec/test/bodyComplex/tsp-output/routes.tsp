import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@typespec/openapi";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace AutoRestComplexTestService;

interface basicOperations {
  /**
   * Get complex type {id: 2, name: 'abc', color: 'YELLOW'}
   */
  @operationId("basic_getValid")
  @route("/complex/basic/valid")
  @get
  getValid is Azure.Core.Foundations.Operation<{}, Basic>;

  /**
   * Please put {id: 2, name: 'abc', color: 'Magenta'}
   */
  @operationId("basic_putValid")
  @route("/complex/basic/valid")
  @put
  putValid is Azure.Core.Foundations.Operation<Basic, void>;

  /**
   * Get a basic complex type that is invalid for the local strong type
   */
  @operationId("basic_getInvalid")
  @route("/complex/basic/invalid")
  @get
  getInvalid is Azure.Core.Foundations.Operation<{}, Basic>;

  /**
   * Get a basic complex type that is empty
   */
  @operationId("basic_getEmpty")
  @route("/complex/basic/empty")
  @get
  getEmpty is Azure.Core.Foundations.Operation<{}, Basic>;

  /**
   * Get a basic complex type whose properties are null
   */
  @operationId("basic_getNull")
  @route("/complex/basic/null")
  @get
  getNull is Azure.Core.Foundations.Operation<{}, Basic>;

  /**
   * Get a basic complex type while the server doesn't provide a response payload
   */
  @operationId("basic_getNotProvided")
  @route("/complex/basic/notprovided")
  @get
  getNotProvided is Azure.Core.Foundations.Operation<{}, Basic>;
}

interface primitiveOperations {
  /**
   * Get complex types with integer properties
   */
  @operationId("primitive_getInt")
  @route("/complex/primitive/integer")
  @get
  getInt is Azure.Core.Foundations.Operation<{}, IntWrapper>;

  /**
   * Put complex types with integer properties
   */
  @operationId("primitive_putInt")
  @route("/complex/primitive/integer")
  @put
  putInt is Azure.Core.Foundations.Operation<IntWrapper, void>;

  /**
   * Get complex types with long properties
   */
  @operationId("primitive_getLong")
  @route("/complex/primitive/long")
  @get
  getLong is Azure.Core.Foundations.Operation<{}, LongWrapper>;

  /**
   * Put complex types with long properties
   */
  @operationId("primitive_putLong")
  @route("/complex/primitive/long")
  @put
  putLong is Azure.Core.Foundations.Operation<LongWrapper, void>;

  /**
   * Get complex types with float properties
   */
  @operationId("primitive_getFloat")
  @route("/complex/primitive/float")
  @get
  getFloat is Azure.Core.Foundations.Operation<{}, FloatWrapper>;

  /**
   * Put complex types with float properties
   */
  @operationId("primitive_putFloat")
  @route("/complex/primitive/float")
  @put
  putFloat is Azure.Core.Foundations.Operation<FloatWrapper, void>;

  /**
   * Get complex types with double properties
   */
  @operationId("primitive_getDouble")
  @route("/complex/primitive/double")
  @get
  getDouble is Azure.Core.Foundations.Operation<{}, DoubleWrapper>;

  /**
   * Put complex types with double properties
   */
  @operationId("primitive_putDouble")
  @route("/complex/primitive/double")
  @put
  putDouble is Azure.Core.Foundations.Operation<DoubleWrapper, void>;

  /**
   * Get complex types with bool properties
   */
  @operationId("primitive_getBool")
  @route("/complex/primitive/bool")
  @get
  getBool is Azure.Core.Foundations.Operation<{}, BooleanWrapper>;

  /**
   * Put complex types with bool properties
   */
  @operationId("primitive_putBool")
  @route("/complex/primitive/bool")
  @put
  putBool is Azure.Core.Foundations.Operation<BooleanWrapper, void>;

  /**
   * Get complex types with string properties
   */
  @operationId("primitive_getString")
  @route("/complex/primitive/string")
  @get
  getString is Azure.Core.Foundations.Operation<{}, StringWrapper>;

  /**
   * Put complex types with string properties
   */
  @operationId("primitive_putString")
  @route("/complex/primitive/string")
  @put
  putString is Azure.Core.Foundations.Operation<StringWrapper, void>;

  /**
   * Get complex types with date properties
   */
  @operationId("primitive_getDate")
  @route("/complex/primitive/date")
  @get
  getDate is Azure.Core.Foundations.Operation<{}, DateWrapper>;

  /**
   * Put complex types with date properties
   */
  @operationId("primitive_putDate")
  @route("/complex/primitive/date")
  @put
  putDate is Azure.Core.Foundations.Operation<DateWrapper, void>;

  /**
   * Get complex types with datetime properties
   */
  @operationId("primitive_getDateTime")
  @route("/complex/primitive/datetime")
  @get
  getDateTime is Azure.Core.Foundations.Operation<{}, DatetimeWrapper>;

  /**
   * Put complex types with datetime properties
   */
  @operationId("primitive_putDateTime")
  @route("/complex/primitive/datetime")
  @put
  putDateTime is Azure.Core.Foundations.Operation<DatetimeWrapper, void>;

  /**
   * Get complex types with datetimeRfc1123 properties
   */
  @operationId("primitive_getDateTimeRfc1123")
  @route("/complex/primitive/datetimerfc1123")
  @get
  getDateTimeRfc1123 is Azure.Core.Foundations.Operation<
    {},
    Datetimerfc1123Wrapper
  >;

  /**
   * Put complex types with datetimeRfc1123 properties
   */
  @operationId("primitive_putDateTimeRfc1123")
  @route("/complex/primitive/datetimerfc1123")
  @put
  putDateTimeRfc1123 is Azure.Core.Foundations.Operation<
    Datetimerfc1123Wrapper,
    void
  >;

  /**
   * Get complex types with duration properties
   */
  @operationId("primitive_getDuration")
  @route("/complex/primitive/duration")
  @get
  getDuration is Azure.Core.Foundations.Operation<{}, DurationWrapper>;

  /**
   * Put complex types with duration properties
   */
  @operationId("primitive_putDuration")
  @route("/complex/primitive/duration")
  @put
  putDuration is Azure.Core.Foundations.Operation<DurationWrapper, void>;

  /**
   * Get complex types with byte properties
   */
  @operationId("primitive_getByte")
  @route("/complex/primitive/byte")
  @get
  getByte is Azure.Core.Foundations.Operation<{}, ByteWrapper>;

  /**
   * Put complex types with byte properties
   */
  @operationId("primitive_putByte")
  @route("/complex/primitive/byte")
  @put
  putByte is Azure.Core.Foundations.Operation<ByteWrapper, void>;
}

interface arrayOperations {
  /**
   * Get complex types with array property
   */
  @operationId("array_getValid")
  @route("/complex/array/valid")
  @get
  getValid is Azure.Core.Foundations.Operation<{}, ArrayWrapper>;

  /**
   * Put complex types with array property
   */
  @operationId("array_putValid")
  @route("/complex/array/valid")
  @put
  putValid is Azure.Core.Foundations.Operation<ArrayWrapper, void>;

  /**
   * Get complex types with array property which is empty
   */
  @operationId("array_getEmpty")
  @route("/complex/array/empty")
  @get
  getEmpty is Azure.Core.Foundations.Operation<{}, ArrayWrapper>;

  /**
   * Put complex types with array property which is empty
   */
  @operationId("array_putEmpty")
  @route("/complex/array/empty")
  @put
  putEmpty is Azure.Core.Foundations.Operation<ArrayWrapper, void>;

  /**
   * Get complex types with array property while server doesn't provide a response
   * payload
   */
  @operationId("array_getNotProvided")
  @route("/complex/array/notprovided")
  @get
  getNotProvided is Azure.Core.Foundations.Operation<{}, ArrayWrapper>;
}

interface dictionaryOperations {
  /**
   * Get complex types with dictionary property
   */
  @operationId("dictionary_getValid")
  @route("/complex/dictionary/typed/valid")
  @get
  getValid is Azure.Core.Foundations.Operation<{}, DictionaryWrapper>;

  /**
   * Put complex types with dictionary property
   */
  @operationId("dictionary_putValid")
  @route("/complex/dictionary/typed/valid")
  @put
  putValid is Azure.Core.Foundations.Operation<DictionaryWrapper, void>;

  /**
   * Get complex types with dictionary property which is empty
   */
  @operationId("dictionary_getEmpty")
  @route("/complex/dictionary/typed/empty")
  @get
  getEmpty is Azure.Core.Foundations.Operation<{}, DictionaryWrapper>;

  /**
   * Put complex types with dictionary property which is empty
   */
  @operationId("dictionary_putEmpty")
  @route("/complex/dictionary/typed/empty")
  @put
  putEmpty is Azure.Core.Foundations.Operation<DictionaryWrapper, void>;

  /**
   * Get complex types with dictionary property which is null
   */
  @operationId("dictionary_getNull")
  @route("/complex/dictionary/typed/null")
  @get
  getNull is Azure.Core.Foundations.Operation<{}, DictionaryWrapper>;

  /**
   * Get complex types with dictionary property while server doesn't provide a
   * response payload
   */
  @operationId("dictionary_getNotProvided")
  @route("/complex/dictionary/typed/notprovided")
  @get
  getNotProvided is Azure.Core.Foundations.Operation<{}, DictionaryWrapper>;
}

interface inheritanceOperations {
  /**
   * Get complex types that extend others
   */
  @operationId("inheritance_getValid")
  @route("/complex/inheritance/valid")
  @get
  getValid is Azure.Core.Foundations.Operation<{}, Siamese>;

  /**
   * Put complex types that extend others
   */
  @operationId("inheritance_putValid")
  @route("/complex/inheritance/valid")
  @put
  putValid is Azure.Core.Foundations.Operation<Siamese, void>;
}

interface polymorphismOperations {
  /**
   * Get complex types that are polymorphic
   */
  @operationId("polymorphism_getValid")
  @route("/complex/polymorphism/valid")
  @get
  getValid is Azure.Core.Foundations.Operation<{}, Fish>;

  /**
   * Put complex types that are polymorphic
   */
  @operationId("polymorphism_putValid")
  @route("/complex/polymorphism/valid")
  @put
  putValid is Azure.Core.Foundations.Operation<Fish, void>;

  /**
   * Get complex types that are polymorphic, JSON key contains a dot
   */
  @operationId("polymorphism_getDotSyntax")
  @route("/complex/polymorphism/dotsyntax")
  @get
  getDotSyntax is Azure.Core.Foundations.Operation<{}, DotFish>;

  /**
   * Get complex object composing a polymorphic scalar property and array property
   * with polymorphic element type, with discriminator specified. Deserialization
   * must NOT fail and use the discriminator type specified on the wire.
   */
  @operationId("polymorphism_getComposedWithDiscriminator")
  @route("/complex/polymorphism/composedWithDiscriminator")
  @get
  getComposedWithDiscriminator is Azure.Core.Foundations.Operation<
    {},
    DotFishMarket
  >;

  /**
   * Get complex object composing a polymorphic scalar property and array property
   * with polymorphic element type, without discriminator specified on wire.
   * Deserialization must NOT fail and use the explicit type of the property.
   */
  @operationId("polymorphism_getComposedWithoutDiscriminator")
  @route("/complex/polymorphism/composedWithoutDiscriminator")
  @get
  getComposedWithoutDiscriminator is Azure.Core.Foundations.Operation<
    {},
    DotFishMarket
  >;

  /**
   * Get complex types that are polymorphic, but not at the root of the hierarchy;
   * also have additional properties
   */
  @operationId("polymorphism_getComplicated")
  @route("/complex/polymorphism/complicated")
  @get
  getComplicated is Azure.Core.Foundations.Operation<{}, Salmon>;

  /**
   * Put complex types that are polymorphic, but not at the root of the hierarchy;
   * also have additional properties
   */
  @operationId("polymorphism_putComplicated")
  @route("/complex/polymorphism/complicated")
  @put
  putComplicated is Azure.Core.Foundations.Operation<Salmon, void>;

  /**
   * Put complex types that are polymorphic, omitting the discriminator
   */
  @operationId("polymorphism_putMissingDiscriminator")
  @route("/complex/polymorphism/missingdiscriminator")
  @put
  putMissingDiscriminator is Azure.Core.Foundations.Operation<Salmon, Salmon>;

  /**
   * Put complex types that are polymorphic, attempting to omit required 'birthday'
   * field - the request should not be allowed from the client
   */
  @operationId("polymorphism_putValidMissingRequired")
  @route("/complex/polymorphism/missingrequired/invalid")
  @put
  putValidMissingRequired is Azure.Core.Foundations.Operation<Fish, void>;
}

interface polymorphicrecursiveOperations {
  /**
   * Get complex types that are polymorphic and have recursive references
   */
  @operationId("polymorphicrecursive_getValid")
  @route("/complex/polymorphicrecursive/valid")
  @get
  getValid is Azure.Core.Foundations.Operation<{}, Fish>;

  /**
   * Put complex types that are polymorphic and have recursive references
   */
  @operationId("polymorphicrecursive_putValid")
  @route("/complex/polymorphicrecursive/valid")
  @put
  putValid is Azure.Core.Foundations.Operation<Fish, void>;
}

interface readonlypropertyOperations {
  /**
   * Get complex types that have readonly properties
   */
  @operationId("readonlyproperty_getValid")
  @route("/complex/readonlyproperty/valid")
  @get
  getValid is Azure.Core.Foundations.Operation<{}, ReadonlyObj>;

  /**
   * Put complex types that have readonly properties
   */
  @operationId("readonlyproperty_putValid")
  @route("/complex/readonlyproperty/valid")
  @put
  putValid is Azure.Core.Foundations.Operation<ReadonlyObj, void>;
}

interface flattencomplexOperations {
  @operationId("flattencomplex_getValid")
  @route("/complex/flatten/valid")
  @get
  getValid is Azure.Core.Foundations.Operation<{}, MyBaseType>;
}
