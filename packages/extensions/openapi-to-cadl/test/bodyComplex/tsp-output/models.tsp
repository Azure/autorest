import "@typespec/rest";
import "@typespec/http";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace AutoRestComplexTestService;

enum CmykColors {
  cyan,
  Magenta,
  YELLOW,
  blacK,
}

enum MyKind {
  Kind1,
}

enum GoblinSharkColor {
  pink,
  gray,
  brown,
  @doc("Uppercase RED") upperRed: "RED",
  @doc("Lowercase RED") lowerRed: "red",
}

model Basic {
  @doc("Basic Id")
  id?: int32;

  @doc("""
Name property with a very long description that does not fit on a single line
and a line break.
""")
  name?: string;
  color?: CmykColors;
}

@error
model Error {
  status?: int32;
  message?: string;
}

model IntWrapper {
  field1?: int32;
  field2?: int32;
}

model LongWrapper {
  field1?: int32;
  field2?: int32;
}

model FloatWrapper {
  field1?: float32;
  field2?: float32;
}

model DoubleWrapper {
  field1?: float32;

  @projectedName(
    "json",
    "field_56_zeros_after_the_dot_and_negative_zero_before_dot_and_this_is_a_long_field_name_on_purpose"
  )
  field56ZerosAfterTheDotAndNegativeZeroBeforeDotAndThisIsALongFieldNameOnPurpose?: float32;
}

model BooleanWrapper {
  @projectedName("json", "field_true")
  fieldTrue?: boolean;

  @projectedName("json", "field_false")
  fieldFalse?: boolean;
}

model StringWrapper {
  field?: string;
  empty?: string;
  null?: string;
}

model DateWrapper {
  field?: plainDate;
  leap?: plainDate;
}

model DatetimeWrapper {
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  field?: utcDateTime;
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  now?: utcDateTime;
}

model Datetimerfc1123Wrapper {
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  field?: utcDateTime;
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  now?: utcDateTime;
}

model DurationWrapper {
  field?: duration;
}

model ByteWrapper {
  field?: bytes;
}

model ArrayWrapper {
  array?: string[];
}

model DictionaryWrapper {
  @doc("Dictionary of <string>")
  defaultProgram?: Record<string>;
}

model Siamese {
  ...Cat;
  breed?: string;
}

model Cat {
  ...Pet;
  color?: string;
  hates?: Dog[];
}

model Dog {
  ...Pet;
  food?: string;
}

model Pet {
  id?: int32;
  name?: string;
}

@discriminator("fishtype")
model Fish {
  species?: string;
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one

  @key
  length: float32;
  siblings?: Fish[];
}

@discriminator("fish.type")
model DotFish {
  species?: string;
}

model DotFishMarket {
  sampleSalmon?: DotSalmon;
  salmons?: DotSalmon[];
  sampleFish?: DotFish;
  fishes?: DotFish[];
}

model DotSalmon extends DotFish {
  location?: string;
  iswild?: boolean;
  `fish.type`: "DotSalmon";
}

@discriminator("fishtype")
model Salmon extends Fish {
  location?: string;
  iswild?: boolean;
}

model ReadonlyObj {
  @visibility("read")
  id?: string;
  size?: int32;
}

@discriminator("kind")
model MyBaseType {
  propB1?: string;
  helper?: MyBaseHelperType;
}

model MyBaseHelperType {
  propBH1?: string;
}

model SmartSalmon extends Salmon {
  ...Record<unknown>;

  @projectedName("json", "college_degree")
  collegeDegree?: string;
  fishtype: "smart_salmon";
}

@discriminator("fishtype")
model Shark extends Fish {
  age?: int32;
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  birthday: utcDateTime;
}

model Sawshark extends Shark {
  picture?: bytes;
  fishtype: "sawshark";
}

model Goblinshark extends Shark {
  jawsize?: int32;

  @doc("Colors possible")
  color?: GoblinSharkColor;
  fishtype: "goblin";
}

model Cookiecuttershark extends Shark {
  fishtype: "cookiecuttershark";
}

model MyDerivedType extends MyBaseType {
  propD1?: string;
  kind: "Kind1";
}
