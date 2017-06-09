# OpenAPI Specifications Authoring - Automated Guidelines #

This document lists the set of automated rules that can be validated against OpenAPI(swagger) spec by running [validation tools](https://github.com/Azure/adx-documentation-pr/wiki/OpenAPI-Validation-tools). Please visit [here for Manual guidelines](https://github.com/Azure/azure-rest-api-specs/blob/master/documentation/openapi-authoring-manual-guidelines.md).

It is a requirement to conform to all manual and automated rules with severity "Error" before sending a pull request for review.

We request OpenAPI(Swagger) spec authoring be assigned to engineers who have an intimate knowledge of a service endpoint and its developer experience to avoid feeding inefficiencies into teams that focus on Azure developer experiences and the rest of the Azure eco-system.

## Index
* [Error vs. Warning](#error-vs-warning)
* [Automated Rules](#automated-rules)
  * [RPC Violations](#rpc-violations)
    * [RPC Errors](#rpc-errors)
    * [RPC Warnings](#rpc-warnings)
  * [SDK Violations](#sdk-violations)
    * [SDK Errors](#sdk-errors)
    * [SDK Warnings](#sdk-warnings)
* [Rule Descriptions](#rule-descriptions)

## Error vs Warning
- Rules with severity "Error" have to be addressed for the OpenAPI(swagger) spec to be approved by the reviewers. If there is a strong reason for why the rule cannot be addressed in an OpenAPI(swagger) spec it will be a permanent exception, then [suppression process](https://github.com/Azure/adx-documentation-pr/wiki/Swagger-Validation-Errors-Suppression) must be followed.

- Rules with severity "Warning" are either strong recommendations made by Azure developer experience team for better SDK/Documentation experience or they point out something to evaluate, for example, the warning for booleans asks the user to evaluate whether the property should be a boolean or not. 

## Automated Rules

### RPC Violations

#### RPC Errors

| Id | Rule Name | Output Message |Severity | 
| --- | --- | --- | --- |
| [M3012](#M3012)	| [APIVersionPattern](#M3012)	| API Version must be in the format: yyyy-MM-dd, optionally followed by -preview, -alpha, -beta, -rc, -privatepreview.	|  Error |
| M3019	| ARMResourcePropertiesBag	| Top level property names should not be repeated inside the properties bag for ARM resource '{0}'. Properties [{1}] conflict with ARM top level properties. Please rename these. | Error |
| [M3016](#M3016)	| [BodyPropertiesNamesCamelCase](#M3016) | Property named: "{0}", must follow camelCase style. Example: "{1}". | Error |
| [M3016](#M3016)	| [DefinitionsPropertiesNamesCamelCase](#M3016)  | Property named: "{0}", for definition: "{1}" must follow camelCase style. Example: "{2}". | Error |
| M3006	| BodyTopLevelProperties | Top level properties should be one of name, type, id, location, properties, tags, plan, sku, etag, managedBy, identity. Extra properties found: "{0}". | Error |
| M3008	| CollectionObjectPropertiesNamingValidation | Collection object {0} returned by list operation {1} with 'x-ms-pageable' extension, has no property named 'value'. | Error |
| M2044	| HttpVerbValidation | Permissible values for HTTP Verb are delete,get,put,patch,head,options,post. | Error |
| M3023	| OperationsAPIImplementationValidation | Operations API must be implemented for '{0}'. | Error |
| M3007	| PutGetPatchResponseValidation | {0} has different responses for PUT/GET/PATCH operations. The PUT/GET/PATCH operations must have same schema response. | Error |
| M3003	| RequiredPropertiesMustExist | Required property does not appear in the list of properties | Error |
| M3001 | ResourceModelValidation | Model definition '{0}' must have the properties 'name', 'id' and 'type' in its hierarchy and these properties must be marked as readonly. | Error |
| M3027	| TrackedResourceGetOperationValidation | Tracked resource '{0}' must have a get operation | Error |
| M3026	| TrackedResourcePatchOperationValidation | Tracked resource '{0}' must have patch operation that at least supports the update of tags | Error |
| M2059	| UniqueResourcePaths | Multiple resource providers are not allowed in a single spec. More than one the resource paths were found: '{0}'. | Error |
| M3013	| DeleteMustNotHaveRequestBody | 'Delete' operation must not have a request body. | Error |
| M2016	| PatchBodyParametersSchemaValidation | Properties of a PATCH request body must not be {0}. PATCH operation: '{1}' Model Definition: '{2}' Property: '{3}' | Error |
| M2062	| PutResponseResourceValidation | The 200 response model for an ARM PUT operation must have x-ms-azure-resource extension set to true in its hierarchy. Operation: '{0}' Model: '{1}'. | Error |
| M3027	| TrackedResourceListByResourceGroup | The tracked resource, '{0}', must have a list by resource group operation. | Error |
| M3027	| TrackedResourceListBySubscription | The tracked resource, '{0}', must have a list by subscriptions operation. | Error |

#### RPC Warnings

| Id | Rule Name | Output Message |Severity | 
| --- | --- | --- | --- |
| M2061	| ProvidersPathValidation |	Type values \"{0}\" have default value(s), please consider parameterizing them | Warning |
| M3018	| BooleanPropertyNotRecommended	| Booleans are not descriptive and make them hard to use. Instead use string enums with allowed set of values defined. |	Warning |
| M3017	| GuidValidation | Guid used at the #/Definitions/{1}/.../{0}. Usage of Guid is not recommanded. If GUIDs are absolutely required in your service, please get sign off from the Azure API review board. | Warning |
| M2057	| SkuModelValidation | Sku Model is not valid. A Sku model must have 'name' property. It can also have 'tier', 'size', 'family', 'capacity' as optional properties. | Warning |
| M3010	| TrackedResourceListByImmediateParent | The child tracked resource, '{0}' with immediate parent '{1}', must have a list by immediate parent operation. | Warning |

### SDK Violations

#### SDK Errors

| Id | Rule Name | Output Message |Severity | 
| --- | --- | --- | --- |
| M2026 | AvoidAnonymousTypes, AnonymousBodyParameter |	Inline/anonymous models must not be used, instead define a schema with a model name in the "definitions" section and refer to it. This allows operations to share the models. | Error |
| M2014	| OperationParametersValidation	| Parameter "subscriptionId" is not allowed in the operations section, define it in the global parameters section instead | Error |
| M2027	| DefaultMustBeInEnum | The default value is not one of the values enumerated as valid for this element. | Error |
| M1009	| DeleteOperationNameValidation | 'DELETE' operation '{0}' must use method name 'Delete'. | Error |
| M1005	| GetOperationNameValidation | 'GET' operation '{0}' must use method name 'Get' or Method name start with 'List' | Error |
| M1004	| ListByOperationsValidation | Operation must be one of List() - lists all resources under a subscription.  ListByResourceGroup() - list all resources in a resource group within a subscription. ListByParent() - where ""Parent"" is a context specific suffix. It lists all resource under a parent. | Error |
| M1003	| ListOperationNamingWarning | Since operation '{0}' response has model definition '{1}', it should be of the form "*_list*" | Error |
| M1001	| OperationIdNounInVerb	| Per the Noun_Verb convention for Operation Ids, the noun '{0}' should not appear after the underscore. | Error |
| M2055	| OneUnderscoreInOperationId | Only 1 underscore is permitted in the operation id, following Noun_Verb conventions.  | Error |
| M1007	| PatchOperationNameValidation | 'PATCH' operation '{0}' must use method name 'Update'. | Error |
| M1006	| PutOperationNameValidation | 'PUT' operation '{0}' must use method name 'Create'. | Error |
| M2014	| ServiceDefinitionParameters | Parameter "{0}" is referenced but not defined in the global parameters section of Service Definition |Error |
| M2043	| SupportedSchemesWarning | Azure Resource Management only supports HTTPS scheme. | Error | 
| M2003	| ValidFormats | '{0}' is not a known format.	| Error |
| M2005	| LongRunningResponseValidationRule | A '{0}' operation '{1}' with x-ms-long-running-operation extension must have a valid terminal success status code {2}. | Error |
| M2008	| MutabilityWithReadOnlyRule | When property is modeled as "readOnly": true then x-ms-mutability extension can only have "read" value. When property is modeled as "readOnly": false then applying x-ms-mutability extension with only "read" value is not allowed. Extension contains invalid values: '{0}'. | Error |
| M2025	| NextLinkPropertyMustExist	| The property '{0}' specified by nextLinkName does not exist in the 200 response schema. \nPlease, specify the name of the property that provides the nextLink. If the model does not have the nextLink property then specify null. | Error |
| M2028	| NonEmptyClientName | Empty x-ms-client-name property | Error |
| M2060 | PageableRequires200Response | A response for the 200 HTTP status code must be defined to use x-ms-pageable | Error |
| M2019	| ResourceIsMsResourceValidation | A 'Resource' definition must have x-ms-azure-resource extension enabled and set to true. |	Error |
| M2013	| XmsClientNameParameterValidation, XmsClientNamePropertyValidation | Value of 'x-ms-client-name' cannot be the same as '{0}' Property/Model. | Error |
| M2058 |XmsPathsMustOverloadPaths | Paths in x-ms-paths must overload a normal path in the paths section, i.e. a path in the x-ms-paths must either be same as a path in the paths section or a path in the paths sections followed by additional parameters. | Error |
| M2047	| ParameterNameValidation | Parameter Must have the "name" property defined with non-empty string as its value | Error |
| M2062	| RequiredReadOnlyPropertiesValidation | Property '{0}' is a required property. It should not be marked as 'readonly'. | Error |
| M2054	| SecurityDefinitionsStructureValidation | An OpenAPI(swagger) spec must have security definitions and must adhere to the specific structure. | Error |
| M2022	| XmsExamplesProvidedValidation | Please provide x-ms-examples describing minimum/maximum property set for response/request payloads for operations.{0} | Error |

#### SDK Warnings

| Id | Rule Name | Output Message |Severity | 
| --- | --- | --- | --- |
| M4000 | ModelTypeIncomplete |	This definition lacks the property 'description', which is required for model types	| Warning |
| M4000 | ParameterDescriptionRequired, OperationDescriptionRequired  | {0} lacks 'description' property. Consider adding a 'description' element. Accurate description is essential for maintaining reference documentation. | Warning |
 M4000 | DescriptiveDescriptionRequired | The value provided for description is not descriptive enough. Accurate and descriptive description is essential for maintaining reference documentation. | Warning |
| ?	| AvoidMSDNReferences |	For better generated code quality, remove all references to "msdn.microsoft.com". | Warning |
| S2001	| AvoidNestedProperties | Consider using x-ms-client-flatten to provide a better end user experience | Warning |
| S2004	| NonAppJsonTypeWarning | Please make sure that media types other than 'application/json' are supported by your service. | Warning |
| M2063	| BodyParametersValidation | A body parameter must be named 'parameters'. | Warning |
| M2017	| PutRequestResponseValidation | A PUT operation request body schema should be the same as its 200 response schema, to allow reusing the same entity between GET and PUT. If the schema of the PUT request body is a superset of the GET response body, make sure you have a PATCH operation to make the resource updatable. Operation: '{0}' Request Model: '{1}' Response Model: '{2}' | Warning |

## Rule Descriptions

### <a name="M3012" />M3012 APIVersionPattern
**Output Message**: API Version must be in the format: yyyy-MM-dd, optionally followed by -preview, -alpha, -beta, -rc, -privatepreview.

**Description**: The API Version paramemter MUST be in the Year-Month-Date format (i.e. 2016-07-04.)  NOTE that this is the en-US ordering of month and date.  

The date MAY optionally be followed by one of:
* -preview - Indicates the API version is in (public) preview
* -alpha
* -beta
* -rc (release candidate)
* -privatepreview

**Good Examples**: Examples of valid version patterns include:
* 2016-07-04
* 2016-07-04-preview

**Bad Examples**: The following would be invalid:
* 97-07-04 - Date should be YYYY, not YY
* 2016/07/04 - Date should use "-", not "/"
* 1842-07-04 - Year should be accurate; we didn't have Azure in 1842 :(
* 2150-07-04 - Year should be current, not in the future; though we'll hopefully get here eventually :)
* 2016-07-04-publicpreview - Use "-preview" to indicate a public preview
* 2016-07-04-rc0 - Just use "rc", not "rc" + number

Links: [Index](#index) | [Error vs. Warning](#error-vs-warning) | [Automated Rules](#automated-rules) | [RPC](#rpc-violations): [Errors](#rpc-errors) or [Warnings](#rpc-warnings) | [SDK](#sdk-violations): [Errors](#sdk-errors) or [Warnings](#sdk-warnings)

### <a name="M3016" />M3016 PropertiesNamesCamelCase
**Output Message**: Property named: "{0}", must follow camelCase style. Example: "{1}".
**Output Message**: Property named: "{0}", for definition: "{1}" must follow camelCase style. Example: "{2}".

**Description**: Property names must use lowerCamelCase style. 
If the property is a single word (ex: foo, bar, etc.) it will be all lowercase. 
Two-letter acronmys (ex: ID, IO, IP, etc.) should be capitalized. 
Three-letter acronyms (ex: API, URL, etc.) should only have the first letter capitalized (ex: Api, Url, etc.) 
For more capitalization guidance, see: [https://msdn.microsoft.com/en-us/library/141e06ef(v=vs.71).aspx](https://msdn.microsoft.com/en-us/library/141e06ef(v=vs.71).aspx)

**Good Examples**: Examples of lowerCamelCase style:
* camelCase
* foo
* bar
* fooBarBaz
* resourceKey
* resourceApiKey

**Bad Examples**: The following would be invalid:
* PascalCase
* UpperCamelCase
* resourceAPIKey

**Bad Examples**: The following violate these guidelines but would not be caught by automation: 
* alllowercase - If there are multiple words, please capitalize starting with the second word
* miXeDcApItAlIzAtIoN - Please capitalize the first letter of each word (and not seemingly random letters)

Links: [Index](#index) | [Error vs. Warning](#error-vs-warning) | [Automated Rules](#automated-rules) | [RPC](#rpc-violations): [Errors](#rpc-errors) or [Warnings](#rpc-warnings) | [SDK](#sdk-violations): [Errors](#sdk-errors) or [Warnings](#sdk-warnings)

### <a name="R3025" />R3025 TrackedResourceGetOperationValidation
**Output Message**: Tracked resource '{0}' must have a get operation.

**Description**: Verifies if a tracked resource has a corresponding GET operation. 
What's a tracked resource? A Tracked Resource is an ARM Resource with "location" as a required property.

**Why the rule is important**: Per ARM guidelines, each tracked resource must have a GET operation.

**How to fix the violation**: Add a GET operation that returns the tracked resource pointed out by the rule - if the operation does not exist for the service, this fix requires a service side change. 
If the resource pointed by the rule is not a tracked resource, this warning may be a false positive, please clarify this with your PR reviewer.

**Impact on generated code**: Generated SDK code will expose the corresponding GET operation only if it's present in the specification.

**Examples**: N/A

Links: [Index](#index) | [Error vs. Warning](#error-vs-warning) | [Automated Rules](#automated-rules) | [RPC](#rpc-violations): [Errors](#rpc-errors) or [Warnings](#rpc-warnings) | [SDK](#sdk-violations): [Errors](#sdk-errors) or [Warnings](#sdk-warnings)

### <a name="R3026" />R3026 TrackedResourcePatchOperationValidation
**Output Message**: Tracked resource '{0}' must have patch operation that at least supports the update of tags.

**Description**: Verifies if a tracked resource has a corresponding PATCH operation. 
What's a tracked resource? A Tracked Resource is an ARM Resource with "location" as a required property.

**Why the rule is important**: Per ARM guidelines, each tracked resource must have a PATCH operation supporting at least the update of tags.

**How to fix the violation**: Add a PATCH operation that allows at least the update of tags for the tracked resource - if the operation does not exist for the service, this fix requires a service side change. 
If the resource pointed by the rule is not a tracked resource, this warning may be a false positive, please clarify this with your PR reviewer.

**Impact on generated code**: Generated SDK code will expose the corresponding PATCH operation only if it's present in the specification.

**Examples**: N/A

Links: [Index](#index) | [Error vs. Warning](#error-vs-warning) | [Automated Rules](#automated-rules) | [RPC](#rpc-violations): [Errors](#rpc-errors) or [Warnings](#rpc-warnings) | [SDK](#sdk-violations): [Errors](#sdk-errors) or [Warnings](#sdk-warnings)

### <a name="R3027" />R3027 TrackedResourceListByResourceGroup
**Output Message**: The tracked resource, '{0}', must have a list by resource group operation.

**Description**: Verifies if a tracked resource has a corresponding ListByResourceGroup operation. 
What's a tracked resource? A Tracked Resource is an ARM Resource with "location" as a required property.

**Why the rule is important**: Per ARM guidelines, each tracked resource must have a corresponding ListByResourceGroup operation.

**How to fix the violation**: Add a corresponding ListByResourceGroup operation for the tracked resource - if the operation does not exist for the service, this fix requires a service side change. If the operation already exists and it is not named following the naming convention "ListbyResourceGroup", consider updating the operation name. 
If the resource pointed by the rule is not a tracked resource or the operation that allows listing by resource group does not follow the naming convention "ListByResourceGroup", this warning may be a false positive, please clarify this with your PR reviewer.

**Impact on generated code**: Generated SDK code will expose the corresponding ListByResourceGroup operation as included in the specification.

**Examples**: N/A

Links: [Index](#index) | [Error vs. Warning](#error-vs-warning) | [Automated Rules](#automated-rules) | [RPC](#rpc-violations): [Errors](#rpc-errors) or [Warnings](#rpc-warnings) | [SDK](#sdk-violations): [Errors](#sdk-errors) or [Warnings](#sdk-warnings)

### <a name="R3028" />R3028 TrackedResourceListBySubscription
**Output Message**: The tracked resource, '{0}', must have a list by subscriptions operation.

**Description**: Verifies if a tracked resource has a corresponding ListByResourceGroup operation. 
What's a tracked resource? A Tracked Resource is an ARM Resource with "location" as a required property.

**Why the rule is important**: Per ARM guidelines, each tracked resource must have a corresponding ListBySubscription operation.

**How to fix the violation**: Add a corresponding ListBySubscription operation for the tracked resource - if the operation does not exist for the service, this fix requires a service side change. If the operation already exists and it is not named following the naming conventions: List, ListBySubscriptionId, ListBySubscription or ListBySubscriptions, consider updating the operation name. 
If the resource pointed by the rule is not a tracked resource or the operation that allows listing by subscription ID does not follow the naming convention mentioned above, this warning may be a false positive, please clarify this with your PR reviewer.

**Impact on generated code**: Generated SDK code will expose the corresponding ListBySubscription operation as included in the specification.

**Examples**: N/A

Links: [Index](#index) | [Error vs. Warning](#error-vs-warning) | [Automated Rules](#automated-rules) | [RPC](#rpc-violations): [Errors](#rpc-errors) or [Warnings](#rpc-warnings) | [SDK](#sdk-violations): [Errors](#sdk-errors) or [Warnings](#sdk-warnings)

### <a name="R3010" />R3010 TrackedResourceListByImmediateParent
**Output Message**: Validates if the child tracked resources have list by immediate parent operation.

**Description**: Verifies if a tracked resource has a corresponding list by immediate parent operation. 
What's a tracked resource? A Tracked Resource is an ARM Resource with "location" as a required property.

**Why the rule is important**: Per ARM guidelines, each tracked resource must have a corresponding "list by immediate parent" operation.

**How to fix the violation**: Add an operation that allows listing the tracked resource by its immediate parent - if the operation does not exist for the service, this fix requires a service side change. If the operation already exists, please double check the name of the operation, our rule is matching the parent and child resource names to the operation names, if those don't match 100%, this warning may be a false positive, please evaluate whether the named picked is appropriate or needs update. 
If the resource pointed by the rule is not a tracked resource this warning may be a false positive, please clarify this with your PR reviewer.

**Impact on generated code**: Generated SDK code will expose the corresponding "list by immediate parent" operation as included in the specification.

**Examples**: N/A

Links: [Index](#index) | [Error vs. Warning](#error-vs-warning) | [Automated Rules](#automated-rules) | [RPC](#rpc-violations): [Errors](#rpc-errors) or [Warnings](#rpc-warnings) | [SDK](#sdk-violations): [Errors](#sdk-errors) or [Warnings](#sdk-warnings)

### <a name="R3018" />R3018 EnumInsteadOfBoolean
**Output Message**: Booleans are not descriptive and make them hard to use. Instead use string enums with allowed set of values defined.

**Description**: Booleans properties are not descriptive in all cases and can make them to use, evaluate whether is makes sense to keep the property as boolean or turn it into an enum. 

**Why the rule is important**: Evaluate whether the property is really a boolean or not, the intent is to consider if there could be more than 2 values possible for the property in the future or not. If the answer is no, then a boolean is fine, if the answer is yes, there could be other values added in the future, making it an enum can help avoid breaking changes in the SDKs in the future.

**How to fix the violation**: Create an enum property, follow autorest [x-ms-enum extension](https://github.com/Azure/autorest/blob/master/docs/extensions/readme.md#x-ms-enum) guidelines.

**Impact on generated code**: Boolean property will turn into a String or an Enum (if SDK language supports it), this will depend on "modelAsString" property value as specified in [x-ms-enum extension](https://github.com/Azure/autorest/blob/master/docs/extensions/readme.md#x-ms-enum) guidelines.

**Examples**: N/A

Links: [Index](#index) | [Error vs. Warning](#error-vs-warning) | [Automated Rules](#automated-rules) | [RPC](#rpc-violations): [Errors](#rpc-errors) or [Warnings](#rpc-warnings) | [SDK](#sdk-violations): [Errors](#sdk-errors) or [Warnings](#sdk-warnings)