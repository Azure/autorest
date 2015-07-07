// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Threading.Tasks;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Ruby.Templates;

namespace Microsoft.Rest.Generator.Ruby
{
    public class RubyCodeGenerator : CodeGenerator
    {
        private readonly RubyCodeNamer codeNamer;

        public RubyCodeGenerator(Settings settings) : base(settings)
        {
            codeNamer = new RubyCodeNamer();
        }

        public override string Name
        {
            get { return "Ruby"; }
        }

        public override string Description
        {
            get { return "Ruby for Http Client Libraries"; }
        }

        public override string UsageInstructions
        {
            get { return "Require to install ClientRuntime gem"; }
        }

        public override string ImplementationFileExtension
        {
            get { return ".rb"; }
        }

        /// <summary>
        /// Normalizes client model by updating names and types to be language specific.
        /// </summary>
        /// <param name="serviceClientModel"></param>
        public override void NormalizeClientModel(ServiceClient serviceClientModel)
        {
            PopulateAdditionalProperties(serviceClientModel);
            codeNamer.NormalizeClientModel(serviceClientModel);
            codeNamer.ResolveNameCollisions(serviceClientModel, Settings.Namespace,
                Settings.Namespace + "::Models");
        }

        private void PopulateAdditionalProperties(ServiceClient serviceClientModel)
        {
            if (Settings.AddCredentials)
            {
                serviceClientModel.Properties.Add(new Property
                {
                    Name = "Credentials",
                    Type = new CompositeType
                    {
                        Name = "ServiceClient"
                    },
                    IsRequired = true,
                    Documentation = "Subscription credentials which uniquely identify client subscription."
                });
            }
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
                Model = new ServiceClientTemplateModel(serviceClient),
            };
            await Write(serviceClientTemplate, 
                RubyCodeNamer.UnderscoreCase(serviceClient.Name) + ImplementationFileExtension);

            // Method groups
            foreach (var group in serviceClient.MethodGroups)
            {
                var groupTemplate = new MethodGroupTemplate
                {
                    Model = new MethodGroupTemplateModel(serviceClient, group),
                };
                await Write(groupTemplate,
                    RubyCodeNamer.UnderscoreCase(group) + ImplementationFileExtension);
            }

            // Models
            foreach (var model in serviceClient.ModelTypes)
            {
                var modelTemplate = new ModelTemplate
                {
                    Model = new ModelTemplateModel(model, serviceClient),
                };
                await Write(modelTemplate, "Models\\" +
                    RubyCodeNamer.UnderscoreCase(model.Name) + ImplementationFileExtension);
            }

            // Enums
            foreach (var enumType in serviceClient.EnumTypes)
            {
                var enumTemplate = new EnumTemplate
                {
                    Model = new EnumTemplateModel(enumType),
                };
                await Write(enumTemplate, "Models\\" + RubyCodeNamer.UnderscoreCase(enumTemplate.Model.TypeDefinitionName) + ImplementationFileExtension);
            }

            // Requirements
            var requirementsTemplate = new RequirementsTemplate
            {
                Model = new RequirementsTemplateModel(serviceClient),
            };
            await Write(requirementsTemplate,
                RubyCodeNamer.UnderscoreCase("sdk_requirements") + ImplementationFileExtension);
        }
    }
}
