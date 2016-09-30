// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.IO;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;
using AutoRest.Ruby.TemplateModels;
using AutoRest.Ruby.Templates;

namespace AutoRest.Ruby
{
    /// <summary>
    /// A class with main code generation logic for Ruby.
    /// </summary>
    public class RubyCodeGenerator : CodeGenerator
    {
        /// <summary>
        /// Name of the generated sub-folder inside ourput directory.
        /// </summary>
        private const string GeneratedFolderName = "generated";

        /// <summary>
        /// The name of the SDK. Determined in the following way:
        /// if the parameter 'Name' is provided that it becomes the
        /// name of the SDK, otherwise the name of input swagger is converted
        /// into Ruby style and taken as name.
        /// </summary>
        protected readonly string sdkName;

        /// <summary>
        /// The name of the package version to be used in creating a version.rb file
        /// </summary>
        protected readonly string packageVersion;

        /// <summary>
        /// The name of the package name to be used in creating a version.rb file
        /// </summary>
        protected readonly string packageName;

        /// <summary>
        /// Relative path to produced SDK files.
        /// </summary>
        protected readonly string sdkPath;

        /// <summary>
        /// Relative path to produced SDK model files.
        /// </summary>
        protected readonly string modelsPath;

        /// <summary>
        /// A code namer instance (object which is responsible for correct files/variables naming).
        /// </summary>
        protected RubyCodeNamer CodeNamer { get; private set; }

        /// <summary>
        /// Initializes a new instance of the class RubyCodeGenerator.
        /// </summary>
        /// <param name="settings">The settings.</param>
        public RubyCodeGenerator(Settings settings) : base(settings)
        {
            CodeNamer = new RubyCodeNamer();
            this.packageVersion = Settings.PackageVersion;
            this.packageName = Settings.PackageName;

            if (Settings.CustomSettings.ContainsKey("Name"))
            {
                this.sdkName = Settings.CustomSettings["Name"].ToString();
            }

            if (sdkName == null)
            {
                this.sdkName = Path.GetFileNameWithoutExtension(Settings.Input);
            }

            if (sdkName == null)
            {
                sdkName = "client";
            }

            this.sdkName = RubyCodeNamer.UnderscoreCase(CodeNamer.RubyRemoveInvalidCharacters(this.sdkName));
            this.sdkPath = this.packageName ?? this.sdkName;
            this.modelsPath = Path.Combine(this.sdkPath, "models");

            // AutoRest generated code for Ruby and Azure.Ruby generator will live inside "generated" sub-folder
            settings.OutputDirectory = Path.Combine(settings.OutputDirectory, GeneratedFolderName);
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
            get { return "Generic Ruby code generator."; }
        }

        /// <summary>
        /// Gets the brief instructions required to complete before using the code generator.
        /// </summary>
        public override string UsageInstructions
        {
            get { return "The \"gem 'ms_rest' ~> 0.5\" is required for working with generated code."; }
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
        /// <param name="serviceClient"></param>
        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
            SwaggerExtensions.NormalizeClientModel(serviceClient, Settings);
            PopulateAdditionalProperties(serviceClient);
            CodeNamer.NormalizeClientModel(serviceClient);
            CodeNamer.ResolveNameCollisions(serviceClient, Settings.Namespace,
                Settings.Namespace + "::Models");
        }

        /// <summary>
        /// Adds special properties to the service client (e.g. credentials).
        /// </summary>
        /// <param name="serviceClient">The service client.</param>
        private void PopulateAdditionalProperties(ServiceClient serviceClient)
        {
            if (Settings.AddCredentials)
            {
                if (!serviceClient.Properties.Any(p => p.Type.IsPrimaryType(KnownPrimaryType.Credentials)))
                {
                    serviceClient.Properties.Add(new Property
                    {
                        Name = "Credentials",
                        Type = new PrimaryType(KnownPrimaryType.Credentials),
                        IsRequired = true,
                        Documentation = "Subscription credentials which uniquely identify client subscription."
                    });
                }
            }
        }

        /// <summary>
        /// Generates Ruby code for service client.
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
                    Model = new ModelTemplateModel(model, serviceClient.ModelTypes)
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
                Model = new RequirementsTemplateModel(serviceClient, this.packageName ?? this.sdkName, this.ImplementationFileExtension, this.Settings.Namespace),
            };
            await Write(requirementsTemplate, RubyCodeNamer.UnderscoreCase(this.packageName ?? this.sdkName) + ImplementationFileExtension);

            // Version File
            if (!string.IsNullOrEmpty(this.packageVersion))
            {
                var versionTemplate = new VersionTemplate
                {
                    Model = new VersionTemplateModel(packageVersion),
                };
                await Write(versionTemplate, Path.Combine(sdkPath, "version" + ImplementationFileExtension));
            }

            // Module Definition File
            if (!string.IsNullOrEmpty(Settings.Namespace))
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
