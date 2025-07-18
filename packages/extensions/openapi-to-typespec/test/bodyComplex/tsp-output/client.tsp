import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using AutoRestComplexTestService;

@@clientName(DoubleWrapper.field_56_zeros_after_the_dot_and_negative_zero_before_dot_and_this_is_a_long_field_name_on_purpose,
  "field56ZerosAfterTheDotAndNegativeZeroBeforeDotAndThisIsALongFieldNameOnPurpose"
);

@@clientName(BooleanWrapper.field_true, "fieldTrue");
@@clientName(BooleanWrapper.field_false, "fieldFalse");

@@clientName(DotFish.`fish.type`, "fishType");

@@clientName(SmartSalmon.college_degree, "collegeDegree");

@@clientLocation(basicOperationGroup.getValid, "basic");
@@clientName(basicOperationGroup.getValid, "getValid");
@@clientLocation(basicOperationGroup.putValid, "basic");
@@clientName(basicOperationGroup.putValid, "putValid");
@@clientLocation(basicOperationGroup.getInvalid, "basic");
@@clientName(basicOperationGroup.getInvalid, "getInvalid");
@@clientLocation(basicOperationGroup.getEmpty, "basic");
@@clientName(basicOperationGroup.getEmpty, "getEmpty");
@@clientLocation(basicOperationGroup.getNull, "basic");
@@clientName(basicOperationGroup.getNull, "getNull");
@@clientLocation(basicOperationGroup.getNotProvided, "basic");
@@clientName(basicOperationGroup.getNotProvided, "getNotProvided");

@@clientLocation(primitiveOperationGroup.getInt, "primitive");
@@clientName(primitiveOperationGroup.getInt, "getInt");
@@clientLocation(primitiveOperationGroup.putInt, "primitive");
@@clientName(primitiveOperationGroup.putInt, "putInt");
@@clientLocation(primitiveOperationGroup.getLong, "primitive");
@@clientName(primitiveOperationGroup.getLong, "getLong");
@@clientLocation(primitiveOperationGroup.putLong, "primitive");
@@clientName(primitiveOperationGroup.putLong, "putLong");
@@clientLocation(primitiveOperationGroup.getFloat, "primitive");
@@clientName(primitiveOperationGroup.getFloat, "getFloat");
@@clientLocation(primitiveOperationGroup.putFloat, "primitive");
@@clientName(primitiveOperationGroup.putFloat, "putFloat");
@@clientLocation(primitiveOperationGroup.getDouble, "primitive");
@@clientName(primitiveOperationGroup.getDouble, "getDouble");
@@clientLocation(primitiveOperationGroup.putDouble, "primitive");
@@clientName(primitiveOperationGroup.putDouble, "putDouble");
@@clientLocation(primitiveOperationGroup.getBool, "primitive");
@@clientName(primitiveOperationGroup.getBool, "getBool");
@@clientLocation(primitiveOperationGroup.putBool, "primitive");
@@clientName(primitiveOperationGroup.putBool, "putBool");
@@clientLocation(primitiveOperationGroup.getString, "primitive");
@@clientName(primitiveOperationGroup.getString, "getString");
@@clientLocation(primitiveOperationGroup.putString, "primitive");
@@clientName(primitiveOperationGroup.putString, "putString");
@@clientLocation(primitiveOperationGroup.getDate, "primitive");
@@clientName(primitiveOperationGroup.getDate, "getDate");
@@clientLocation(primitiveOperationGroup.putDate, "primitive");
@@clientName(primitiveOperationGroup.putDate, "putDate");
@@clientLocation(primitiveOperationGroup.getDateTime, "primitive");
@@clientName(primitiveOperationGroup.getDateTime, "getDateTime");
@@clientLocation(primitiveOperationGroup.putDateTime, "primitive");
@@clientName(primitiveOperationGroup.putDateTime, "putDateTime");
@@clientLocation(primitiveOperationGroup.getDateTimeRfc1123, "primitive");
@@clientName(primitiveOperationGroup.getDateTimeRfc1123, "getDateTimeRfc1123");
@@clientLocation(primitiveOperationGroup.putDateTimeRfc1123, "primitive");
@@clientName(primitiveOperationGroup.putDateTimeRfc1123, "putDateTimeRfc1123");
@@clientLocation(primitiveOperationGroup.getDuration, "primitive");
@@clientName(primitiveOperationGroup.getDuration, "getDuration");
@@clientLocation(primitiveOperationGroup.putDuration, "primitive");
@@clientName(primitiveOperationGroup.putDuration, "putDuration");
@@clientLocation(primitiveOperationGroup.getByte, "primitive");
@@clientName(primitiveOperationGroup.getByte, "getByte");
@@clientLocation(primitiveOperationGroup.putByte, "primitive");
@@clientName(primitiveOperationGroup.putByte, "putByte");

@@clientLocation(arrayOperationGroup.getValid, "array");
@@clientName(arrayOperationGroup.getValid, "getValid");
@@clientLocation(arrayOperationGroup.putValid, "array");
@@clientName(arrayOperationGroup.putValid, "putValid");
@@clientLocation(arrayOperationGroup.getEmpty, "array");
@@clientName(arrayOperationGroup.getEmpty, "getEmpty");
@@clientLocation(arrayOperationGroup.putEmpty, "array");
@@clientName(arrayOperationGroup.putEmpty, "putEmpty");
@@clientLocation(arrayOperationGroup.getNotProvided, "array");
@@clientName(arrayOperationGroup.getNotProvided, "getNotProvided");

@@clientLocation(dictionaryOperationGroup.getValid, "dictionary");
@@clientName(dictionaryOperationGroup.getValid, "getValid");
@@clientLocation(dictionaryOperationGroup.putValid, "dictionary");
@@clientName(dictionaryOperationGroup.putValid, "putValid");
@@clientLocation(dictionaryOperationGroup.getEmpty, "dictionary");
@@clientName(dictionaryOperationGroup.getEmpty, "getEmpty");
@@clientLocation(dictionaryOperationGroup.putEmpty, "dictionary");
@@clientName(dictionaryOperationGroup.putEmpty, "putEmpty");
@@clientLocation(dictionaryOperationGroup.getNull, "dictionary");
@@clientName(dictionaryOperationGroup.getNull, "getNull");
@@clientLocation(dictionaryOperationGroup.getNotProvided, "dictionary");
@@clientName(dictionaryOperationGroup.getNotProvided, "getNotProvided");

@@clientLocation(inheritanceOperationGroup.getValid, "inheritance");
@@clientName(inheritanceOperationGroup.getValid, "getValid");
@@clientLocation(inheritanceOperationGroup.putValid, "inheritance");
@@clientName(inheritanceOperationGroup.putValid, "putValid");

@@clientLocation(polymorphismOperationGroup.getValid, "polymorphism");
@@clientName(polymorphismOperationGroup.getValid, "getValid");
@@clientLocation(polymorphismOperationGroup.putValid, "polymorphism");
@@clientName(polymorphismOperationGroup.putValid, "putValid");
@@clientLocation(polymorphismOperationGroup.getDotSyntax, "polymorphism");
@@clientName(polymorphismOperationGroup.getDotSyntax, "getDotSyntax");
@@clientLocation(polymorphismOperationGroup.getComposedWithDiscriminator,
  "polymorphism"
);
@@clientName(polymorphismOperationGroup.getComposedWithDiscriminator,
  "getComposedWithDiscriminator"
);
@@clientLocation(polymorphismOperationGroup.getComposedWithoutDiscriminator,
  "polymorphism"
);
@@clientName(polymorphismOperationGroup.getComposedWithoutDiscriminator,
  "getComposedWithoutDiscriminator"
);
@@clientLocation(polymorphismOperationGroup.getComplicated, "polymorphism");
@@clientName(polymorphismOperationGroup.getComplicated, "getComplicated");
@@clientLocation(polymorphismOperationGroup.putComplicated, "polymorphism");
@@clientName(polymorphismOperationGroup.putComplicated, "putComplicated");
@@clientLocation(polymorphismOperationGroup.putMissingDiscriminator,
  "polymorphism"
);
@@clientName(polymorphismOperationGroup.putMissingDiscriminator,
  "putMissingDiscriminator"
);
@@clientLocation(polymorphismOperationGroup.putValidMissingRequired,
  "polymorphism"
);
@@clientName(polymorphismOperationGroup.putValidMissingRequired,
  "putValidMissingRequired"
);

@@clientLocation(polymorphicrecursiveOperationGroup.getValid,
  "polymorphicrecursive"
);
@@clientName(polymorphicrecursiveOperationGroup.getValid, "getValid");
@@clientLocation(polymorphicrecursiveOperationGroup.putValid,
  "polymorphicrecursive"
);
@@clientName(polymorphicrecursiveOperationGroup.putValid, "putValid");

@@clientLocation(readonlypropertyOperationGroup.getValid, "readonlyproperty");
@@clientName(readonlypropertyOperationGroup.getValid, "getValid");
@@clientLocation(readonlypropertyOperationGroup.putValid, "readonlyproperty");
@@clientName(readonlypropertyOperationGroup.putValid, "putValid");

@@clientLocation(flattencomplexOperationGroup.getValid, "flattencomplex");
@@clientName(flattencomplexOperationGroup.getValid, "getValid");
