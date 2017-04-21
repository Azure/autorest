# Identifying resource model definitions in a specification
## Description
A model definition is considered as a resource model definition if:

- The model is returned by a PUT operation as a part of 200 or 201 response codes.
- The model has an 'allOf' Resource at any level [name of the root model is 'Resource'] AND the model is returned by a GET operation in 200 response.
- The model has 'x-ms-azure-resource': true or if any model has an 'x-ms-azure-resource' set to true in its model hierarchy and is not named either of 'Resource', 'TrackedResource' or 'ProxyResource'.

## Types of resource models
Any resource can be categorized into 2 types: `TrackedResources` and `ProxyResources`.
1. TrackedResource: A resource is considered a tracked resource if a model hierarchy has a property named 'location' which is marked as __required__.
2. ProxyResource: Proxy resources are all resources without a required 'location' property in their model hierarchy.

## Validation rules for resource models

### M3007 - PutGetPatchResponseInvalid 
For a Given Resource, GET/PUT/PATCH MUST return the same `Resource` Model. The GET/PUT/PATCH operations under a path should reference the same response model schema.
### How to fix it
Ensure GET/PUT/PATCH operations under a path reference the same resource model in their response model schemas.

### M2017 - PutRequestResponseValidation
A PUT operation request body schema should be the same as its 200 response schema, to allow reusing the same entity between GET and PUT. If the schema of the PUT request body is a superset of the GET response body, there must be a PATCH operation to make the resource updatable.
### How to fix it
Ensure the PUT operation request and response schemas are the same. If they are not the same, ensure there is a PATCH operation to make the resource updatable.

### M2019 - ResourceIsMsResourceValidation
Every `Resource` Model MUST be tagged with `x-ms-azure-resource`. For auto-generated sdks of certain languages, this indicates Autorest to make the Resource model inherit from the Resource definition in the client runtime.
### How to fix it
Ensure the `x-ms-azure-resource` extension is set to true in the model hierarchy of the resource, preferably at the root of the model hierarchy (i.e., the models named `Resource`, `TrackedResource` or `ProxyResource`)

### M2020 - ResourceModelValidation
A "Resource" model definition *MUST* have `id`, `name` and `type` properties marked as `"readOnly": true` in its model hierarchy.
### How to fix it
Ensure the properties `id`, `name` and `type` are marked as `"readOnly": true` in the resource model hierarchy, preferably at the root level of the model hierarchy (i.e., `Resource`, `TrackedResource` or `ProxyResource`)

### M2062 - PutResponseResourceValidation
PUT operation response models (200/201) status codes must have the extension `"x-ms-azure-resource" : true` in its model hierarchy.
### How to fix it
Ensure the extension `"x-ms-azure-resource" : true` is set in the PUT response model hierarchy, preferably at the root level (i.e., model named `Resource`, `TrackedResource` or `ProxyResource`)