# BooleanPropertyNotRecommended
## Description
Booleans are not descriptive and make them hard to use. Instead use string enums with allowed set of values defined.

## Why?
This is a warning prompting to evaluate whether the property is really a boolean or not, the intent is to consider if there could be more than 2 values possible for the property in the future or not. If the answer is no, then a boolean is fine, if the answer is yes, there could be other values added in the future, making it an enum can help avoid breaking changes in the SDKs in the future.
  
## How to fix
Create an enum property, follow autorest [x-ms-enum extension guidelines](https://github.com/Azure/autorest/blob/master/docs/extensions/readme.md#x-ms-enum)


## Impact on generated code
Boolean property will turn into a String or an Enum (if SDK language supports it), this will depend on "modelAsString" property values as specified in [x-ms-enum extension guidelines](https://github.com/Azure/autorest/blob/master/docs/extensions/readme.md#x-ms-enum)