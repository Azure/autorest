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
