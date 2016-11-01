# RequiredPropertiesMustExist
## Description
Any properties that are specified as required must actually exist. This rule makes sure that all property names in the `required` array are actually properties on a schema.
## How to fix
Add a property for each key that is in the `required` array.

_or_

Remove any keys from the `required` array that are not also described in the `properties` section.
