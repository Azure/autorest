// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Threading.Tasks;
using AutoRest.Generator.Azure.Ruby.Templates;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Ruby;
using Microsoft.Rest.Generator.Ruby.Templates;

namespace Microsoft.Rest.Generator.Azure.Ruby
{
    public class AzureRubyCodeGenerator : AzureCodeGenerator
    {
        private readonly RubyCodeNamingFramework _namingFramework;

        public AzureRubyCodeGenerator(Settings settings) : base(settings)
        {
            _namingFramework = new RubyCodeNamingFramework();
        }

        public override string Name
        {
            get { return "Azure.Ruby"; }
        }

        public override string Description
        {
            get { return "Ruby for Http Client Libraries"; }
        }

        public override string UsageInstructions
        {
            get { return "TODO"; }
        }

        public override string ImplementationFileExtension
        {
            get { return ".rb"; }
        }

        /// <summary>
        /// Normalizes client model by updating names and types to be language specific.
        /// </summary>
        /// <param name="serviceClient"></param>
        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
            base.NormalizeClientModel(serviceClient);
            _namingFramework.NormalizeClientModel(serviceClient);
            _namingFramework.ResolveNameCollisions(serviceClient, Settings.Namespace,
                Settings.Namespace + ".Models");
        }

        /// <summary>
        /// Generates C# code for service client.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <returns></returns>
        public override async Task Generate(ServiceClient serviceClient)
        {
            // Service client
            var serviceClientTemplate = new ServiceClientTemplate
            {
                Model = new AzureServiceClientTemplateModel(serviceClient),
            };
            await Write(serviceClientTemplate, RubyCodeNamingFramework.UnderscoreCase(serviceClient.Name) + ImplementationFileExtension);

            //// Service client extensions
            //var extensionsTemplate = new ExtensionsTemplate
            //{
            //    Model = new AzureExtensionsTemplateModel(serviceClient, null),
            //};
            //await Write(extensionsTemplate, serviceClient.Name + "Extensions.cs");

            //// Service client interface
            //var serviceClientInterfaceTemplate = new ServiceClientInterfaceTemplate
            //{
            //    Model = new AzureServiceClientTemplateModel(serviceClient),
            //};
            //await Write(serviceClientInterfaceTemplate, "I" + serviceClient.Name + ".rb");

            // Operations
            foreach (var group in serviceClient.MethodGroups)
            {
                // Operation
                var operationsTemplate = new AzureMethodGroupTemplate
                {
                    Model = new AzureMethodGroupTemplateModel(serviceClient, group),
                };
                await Write(operationsTemplate, RubyCodeNamingFramework.UnderscoreCase(operationsTemplate.Model.MethodGroupName) + ImplementationFileExtension);

                //// Service client extensions
                //var operationExtensionsTemplate = new ExtensionsTemplate
                //{
                //    Model = new AzureExtensionsTemplateModel(serviceClient, group),
                //};
                //await Write(operationExtensionsTemplate, operationExtensionsTemplate.Model.ExtensionName + "Extensions.rb");

                //// Operation interface
                //var operationsInterfaceTemplate = new MethodGroupInterfaceTemplate
                //{
                //    Model = new AzureMethodGroupTemplateModel(serviceClient, group),
                //};
                //await Write(operationsInterfaceTemplate, "I" + operationsInterfaceTemplate.Model.MethodGroupType + ".rb");
            }

            // Models
            foreach (var model in serviceClient.ModelTypes)
            {
                if (model.Extensions.ContainsKey(ExternalExtension))
                {
                    continue;
                }

                var modelTemplate = new ModelTemplate
                {
                    Model = new AzureModelTemplateModel(model, serviceClient),
                };

                await Write(modelTemplate, "Models\\" + RubyCodeNamingFramework.UnderscoreCase(model.Name) + ImplementationFileExtension);
            }

            // Enums
            foreach (var enumType in serviceClient.EnumTypes)
            {
                var enumTemplate = new EnumTemplate
                {
                    Model = new EnumTemplateModel(enumType),
                };
                await Write(enumTemplate, "Models\\" + RubyCodeNamingFramework.UnderscoreCase(enumTemplate.Model.TypeDefinitionName) + ImplementationFileExtension);
            }

            // Requirements
            var requirementsTemplate = new RequirementsTemplate
            {
                Model = new AzureRequirementsTemplateModel(serviceClient),
            };
            await Write(requirementsTemplate,
                RubyCodeNamingFramework.UnderscoreCase("sdk_requirements") + ImplementationFileExtension);
        }
    }
}
