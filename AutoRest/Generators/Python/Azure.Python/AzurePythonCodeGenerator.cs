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
        private const string ClientRuntimePackage = "msrestazure version 0.4.0";

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
            get { return "Azure specific Python code generator."; }
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
            AzureExtensions.ProcessClientRequestIdExtension(serviceClient);
            AzureExtensions.UpdateHeadMethods(serviceClient);
            AzureExtensions.ParseODataExtension(serviceClient);
            Extensions.FlattenModels(serviceClient);
            ParameterGroupExtensionHelper.AddParameterGroups(serviceClient);
            AzureExtensions.AddAzureProperties(serviceClient);
            AzureExtensions.SetDefaultResponses(serviceClient);
            CorrectFilterParameters(serviceClient);

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

            Extensions.RemoveUnreferencedTypes(serviceClient, new HashSet<string>(convertedTypes.Keys.Cast<CompositeType>().Select(t => t.Name)));
        }

        /// <summary>
        /// Corrects type of the filter parameter. Currently typization of filters isn't
        /// supported and therefore we provide to user an opportunity to pass it in form
        /// of raw string.
        /// </summary>
        /// <param name="serviceClient">The service client.</param>
        public static void CorrectFilterParameters(ServiceClient serviceClient)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            foreach (var method in serviceClient.Methods.Where(m => m.Extensions.ContainsKey(AzureExtensions.ODataExtension)))
            {
                var filterParameter = method.Parameters.FirstOrDefault(p =>
                        p.SerializedName.Equals("$filter", StringComparison.OrdinalIgnoreCase) &&
                        p.Location == ParameterLocation.Query &&
                        p.Type is CompositeType);

                if (filterParameter != null)
                {
                    filterParameter.Type = new PrimaryType(KnownPrimaryType.String);
                }
            }
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
            await Write(serviceClientInitTemplate, Path.Combine(serviceClientTemplateModel.PackageName, "__init__.py"));

            var serviceClientTemplate = new AzureServiceClientTemplate
            {
                Model = serviceClientTemplateModel,
            };
            await Write(serviceClientTemplate, Path.Combine(serviceClientTemplateModel.PackageName, serviceClientTemplateModel.Name.ToPythonCase() + ".py"));

            var versionTemplate = new VersionTemplate
            {
                Model = serviceClientTemplateModel,
            };
            await Write(versionTemplate, Path.Combine(serviceClientTemplateModel.PackageName, "version.py"));

            var exceptionTemplate = new ExceptionTemplate
            {
                Model = serviceClientTemplateModel,
            };
            await Write(exceptionTemplate, Path.Combine(serviceClientTemplateModel.PackageName, "exceptions.py"));

            var credentialTemplate = new CredentialTemplate
            {
                Model = serviceClientTemplateModel,
            };
            await Write(credentialTemplate, Path.Combine(serviceClientTemplateModel.PackageName, "credentials.py"));

            //Models
            if (serviceClientTemplateModel.ModelTemplateModels.Any())
            {
                var modelInitTemplate = new AzureModelInitTemplate
                {
                    Model = new AzureModelInitTemplateModel(serviceClient, pageModels.Select(t => t.TypeDefinitionName))
                };
                await Write(modelInitTemplate, Path.Combine(serviceClientTemplateModel.PackageName, "models", "__init__.py"));

                foreach (var modelType in serviceClientTemplateModel.ModelTemplateModels)
                {
                    var modelTemplate = new ModelTemplate
                    {
                        Model = modelType
                    };
                    await Write(modelTemplate, Path.Combine(serviceClientTemplateModel.PackageName, "models", modelType.Name.ToPythonCase() + ".py"));
                }
            }

            //MethodGroups
            if (serviceClientTemplateModel.MethodGroupModels.Any())
            {
                var methodGroupIndexTemplate = new MethodGroupInitTemplate
                {
                    Model = serviceClientTemplateModel
                };
                await Write(methodGroupIndexTemplate, Path.Combine(serviceClientTemplateModel.PackageName, "operations", "__init__.py"));

                foreach (var methodGroupModel in serviceClientTemplateModel.MethodGroupModels)
                {
                    var methodGroupTemplate = new AzureMethodGroupTemplate
                    {
                        Model = methodGroupModel as AzureMethodGroupTemplateModel
                    };
                    await Write(methodGroupTemplate, Path.Combine(serviceClientTemplateModel.PackageName, "operations", methodGroupModel.MethodGroupType.ToPythonCase() + ".py"));
                }
            }

            // Enums
            if (serviceClient.EnumTypes.Any())
            {
                var enumTemplate = new EnumTemplate
                {
                    Model = new EnumTemplateModel(serviceClient.EnumTypes),
                };
                await Write(enumTemplate, Path.Combine(serviceClientTemplateModel.PackageName, "models", serviceClientTemplateModel.Name.ToPythonCase() + "_enums.py"));
            }

            // Page class
            foreach (var pageModel in pageModels)
            {
                var pageTemplate = new PageTemplate
                {
                    Model = pageModel
                };
                await Write(pageTemplate, Path.Combine(serviceClientTemplateModel.PackageName, "models", pageModel.TypeDefinitionName.ToPythonCase() + ".py"));
            }
        }
    }
}
