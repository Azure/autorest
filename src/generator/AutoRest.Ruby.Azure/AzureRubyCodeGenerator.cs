// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.ClientModel;
using AutoRest.Extensions.Azure;
using AutoRest.Extensions.Azure.Model;
using AutoRest.Ruby.Templates;
using AutoRest.Ruby.Azure.TemplateModels;
using AutoRest.Ruby.Azure.Templates;
using Newtonsoft.Json;
using AutoRest.Ruby.TemplateModels;

namespace AutoRest.Ruby.Azure
{
    /// <summary>
    /// A class with main code generation logic for Azure.Ruby.
    /// </summary>
    public class AzureRubyCodeGenerator : RubyCodeGenerator
    {

        // List of models with paging extensions.
        private IList<PageTemplateModel> pageModels;

        /// <summary>
        /// Initializes a new instance of the class AzureRubyCodeGenerator.
        /// </summary>
        /// <param name="settings">The settings.</param>
        public AzureRubyCodeGenerator(Settings settings) : base(settings)
        {
            pageModels = new List<PageTemplateModel>();
        }

        /// <summary>
        /// Gets the name of code generator.
        /// </summary>
        public override string Name
        {
            get { return "Azure.Ruby"; }
        }

        /// <summary>
        /// Gets the description of code generator.
        /// </summary>
        public override string Description
        {
            get { return "Azure specific Ruby code generator."; }
        }

        /// <summary>
        /// Gets the usage instructions for the code generator.
        /// </summary>
        public override string UsageInstructions
        {
            get { return "The \"gem 'ms_rest_azure' ~> 0.3\" is required for working with generated code."; }
        }

        /// <summary>
        /// Normalizes client model by updating names and types to be language specific.
        /// </summary>
        /// <param name="serviceClient">The service client.</param>
        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
            Settings.AddCredentials = true;
            AzureExtensions.NormalizeAzureClientModel(serviceClient, Settings, CodeNamer);
            CorrectFilterParameters(serviceClient);
            base.NormalizeClientModel(serviceClient);
            AddRubyPageableMethod(serviceClient);
            ApplyPagination(serviceClient);
        }

        /// <summary>
        /// Adds method to use for autopagination.
        /// </summary>
        /// <param name="serviceClient">The service client.</param>
        private void AddRubyPageableMethod(ServiceClient serviceClient)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException(nameof(serviceClient));
            }

            for (int i = 0; i < serviceClient.Methods.Count; i++)
            {
                Method method = serviceClient.Methods[i];
                if (method.Extensions.ContainsKey(AzureExtensions.PageableExtension))
                {
                    PageableExtension pageableExtension = JsonConvert.DeserializeObject<PageableExtension>(method.Extensions[AzureExtensions.PageableExtension].ToString());
                    if (pageableExtension != null && !method.Extensions.ContainsKey("nextLinkMethod") && !string.IsNullOrWhiteSpace(pageableExtension.NextLinkName))
                    {
                        serviceClient.Methods.Insert(i, (Method)method.Clone());
                        if (serviceClient.Methods[i].Extensions.ContainsKey("nextMethodName"))
                        {
                            serviceClient.Methods[i].Extensions["nextMethodName"] = CodeNamer.GetMethodName((string)method.Extensions["nextMethodName"]);
                        }
                        i++;
                    }
                    serviceClient.Methods[i].Extensions.Remove(AzureExtensions.PageableExtension);
                }
            }
        }

        /// <summary>
        /// Changes paginated method signatures to return Page type.
        /// </summary>
        /// <param name="serviceClient">The service client.</param>
        private void ApplyPagination(ServiceClient serviceClient)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException(nameof(serviceClient));
            }

            foreach (Method method in serviceClient.Methods.Where(m => m.Extensions.ContainsKey(AzureExtensions.PageableExtension)))
            {
                string nextLinkName = null;
                var ext = method.Extensions[AzureExtensions.PageableExtension] as Newtonsoft.Json.Linq.JContainer;
                if (ext == null)
                {
                    continue;
                }
                nextLinkName = CodeNamer.GetPropertyName((string)ext["nextLinkName"]);
                string itemName = CodeNamer.GetPropertyName((string)ext["itemName"] ?? "value");
                foreach (var responseStatus in method.Responses.Where(r => r.Value.Body is CompositeType).Select(s => s.Key).ToArray())
                {
                    CompositeType compositeType = (CompositeType)method.Responses[responseStatus].Body;
                    SequenceType sequenceType = compositeType.Properties.Select(p => p.Type).FirstOrDefault(t => t is SequenceType) as SequenceType;

                    // if the type is a wrapper over page-able response
                    if (sequenceType != null)
                    {
                        compositeType.Extensions[AzureExtensions.PageableExtension] = true;
                        PageTemplateModel pageTemplateModel = new PageTemplateModel(compositeType, serviceClient.ModelTypes, nextLinkName, itemName);
                        if (!pageModels.Contains(pageTemplateModel))
                        {
                            pageModels.Add(pageTemplateModel);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Corrects type of the filter parameter. Currently typization of filters isn't
        /// supported and therefore we provide to user an opportunity to pass it in form
        /// of raw string.
        /// </summary>
        /// <param name="serviceClient">The service client.</param>
        public static void CorrectFilterParameters(ServiceClient serviceClient)
        {
            foreach (var method in serviceClient.Methods.Where(m => m.Extensions.ContainsKey(AzureExtensions.ODataExtension)))
            {
                var filterParameter = method.Parameters
                    .FirstOrDefault(p => p.Location == ParameterLocation.Query && p.Name == "$filter");

                if (filterParameter != null)
                {
                    filterParameter.Type = new PrimaryType(KnownPrimaryType.String);
                }
            }
        }

        /// <summary>
        /// Generates Ruby code for Azure service client.
        /// </summary>
        /// <param name="serviceClient">The service client.</param>
        /// <returns>Async tasks which generates SDK files.</returns>
        public override async Task Generate(ServiceClient serviceClient)
        {
            var serviceClientTemplateModel = new AzureServiceClientTemplateModel(serviceClient);
            // Service client
            var serviceClientTemplate = new ServiceClientTemplate
            {
                Model = serviceClientTemplateModel
            };
            await Write(serviceClientTemplate, Path.Combine(sdkPath, RubyCodeNamer.UnderscoreCase(serviceClient.Name) + ImplementationFileExtension));

            // Operations
            foreach (var group in serviceClient.MethodGroups)
            {
                // Operation
                var operationsTemplate = new AzureMethodGroupTemplate
                {
                    Model = new AzureMethodGroupTemplateModel(serviceClient, group),
                };
                await Write(operationsTemplate, Path.Combine(sdkPath, RubyCodeNamer.UnderscoreCase(operationsTemplate.Model.MethodGroupName) + ImplementationFileExtension));
            }

            // Models
            foreach (var model in serviceClientTemplateModel.ModelTypes)
            {
                if ((model.Extensions.ContainsKey(AzureExtensions.ExternalExtension) &&
                    (bool)model.Extensions[AzureExtensions.ExternalExtension])
                    || model.Name == "Resource" || model.Name == "SubResource")
                {
                    continue;
                }

                var modelTemplate = new ModelTemplate
                {
                    Model = new AzureModelTemplateModel(model, serviceClient.ModelTypes),
                };
                await Write(modelTemplate, Path.Combine(modelsPath, RubyCodeNamer.UnderscoreCase(model.Name) + ImplementationFileExtension));
            }
            // Paged Models
            foreach (var pageModel in pageModels)
            {
                var pageTemplate = new PageModelTemplate
                {
                    Model = pageModel
                };
                await Write(pageTemplate, Path.Combine(modelsPath, RubyCodeNamer.UnderscoreCase(pageModel.Name) + ImplementationFileExtension));
            }

            // Enums
            foreach (var enumType in serviceClient.EnumTypes)
            {
                var enumTemplate = new EnumTemplate
                {
                    Model = new EnumTemplateModel(enumType),
                };
                await Write(enumTemplate, Path.Combine(modelsPath, RubyCodeNamer.UnderscoreCase(enumTemplate.Model.TypeDefinitionName) + ImplementationFileExtension));
            }

            // Requirements
            var requirementsTemplate = new RequirementsTemplate
            {
                Model = new AzureRequirementsTemplateModel(serviceClient, this.packageName ?? this.sdkName, this.ImplementationFileExtension, this.Settings.Namespace),
            };
            await Write(requirementsTemplate, RubyCodeNamer.UnderscoreCase(this.packageName ?? this.sdkName) + ImplementationFileExtension);

            // Version File
            if (this.packageVersion != null)
            {
                var versionTemplate = new VersionTemplate
                {
                    Model = new VersionTemplateModel(packageVersion),
                };
                await Write(versionTemplate, Path.Combine(sdkPath, "version" + ImplementationFileExtension));
            }

            // Module Definition File
            if (Settings.Namespace != null)
            {
                var modTemplate = new ModuleDefinitionTemplate
                {
                    Model = new ModuleDefinitionTemplateModel(Settings.Namespace),
                };
                await Write(modTemplate, Path.Combine(sdkPath, "module_definition" + ImplementationFileExtension));
            }
        }
    }
}
