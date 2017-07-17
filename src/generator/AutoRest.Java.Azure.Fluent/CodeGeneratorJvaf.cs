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
using AutoRest.Java.Azure.Fluent.Model;
using AutoRest.Java.Azure.Templates;
using AutoRest.Java.Model;
using AutoRest.Java.Templates;
using System;
using System.Text.RegularExpressions;

namespace AutoRest.Java.Azure.Fluent
{
    public class CodeGeneratorJvaf : CodeGeneratorJva
    {
        private const string ClientRuntimePackage = "com.microsoft.azure:azure-client-runtime:1.0.0-beta6-SNAPSHOT";
        private const string _packageInfoFileName = "package-info.java";

        public override bool IsSingleFileGenerationSupported => true;
        
        public override string UsageInstructions => string.Format(CultureInfo.InvariantCulture, Properties.Resources.UsageInformation, ClientRuntimePackage);

        /// <summary>
        /// Generates C# code for service client.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <returns></returns>
        public override async Task Generate(CodeModel cm)
        {
            var packagePath = Path.Combine("src/main/java", cm.Namespace.ToLower().Replace('.', '/'));

            // get Azure Java specific codeModel
            var codeModel = cm as CodeModelJvaf;
            if (codeModel == null)
            {
                throw new InvalidCastException("CodeModel is not a Azure Java Fluent CodeModel");
            }

            // Service client
            var serviceClientTemplate = new AzureServiceClientTemplate { Model = codeModel };
            await Write(serviceClientTemplate, Path.Combine(packagePath, "implementation", codeModel.Name.ToPascalCase() + "Impl" + ImplementationFileExtension));

            // operations
            foreach (MethodGroupJvaf methodGroup in codeModel.AllOperations)
            {
                // Operation
                var operationsTemplate = new AzureMethodGroupTemplate { Model = methodGroup };
                await Write(operationsTemplate, Path.Combine(packagePath, "implementation", methodGroup.TypeName.ToPascalCase()) + "Inner" + ImplementationFileExtension);
            }

            //Models
            foreach (CompositeTypeJvaf modelType in cm.ModelTypes.Concat(codeModel.HeaderTypes))
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
                await Write(modelTemplate, Path.Combine(packagePath, modelType.ModelsPackage.Trim('.'), $"{modelType.Name.ToPascalCase()}{ImplementationFileExtension}"));
            }

            //Enums
            foreach (EnumTypeJvaf enumType in cm.EnumTypes)
            {
                var enumTemplate = new EnumTemplate { Model = enumType };
                await Write(enumTemplate, Path.Combine(packagePath, enumType.ModelsPackage.Trim('.'), $"{enumTemplate.Model.Name.ToPascalCase()}{ImplementationFileExtension}"));
            }

            // Page class
            foreach (var pageClass in codeModel.pageClasses)
            {
                var pageTemplate = new PageTemplate
                {
                    Model = new PageJvaf(pageClass.Value, pageClass.Key.Key, pageClass.Key.Value),
                };
                await Write(pageTemplate, Path.Combine(packagePath, "implementation", $"{pageTemplate.Model.TypeDefinitionName.ToPascalCase()}{ImplementationFileExtension}"));
            }

            // Exceptions
            foreach (CompositeTypeJv exceptionType in codeModel.ErrorTypes)
            {
                if (exceptionType.Name == "CloudError")
                {
                    continue;
                }

                var exceptionTemplate = new ExceptionTemplate { Model = exceptionType };
                await Write(exceptionTemplate, Path.Combine(packagePath, exceptionType.ModelsPackage.Trim('.'), $"{exceptionTemplate.Model.ExceptionTypeDefinitionName}{ImplementationFileExtension}"));
            }

            // package-info.java
            await Write(new PackageInfoTemplate
            {
                Model = new PackageInfoTemplateModel(cm)
            }, Path.Combine(packagePath, _packageInfoFileName));
            await Write(new PackageInfoTemplate
            {
                Model = new PackageInfoTemplateModel(cm, "implementation")
            }, Path.Combine(packagePath, "implementation", _packageInfoFileName));

            object value;
            bool regenerateManager;
            if (Settings.Instance.CustomSettings.TryGetValue("RegenerateManager", out value) &&
                bool.TryParse(value.ToString(), out regenerateManager) &&
                regenerateManager)
            {
                // Manager
                await Write(
                    new AzureServiceManagerTemplate { Model = codeModel },
                    Path.Combine(packagePath, "implementation", codeModel.ServiceName + "Manager" + ImplementationFileExtension));

                // POM
                await Write(new AzurePomTemplate { Model = codeModel }, "pom.xml");
            }
        }
    }
}
