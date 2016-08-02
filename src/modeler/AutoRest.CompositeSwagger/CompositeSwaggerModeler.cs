// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.Linq;
using AutoRest.CompositeSwagger.Model;
using AutoRest.CompositeSwagger.Properties;
using AutoRest.Core;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Logging;
using AutoRest.Core.Utilities;
using AutoRest.Swagger;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using AutoRest.Core.Validation;
using System.Collections.Generic;

namespace AutoRest.CompositeSwagger
{
    public class CompositeSwaggerModeler : Modeler
    {
        public CompositeSwaggerModeler(Settings settings) : base(settings)
        {
            if (settings == null)
            {
                throw new ArgumentNullException("settings");
            }
        }

        public override string Name
        {
            get { return "CompositeSwagger"; }
        }

        public override ServiceClient Build()
        {
            var compositeSwaggerModel = Parse(Settings.Input);
            if (compositeSwaggerModel == null)
            {
                throw ErrorManager.CreateError(Resources.ErrorParsingSpec);
            }

            if (!compositeSwaggerModel.Documents.Any())
            {
                throw ErrorManager.CreateError(string.Format(CultureInfo.InvariantCulture, "{0}. {1}",
                    Resources.ErrorParsingSpec, "Documents collection can not be empty."));
            }

            if (compositeSwaggerModel.Info == null)
            {
                throw ErrorManager.CreateError(Resources.InfoSectionMissing);
            }

            ServiceClient compositeClient = InitializeServiceClient(compositeSwaggerModel);

            foreach (var childSwaggerPath in compositeSwaggerModel.Documents)
            {
                Settings.Input = childSwaggerPath;
                var swaggerModeler = new SwaggerModeler(Settings);
                var serviceClient = swaggerModeler.Build();
                compositeClient = Merge(compositeClient, serviceClient);
            }
            return compositeClient;
        }

        private ServiceClient InitializeServiceClient(CompositeServiceDefinition compositeSwaggerModel)
        {
            ServiceClient compositeClient = new ServiceClient();

            if (string.IsNullOrWhiteSpace(Settings.ClientName))
            {
                if (compositeSwaggerModel.Info.Title == null)
                {
                    throw ErrorManager.CreateError(Resources.TitleMissing);
                }

                compositeClient.Name = compositeSwaggerModel.Info.Title.Replace(" ", "");
            }
            else
            {
                compositeClient.Name = Settings.ClientName;
            }
            compositeClient.Namespace = Settings.Namespace;
            compositeClient.ModelsName = Settings.ModelsName;
            compositeClient.Documentation = compositeSwaggerModel.Info.Description;

            return compositeClient;
        }

        private CompositeServiceDefinition Parse(string input)
        {
            var inputBody = Settings.FileSystem.ReadFileAsText(input);
            try
            {
                var settings = new JsonSerializerSettings
                {
                    TypeNameHandling = TypeNameHandling.None,
                    MetadataPropertyHandling = MetadataPropertyHandling.Ignore
                };
                return JsonConvert.DeserializeObject<CompositeServiceDefinition>(inputBody, settings);                
            }
            catch (JsonException ex)
            {
                throw ErrorManager.CreateError(string.Format(CultureInfo.InvariantCulture, "{0}. {1}",
                    Resources.ErrorParsingSpec, ex.Message), ex);
            }
        }

        private static ServiceClient Merge(ServiceClient compositeClient, ServiceClient subClient)
        {
            if (compositeClient == null)
            {
                throw new ArgumentNullException("compositeClient");
            }

            if (subClient == null)
            {
                throw new ArgumentNullException("subClient");
            }

            // Merge
            if(compositeClient.BaseUrl == null)
            {
                compositeClient.BaseUrl = subClient.BaseUrl;
            }
            else
            {
                AssertEquals(compositeClient.BaseUrl, subClient.BaseUrl, "BaseUrl");
            }

            // Copy client properties
            foreach (var subClientProperty in subClient.Properties)
            {
                if (subClientProperty.SerializedName == "api-version")
                {
                    continue;
                }

                var compositeClientProperty = compositeClient.Properties.FirstOrDefault(p => p.Name == subClientProperty.Name);
                if (compositeClientProperty == null)
                {
                    compositeClient.Properties.Add(subClientProperty);
                }
                else
                {
                    AssertJsonEquals(compositeClientProperty, subClientProperty);
                }
            }

            // Copy models
            foreach (var subClientModel in subClient.ModelTypes)
            {
                var compositeClientModel = compositeClient.ModelTypes.FirstOrDefault(p => p.Name == subClientModel.Name);
                if (compositeClientModel == null)
                {
                    compositeClient.ModelTypes.Add(subClientModel);
                }
                else
                {
                    AssertJsonEquals(compositeClientModel, subClientModel);
                }
            }

            // Copy enum types
            foreach (var subClientModel in subClient.EnumTypes)
            {
                var compositeClientModel = compositeClient.EnumTypes.FirstOrDefault(p => p.Name == subClientModel.Name);
                if (compositeClientModel == null)
                {
                    compositeClient.EnumTypes.Add(subClientModel);
                }
                else
                {
                    AssertJsonEquals(compositeClientModel, subClientModel);
                }
            }

            // Copy error types
            foreach (var subClientModel in subClient.ErrorTypes)
            {
                var compositeClientModel = compositeClient.ErrorTypes.FirstOrDefault(p => p.Name == subClientModel.Name);
                if (compositeClientModel == null)
                {
                    compositeClient.ErrorTypes.Add(subClientModel);
                }
                else
                {
                    AssertJsonEquals(compositeClientModel, subClientModel);
                }
            }

            // Copy header types
            foreach (var subClientModel in subClient.HeaderTypes)
            {
                var compositeClientModel = compositeClient.HeaderTypes.FirstOrDefault(p => p.Name == subClientModel.Name);
                if (compositeClientModel == null)
                {
                    compositeClient.HeaderTypes.Add(subClientModel);
                }
                else
                {
                    AssertJsonEquals(compositeClientModel, subClientModel);
                }
            }

            // Copy methods
            foreach (var subClientMethod in subClient.Methods)
            {
                var apiVersionParameter = subClientMethod.Parameters.FirstOrDefault(p => p.SerializedName == "api-version");
                if (apiVersionParameter != null)
                {
                    apiVersionParameter.ClientProperty = null;
                    apiVersionParameter.IsConstant = true;
                    apiVersionParameter.DefaultValue = subClient.ApiVersion;
                    apiVersionParameter.IsRequired = true;
                }

                var compositeClientMethod = compositeClient.Methods.FirstOrDefault(m => m.ToString() == subClientMethod.ToString()
                    && m.Group == subClientMethod.Group);
                if (compositeClientMethod == null)
                {
                    // Re-link client parameters
                    foreach (var parameter in subClientMethod.Parameters.Where(p => p.ClientProperty != null))
                    {
                        var clientProperty = compositeClient.Properties
                            .FirstOrDefault(p => p.SerializedName == parameter.ClientProperty.SerializedName);
                        if (clientProperty != null)
                        {
                            parameter.ClientProperty = clientProperty;
                        }
                    }
                    compositeClient.Methods.Add(subClientMethod);
                }
            }

            return compositeClient;
        }

        private static void AssertJsonEquals<T>(T compositeParam, T subParam)
        {
            if (compositeParam != null)
            {
                var jsonSettings = new JsonSerializerSettings
                {
                    Formatting = Formatting.Indented,
                    NullValueHandling = NullValueHandling.Ignore,
                    ContractResolver = new CamelCaseContractResolver(),
                    ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                };
                jsonSettings.Converters.Add(new StringEnumConverter { CamelCaseText = true });

                var compositeParamJson = JsonConvert.SerializeObject(compositeParam, jsonSettings);
                var subParamJson = JsonConvert.SerializeObject(subParam, jsonSettings);

                if (!compositeParamJson.Equals(subParamJson))
                {
                    throw ErrorManager.CreateError(string.Format(CultureInfo.InvariantCulture,
                        "{0}s are not the same.\nObject 1: {1}\nObject 2:{2}",
                        typeof(T).Name, compositeParamJson, subParamJson));
                }
            }
        }

        private static void AssertEquals<T>(T compositeProperty, T subProperty, string propertyName)
        {
            if (compositeProperty != null)
            {
                if (!compositeProperty.Equals(subProperty))
                {
                    throw ErrorManager.CreateError(string.Format(CultureInfo.InvariantCulture,
                        "{0} has different values in sub swagger documents.",
                        propertyName));
                }
            }
        }

        public override ServiceClient Build(out IEnumerable<ValidationMessage> messages)
        {
            // No composite modeler validation messages yet
            messages = new List<ValidationMessage>();
            return Build();
        }
    }
}
