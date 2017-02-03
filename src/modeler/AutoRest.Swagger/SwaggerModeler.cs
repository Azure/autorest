// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Logging;
using AutoRest.Core.Parsing;
using AutoRest.Core.Utilities;
using AutoRest.Core.Utilities.Collections;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Properties;
using ParameterLocation = AutoRest.Swagger.Model.ParameterLocation;
using AutoRest.Core.Validation;
using YamlDotNet.RepresentationModel;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Swagger
{
    public class SwaggerModeler
    {
        private const string BaseUriParameterName = "BaseUri";

        internal Dictionary<string, string> ExtendedTypes = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        internal Dictionary<string, CompositeType> GeneratedTypes = new Dictionary<string, CompositeType>();
        internal Dictionary<Schema, CompositeType> GeneratingTypes = new Dictionary<Schema, CompositeType>();

        public SwaggerModeler() 
        {
            DefaultProtocol = TransferProtocolScheme.Http;
        }

        /// <summary>
        /// Swagger service model.
        /// </summary>
        public ServiceDefinition ServiceDefinition { get; set; }

        /// <summary>
        /// Client model.
        /// </summary>
        public CodeModel CodeModel { get; set; }

        /// <summary>
        /// Default protocol when no protocol is specified in the schema
        /// </summary>
        public TransferProtocolScheme DefaultProtocol { get; set; }

        /// <summary>
        /// Builds service model from swagger file.
        /// </summary>
        /// <returns></returns>
        public ServiceDefinition Parse(IFileSystem fs, string[] inputFiles)
        {
            Logger.Instance.Log(Category.Info, Resources.ParsingSwagger);
            if (inputFiles.Length == 1)
            {
                using (NewContext)
                {
                    new Settings
                    {
                        FileSystemInput = fs
                    };
                    return SwaggerParser.Load(inputFiles[0], fs);
                }
            }

            // composite mode
            // Ensure all the docs are absolute URIs or rooted paths
            for (var i = 0; i < inputFiles.Length; i++)
            {
                var compositeDocument = inputFiles[i];
                if (!fs.IsCompletePath(compositeDocument) || !fs.FileExists(compositeDocument))
                {
                    // Otherwise, root it from the current path
                    inputFiles[i] = fs.MakePathRooted(fs.GetParentDir(inputFiles[0]), compositeDocument);
                }
            }

            // construct merged swagger document
            var mergedSwagger = new YamlMappingNode();
            mergedSwagger.Set("info", (fs.ReadAllText(inputFiles[0]).ParseYaml() as YamlMappingNode)?.Get("info") as YamlMappingNode);

            // merge child swaggers
            foreach (var childSwaggerPath in inputFiles)
            {
                var childSwaggerRaw = fs.ReadAllText(childSwaggerPath);
                using (NewContext)
                {
                    new Settings
                    {
                        FileSystemInput = fs
                    };
                    childSwaggerRaw = SwaggerParser.Normalize(childSwaggerPath, childSwaggerRaw);
                }
                var childSwagger = childSwaggerRaw.ParseYaml() as YamlMappingNode;
                if (childSwagger == null)
                {
                    throw ErrorManager.CreateError("Failed parsing referenced Swagger file {0}.", childSwaggerPath);
                }

                // remove info
                var info = childSwagger.Get("info") as YamlMappingNode;
                var version = info.Get("version");
                info.Remove("title");
                info.Remove("description");
                info.Remove("version");

                // fix up api version
                var apiVersionParam = (childSwagger.Get("parameters") as YamlMappingNode)?.Children?.FirstOrDefault(param => ((param.Value as YamlMappingNode)?.Get("name") as YamlScalarNode)?.Value == "api-version");
                var apiVersionParamName = (apiVersionParam?.Key as YamlScalarNode)?.Value;
                if (apiVersionParamName != null)
                {
                    var paths =
                        ((childSwagger.Get("paths") as YamlMappingNode)?.Children?.Values ?? Enumerable.Empty<YamlNode>()).Concat
                        ((childSwagger.Get("x-ms-paths") as YamlMappingNode)?.Children?.Values ?? Enumerable.Empty<YamlNode>());
                    var methods = paths.OfType<YamlMappingNode>().SelectMany(path => path.Children.Values.OfType<YamlMappingNode>());
                    var parameters = methods.SelectMany(method => (method.Get("parameters") as YamlSequenceNode)?.Children?.OfType<YamlMappingNode>() ?? Enumerable.Empty<YamlMappingNode>());
                    var apiVersionParams = parameters.Where(param => (param.Get("$ref") as YamlScalarNode)?.Value == $"#/parameters/{apiVersionParamName}");
                    foreach (var param in apiVersionParams)
                    {
                        param.Remove("$ref");
                        foreach (var child in (apiVersionParam?.Value as YamlMappingNode).Children)
                        {
                            param.Children.Add(child);
                        }
                        param.Set("enum", new YamlSequenceNode(version));
                    }
                }

                // merge
                mergedSwagger = mergedSwagger.MergeWith(childSwagger);
            }
            // remove apiVersion client property
            var mergedSwaggerApiVersionParam = (mergedSwagger.Get("parameters") as YamlMappingNode)?.Children?.FirstOrDefault(param => ((param.Value as YamlMappingNode)?.Get("name") as YamlScalarNode)?.Value == "api-version");
            var mergedSwaggerApiVersionParamName = (mergedSwaggerApiVersionParam?.Key as YamlScalarNode)?.Value;
            if (mergedSwaggerApiVersionParamName != null)
            {
                (mergedSwagger.Get("parameters") as YamlMappingNode).Remove(mergedSwaggerApiVersionParamName);
            }

            // CodeModel compositeClient = InitializeServiceClient(compositeSwaggerModel);
            return SwaggerParser.Parse(inputFiles[0], mergedSwagger.Serialize());
        }

        [Obsolete("that's not how we do it")]
        public CodeModel Build()
        {
            return Build(Parse(Settings.Instance.FileSystemInput, new[] {Settings.Instance.Input}));
        }

        [Obsolete("that's not how we do it")]
        public CodeModel Build(IFileSystem fs, string[] inputFiles)
        {
            return Build(Parse(fs, inputFiles));
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Maintainability",
             "CA1506:AvoidExcessiveClassCoupling")]
        public CodeModel Build(ServiceDefinition serviceDefinition)
        {
            ServiceDefinition = serviceDefinition;

            Logger.Instance.Log(Category.Info, Resources.GeneratingClient);
            // Update settings
            UpdateSettings();

            InitializeClientModel();
            BuildCompositeTypes();

            // Build client parameters
            foreach (var swaggerParameter in ServiceDefinition.Parameters.Values)
            {
                var parameter = ((ParameterBuilder) swaggerParameter.GetBuilder(this)).Build();

                var clientProperty = New<Property>();
                clientProperty.LoadFrom(parameter);
                clientProperty.RealPath = new string[] {parameter.SerializedName.Value};

                CodeModel.Add(clientProperty);
            }

            var methods = new List<Method>();
            // Build methods
            foreach (var path in ServiceDefinition.Paths.Concat(ServiceDefinition.CustomPaths))
            {
                foreach (var verb in path.Value.Keys)
                {
                    var operation = path.Value[verb];
                    if (string.IsNullOrWhiteSpace(operation.OperationId))
                    {
                        throw ErrorManager.CreateError(
                            string.Format(CultureInfo.InvariantCulture,
                                Resources.OperationIdMissing,
                                verb,
                                path.Key));
                    }
                    var methodName = GetMethodName(operation);
                    var methodGroup = GetMethodGroup(operation);

                    if (verb.ToHttpMethod() != HttpMethod.Options)
                    {
                        string url = path.Key;
                        if (url.Contains("?"))
                        {
                            url = url.Substring(0, url.IndexOf('?'));
                        }
                        var method = BuildMethod(verb.ToHttpMethod(), url, methodName, operation);
                        method.Group = methodGroup;

                        methods.Add(method);
                        if (method.DefaultResponse.Body is CompositeType)
                        {
                            CodeModel.AddError((CompositeType) method.DefaultResponse.Body);
                        }
                    }
                    else
                    {
                        Logger.Instance.Log(Category.Warning, Resources.OptionsNotSupported);
                    }
                }
            }

            // Set base type
            foreach (var typeName in GeneratedTypes.Keys)
            {
                var objectType = GeneratedTypes[typeName];
                if (ExtendedTypes.ContainsKey(typeName))
                {
                    objectType.BaseModelType = GeneratedTypes[ExtendedTypes[typeName]];
                }

                CodeModel.Add(objectType);
            }
            CodeModel.AddRange(methods);


            return CodeModel;
        }

        /// <summary>
        /// Copares two versions of the same service specification.
        /// </summary>
        /// <returns></returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Maintainability", "CA1506:AvoidExcessiveClassCoupling")]
        public IEnumerable<ComparisonMessage> Compare()
        {
            var settings = Settings.Instance;

            Logger.Instance.Log(Category.Info, Resources.ParsingSwagger);
            if (string.IsNullOrWhiteSpace(settings.Input) || string.IsNullOrWhiteSpace(settings.Previous))
            {
                throw ErrorManager.CreateError(Resources.InputRequired);
            }

            var oldDefintion = SwaggerParser.Load(settings.Previous, settings.FileSystemInput);
            var newDefintion = SwaggerParser.Load(settings.Input, settings.FileSystemInput);

            var context = new ComparisonContext(oldDefintion, newDefintion);

            // Look for semantic errors and warnings in the new document.
            var validator = new RecursiveObjectValidator(PropertyNameResolver.JsonName);
            var LogMessages = validator.GetValidationExceptions(newDefintion).ToList();

            // Only compare versions if the new version is correct.
            var comparisonMessages = 
                !LogMessages.Any(m => m.Severity > Category.Error) ? 
                newDefintion.Compare(context, oldDefintion) : 
                Enumerable.Empty<ComparisonMessage>();

            return LogMessages
                .Select(msg => new ComparisonMessage(new MessageTemplate { Id = 0, Message = msg.Message }, msg.Path, msg.Severity))
                .Concat(comparisonMessages);
        }

        private void UpdateSettings()
        {
            var settings = Settings.Instance;
            if (settings != null)
            {
                // TODO: Note: this is the kind of settings we WANT in a pipeline model! Custom customizations for the current stage!
                if (ServiceDefinition.Info.CodeGenerationSettings != null)
                {
                    foreach (var key in ServiceDefinition.Info.CodeGenerationSettings.Extensions.Keys)
                    {
                        //Don't overwrite settings that come in from the command line
                        if (!settings.CustomSettings.ContainsKey(key))
                            settings.CustomSettings[key] = ServiceDefinition.Info.CodeGenerationSettings.Extensions[key];
                    }
                    Settings.PopulateSettings(settings, settings.CustomSettings);
                }
            }
        }

        /// <summary>
        /// Initialize the base service and populate global service properties
        /// </summary>
        /// <returns>The base ServiceModel Service</returns>
        public virtual void InitializeClientModel()
        {
            if (string.IsNullOrEmpty(ServiceDefinition.Swagger))
            {
                throw ErrorManager.CreateError(Resources.UnknownSwaggerVersion);
            }

            if (ServiceDefinition.Info == null)
            {
                throw ErrorManager.CreateError(Resources.InfoSectionMissing);
            }

            if (ServiceDefinition.Info.Title == null)
            {
                throw ErrorManager.CreateError(Resources.TitleMissing);
            }

            CodeModel = New<CodeModel>();

            CodeModel.Name = ServiceDefinition.Info.Title?.Replace(" ", "");

            CodeModel.ApiVersion = ServiceDefinition.Info.Version;
            CodeModel.Documentation = ServiceDefinition.Info.Description;
            if (ServiceDefinition.Schemes == null || ServiceDefinition.Schemes.Count != 1)
            {
                ServiceDefinition.Schemes = new List<TransferProtocolScheme> { DefaultProtocol };
            }
            if (string.IsNullOrEmpty(ServiceDefinition.Host))
            {
                ServiceDefinition.Host = "localhost";
            }
            CodeModel.BaseUrl = string.Format(CultureInfo.InvariantCulture, "{0}://{1}{2}",
                ServiceDefinition.Schemes[0].ToString().ToLower(CultureInfo.InvariantCulture),
                ServiceDefinition.Host, ServiceDefinition.BasePath);

            // Copy extensions
            ServiceDefinition.Extensions.ForEach(extention => CodeModel.Extensions.AddOrSet(extention.Key, extention.Value));
        }

        /// <summary>
        /// Build composite types from definitions
        /// </summary>
        public virtual void BuildCompositeTypes()
        {
            // Build service types and validate allOf
            if (ServiceDefinition.Definitions != null)
            {
                foreach (var schemaName in ServiceDefinition.Definitions.Keys.ToArray())
                {
                    var schema = ServiceDefinition.Definitions[schemaName];
                    schema.GetBuilder(this).BuildServiceType(schemaName);

                    Resolver.ExpandAllOf(schema);
                    var parent = string.IsNullOrEmpty(schema.Extends.StripDefinitionPath())
                        ? null
                        : ServiceDefinition.Definitions[schema.Extends.StripDefinitionPath()];

                    if (parent != null &&
                        !AncestorsHaveProperties(parent.Properties, parent.Extends))
                    {
                        throw ErrorManager.CreateError(Resources.InvalidAncestors, schemaName);
                    }
                }
            }
        }

        /// <summary>
        /// Recursively traverse the schema's extends to verify that it or one of it's parents
        /// has at least one property
        /// </summary>
        /// <param name="properties">The schema's properties</param>
        /// <param name="extends">The schema's extends</param>
        /// <returns>True if one or more properties found in this schema or in it's ancestors. False otherwise</returns>
        private bool AncestorsHaveProperties(Dictionary<string, Schema> properties, string extends)
        {
            if (properties.IsNullOrEmpty() && string.IsNullOrEmpty(extends))
            {
                return false;
            }

            if (!properties.IsNullOrEmpty())
            {
                return true;
            }

            extends = extends.StripDefinitionPath();
            Debug.Assert(!string.IsNullOrEmpty(extends) && ServiceDefinition.Definitions.ContainsKey(extends));
            return AncestorsHaveProperties(ServiceDefinition.Definitions[extends].Properties,
                ServiceDefinition.Definitions[extends].Extends);
        }

        /// <summary>
        /// Builds method from swagger operation.
        /// </summary>
        /// <param name="httpMethod"></param>
        /// <param name="url"></param>
        /// <param name="name"></param>
        /// <param name="operation"></param>
        /// <returns></returns>
        public Method BuildMethod(HttpMethod httpMethod, string url, string name,
            Operation operation)
        {
            string methodGroup = GetMethodGroup(operation);
            var operationBuilder = new OperationBuilder(operation, this);
            Method method = operationBuilder.BuildMethod(httpMethod, url, name, methodGroup);
            return method;
        }

        /// <summary>
        /// Extracts method group from operation ID.
        /// </summary>
        /// <param name="operation">The swagger operation.</param>
        /// <returns>Method group name or null.</returns>
        public static string GetMethodGroup(Operation operation)
        {
            if (operation == null)
            {
                throw new ArgumentNullException("operation");
            }

            if (operation.OperationId == null || operation.OperationId.IndexOf('_') == -1)
            {
                return null;
            }

            var parts = operation.OperationId.Split('_');
            return parts[0];
        }

        /// <summary>
        /// Extracts method name from operation ID.
        /// </summary>
        /// <param name="operation">The swagger operation.</param>
        /// <returns>Method name.</returns>
        public static string GetMethodName(Operation operation)
        {
            if (operation == null)
            {
                throw new ArgumentNullException("operation");
            }

            if (operation.OperationId == null)
            {
                return null;
            }

            if (operation.OperationId.IndexOf('_') == -1)
            {
                return operation.OperationId;
            }

            var parts = operation.OperationId.Split('_');
            return parts[1];
        }

        public SwaggerParameter Unwrap(SwaggerParameter swaggerParameter)
        {
            if (swaggerParameter == null)
            {
                throw new ArgumentNullException("swaggerParameter");
            }

            // If referencing global parameters serializationProperty
            if (swaggerParameter.Reference != null)
            {
                string referenceKey = swaggerParameter.Reference.StripParameterPath();
                if (!ServiceDefinition.Parameters.ContainsKey(referenceKey))
                {
                    throw new ArgumentException(
                        string.Format(CultureInfo.InvariantCulture,
                        Resources.DefinitionDoesNotExist, referenceKey));
                }

                swaggerParameter = ServiceDefinition.Parameters[referenceKey];
            }

            // Unwrap the schema if in "body"
            if (swaggerParameter.Schema != null && swaggerParameter.In == ParameterLocation.Body)
            {
                swaggerParameter.Schema = Resolver.Unwrap(swaggerParameter.Schema);
            }

            return swaggerParameter;
        }

        public SchemaResolver Resolver
        {
            get { return new SchemaResolver(this); }
        }
    }
}
