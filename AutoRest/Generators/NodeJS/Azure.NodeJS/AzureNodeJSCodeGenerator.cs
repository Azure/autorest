// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Rest.Generator.Azure.NodeJS.Properties;
using Microsoft.Rest.Generator.Azure.NodeJS.Templates;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.NodeJS;
using Microsoft.Rest.Generator.NodeJS.Templates;
using Microsoft.Rest.Generator.Utilities;
using System.Collections.Generic;

namespace Microsoft.Rest.Generator.Azure.NodeJS
{
    public class AzureNodeJSCodeGenerator : NodeJSCodeGenerator
    {
        private const string ClientRuntimePackage = "ms-rest-azure version 1.14.2";

        // List of models with paging extensions.
        private IList<PageTemplateModel> pageModels;

        public AzureNodeJSCodeGenerator(Settings settings)
            : base(settings)
        {
            pageModels = new List<PageTemplateModel>();
        }

        public override string Name
        {
            get { return "Azure.NodeJS"; }
        }

        public override string Description
        {
            // TODO resource string.
            get { return "Azure specific NodeJS code generator."; }
        }

        public override string UsageInstructions
        {
            get
            {
                return string.Format(CultureInfo.InvariantCulture,
                    Resources.UsageInformation, ClientRuntimePackage);
            }
        }

        public override string ImplementationFileExtension
        {
            get { return ".js"; }
        }

        /// <summary>
        /// Normalizes client model by updating names and types to be language specific.
        /// </summary>
        /// <param name="serviceClient"></param>
        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
            // MethodNames are normalized explicitly to provide a consitent method name while 
            // generating cloned methods for long running operations with reserved words. For
            // example - beginDeleteMethod() insteadof beginDelete() as delete is a reserved word.
            Namer.NormalizeMethodNames(serviceClient);
            AzureExtensions.NormalizeAzureClientModel(serviceClient, Settings, Namer);
            base.NormalizeClientModel(serviceClient);
            NormalizeApiVersion(serviceClient);
            NormalizePaginatedMethods(serviceClient);
            ExtendAllResourcesToBaseResource(serviceClient);
        }

        private static void ExtendAllResourcesToBaseResource(ServiceClient serviceClient)
        {
            if (serviceClient != null)
            {
                foreach (var model in serviceClient.ModelTypes)
                {
                    if (model.Extensions.ContainsKey(AzureExtensions.AzureResourceExtension) &&
                        (bool)model.Extensions[AzureExtensions.AzureResourceExtension])
                    {
                        model.BaseModelType = new CompositeType { Name = "BaseResource", SerializedName = "BaseResource" };
                    }
                }
            }
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
        /// Changes paginated method signatures to return Page type.
        /// </summary>
        /// <param name="serviceClient"></param>
        public virtual void NormalizePaginatedMethods(ServiceClient serviceClient)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            foreach (var method in serviceClient.Methods.Where(m => m.Extensions.ContainsKey(AzureExtensions.PageableExtension)))
            {
                string nextLinkName = null;
                var ext = method.Extensions[AzureExtensions.PageableExtension] as Newtonsoft.Json.Linq.JContainer;
                if (ext == null)
                {
                    continue;
                }
                
                nextLinkName = (string)ext["nextLinkName"];
                string itemName = (string)ext["itemName"] ?? "value";
                foreach (var responseStatus in method.Responses.Where(r => r.Value.Body is CompositeType).Select(s => s.Key).ToArray())
                {
                    var compositType = (CompositeType)method.Responses[responseStatus].Body;
                    var sequenceType = compositType.Properties.Select(p => p.Type).FirstOrDefault(t => t is SequenceType) as SequenceType;

                    // if the type is a wrapper over page-able response
                    if (sequenceType != null)
                    {
                        compositType.Extensions[AzureExtensions.PageableExtension] = true;
                        var pageTemplateModel = new PageTemplateModel(compositType, serviceClient, nextLinkName, itemName);
                        if (!pageModels.Contains(pageTemplateModel))
                        {
                            pageModels.Add(pageTemplateModel);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Generate Azure NodeJS client code for given ServiceClient.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <returns></returns>
        public override async Task Generate(ServiceClient serviceClient)
        {
            var serviceClientTemplateModel = new AzureServiceClientTemplateModel(serviceClient);
            // Service client
            var serviceClientTemplate = new Microsoft.Rest.Generator.Azure.NodeJS.Templates.AzureServiceClientTemplate
            {
                Model = serviceClientTemplateModel
            };
            await Write(serviceClientTemplate, serviceClient.Name.ToCamelCase() + ".js");

            if (!DisableTypeScriptGeneration)
            {
                var serviceClientTemplateTS = new AzureServiceClientTemplateTS
                {
                    Model = serviceClientTemplateModel,
                };
                await Write(serviceClientTemplateTS, serviceClient.Name.ToCamelCase() + ".d.ts");
            }

            //Models
            if (serviceClient.ModelTypes.Any())
            {
                // Paged Models
                foreach (var pageModel in pageModels)
                {
                    //Add the PageTemplateModel to AzureServiceClientTemplateModel
                    if (!serviceClientTemplateModel.PageTemplateModels.Contains(pageModel))
                    {
                        serviceClientTemplateModel.PageTemplateModels.Add(pageModel);
                    }
                    var pageTemplate = new PageModelTemplate
                    {
                        Model = pageModel
                    };
                    await Write(pageTemplate, Path.Combine("models", pageModel.Name.ToCamelCase() + ".js"));
                }

                var modelIndexTemplate = new AzureModelIndexTemplate
                {
                    Model = serviceClientTemplateModel
                };
                await Write(modelIndexTemplate, Path.Combine("models", "index.js"));

                if (!DisableTypeScriptGeneration)
                {
                    var modelIndexTemplateTS = new AzureModelIndexTemplateTS
                    {
                        Model = serviceClientTemplateModel
                    };
                    await Write(modelIndexTemplateTS, Path.Combine("models", "index.d.ts"));
                }

                foreach (var modelType in serviceClientTemplateModel.ModelTemplateModels)
                {
                    var modelTemplate = new ModelTemplate
                    {
                        Model = modelType
                    };
                    await Write(modelTemplate, Path.Combine("models", modelType.Name.ToCamelCase() + ".js"));
                }
            }

            //MethodGroups
            if (serviceClientTemplateModel.MethodGroupModels.Any())
            {
                var methodGroupIndexTemplate = new MethodGroupIndexTemplate
                {
                    Model = serviceClientTemplateModel
                };
                await Write(methodGroupIndexTemplate, Path.Combine("operations", "index.js"));

                if (!DisableTypeScriptGeneration)
                {
                    var methodGroupIndexTemplateTS = new MethodGroupIndexTemplateTS
                    {
                        Model = serviceClientTemplateModel
                    };
                    await Write(methodGroupIndexTemplateTS, Path.Combine("operations", "index.d.ts"));
                }
                
                foreach (var methodGroupModel in serviceClientTemplateModel.MethodGroupModels)
                {
                    var methodGroupTemplate = new AzureMethodGroupTemplate
                    {
                        Model = methodGroupModel as AzureMethodGroupTemplateModel
                    };
                    await Write(methodGroupTemplate, Path.Combine("operations", methodGroupModel.MethodGroupType.ToCamelCase() + ".js"));
                }
            }
        }
    }
}
