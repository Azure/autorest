// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;
using AutoRest.Extensions.Azure;
using AutoRest.Java.Azure.Model;
using AutoRest.Java.Azure.Templates;
using AutoRest.Java.Model;
using AutoRest.Java.Templates;
using System;

namespace AutoRest.Java.Azure
{
    public class CodeGeneratorJva : CodeGeneratorJv
    {
        private const string ClientRuntimePackage = "com.microsoft.azure:azure-client-runtime:1.0.0-beta5-SNAPSHOT from snapshot repo https://oss.sonatype.org/content/repositories/snapshots/";
        private const string _packageInfoFileName = "package-info.java";
        
        public override bool IsSingleFileGenerationSupported => true;

        public override string UsageInstructions => string.Format(CultureInfo.InvariantCulture, Properties.Resources.UsageInformation, ClientRuntimePackage);
        
        /// <summary>
        /// Generates Azure Java code for service client.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <returns></returns>
        public override async Task Generate(CodeModel cm)
        {
            // get Azure Java specific codeModel
            var codeModel = cm as CodeModelJva;
            if (codeModel == null)
            {
                throw new InvalidCastException("CodeModel is not a Azure Java CodeModel");
            }

            // Service client
            var serviceClientTemplate = new AzureServiceClientTemplate { Model = codeModel };
            await Write(serviceClientTemplate, $"{Path.Combine("implementation", codeModel.Name.ToPascalCase() + "Impl")}{ImplementationFileExtension}");

            // Service client interface
            var serviceClientInterfaceTemplate = new AzureServiceClientInterfaceTemplate { Model = codeModel };
            await Write(serviceClientInterfaceTemplate, $"{cm.Name.ToPascalCase()}{ImplementationFileExtension}");

            // operations
            foreach (MethodGroupJva methodGroup in codeModel.AllOperations)
            {
                // Operation
                var operationsTemplate = new AzureMethodGroupTemplate { Model = methodGroup };
                await Write(operationsTemplate, $"{Path.Combine("implementation", methodGroup.TypeName.ToPascalCase())}Impl{ImplementationFileExtension}");
                
                // Operation interface
                var operationsInterfaceTemplate = new AzureMethodGroupInterfaceTemplate { Model = methodGroup };
                await Write(operationsInterfaceTemplate, $"{methodGroup.TypeName.ToPascalCase()}{ImplementationFileExtension}");
            }

            //Models
            foreach (CompositeTypeJva modelType in cm.ModelTypes.Concat(codeModel.HeaderTypes))
            {
                if (modelType.Extensions.ContainsKey(AzureExtensions.ExternalExtension) &&
                    (bool)modelType.Extensions[AzureExtensions.ExternalExtension])
                {
                    continue;
                }
                if (modelType.IsResource)
                {
                    continue;
                }

                var modelTemplate = new ModelTemplate { Model = modelType };
                await Write(modelTemplate, Path.Combine("models", $"{modelType.Name.ToPascalCase()}{ImplementationFileExtension}"));
            }

            //Enums
            foreach (EnumTypeJva enumType in cm.EnumTypes)
            {
                var enumTemplate = new EnumTemplate { Model = enumType };
                await Write(enumTemplate, Path.Combine("models", $"{enumTemplate.Model.Name.ToPascalCase()}{ImplementationFileExtension}"));
            }

            // Page class
            foreach (var pageClass in codeModel.pageClasses)
            {
                var pageTemplate = new PageTemplate
                {
                    Model = new PageJva(pageClass.Value, pageClass.Key.Key, pageClass.Key.Value),
                };
                await Write(pageTemplate, Path.Combine("models", $"{pageTemplate.Model.TypeDefinitionName.ToPascalCase()}{ImplementationFileExtension}"));
            }

            // Exceptions
            foreach (CompositeTypeJv exceptionType in codeModel.ErrorTypes)
            {
                if (exceptionType.Name == "CloudError")
                {
                    continue;
                }

                var exceptionTemplate = new ExceptionTemplate { Model = exceptionType };
                await Write(exceptionTemplate, Path.Combine("models", $"{exceptionTemplate.Model.ExceptionTypeDefinitionName}{ImplementationFileExtension}"));
            }

            // package-info.java
            await Write(new PackageInfoTemplate
            {
                Model = new PackageInfoTemplateModel(cm)
            }, _packageInfoFileName);
            await Write(new PackageInfoTemplate
            {
                Model = new PackageInfoTemplateModel(cm, "implementation")
            }, Path.Combine("implementation", _packageInfoFileName));
            await Write(new PackageInfoTemplate
            {
                Model = new PackageInfoTemplateModel(cm, "models")
            }, Path.Combine("models", _packageInfoFileName));
        }
    }
}
