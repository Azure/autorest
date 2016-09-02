// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using System.Collections.Generic;
using System.Globalization;
using Newtonsoft.Json;
using AutoRest.Core.Validation;
using AutoRest.Core.Logging;
using AutoRest.Core.Utilities.Collections;
using AutoRest.Swagger.Validation;
using System.Text.RegularExpressions;

namespace AutoRest.Swagger.Model
{
    /// <summary>
    /// Class that represents Swagger 2.0 schema
    /// http://json.schemastore.org/swagger-2.0
    /// Swagger Object - https://github.com/wordnik/swagger-spec/blob/master/versions/2.0.md#swagger-object- 
    /// </summary>
    [Serializable]
    public class ServiceDefinition : SpecObject
    {
        public ServiceDefinition()
        {
            Definitions = new Dictionary<string, Schema>();
            Schemes = new List<TransferProtocolScheme>();
            Consumes = new List<string>();
            Produces = new List<string>();
            Paths = new Dictionary<string, Dictionary<string, Operation>>();
            CustomPaths = new Dictionary<string, Dictionary<string, Operation>>();
            Parameters = new Dictionary<string, SwaggerParameter>();
            Responses = new Dictionary<string, OperationResponse>();
            SecurityDefinitions = new Dictionary<string, SecurityDefinition>();
            Security = new List<Dictionary<string, List<string>>>();
            Tags = new List<Tag>();
            ExternalReferences = new List<string>();
        }

        /// <summary>
        /// Specifies the Swagger Specification version being used. 
        /// </summary>
        public string Swagger { get; set; }

        /// <summary>
        /// Provides metadata about the API. The metadata can be used by the clients if needed.
        /// </summary>
        public Info Info { get; set; }

        /// <summary>
        /// The host (serviceTypeName or ip) serving the API.
        /// </summary>
        public string Host { get; set; }

        /// <summary>
        /// The base path on which the API is served, which is relative to the host.
        /// </summary>
        public string BasePath { get; set; }

        /// <summary>
        /// The transfer protocol of the API.
        /// </summary>
        public IList<TransferProtocolScheme> Schemes { get; set; }

        /// <summary>
        /// A list of MIME types the service can consume.
        /// </summary>
        public IList<string> Consumes { get; set; }

        /// <summary>
        /// A list of MIME types the APIs can produce.
        /// </summary>
        public IList<string> Produces { get; set; }

        /// <summary>
        /// Key is actual path and the value is serializationProperty of http operations and operation objects.
        /// </summary>
        public Dictionary<string, Dictionary<string, Operation>> Paths { get; set; }

        /// <summary>
        /// Key is actual path and the value is serializationProperty of http operations and operation objects.
        /// </summary>
        [JsonProperty("x-ms-paths")]
        [CollectionRule(typeof(XmsPathsMustOverloadPaths))]
        public Dictionary<string, Dictionary<string, Operation>> CustomPaths { get; set; }

        /// <summary>
        /// Key is the object serviceTypeName and the value is swagger definition.
        /// </summary>
        public Dictionary<string, Schema> Definitions { get; set; }

        /// <summary>
        /// Dictionary of parameters that can be used across operations.
        /// This property does not define global parameters for all operations.
        /// </summary>
        [CollectionRule(typeof(AnonymousParameterTypes))]
        public Dictionary<string, SwaggerParameter> Parameters { get; set; }

        /// <summary>
        /// Dictionary of responses that can be used across operations. The key indicates status code.
        /// </summary>
        public Dictionary<string, OperationResponse> Responses { get; set; }

        /// <summary>
        /// Key is the object serviceTypeName and the value is swagger security definition.
        /// </summary>
        public Dictionary<string, SecurityDefinition> SecurityDefinitions { get; set; }

        /// <summary>
        /// A declaration of which security schemes are applied for the API as a whole. 
        /// The list of values describes alternative security schemes that can be used 
        /// (that is, there is a logical OR between the security requirements). Individual 
        /// operations can override this definition.
        /// </summary>
        public IList<Dictionary<string, List<string>>> Security { get; set; }

        /// <summary>
        /// A list of tags used by the specification with additional metadata. The order 
        /// of the tags can be used to reflect on their order by the parsing tools. Not all 
        /// tags that are used by the Operation Object must be declared. The tags that are 
        /// not declared may be organized randomly or based on the tools' logic. Each 
        /// tag name in the list MUST be unique.
        /// </summary>
        public IList<Tag> Tags { get; set; }

        /// <summary>
        /// Additional external documentation
        /// </summary>
        public ExternalDoc ExternalDocs { get; set; }

        /// <summary>
        /// A list of all external references listed in the service.
        /// </summary>
        public IList<string> ExternalReferences { get; set; }

        /// <summary>
        /// Compare a modified document node (this) to a previous one and look for breaking as well as non-breaking changes.
        /// </summary>
        /// <param name="context">The modified document context.</param>
        /// <param name="previous">The original document model.</param>
        /// <returns>A list of messages from the comparison.</returns>
        public override IEnumerable<ComparisonMessage> Compare(ComparisonContext context, SwaggerBase previous)
        {
            if (previous == null)
                throw new ArgumentNullException("previous");

            context.CurrentRoot = this;
            context.PreviousRoot = previous;

            context.Push("#");

            base.Compare(context, previous);

            var previousDefinition = previous as ServiceDefinition;

            if (previousDefinition == null)
                throw new ArgumentException("Comparing a service definition with something else.");

            if (Info != null && previousDefinition.Info != null)
            {
                context.Push("info/version");

               CompareVersions(context, Info.Version, previousDefinition.Info.Version);

                context.Pop();
            }

            if (context.Strict)
            {
                // There was no version change between the documents. This is not an error, but noteworthy.
                context.LogInfo(ComparisonMessages.NoVersionChange);
            }

            // Check that all the protocols of the old version are supported by the new version.

            context.Push("schemes");
            foreach (var scheme in previousDefinition.Schemes)
            {
                if (!Schemes.Contains(scheme))
                {
                    context.LogBreakingChange(ComparisonMessages.ProtocolNoLongerSupported, scheme);
                }
            }
            context.Pop();

            // Check that all the request body formats that were accepted still are.

            context.Push("consumes");
            foreach (var format in previousDefinition.Consumes)
            {
                if (!Consumes.Contains(format))
                {
                    context.LogBreakingChange(ComparisonMessages.RequestBodyFormatNoLongerSupported, format);
                }
            }
            context.Pop();

            // Check that all the response body formats were also supported by the old version.

            context.Push("produces");
            foreach (var format in Produces)
            {
                if (!previousDefinition.Produces.Contains(format))
                {
                    context.LogBreakingChange(ComparisonMessages.ResponseBodyFormatNowSupported, format);
                }
            }
            context.Pop();

            // Check that no paths were removed, and compare the paths that are still there.

            var newPaths = RemovePathVariables(Paths);

            context.Push("paths");
            foreach (var path in previousDefinition.Paths.Keys)
            {
                var p = Regex.Replace(path, @"\{\w*\}", @"{}");

                context.Push(path);

                Dictionary<string, Operation> operations = null;
                if (!newPaths.TryGetValue(p, out operations))
                {
                    context.LogBreakingChange(ComparisonMessages.RemovedPath, path);
                }
                else
                {
                    Dictionary<string, Operation> previousOperations = previousDefinition.Paths[path];
                    foreach (var previousOperation in previousOperations)
                    {
                        Operation newOperation = null;
                        if (!operations.TryGetValue(previousOperation.Key, out newOperation))
                        {
                            context.LogBreakingChange(ComparisonMessages.RemovedOperation, previousOperation.Value.OperationId);
                        }
                    }

                    foreach (var operation in operations)
                    {
                        Operation previousOperation = null;
                        if (previousDefinition.Paths[path].TryGetValue(operation.Key, out previousOperation))
                        {
                            context.Push(operation.Key);
                            operation.Value.Compare(context, previousOperation);
                            context.Pop();
                        }
                    }
                }
                context.Pop();
            }
            context.Pop();

            newPaths = RemovePathVariables(CustomPaths);

            context.Push("x-ms-paths");
            foreach (var path in previousDefinition.CustomPaths.Keys)
            {
                var p = Regex.Replace(path, @"\{\w*\}", @"{}");

                context.Push(path);

                Dictionary<string, Operation> operations = null;
                if (!newPaths.TryGetValue(p, out operations))
                {
                    context.LogBreakingChange(ComparisonMessages.RemovedPath, path);
                }
                else
                {
                    Dictionary<string, Operation> previousOperations = previousDefinition.CustomPaths[path];
                    foreach (var previousOperation in previousOperations)
                    {
                        Operation newOperation = null;
                        if (!operations.TryGetValue(previousOperation.Key, out newOperation))
                        {
                            context.LogBreakingChange(ComparisonMessages.RemovedOperation, previousOperation.Value.OperationId);
                        }
                    }

                    foreach (var operation in operations)
                    {
                        Operation previousOperation = null;
                        if (previousDefinition.CustomPaths[path].TryGetValue(operation.Key, out previousOperation))
                        {
                            context.Push(operation.Key);
                            operation.Value.Compare(context, previousOperation);
                            context.Pop();
                        }
                    }
                }
                context.Pop();
            }
            context.Pop();

            ReferenceTrackSchemas(this);
            ReferenceTrackSchemas(previousDefinition);

            context.Push("parameters");
            foreach (var def in previousDefinition.Parameters.Keys)
            {
                SwaggerParameter parameter = null;
                if (!Parameters.TryGetValue(def, out parameter))
                {
                    context.LogBreakingChange(ComparisonMessages.RemovedClientParameter, def);
                }
                else
                {
                    context.Push(def);
                    parameter.Compare(context, previousDefinition.Parameters[def]);
                    context.Pop();
                }
            }
            context.Pop();

            context.Push("responses");
            foreach (var def in previousDefinition.Responses.Keys)
            {
                OperationResponse response = null;
                if (!Responses.TryGetValue(def, out response))
                {
                    context.LogBreakingChange(ComparisonMessages.RemovedDefinition, def);
                }
                else
                {
                    context.Push(def);
                    response.Compare(context, previousDefinition.Responses[def]);
                    context.Pop();
                }
            }
            context.Pop();

            context.Push("definitions");
            foreach (var def in previousDefinition.Definitions.Keys)
            {
                Schema schema = null;
                Schema oldSchema = previousDefinition.Definitions[def];

                if (!Definitions.TryGetValue(def, out schema))
                {
                    if (oldSchema.IsReferenced)
                        // It's only an error if the definition is referenced in the old service.
                        context.LogBreakingChange(ComparisonMessages.RemovedDefinition, def);
                }
                else if (schema.IsReferenced && oldSchema.IsReferenced)
                {
                    context.Push(def);
                    schema.Compare(context, previousDefinition.Definitions[def]);
                    context.Pop();
                }
            }
            context.Pop();

            context.Pop();

            return context.Messages;
        }


        /// <summary>
        /// Since renaming a path parameter doesn't logically alter the path, we must remove the parameter names
        /// before comparing paths using string comparison.
        /// </summary>
        /// <param name="paths">A dictionary of paths, potentially with embedded parameter names.</param>
        /// <returns>A transformed dictionary, where paths do not embed parameter names.</returns>
        private Dictionary<string, Dictionary<string, Operation>> RemovePathVariables(Dictionary<string, Dictionary<string, Operation>> paths)
        {
            var result = new Dictionary<string, Dictionary<string, Operation>>();

            foreach (var kv in paths)
            {
                var p = Regex.Replace(kv.Key, @"\{\w*\}", @"{}");
                result[p] = kv.Value;
            }

            return result;
        }

        /// <summary>
        /// Since some services may rely on semantic versioning, comparing versions is fairly complex.
        /// </summary>
        /// <param name="context">A comparison context.</param>
        /// <param name="newVer">The new version string.</param>
        /// <param name="oldVer">The old version string</param>
        /// <remarks>
        /// In semantic versioning schemes, only the major and minor version numbers are considered when comparing versions.
        /// Build numbers are ignored.
        /// </remarks>
        private void CompareVersions(ComparisonContext context, string newVer, string oldVer)
        {
            var oldVersion = oldVer.Split('.');
            var newVersion = newVer.Split('.');

            // If the version consists only of numbers separated by '.', we'll consider it semantic versioning.

            if (!context.Strict && oldVersion.Length > 0 && newVersion.Length > 0)
            {
                bool versionChanged = false;

                // Situation 1: The versioning scheme is semantic, i.e. it uses a major.minr.build-number scheme, where each component is an integer.
                //              In this case, we care about the major/minor numbers, but not the build number. In othe words, ifall that is different
                //              is the build number, it will not be treated as a version change.

                int oldMajor = 0, newMajor = 0;
                bool integers = int.TryParse(oldVersion[0], out oldMajor) && int.TryParse(newVersion[0], out newMajor);

                if (integers && oldMajor != newMajor)
                {
                    versionChanged = true;

                    if (oldMajor > newMajor)
                    {
                        context.LogError(ComparisonMessages.VersionsReversed, oldVer, newVer);
                    }
                }

                if (!versionChanged && integers && oldVersion.Length > 1 && newVersion.Length > 1)
                {
                    int oldMinor = 0, newMinor = 0;
                    integers = int.TryParse(oldVersion[1], out oldMinor) && int.TryParse(newVersion[1], out newMinor);

                    if (integers && oldMinor != newMinor)
                    {
                        versionChanged = true;

                        if (oldMinor > newMinor)
                        {
                            context.LogError(ComparisonMessages.VersionsReversed, oldVer, newVer);
                        }
                    }
                }

                // Situation 2: The versioning scheme is something else, maybe a date or just a label?
                //              Regardless of what it is, we just check whether the two strings are equal or not.

                if (!versionChanged && !integers)
                {
                    versionChanged = !oldVer.ToLower(CultureInfo.CurrentCulture).Equals(newVer.ToLower(CultureInfo.CurrentCulture));
                }

                context.Strict = !versionChanged;
            }
        }

        /// <summary>
        /// In order to avoid comparing definitions (schemas) that are not used, we go through all references that are 
        /// found in operations, global parameters, and global responses. Definitions that are referenced from other
        /// definitions are included only by transitive closure.
        /// </summary>
        private static void ReferenceTrackSchemas(ServiceDefinition service)
        {
            foreach (var schema in service.Definitions.Values)
            {
                schema.IsReferenced = false;
            }

            foreach (var path in service.Paths.Values)
            {
                foreach (var operation in path.Values)
                {
                    foreach (var parameter in operation.Parameters)
                    {
                        if (parameter.Schema != null && !string.IsNullOrWhiteSpace(parameter.Schema.Reference))
                        {
                            var schema = FindReferencedSchema(parameter.Schema.Reference, service.Definitions);
                            schema.IsReferenced = true;
                        }
                    }
                }
            }
            foreach (var path in service.CustomPaths.Values)
            {
                foreach (var operation in path.Values)
                {
                    foreach (var parameter in operation.Parameters)
                    {
                        if (parameter.Schema != null && !string.IsNullOrWhiteSpace(parameter.Schema.Reference))
                        {
                            var schema = FindReferencedSchema(parameter.Schema.Reference, service.Definitions);
                            schema.IsReferenced = true;
                        }
                    }
                }
            }
            foreach (var parameter in service.Parameters.Values)
            {
                if (parameter.Schema != null && !string.IsNullOrWhiteSpace(parameter.Schema.Reference))
                {
                    var schema = FindReferencedSchema(parameter.Schema.Reference, service.Definitions);
                    schema.IsReferenced = true;
                }
            }
            foreach (var response in service.Responses.Values)
            {
                if (response.Schema != null && !string.IsNullOrWhiteSpace(response.Schema.Reference))
                {
                    var schema = FindReferencedSchema(response.Schema.Reference, service.Definitions);
                    schema.IsReferenced = true;
                }
            }

            var changed = true;
            while (changed)
            {
                changed = false;

                foreach (var schema in service.Definitions.Values.Where(d => d.IsReferenced))
                {
                    foreach (var property in schema.Properties.Values)
                    {
                        if (!string.IsNullOrWhiteSpace(property.Reference))
                        {
                            var s = FindReferencedSchema(property.Reference, service.Definitions);
                            changed = changed || !s.IsReferenced;
                            s.IsReferenced = true;
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Retrieve a schema from the definitions section.
        /// </summary>
        /// <param name="reference">A document-relative reference path -- #/definitions/XXX</param>
        /// <param name="definitions">The definitions dictionary to use</param>
        /// <returns></returns>
        private static Schema FindReferencedSchema(string reference, IDictionary<string, Schema> definitions)
        {
            if (reference != null && reference.StartsWith("#", StringComparison.Ordinal))
            {
                var parts = reference.Split('/');
                if (parts.Length == 3 && parts[1].Equals("definitions"))
                {
                    Schema p = null;
                    if (definitions.TryGetValue(parts[2], out p))
                    {
                        return p;
                    }
                }
            }

            return null;
        }
    }
}