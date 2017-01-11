# DefaultInEnum
## Description
This rule applies when the value specified by the `default` property does not appear in the `enum` constraint for a schema.
## How to fix
Add the value from `default` property to the set of values in the `enum` constraint.

_or_

Change the value for the `default` property to one of the values in the `enum` array.
## Effect on generated code
Failing to pass this validation rule affects the generated code because default values allow users to call an operation without specifying a value for that parameter or property. In that case, the generated code will send the default value instead, which should be invalid for the server. Spec files that have this issue generate code that can easily send bad requests.