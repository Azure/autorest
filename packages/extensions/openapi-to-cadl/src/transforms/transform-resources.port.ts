// import {
//   CodeModel,
//   Operation,
//   ObjectSchema,
//   HttpMethod,
//   SchemaResponse,
//   isObjectSchema,
//   SchemaType,
//   Schema,
//   HttpRequest,
//   OperationGroup,
//   Request,
// } from "@autorest/codemodel";
// import { isResponseSchema } from "utils/schemas";

// type OperationsByPath = Record<string, Operation[]>;

// type OperationSet = Operation[] & {
//   path: string;
// };

// type HttpVerb = "GET" | "HEAD" | "POST" | "PUT" | "DELETE" | "CONNECT" | "OPTIONS" | "TRACE" | "PATCH";

// const _resourceDataSchemaCache = new Map<string, ObjectSchema | null>();
// const _operationToParentRequestPathCache = new Map<Operation, RequestPath>();
// const _providerSegment = "/providers/";
// const _managementGroupScopePrefix = "/providers/Microsoft.Management/managementGroups";
// const _resourceGroupScopePrefix = "/subscriptions/{subscriptionId}/resourceGroups";
// const _subscriptionScopePrefix = "/subscriptions";
// const _tenantScopePrefix = "/tenants";
// const _operationsToRequestPath: Map<Operation, RequestPath> = new Map<Operation, RequestPath>();
// const _operationGroupToRequestPaths: Map<OperationGroup, Set<string>> = new Map<OperationGroup, Set<string>>();
// let _rawRequestPathToOperationSets = new Map<string, OperationSet>();
// let _resourceDataSchemaNameToOperationSets = new Map<string, Set<OperationSet>>();
// const _scopePathCache = new Map<RequestPath, RequestPath>();

// export function decorateOperationSets(operationSets: OperationsByPath) {
//   _resourceDataSchemaNameToOperationSets = new Map<string, Set<OperationSet>>();
//   for (const [path, operations] of Object.entries(operationSets)) {
//     const operationSet: OperationSet = Object.assign({}, operations, { path });
//     const resourceDataSchema = getResourceDataSchema(operationSet);
//     if (resourceDataSchema) {
//       const schemaName = resourceDataSchema.language.default.name;

//       // if this operation set corresponds to a SDK resource, we add it to the map
//       const sdkResource = _resourceDataSchemaNameToOperationSets.get(schemaName);
//       if (!sdkResource) {
//         _resourceDataSchemaNameToOperationSets.set(schemaName, new Set<OperationSet>());
//       } else {
//         sdkResource.add(operationSet);
//       }
//     }
//   }

//   return _resourceDataSchemaNameToOperationSets;
// }

// function isResource(operationSet: OperationSet){
//   return Boolean(getResourceDataSchema(operationSet));
// }

// function getRequestPathToResourcesMap(operationSets: OperationsByPath) {
//   const resourceDataSchemaNameToOperationSets = decorateOperationSets(operationSets);

//   for (const [schemaName, operationSets] of resourceDataSchemaNameToOperationSets.entries()) {
//     for (const operationSet of operationSets) {
//       // get the corresponding resource data
//       const originalResourcePath = getNonHintRequestPath(operationSet);
//       // const opertations =
//     }
//   }
// }

// function getNonHintRequestPath(operationSet: OperationSet) {
//   const operation = findBestOperation(operationSet);

//   if (operation) {
//     return getRequestPathFromOperation(operation);
//   }

//   // TODO
//   // we do not have an operation in this operation set to construct the RequestPath
//   // therefore this must be a request path for a virtual resource
//   // we find an operation with a prefix of this and take that many segment from its path as the request path of this operation set

//   throw new Error(`Virtual resources not implemented yet. Path: ${operationSet.path}`);
// }

// function findBestOperation(operationSet: OperationSet) {
//   if (!operationSet.length) {
//     return undefined;
//   }

//   const getOperation = operationSet.find((o) => hasHttpVerb(o, "GET"));

//   if (getOperation) {
//     return getOperation;
//   }

//   const putOperation = operationSet.find((o) => hasHttpVerb(o, "PUT"));

//   if (putOperation) {
//     return putOperation;
//   }

//   // if no PUT or GET, we just return the first one
//   return operationSet[0];
// }

// type RequestPath = string;

// function populateOperationsToRequestPaths({ operationGroups }: CodeModel) {
//   for (const { operations } of operationGroups) {
//     for (const operation of operations) {
//       const requestPath = getRequestPathFromOperation(operation);
//       _operationsToRequestPath.set(operation, requestPath);
//     }
//   }
// }

// function getRequestPathFromOperation(operation: Operation): RequestPath {
//   for (const request of operation.requests ?? []) {
//     const httpRequest = request.protocol.http as HttpRequest;

//     if (!httpRequest) {
//       continue;
//     }

//     // TODO - Segments:
//     // var references = new MgmtRestClientBuilder(operationGroup).GetReferencesToOperationParameters(operation, request.Parameters);
//     // var segments = new List<Segment>();
//     // var segmentIndex = 0;
//     // CreateSegments(httpRequest.Uri, references, segments, ref segmentIndex);
//     // CreateSegments(httpRequest.Path, references, segments, ref segmentIndex);

//     // return new RequestPath(CheckByIdPath(segments), operation.GetHttpPath());

//     return httpRequest.path;
//   }

//   throw new Error(`Operation doesn't contain a Path`);
// }

// export function getPathToOperationMap(codeModel: CodeModel) {
//   const { operationGroups } = codeModel;
//   _rawRequestPathToOperationSets = categorizeOperationGroups(codeModel);
//   populateOperationsToRequestPaths(codeModel);

//   const operationSets: OperationsByPath = {};
//   const requestPaths = new Set<string>();
//   for (const operationGroup of operationGroups) {
//     for (const operation of operationGroup.operations) {
//       const httpPath = getHttpPath(operation);
//       requestPaths.add(httpPath);

//       if (operationSets[httpPath]) {
//         operationSets[httpPath].push(operation);
//       } else {
//         operationSets[httpPath] = [operation];
//       }
//     }
//   }

//   // TODO: Tracked resources

//   decorateOperationSets(operationSets);
//   return operationSets;
// }

// function getScopePath(requestPath: RequestPath): RequestPath {
//   let scopePath = _scopePathCache.get(requestPath);

//   if(scopePath) {
//     return scopePath;
//   }

//   scopePath = calulateScopePath(requestPath);
//   _scopePathCache.set(requestPath, scopePath);
//   return scopePath;
// }

// function calulateScopePath(requestPath: RequestPath): RequestPath {
//   const segments = requestPath.split("/").filter((segment) => segment !== "");
//   const lastIndexOfProviderSegment = segments.lastIndexOf(_providerSegment);

//   // if there is no providers segment, myself should be a scope request path. Just return myself
//   if(lastIndexOfProviderSegment < 0) {
//     if(lastIndexOfProviderSegment === 0 && requestPath.toLowerCase().startsWith(_managementGroupScopePrefix.toLowerCase())) {
//       return `${_managementGroupScopePrefix}/{managementGroupId}`
//     } else {
//       return requestPath.substring(0, lastIndexOfProviderSegment);
//     }
//   }

//   if(requestPath.toLowerCase().startsWith(_resourceGroupScopePrefix.toLowerCase())) {
//     return `${_resourceGroupScopePrefix}/{resourceGroupName}`;
//   }

//   if(requestPath.toLowerCase().startsWith(_subscriptionScopePrefix.toLowerCase())) {
//     return `${_subscriptionScopePrefix}/{subscriptionId}`;
//   }

//   if(requestPath.toLowerCase()  === _tenantScopePrefix.toLowerCase()) {
//     return "";
//   }

//   return requestPath;
// }

// function getResourceDataSchema(operationSet: OperationSet) {
//   const {path} = operationSet;
//   const cachedSchema = _resourceDataSchemaCache.get(path);

//   if (cachedSchema === null) {
//     return undefined;
//   }

//   if (cachedSchema) {
//     return cachedSchema;
//   }

//   // TODO: Tracked and Partial resources

//   // Check if the request path has even number of segments after the providers segment
//   if (getSegmentCountKind(path) === "even") {
//     return undefined;
//   }

//   // before we are finding any operations, we need to ensure this operation set has a GET request.
//   if (!operationSet.some((operation) => hasHttpVerb(operation, "GET"))) {
//     return undefined;
//   }

//   // try put operation to get the resource name
//   const putResponseSchema = getResponseSchema(operationSet, "PUT");

//   if (putResponseSchema && isObjectSchema(putResponseSchema)) {
//     _resourceDataSchemaCache.set(path, putResponseSchema);
//     return putResponseSchema;
//   }

//   // try get operation to get the resource name
//   const responseSchema = getResponseSchema(operationSet, "GET");
//   if (responseSchema && isObjectSchema(responseSchema)) {
//     _resourceDataSchemaCache.set(path, responseSchema);
//     return responseSchema;
//   }

//   // We tried everything, this is not a resource
//   _resourceDataSchemaCache.set(path, null);
//   return undefined;
// }

// function getSegmentCountKind(path: string): SegmentCountKind {
//   const index = path.lastIndexOf(_providerSegment);

//   if (index < 0) {
//     return "even";
//   }

//   const following = path.substring(index);
//   const segments: string[] = following.split("/").filter((segment) => segment !== "");

//   return segments.length % 2 == 0 ? "even" : "odd";
// }

// type SegmentCountKind = "even" | "odd";

// function getHttpPath(operation: Operation): string {
//   const httpRequest = getHttpRequest(operation);

//   if (!httpRequest?.path) {
//     throw new Error(`operation ${operation.language.default.name} doesn't have an http path`);
//   }

//   return httpRequest.path;
// }

// function calculateResourceChildOperations() {
//   const childOperations = new Map<RequestPath, Set<Operation>>();

//   for(const [path, operationSet] of _rawRequestPathToOperationSets) {
//     if (isResource(operationSet)) {
//       continue;
//     }

//     for(const operation of operationSet) {
//       const parentRequestPath = operation.
//     }
//   }
// }

// export function parentRequestPath(operation: Operation): RequestPath {
//   let requestPath = _operationToParentRequestPathCache.get(operation);
//   if (requestPath) {
//     return requestPath;
//   }

//   const result = getParentRequestPath(operation);
//   _operationToParentRequestPathCache.set(operation, result);
//   return result;
// }

// function getParentRequestPath(operation: Operation): RequestPath {
//   // escape the calculation if this is configured in the configuration
//   const httpPath = getHttpPath(operation);
//   const currentRequestPath = getRequestPathFromOperation(operation);
//   const currentOperationSet = _rawRequestPathToOperationSets.get(currentRequestPath);
//   // if this operation comes from a resource, return itself
//   if (currentOperationSet && isResource(currentOperationSet)) {
//     return currentRequestPath;
//   }

//   // if this operation corresponds to a collection operation of a resource, return the path of the resource
//   let operationSetOfResource: OperationSet;
//   if (isResourceCollectionOperation(operation)) {
//     return operationSetOfResource.getRequestPath();
//   }

//   // if neither of the above, we find a request path that is the longest parent of this, and belongs to a resource
//   return parentRequestPath(currentRequestPath);
// }

// function isListOperation(operation: Operation) {
//   for (const response of operation.responses ?? []) {
//     if(!isResponseSchema(response)) {
//       continue;
//     }

//     return response.schema.type === SchemaType.Array;
//   }

//   return false;
// }

// export function isResourceCollectionOperation(operation: Operation): boolean {
//   let operationSetOfResource: OperationSet | null = null;
//   // first we need to ensure this operation at least returns a collection of something

//   if (!isListOperation(operation)) {
//     return false;
//   }

//   // then check if its path is a prefix of which resource's operationSet
//   // if there are multiple resources that share the same prefix of request path, we choose the shortest one
//   const requestPath = getHttpPath(operation);
//   operationSetOfResource = findOperationSetOfResource(requestPath);
//   // if we find none, this cannot be a resource collection operation
//   if (!operationSetOfResource) {
//     return [false, null];
//   }

//   // then check if this method returns a collection of the corresponding resource data
//   // check if valueType is the current resource data type
//   const resourceData = MgmtContext.Library.getResourceData(operationSetOfResource.requestPath);
//   return [valueType === resourceData.type, operationSetOfResource];
// }

// function findOperationSetOfResource(requestPath: RequestPath): OperationSet | null {
//   const candidates: OperationSet[] = [];

//   for(const operationSet of _rawRequestPathToOperationSets.values()) {
//     const resourceRequestPath = operationSet.path;
//     // we compare the request with the resource request in two parts:
//     // 1. Compare if they have the same scope
//     // 2. Compare if they have the "compatible" remaining path
//     // check if they have compatible scopes
//     // if(!isScopeCompatible(resourceRequestPath, requestPath)) {
//     //   continue;
//     // }

//   }
// }

// function getScopeResourceTypes(requestPath: RequestPath) {
//   const scope = getScopePath(requestPath);
//   // TODO: Handle non-parametrized scopes

// }

// function isScopeCompatible(requestPath: RequestPath, resourcePath: RequestPath): boolean {
//   // get scope types
//   const requestScopeTypes = getScopeResourceTypes(requestPath);
//   const resourceScopeTypes = getScopeResourceTypes(resourcePath);
//   if (resourceScopeTypes.has(ResourceTypeSegment.Any)) {
//     return true;
//   }
//   return isSubset(requestScopeTypes, resourceScopeTypes);
// }

// function categorizeOperationGroups(codeModel: CodeModel) {
//   const rawRequestPathToOperationSets = new Map<string, OperationSet>();
//   for (const operationGroup of codeModel.operationGroups) {
//     const requestPathSet = new Set<string>();
//     _operationGroupToRequestPaths.set(operationGroup, requestPathSet);
//     for (const operation of operationGroup.operations) {
//       const path = getHttpPath(operation);
//       requestPathSet.add(path);

//       let operationSet = rawRequestPathToOperationSets.get(path);
//       if (operationSet) {
//         operationSet.push(operation);
//       } else {
//         operationSet = Object.assign({}, [operation], { path });
//         rawRequestPathToOperationSets.set(path, operationSet);
//       }
//     }
//   }

//   return rawRequestPathToOperationSets;
// }

// function getResponseSchema(operationSet: OperationSet, verb: HttpVerb, statusCode = "200") {
//   const operation = operationSet.find((operation) => hasHttpVerb(operation, verb));
//   const response = operation?.responses?.find(
//     (r) => r.protocol.http?.statusCodes && r.protocol.http.statusCodes.includes(statusCode),
//   );

//   if (!response) {
//     return undefined;
//   }

//   if (!isResponseSchema(response)) {
//     return undefined;
//   }

//   // we need to verify this schema has ID, type and name so that this is a resource model
//   if (!isResourceSchema(response.schema)) {
//     return undefined;
//   }

//   return response.schema;
// }

// function isResourceSchema(schema: Schema) {
//   if (!isObjectSchema(schema)) {
//     return undefined;
//   }

//   const allProperties = schema.properties ?? [];
//   let hasIdProperty = false;
//   let hasTypeProperty = false;
//   let hasNameProperty = false;
//   // TODO:
//   // bool typePropertyFound = !Configuration.MgmtConfiguration.DoesResourceModelRequireType;
//   // bool namePropertyFound = !Configuration.MgmtConfiguration.DoesResourceModelRequireName;

//   for (const property of allProperties) {
//     // check if this property is flattened from lower level, we should only consider first level properties in this model
//     // therefore if flattenedNames is not empty, this property is flattened, we skip this property
//     if (property.flattenedNames?.length) {
//       continue;
//     }

//     switch (property.serializedName) {
//       case "id":
//         if (property.schema.type === SchemaType.String || property.schema.type === SchemaType.ArmId) {
//           hasIdProperty = true;
//           continue;
//         }
//         break;
//       case "type":
//         if (property.schema.type === SchemaType.String) {
//           hasTypeProperty = true;
//           continue;
//         }
//         break;
//       case "name":
//         if (property.schema.type === SchemaType.String) {
//           hasNameProperty = true;
//           continue;
//         }
//         break;
//     }
//   }

//   return hasIdProperty && hasNameProperty && hasTypeProperty;
// }

// function hasHttpVerb(operation: Operation, verb: HttpVerb) {
//   for (const request of operation.requests ?? []) {
//     const method: string = ((request.protocol.http?.method as string) ?? "").toUpperCase();
//     if (method === verb) {
//       return true;
//     }
//   }

//   return false;
// }

// function getHttpRequest({ requests = [] }: Operation) {
//   for (const request of requests) {
//     return request.protocol.http ?? undefined;
//   }

//   return undefined;
// }
