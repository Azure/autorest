// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;
using System.Globalization;
using System.Linq;
using AutoRest.CompositeSwagger.Model;
using AutoRest.CompositeSwagger.Properties;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Logging;
using AutoRest.Core.Utilities;
using AutoRest.Swagger;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using AutoRest.Core.Validation;
using System.Collections.Generic;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.CompositeSwagger
{
    public class CompositeSwaggerModeler : Modeler
    {
        public CompositeSwaggerModeler()
        {
        }

        public override string Name
        {
            get { return "CompositeSwagger"; }
        }

        public override CodeModel Build()
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

            // Ensure all the docs are absolute URIs or rooted paths
            for (var i = 0; i < compositeSwaggerModel.Documents.Count; i++)
            {
                var compositeDocument = compositeSwaggerModel.Documents[i];
                if (!Settings.FileSystem.IsCompletePath(compositeDocument) || !Settings.FileSystem.FileExists(compositeDocument))
                {
                    // Otherwise, root it from the current path
                    compositeSwaggerModel.Documents[i] = Settings.FileSystem.MakePathRooted(Settings.InputFolder, compositeDocument);
                }
            }

            CodeModel compositeClient = InitializeServiceClient(compositeSwaggerModel);
            using (NewContext)
            {
                foreach (var childSwaggerPath in compositeSwaggerModel.Documents)
                {
                    Settings.Input = childSwaggerPath;
                    var swaggerModeler = new SwaggerModeler();
                    var serviceClient = swaggerModeler.Build();
                    compositeClient = Merge(compositeClient, serviceClient);
                }
            }
            return compositeClient;
        }

        private CodeModel InitializeServiceClient(CompositeServiceDefinition compositeSwaggerModel)
        {
            CodeModel compositeClient = New<CodeModel>();

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

        private static CodeModel Merge(CodeModel compositeClient, CodeModel subClient)
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
            if (compositeClient.BaseUrl == null)
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
                    compositeClient.Add( subClientProperty);
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
                    compositeClient.Add(subClientModel);
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
                    compositeClient.Add(subClientModel);
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
                    compositeClient.AddError(subClientModel);
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
                    compositeClient.AddHeader(subClientModel);
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
                    foreach (var parameter in subClientMethod.Parameters.Where(p => p.IsClientProperty))
                    {
                        var clientProperty = compositeClient.Properties
                            .FirstOrDefault(p => p.SerializedName == parameter.ClientProperty.SerializedName);
                        if (clientProperty != null)
                        {
                            parameter.ClientProperty = clientProperty;
                        }
                    }
                    compositeClient.Add(subClientMethod);
                    
                }
            }


            // make sure that properties and parameters are using the types from the new model
            // and not the types from the original.
            foreach (var property in compositeClient.Properties)
            {
                EnsureUsesTypeFromModel(property, compositeClient);
            }
            foreach (var method in compositeClient.Methods)
            {
                foreach (var parameter in method.Parameters)
                {
                    EnsureUsesTypeFromModel(parameter, compositeClient);
                }

                foreach (var response in method.Responses.Values)
                {
                    response.Body = EnsureUsesTypeFromModel(response.Body, compositeClient);
                    response.Headers = EnsureUsesTypeFromModel(response.Headers, compositeClient);
                }

                method.ReturnType.Body = EnsureUsesTypeFromModel(method.ReturnType.Body, compositeClient);
                method.ReturnType.Headers = EnsureUsesTypeFromModel(method.ReturnType.Headers, compositeClient);
            }
            foreach (var modelType in compositeClient.ModelTypes)
            {
                foreach (var property in modelType.Properties)
                {
                    EnsureUsesTypeFromModel(property, compositeClient);
                }
            }

            return compositeClient;
        }

        private static void EnsureUsesTypeFromModel(IVariable variable, CodeModel compositeClient)
        {
            if (variable.ModelType == null)
            {
                return;
            }
            if (variable.ModelType is EnumType)
            {
                variable.ModelType = FindEnumType((EnumType) variable.ModelType,compositeClient);
            }
            if (variable.ModelType is CompositeType)
            {
                variable.ModelType = FindCompositeType((CompositeType)variable.ModelType, compositeClient);
            }
            if (variable.ModelType is SequenceType)
            {
                var st = (SequenceType)variable.ModelType;
                if (st.ElementType is EnumType)
                {
                    st.ElementType = FindEnumType((EnumType)st.ElementType, compositeClient);
                }
                if (st.ElementType is CompositeType)
                {
                    st.ElementType = FindCompositeType((CompositeType)st.ElementType, compositeClient);
                }
            }
            if (variable.ModelType is DictionaryType)
            {
                var dt = (DictionaryType)variable.ModelType;
                if (dt.ValueType is EnumType)
                {
                    dt.ValueType  = FindEnumType((EnumType)dt.ValueType, compositeClient);
                }
                if (dt.ValueType is CompositeType)
                {
                    dt.ValueType = FindCompositeType((CompositeType)dt.ValueType, compositeClient);
                }
            }
        }

        private static IModelType EnsureUsesTypeFromModel(IModelType modelType, CodeModel compositeClient)
        {
            if (modelType == null)
            {
                return modelType;
            }
            if (modelType is EnumType)
            {
                return FindEnumType((EnumType)modelType, compositeClient);
            }
            if (modelType is CompositeType)
            {
                return FindCompositeType((CompositeType)modelType, compositeClient);
            }
            if (modelType is SequenceType)
            {
                var st = (SequenceType)modelType;
                if (st.ElementType is EnumType)
                {
                    st.ElementType = FindEnumType((EnumType)st.ElementType, compositeClient);
                }
                if (st.ElementType is CompositeType)
                {
                    st.ElementType = FindCompositeType((CompositeType)st.ElementType, compositeClient);
                }
                return st;
            }
            if (modelType is DictionaryType)
            {
                var dt = (DictionaryType)modelType;
                if (dt.ValueType is EnumType)
                {
                    dt.ValueType = FindEnumType((EnumType)dt.ValueType, compositeClient);
                }
                if (dt.ValueType is CompositeType)
                {
                    dt.ValueType = FindCompositeType((CompositeType)dt.ValueType, compositeClient);
                }
                return dt;
            }
            return modelType;
        }

        private static CompositeType FindCompositeType(CompositeType ct, CodeModel compositeClient)
        {
            if (ct != null && !ct.Name.IsNullOrEmpty())
            {
                // if this has a name, then make sure it's in the model
                if (!compositeClient.ModelTypes.Any(each => ReferenceEquals(each, ct)))
                {
                    // otherwise find the correct one in the model.
                    return compositeClient.ModelTypes.Single(each => each.Name == ct.Name);
                }
            }
            return ct;
        }

        private static EnumType FindEnumType(EnumType et, CodeModel compositeClient)
        {
            if (et != null && !et.Name.IsNullOrEmpty())
            {
                // if this has a name, then make sure it's in the model
                if (!compositeClient.EnumTypes.Any(each => ReferenceEquals(each, et)))
                {
                    // otherwise find the correct one in the model.
                    return compositeClient.EnumTypes.Single(each => each.Name == et.Name);
                }
            }
            return et;
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

        public override CodeModel Build(out IEnumerable<ValidationMessage> messages)
        {
            // No composite modeler validation messages yet
            messages = new List<ValidationMessage>();
            return Build();
        }

        /// <summary>
        /// Copares two versions of the same service specification.
        /// </summary>
        /// <returns></returns>
        public override IEnumerable<ComparisonMessage> Compare()
        {
            throw new NotImplementedException("Version comparison of compositions. Please run the comparison on individual specifications");
        }
    }
}