// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Ruby.Model;
using AutoRest.Ruby.Templates;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Ruby
{
    /// <summary>
    ///     A class with main code generation logic for Ruby.
    /// </summary>
    public class CodeGeneratorRb : CodeGenerator
    {
        /// <summary>
        ///     Name of the generated sub-folder inside ourput directory.
        /// </summary>
        private const string GeneratedFolderName = "generated";

        public CodeGeneratorRb() 
        {
            // todo: make sure this doesn't happen more than once.
            Settings.Instance.OutputDirectory = Path.Combine(Settings.Instance.OutputDirectory,
                GeneratedFolderName);
        }

        /// <summary>
        ///     Gets the file extension of the generated code files.
        /// </summary>
        public override string ImplementationFileExtension => ".rb";

        /// <summary>
        ///     Gets the brief instructions required to complete before using the code generator.
        /// </summary>
        public override string UsageInstructions
            => @"The ""gem 'ms_rest' ~> 0.6"" is required for working with generated code.";

        public CodeNamerRb CodeNamer => Singleton<CodeNamerRb>.Instance;

        /// <summary>
        ///     Generates Ruby code for service client.
        /// </summary>
        /// <param name="cm">The code model.</param>
        /// <returns>Async task for generating SDK files.</returns>
        public override async Task Generate(CodeModel cm)
        {
            var codeModel = cm as CodeModelRb;
            if (codeModel == null)
            {
                throw new InvalidCastException("CodeModel is not a Ruby code model.");
            }

            // Service client
            var serviceClientTemplate = new ServiceClientTemplate { Model = codeModel };
            await Write(serviceClientTemplate,
                Path.Combine(GeneratorSettingsRb.Instance.sdkPath, CodeNamer.UnderscoreCase(codeModel.Name) + ImplementationFileExtension));

            // Method groups
            foreach (MethodGroupRb group in codeModel.Operations.Where( each => !each.IsCodeModelMethodGroup))
            {
                var groupTemplate = new MethodGroupTemplate { Model = group };
                await Write(groupTemplate,
                    Path.Combine(GeneratorSettingsRb.Instance.sdkPath, CodeNamer.UnderscoreCase(@group.TypeName) + ImplementationFileExtension));
            }

            // Models
            foreach (CompositeTypeRb model in codeModel.ModelTypes)
            {
                var modelTemplate = new ModelTemplate { Model = model };
                await Write(modelTemplate,
                    Path.Combine(GeneratorSettingsRb.Instance.modelsPath, CodeNamer.UnderscoreCase(model.Name) + ImplementationFileExtension));
            }

            // Enums
            foreach (EnumTypeRb enumType in codeModel.EnumTypes)
            {
                var enumTemplate = new EnumTemplate { Model = enumType };
                await Write(enumTemplate,
                    Path.Combine(GeneratorSettingsRb.Instance.modelsPath,CodeNamer.UnderscoreCase(enumTemplate.Model.Name) + ImplementationFileExtension));
            }

            // Requirements
            var requirementsTemplate = new RequirementsTemplate
            {
                Model = new RequirementsRb(codeModel, this)
            };
            await Write(requirementsTemplate,
                    CodeNamer.UnderscoreCase(GeneratorSettingsRb.Instance.packageName ?? GeneratorSettingsRb.Instance.sdkName) + ImplementationFileExtension);

            // Version File
            if (!string.IsNullOrEmpty(GeneratorSettingsRb.Instance.packageVersion))
            {
                var versionTemplate = new VersionTemplate { Model = GeneratorSettingsRb.Instance.packageVersion };
                await Write(versionTemplate, Path.Combine(GeneratorSettingsRb.Instance.sdkPath, "version" + ImplementationFileExtension));
            }

            // Module Definition File
            if (!string.IsNullOrEmpty(Settings.Instance.Namespace))
            {
                var modTemplate = new ModuleDefinitionTemplate{ Model = GeneratorSettingsRb.Instance.ModuleDeclarations };
                await Write(modTemplate, Path.Combine(GeneratorSettingsRb.Instance.sdkPath, "module_definition" + ImplementationFileExtension));
            }
        }
    }
}
