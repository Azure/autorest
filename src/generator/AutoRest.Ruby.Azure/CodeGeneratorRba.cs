// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Security.Policy;
using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions.Azure;
using AutoRest.Ruby.Azure.Model;
using AutoRest.Ruby.Templates;
using AutoRest.Ruby.Azure.Templates;
using AutoRest.Ruby.Model;

namespace AutoRest.Ruby.Azure
{
    /// <summary>
    /// A class with main code generation logic for Azure.Ruby.
    /// </summary>
    public class CodeGeneratorRba : CodeGeneratorRb
    {
        public CodeGeneratorRba() 
        {
        }

        /// <summary>
        /// Gets the usage instructions for the code generator.
        /// </summary>
        public override string UsageInstructions => @"The ""gem 'ms_rest_azure' ~> 0.6"" is required for working with generated code.";

        /// <summary>
        /// Generates Ruby code for Azure service client.
        /// </summary>
        /// <param name="cm">The code model.</param>
        /// <returns>Async tasks which generates SDK files.</returns>
        public override async Task Generate(CodeModel cm)
        {
            var codeModel = cm as CodeModelRba;
            if (codeModel == null)
            {
                throw new InvalidCastException("CodeModel is not a Azure Ruby code model.");
            }

            // Service client
            var serviceClientTemplate = new ServiceClientTemplate { Model = codeModel };
            await Write(serviceClientTemplate, Path.Combine(GeneratorSettingsRba.Instance.sdkPath, CodeNamer.UnderscoreCase(codeModel.Name) + ImplementationFileExtension));

            // Operations
            foreach (MethodGroupRba group in codeModel.Operations.Where(each => !each.IsCodeModelMethodGroup))
            {
                // Operation
                var operationsTemplate = new AzureMethodGroupTemplate { Model = group };
                await Write(operationsTemplate, Path.Combine(GeneratorSettingsRba.Instance.sdkPath, CodeNamer.UnderscoreCase(operationsTemplate.Model.TypeName) + ImplementationFileExtension));
            }

            // Models
            foreach (CompositeTypeRba model in codeModel.ModelTypes)
            {
                if ((model.Extensions.ContainsKey(AzureExtensions.ExternalExtension) &&
                    (bool)model.Extensions[AzureExtensions.ExternalExtension])
                    || model.Name == "Resource" || model.Name == "SubResource")
                {
                    continue;
                }

                if( codeModel.pageModels.Any( each => each.Name.EqualsIgnoreCase(model.Name ) ) )
                {
                    // Skip, handled in the .pageModels section below.
                    continue;
                }

                var modelTemplate = new ModelTemplate { Model = model };
                await Write(modelTemplate, Path.Combine(GeneratorSettingsRb.Instance.modelsPath, CodeNamer.UnderscoreCase(model.Name) + ImplementationFileExtension));
            }
            // Paged Models
            foreach (var pageModel in codeModel.pageModels)
            {
                var pageTemplate = new PageModelTemplate { Model = pageModel };
                await Write(pageTemplate, Path.Combine(GeneratorSettingsRb.Instance.modelsPath, CodeNamer.UnderscoreCase(pageModel.Name) + ImplementationFileExtension));
            }

            // Enums
            foreach (EnumTypeRb enumType in codeModel.EnumTypes)
            {
                var enumTemplate = new EnumTemplate { Model = enumType };
                await Write(enumTemplate, Path.Combine(GeneratorSettingsRb.Instance.modelsPath, CodeNamer.UnderscoreCase(enumTemplate.Model.Name) + ImplementationFileExtension));
            }

            // Requirements
            var requirementsTemplate = new RequirementsTemplate{Model = new RequirementsRba(codeModel, this)};
            await Write(requirementsTemplate, CodeNamer.UnderscoreCase(GeneratorSettingsRb.Instance.packageName ?? GeneratorSettingsRb.Instance.sdkName) + ImplementationFileExtension);

            // Version File
            if (GeneratorSettingsRb.Instance.packageVersion != null)
            {
                var versionTemplate = new VersionTemplate { Model = GeneratorSettingsRb.Instance.packageVersion };
                await Write(versionTemplate, Path.Combine(GeneratorSettingsRb.Instance.sdkPath, "version" + ImplementationFileExtension));
            }

            // Module Definition File
            if (Settings.Instance.Namespace != null)
            {
                var modTemplate  = new ModuleDefinitionTemplate { Model = GeneratorSettingsRb.Instance.ModuleDeclarations };
                await Write(modTemplate, Path.Combine(GeneratorSettingsRb.Instance.sdkPath, "module_definition" + ImplementationFileExtension));
            }
        }
    }
}
