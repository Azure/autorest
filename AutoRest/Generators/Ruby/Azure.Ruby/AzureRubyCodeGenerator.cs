// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Threading.Tasks;
using Microsoft.Rest.Generator.Azure.Ruby.Templates;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Ruby;
using Microsoft.Rest.Generator.Ruby.Templates;
using System.IO;

namespace Microsoft.Rest.Generator.Azure.Ruby
{
    public class AzureRubyCodeGenerator : RubyCodeGenerator
    {
        public AzureRubyCodeGenerator(Settings settings) : base(settings)
        {
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

        /// <summary>
        /// Gets the exte
        /// </summary>
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
            Settings.AddCredentials = true;
            AzureCodeGenerator.UpdateHeadMethods(serviceClient);
            AzureCodeGenerator.ParseODataExtension(serviceClient);
            AzureCodeGenerator.AddPageableMethod(serviceClient);
            AzureCodeGenerator.AddLongRunningOperations(serviceClient);
            AzureCodeGenerator.AddAzureProperties(serviceClient);
            AzureCodeGenerator.SetDefaultResponses(serviceClient);
            base.NormalizeClientModel(serviceClient);
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
            await Write(serviceClientTemplate, RubyCodeNamer.UnderscoreCase(serviceClient.Name) + ImplementationFileExtension);

            // Operations
            foreach (var group in serviceClient.MethodGroups)
            {
                // Operation
                var operationsTemplate = new AzureMethodGroupTemplate
                {
                    Model = new AzureMethodGroupTemplateModel(serviceClient, group),
                };
                await Write(operationsTemplate, RubyCodeNamer.UnderscoreCase(operationsTemplate.Model.MethodGroupName) + ImplementationFileExtension);
            }

            // Models
            foreach (var model in serviceClient.ModelTypes)
            {
                if (model.Extensions.ContainsKey("x-ms-external"))
                {
                    continue;
                }

                var modelTemplate = new ModelTemplate
                {
                    Model = new AzureModelTemplateModel(model, serviceClient),
                };

                await Write(modelTemplate, Path.Combine("models", RubyCodeNamer.UnderscoreCase(model.Name) + ImplementationFileExtension));
            }

            // Enums
            foreach (var enumType in serviceClient.EnumTypes)
            {
                var enumTemplate = new EnumTemplate
                {
                    Model = new EnumTemplateModel(enumType),
                };
                await Write(enumTemplate, Path.Combine("models", RubyCodeNamer.UnderscoreCase(enumTemplate.Model.TypeDefinitionName) + ImplementationFileExtension));
            }

            // Requirements
            var requirementsTemplate = new RequirementsTemplate
            {
                Model = new AzureRequirementsTemplateModel(serviceClient),
            };
            await Write(requirementsTemplate,
                RubyCodeNamer.UnderscoreCase("sdk_requirements") + ImplementationFileExtension);
        }
    }
}
