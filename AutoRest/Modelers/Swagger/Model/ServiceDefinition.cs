// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using System.Globalization;
using System.Collections.Generic;
using Resources = Microsoft.Rest.Modeler.Swagger.Properties.Resources;
using Newtonsoft.Json;
using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Modeler.Swagger.Validators;

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
        [IterableRule(typeof(AnonymousTypes))]
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

        public override bool Compare(SwaggerBase priorVersion, ValidationContext context)
        {
            var priorServiceDefinition = priorVersion as ServiceDefinition;

            if (priorServiceDefinition == null)
            {
                throw new ArgumentNullException("priorVersion");
            }
            if (context == null)
            {
                throw new ArgumentNullException("context");
            }

            var errorCount = context.ValidationErrors.Count;

            // Set up our "symbol table" for processing by nested elements.

            context.Responses = Responses;
            context.Parameters = Parameters;
            context.Definitions = Definitions;
            context.PriorResponses = priorServiceDefinition.Responses;
            context.PriorParameters = priorServiceDefinition.Parameters;
            context.PriorDefinitions = priorServiceDefinition.Definitions;

            // If there's no major/minor version change, apply strict rules, which means that
            // breaking changes are errors, not warnings.

            var oldVersion = priorServiceDefinition.Info.Version.Split('.');
            var newVersion = Info.Version.Split('.');

            CompareVersions(context, priorServiceDefinition, oldVersion, newVersion);

            if (context.Strict)
            {
                context.ValidationErrors.Add(new LogEntry
                {
                    Severity = LogEntrySeverity.Info,
                    Message = Resources.NoVersionChange
                });
            }

            base.Compare(priorVersion, context);

            // Check that all the HTTP schemes of the old version are supported by the new version.

            context.PushTitle("Schemes");
            foreach (var scheme in priorServiceDefinition.Schemes)
            {
                if (!Schemes.Contains(scheme))
                {
                    context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.ProtocolNoLongerSupported1, scheme.ToString()));
                }
            }
            context.PopTitle();

            // Check that all the request body formats of the old version are supported by the new version.

            context.PushTitle("Consumes");
            foreach (var format in priorServiceDefinition.Consumes)
            {
                if (!Consumes.Contains(format))
                {
                    context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.RequestBodyFormatNoLongerSupported1, format));
                }
            }
            context.PopTitle();

            // Check that all the response body formats of the new version were supported by the old version.

            context.PushTitle("Produces");
            foreach (var format in Produces)
            {
                if (!priorServiceDefinition.Produces.Contains(format))
                {
                    context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.ResponseBodyFormatNoLongerSupported1, format));
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
                    context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.RemovedPath1, path));
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
                    context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.RemovedPath1, path));
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
                    context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.RemovedDefinition1, def));
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
                    context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.RemovedClientParameter1, def));
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

        private void CompareVersions(ValidationContext context, ServiceDefinition priorServiceDefinition, string[] oldVersion, string[] newVersion)
        {
            context.PushTitle("Versions");

            if (!context.Strict && oldVersion.Length > 0 && newVersion.Length > 0)
            {
                bool versionChanged = false;

                // Situation 1: The versioning scheme is semantic, i.e. it uses a major.minor.build-number scheme, where each component is an integer.
                //              In this case, we care about the major/minor numbers, but not the build number. In other words, if all that is different 
                //              is the build number, it will be not be treated as a version change.

                int oldMajor, newMajor = 0;
                bool integers = int.TryParse(oldVersion[0], out oldMajor) && int.TryParse(newVersion[0], out newMajor);

                if (integers && oldMajor != newMajor)
                {
                    versionChanged = true;

                    if (oldMajor > newMajor)
                    {
                        context.LogError(string.Format(CultureInfo.InvariantCulture, Resources.VersionLowered2, priorServiceDefinition.Info.Version, Info.Version));
                    }
                }

                if (!versionChanged && integers && oldVersion.Length > 1 && newVersion.Length > 1)
                {
                    int oldMinor, newMinor = 0;
                    integers = int.TryParse(oldVersion[1], out oldMinor) && int.TryParse(newVersion[1], out newMinor);

                    if (integers && oldMinor != newMinor)
                    {
                        versionChanged = true;

                        if (oldMinor > newMinor)
                        {
                            context.LogError(string.Format(CultureInfo.InvariantCulture, Resources.VersionLowered2, priorServiceDefinition.Info.Version, Info.Version));
                        }
                    }
                }

                // Situation 2: The versioning scheme is something else, maybe a date or just a label?
                //              Regardless of what it is, we just check whether the two versions are equal or not.

                if (!versionChanged && !integers)
                {
                    versionChanged = !priorServiceDefinition.Info.Version.ToLower(CultureInfo.CurrentCulture).Equals(Info.Version.ToLower(CultureInfo.CurrentCulture));
                }

                context.Strict = !versionChanged;
            }

            context.PopTitle();
        }
    }
}