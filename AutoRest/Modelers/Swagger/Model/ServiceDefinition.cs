// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using System.Collections.Generic;
using Newtonsoft.Json;
using Microsoft.Rest.Generator.Logging;

namespace Microsoft.Rest.Modeler.Swagger.Model
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
        public Dictionary<string, Dictionary<string, Operation>> CustomPaths { get; set; }

        /// <summary>
        /// Key is the object serviceTypeName and the value is swagger definition.
        /// </summary>
        public Dictionary<string, Schema> Definitions { get; set; }

        /// <summary>
        /// Dictionary of parameters that can be used across operations.
        /// This property does not define global parameters for all operations.
        /// </summary>
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
        /// Validate the Swagger object against a number of object-specific validation rules.
        /// </summary>
        /// <param name="validationErrors">A list of error messages, filled in during processing.</param>
        /// <returns>True if there are no validation errors, false otherwise.</returns>
        public override bool Validate(List<LogEntry> validationErrors)
        {
            var errorCount = validationErrors.Count;

            base.Validate(validationErrors);

            validationErrors.AddRange(Consumes
                .Where(input => !string.IsNullOrEmpty(input) && !input.Contains("json"))
                .Select(input => new LogEntry(LogEntrySeverity.Error, string.Format("Currently, only JSON-based request payloads are supported, so '{0}' won't work.", input))));

            validationErrors.AddRange(Produces
                .Where(input => !string.IsNullOrEmpty(input) && !input.Contains("json"))
                .Select(input => new LogEntry(LogEntrySeverity.Error, string.Format("Currently, only JSON-based request payloads are supported, so '{0}' won't work.", input))));

            foreach (var def in Definitions.Values)
            {
                def.Validate(validationErrors);
            }
            foreach (var path in Paths.Values)
            {
                foreach (var operation in path.Values)
                {
                    operation.Validate(validationErrors);
                }
            }
            foreach (var path in CustomPaths.Values)
            {
                foreach (var operation in path.Values)
                {
                    operation.Validate(validationErrors);
                }
            }
            foreach (var param in Parameters.Values)
            {
                param.Validate(validationErrors);
            }
            foreach (var response in Responses.Values)
            {
                response.Validate(validationErrors);
            }
            foreach (var secDef in SecurityDefinitions.Values)
            {
                secDef.Validate(validationErrors);
            }
            foreach (var tag in Tags)
            {
                tag.Validate(validationErrors);
            }

            if (ExternalDocs != null)
                ExternalDocs.Validate(validationErrors);

            return validationErrors.Count == errorCount;
        }

        public override bool Compare(SwaggerBase priorVersion, ValidationContext context)
        {
            var priorServiceDefinition = priorVersion as ServiceDefinition;

            if (priorServiceDefinition == null)
            {
                throw new ArgumentNullException("priorVersion");
            }

            if (context == null)
            {
                throw new ArgumentNullException("context string");
            }

            var errorCount = context.ValidationErrors.Count;

            context.Definitions = this.Definitions;
            context.Parameters = this.Parameters;
            context.Responses = this.Responses;

            // If there's no major/minor version change, apply strict rules, which means that
            // breaking changes are errors, not warnings.

            var oldVersion = priorServiceDefinition.Info.Version.Split('.');
            var newVersion = Info.Version.Split('.');

            context.PushTitle("Versions");
            if (!context.Strict && oldVersion.Length > 0 && newVersion.Length > 0)
            {
                if (oldVersion.Length == 1 && newVersion.Length == 1)
                {
                    context.Strict = oldVersion[0].Equals(newVersion[0]);

                    if (int.Parse(oldVersion[0]) > int.Parse(newVersion[0]))
                    {
                        context.LogError(string.Format("The new version has a lower value than the old: {0} -> {1}", priorServiceDefinition.Info.Version, Info.Version));
                    }
                }
                else
                {
                    context.Strict = oldVersion[0].Equals(newVersion[0]) && oldVersion[1].Equals(newVersion[1]);

                    if (int.Parse(oldVersion[0]) > int.Parse(newVersion[0]) || 
                        (int.Parse(oldVersion[0]) == int.Parse(newVersion[0]) && 
                         int.Parse(oldVersion[1]) > int.Parse(newVersion[1])))
                    {
                        context.LogError(string.Format("The new version has a lower value than the old: {0} -> {1}", priorServiceDefinition.Info.Version, Info.Version));
                    }
                }
            }
            context.PopTitle();

            if (context.Strict)
            {
                context.ValidationErrors.Add(new LogEntry
                {
                    Severity = LogEntrySeverity.Info,
                    Message = string.Format("The major/minor version has not been changed, so breaking changes will be reported as errors.")
                });
            }

            base.Compare(priorVersion, context);

            // Check that all the HTTP schemes of the old version are supported by the new version.

            context.PushTitle("Schemes");
            foreach (var scheme in priorServiceDefinition.Schemes)
            {
                if (!Schemes.Contains(scheme))
                {
                    context.LogBreakingChange(string.Format("The new version does not support '{0}' as a protocol.", scheme.ToString()));
                }
            }
            context.PopTitle();

            // Check that all the request body formats of the old version are supported by the new version.

            context.PushTitle("Consumes");
            foreach (var format in priorServiceDefinition.Consumes)
            {
                context.LogBreakingChange(string.Format("The new version does not support '{0}' as a request body format", format));
            }
            context.PopTitle();

            // Check that all the response body formats of the new version were supported by the old version.

            context.PushTitle("Produces");
            foreach (var format in Produces)
            {
                if (!priorServiceDefinition.Produces.Contains(format))
                {
                    context.LogBreakingChange(string.Format("The old version does not support '{0}' as a response body format.", format));
                }
            }
            context.PopTitle();

            // Check that no paths were removed, and compare them if it's not the case.

            context.PushTitle("Paths");
            foreach (var path in priorServiceDefinition.Paths.Keys)
            {
                Dictionary<string, Operation> operations = null;
                if (!Paths.TryGetValue(path, out operations))
                {
                    context.LogBreakingChange(string.Format("The new version is missing a path found in the old version. Was '{0}' restructured or removed?", path));
                }
                else
                {
                    // TODO: check that no operations were removed.

                    foreach (var operation in operations)
                    {
                        context.PushTitle(operation.Value.OperationId);
                        operation.Value.Compare(priorServiceDefinition.Paths[path][operation.Key], context);
                        context.PopTitle();
                    }
                }
            }
            context.PopTitle();

            context.PushTitle("CustomPaths");
            foreach (var path in priorServiceDefinition.CustomPaths.Keys)
            {
                Dictionary<string, Operation> operations = null;
                if (!CustomPaths.TryGetValue(path, out operations))
                {
                    context.LogBreakingChange(string.Format("The new version is missing a path found in the old version. Was '{0}' restructured or removed?", path));
                }
                else
                {
                    // TODO: check that no operations were removed.

                    foreach (var operation in operations)
                    {
                        context.PushTitle(operation.Value.OperationId);
                        operation.Value.Compare(priorServiceDefinition.CustomPaths[path][operation.Key], context);
                        context.PopTitle();
                    }
                }
            }
            context.PopTitle();

            // Check that no payload models were removed, and compare them if it's not the case.

            context.PushTitle("Definitions");
            foreach (var def in priorServiceDefinition.Definitions.Keys)
            {
                Schema model = null;
                if (!Definitions.TryGetValue(def, out model))
                {
                    context.LogBreakingChange(string.Format("The new version is missing a payload model found in the old version. Was '{0}' renamed or removed?", def));
                }
                else
                {
                    context.PushTitle("Definitions/" + def);
                    model.Compare(priorServiceDefinition.Definitions[def], context);
                    context.PopTitle();
                }
            }
            context.PopTitle();

            // Check that no client parameters were removed, and compare them if it's not the case.

            context.PushTitle("Parameters");
            foreach (var def in priorServiceDefinition.Parameters.Keys)
            {
                SwaggerParameter model = null;
                if (!Parameters.TryGetValue(def, out model))
                {
                    context.LogBreakingChange(string.Format("The new version is missing a client parameter found in the old version. Was '{0}' renamed or removed?", def));
                }
                else
                {
                    context.PushTitle("Parameters/" + def);
                    model.Compare(priorServiceDefinition.Parameters[def], context);
                    context.PopTitle();
                }
            }
            context.PopTitle();

            return context.ValidationErrors.Count == errorCount;
        }
    }
}