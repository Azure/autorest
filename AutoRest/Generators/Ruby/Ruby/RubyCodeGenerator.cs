// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Threading.Tasks;
using System.IO;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Ruby.Templates;

namespace Microsoft.Rest.Generator.Ruby
{
    /// <summary>
    /// A class with main code generation logic for Ruby.
    /// </summary>
    public class RubyCodeGenerator : CodeGenerator
    {
        /// <summary>
        /// A code namer instance (object which is responsible for correct files/variables naming).
        /// </summary>
        private readonly RubyCodeNamer codeNamer;

        /// <summary>
        /// The name of the SDK. Determined in the following way:
        /// if the parameter 'Name' is provided that it becames the
        /// name of the SDK, otherwise the name of input swagger is converted
        /// into Ruby style and taken as name.
        /// </summary>
        protected readonly string sdkName;

        /// <summary>
        /// Relative path to produced SDK files.
        /// </summary>
        protected readonly string sdkPath;

        /// <summary>
        /// Relative path to produced SDK model files.
        /// </summary>
        protected readonly string modelsPath;

        /// <summary>
        /// Initializes a new instance of the class RubyCodeGenerator.
        /// </summary>
        /// <param name="settings">The settings.</param>
        public RubyCodeGenerator(Settings settings) : base(settings)
        {
            codeNamer = new RubyCodeNamer();

            if (Settings.CustomSettings.ContainsKey("Name"))
            {
                sdkName = Settings.CustomSettings["Name"];
            }
            else
            {
                sdkName = Path.GetFileNameWithoutExtension(Settings.Input);
            }

            sdkName = RubyCodeNamer.UnderscoreCase(codeNamer.RubyRemoveInvalidCharacters(sdkName));
            sdkPath = sdkName;
            modelsPath = Path.Combine(sdkPath, "models");
        }

        /// <summary>
        /// Gets the name of code generator.
        /// </summary>
        public override string Name
        {
            get { return "Ruby"; }
        }

        /// <summary>
        /// Gets the brief description of the code generator.
        /// </summary>
        public override string Description
        {
            get { return "Ruby for Http Client Libraries"; }
        }

        /// <summary>
        /// Gets the brief instructions required to complete before using the code generator.
        /// </summary>
        public override string UsageInstructions
        {
            get { return "The gem 'ms-rest' is required for working with generated code."; }
        }

        /// <summary>
        /// Gets the file extension of the generated code files.
        /// </summary>
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

        /// <summary>
        /// Adds special properties to the service client (e.g. credentials).
        /// </summary>
        /// <param name="serviceClientModel">The service client.</param>
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
        /// <param name="serviceClient">The service client.</param>
        /// <returns>Async task for generating SDK files.</returns>
        public override async Task Generate(ServiceClient serviceClient)
        {
            // Service client
            var serviceClientTemplate = new ServiceClientTemplate
            {
                Model = new ServiceClientTemplateModel(serviceClient),
            };
            await Write(serviceClientTemplate,
                Path.Combine(sdkPath, RubyCodeNamer.UnderscoreCase(serviceClient.Name) + ImplementationFileExtension));

            // Method groups
            foreach (var group in serviceClient.MethodGroups)
            {
                var groupTemplate = new MethodGroupTemplate
                {
                    Model = new MethodGroupTemplateModel(serviceClient, group),
                };
                await Write(groupTemplate,
                    Path.Combine(sdkPath, RubyCodeNamer.UnderscoreCase(group) + ImplementationFileExtension));
            }

            // Models
            foreach (var model in serviceClient.ModelTypes)
            {
                var modelTemplate = new ModelTemplate
                {
                    Model = new ModelTemplateModel(model)
                };
                await Write(modelTemplate,
                    Path.Combine(modelsPath, RubyCodeNamer.UnderscoreCase(model.Name) + ImplementationFileExtension));
            }

            // Enums
            foreach (var enumType in serviceClient.EnumTypes)
            {
                var enumTemplate = new EnumTemplate
                {
                    Model = new EnumTemplateModel(enumType),
                };
                await Write(enumTemplate,
                    Path.Combine(modelsPath, RubyCodeNamer.UnderscoreCase(enumTemplate.Model.TypeDefinitionName) + ImplementationFileExtension));
            }

            // Requirements
            var requirementsTemplate = new RequirementsTemplate
            {
                Model = new RequirementsTemplateModel(serviceClient, sdkName, this.ImplementationFileExtension),
            };
            await Write(requirementsTemplate,
                RubyCodeNamer.UnderscoreCase(sdkName) + ImplementationFileExtension);
        }
    }
}
