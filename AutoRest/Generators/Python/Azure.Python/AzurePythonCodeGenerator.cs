// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.Azure.Python.Properties;
using Microsoft.Rest.Generator.Azure.Python.Templates;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Python;
using Microsoft.Rest.Generator.Python.Templates;
using Microsoft.Rest.Generator.Python.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace Microsoft.Rest.Generator.Azure.Python
{
    public class AzurePythonCodeGenerator : PythonCodeGenerator
    {
        private const string ClientRuntimePackage = "runtime.msrestazure version 1.1.0";

        // page extensions class dictionary.
        private IList<PageTemplateModel> pageModels;

        public AzurePythonCodeGenerator(Settings settings)
            : base(settings)
        {
            pageModels = new List<PageTemplateModel>();
            Namer = new AzurePythonCodeNamer();
        }

        public override string Name
        {
            get { return "Azure.Python"; }
        }

        public override string Description
        {
            // TODO resource string.
            get { return "Python for Http Client Libraries"; }
        }

        public override string UsageInstructions
        {
            get
            {
                return string.Format(CultureInfo.InvariantCulture,
                    Resources.UsageInformation, ClientRuntimePackage);
            }
        }

        /// <summary>
        /// Normalizes client model by updating names and types to be language specific.
        /// </summary>
        /// <param name="serviceClient"></param>
        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
            // Don't add pagable/longrunning method since we already handle ourself.
            Settings.AddCredentials = true;
            AzureExtensions.UpdateHeadMethods(serviceClient);
            AzureExtensions.ParseODataExtension(serviceClient);
            AzureExtensions.FlattenResourceProperties(serviceClient);
            AzureExtensions.AddAzureProperties(serviceClient);
            AzureExtensions.SetDefaultResponses(serviceClient);
            AzureExtensions.AddParameterGroups(serviceClient);

            base.NormalizeClientModel(serviceClient);
            NormalizeApiVersion(serviceClient);
            NormalizePaginatedMethods(serviceClient);
        }

        private static void NormalizeApiVersion(ServiceClient serviceClient)
        {
            serviceClient.Properties.Where(
                p => p.SerializedName.Equals(AzureExtensions.ApiVersion, StringComparison.OrdinalIgnoreCase))
                .ForEach(p => p.DefaultValue = p.DefaultValue.Replace("\"", "'"));

            serviceClient.Properties.Where(
                p => p.SerializedName.Equals(AzureExtensions.AcceptLanguage, StringComparison.OrdinalIgnoreCase))
                .ForEach(p => p.DefaultValue = p.DefaultValue.Replace("\"", "'"));
        }

        /// <summary>
        /// Creates long running operation methods.
        /// </summary>
        /// <param name="serviceClient"></param>
        public void AddLongRunningOperations(ServiceClient serviceClient)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            for (int i = 0; i < serviceClient.Methods.Count; i++)
            {
                var method = serviceClient.Methods[i];
                if (method.Extensions.ContainsKey(AzureExtensions.LongRunningExtension))
                {
                    var isLongRunning = method.Extensions[AzureExtensions.LongRunningExtension];
                    if (isLongRunning is bool && (bool)isLongRunning)
                    {
                        serviceClient.Methods.Insert(i, (Method)method.Clone());
                        method.Name = "begin" + Namer.GetMethodName(method.Name.ToPascalCase());
                        i++;
                    }

                    method.Extensions.Remove(AzureExtensions.LongRunningExtension);
                }
            }
        }

        private string GetPagingSetting(Dictionary<string, object> extensions, string valueTypeName)
        {
            var ext = extensions[AzureExtensions.PageableExtension] as Newtonsoft.Json.Linq.JContainer;

            string nextLinkName = (string)ext["nextLinkName"] ?? "nextLink";
            string itemName = (string)ext["itemName"] ?? "value";
            string className = (string)ext["className"];
            if (string.IsNullOrEmpty(className))
            {
                className = valueTypeName + "Paged";
                ext["className"] = className;
            }

            var pageModel = new PageTemplateModel(className, nextLinkName, itemName, valueTypeName);
            if (!pageModels.Contains(pageModel))
            {
                pageModels.Add(pageModel);
            }

            return className;
        }

        /// <summary>
        /// Changes paginated method signatures to return Page type.
        /// </summary>
        /// <param name="serviceClient"></param>
        private void NormalizePaginatedMethods(ServiceClient serviceClient)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            var convertedTypes = new Dictionary<IType, Response>();

            foreach (var method in serviceClient.Methods.Where(m => m.Extensions.ContainsKey(AzureExtensions.PageableExtension)))
            {
                foreach (var responseStatus in method.Responses.Where(r => r.Value.Body is CompositeType).Select(s => s.Key))
                {
                    var compositType = (CompositeType)method.Responses[responseStatus].Body;
                    var sequenceType = compositType.Properties.Select(p => p.Type).FirstOrDefault(t => t is SequenceType) as SequenceType;

                    // if the type is a wrapper over page-able response
                    if (sequenceType != null)
                    {
                        string pagableTypeName = GetPagingSetting(method.Extensions, sequenceType.ElementType.Name);

                        CompositeType pagedResult = new CompositeType
                        {
                            Name = pagableTypeName
                        };

                        convertedTypes[compositType] = new Response(pagedResult, null);
                        method.Responses[responseStatus] = convertedTypes[compositType];
                        break;
                    }
                }

                if (convertedTypes.ContainsKey(method.ReturnType.Body))
                {
                    method.ReturnType = convertedTypes[method.ReturnType.Body];
                }
            }

            AzureExtensions.RemoveUnreferencedTypes(serviceClient, convertedTypes.Keys.Cast<CompositeType>().Select(t => t.Name));
        }

        /// <summary>
        /// Generate Python client code for given ServiceClient.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <returns></returns>
        public override async Task Generate(ServiceClient serviceClient)
        {
            var serviceClientTemplateModel = new AzureServiceClientTemplateModel(serviceClient);

            if (!string.IsNullOrWhiteSpace(Version))
            {
                serviceClientTemplateModel.Version = Version;
            }

            // Service client
            var setupTemplate = new SetupTemplate
            {
                Model = serviceClientTemplateModel
            };
            await Write(setupTemplate, "setup.py");

            var serviceClientInitTemplate = new ServiceClientInitTemplate
            {
                Model = serviceClientTemplateModel
            };
            await Write(serviceClientInitTemplate, Path.Combine(serviceClient.Name.ToPythonCase(), "__init__.py"));

            var serviceClientTemplate = new AzureServiceClientTemplate
            {
                Model = serviceClientTemplateModel,
            };
            await Write(serviceClientTemplate, Path.Combine(serviceClient.Name.ToPythonCase(), "api_client.py"));

            //Models
            if (serviceClientTemplateModel.ModelTemplateModels.Any())
            {
                var modelInitTemplate = new AzureModelInitTemplate
                {
                    Model = new AzureModelInitTemplateModel(serviceClient, pageModels.Select(t => t.TypeDefinitionName))
                };
                await Write(modelInitTemplate, Path.Combine(serviceClient.Name.ToPythonCase(), "models", "__init__.py"));

                foreach (var modelType in serviceClientTemplateModel.ModelTemplateModels)
                {
                    var modelTemplate = new ModelTemplate
                    {
                        Model = modelType
                    };
                    await Write(modelTemplate, Path.Combine(serviceClient.Name.ToPythonCase(), "models", modelType.Name.ToPythonCase() + ".py"));
                }
            }

            //MethodGroups
            if (serviceClientTemplateModel.MethodGroupModels.Any())
            {
                var methodGroupIndexTemplate = new MethodGroupInitTemplate
                {
                    Model = serviceClientTemplateModel
                };
                await Write(methodGroupIndexTemplate, Path.Combine(serviceClient.Name.ToPythonCase(), "operations", "__init__.py"));

                foreach (var methodGroupModel in serviceClientTemplateModel.MethodGroupModels)
                {
                    var methodGroupTemplate = new AzureMethodGroupTemplate
                    {
                        Model = methodGroupModel as AzureMethodGroupTemplateModel
                    };
                    await Write(methodGroupTemplate, Path.Combine(serviceClient.Name.ToPythonCase(), "operations", methodGroupModel.MethodGroupType.ToPythonCase() + ".py"));
                }
            }

            // Enums
            if (serviceClient.EnumTypes.Any())
            {
                var enumTemplate = new EnumTemplate
                {
                    Model = new EnumTemplateModel(serviceClient.EnumTypes),
                };
                await Write(enumTemplate, Path.Combine(serviceClient.Name.ToPythonCase(), "models", "enums.py"));
            }

            // Page class
            foreach (var pageModel in pageModels)
            {
                var pageTemplate = new PageTemplate
                {
                    Model = pageModel
                };
                await Write(pageTemplate, Path.Combine(serviceClient.Name.ToPythonCase(), "models", pageModel.TypeDefinitionName.ToPythonCase() + ".py"));
            }
        }
    }
}
