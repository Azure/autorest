// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.Logging;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.CSharp.LoadBalanced.Model;
using AutoRest.CSharp.LoadBalanced.Strategies;
using AutoRest.CSharp.LoadBalanced.Templates.Rest.Client;
using AutoRest.CSharp.LoadBalanced.Templates.Rest.Common;
using AutoRest.Extensions;

namespace AutoRest.CSharp.LoadBalanced
{
    public class LoadBalancedCodeGeneratorCs : CodeGenerator
    {
        private const string ClientRuntimePackage = "Microsoft.Rest.ClientRuntime.2.2.0";

        public override bool IsSingleFileGenerationSupported => true;


        public override string UsageInstructions => string.Format(CultureInfo.InvariantCulture,
            "The {0} nuget package is required to compile the generated code.", ClientRuntimePackage);

        public override string ImplementationFileExtension => ".cs";

        private async Task GenerateClientSideCode(CodeModelCs codeModel)
        {
            CompositeTypeCs.DefaultPropertyTypeSelectionStrategy = new WrappedPropertyTypeSelectionStrategy();

            var usings = new List<string>(codeModel.Usings);
            var methods = codeModel.Methods.Where(m => m.Group.IsNullOrEmpty()).Cast<MethodCs>().ToList();

            var project = new ProjectModel
            {
                RootNameSpace = codeModel.Namespace
            };

            var metricsTemplate = new MetricsTemplate {Model = methods};
            var metricsFilePath = "Metrics.cs";
            project.FilePaths.Add(metricsFilePath);
            await Write(metricsTemplate, metricsFilePath);

            usings.Add("System");
            usings.Add("System.Collections.Generic");
            usings.Add("System.Linq");
            usings.Add("System.Threading");
            usings.Add("System.Threading.Tasks");
            usings.Add("Microsoft.Rest");
            usings.Add("System.IO");
            usings.Add("Microsoft.Rest.Serialization");
            usings.Add("Agoda.RoundRobin");
            usings.Add("Agoda.RoundRobin.Constants");
            usings.Add("Newtonsoft.Json");
            usings.Add($"{codeModel.Namespace}.Models");

            codeModel.Usings = usings.Where(u => !string.IsNullOrWhiteSpace(u)).Distinct();

            // Service client
            var serviceClientTemplate = new ServiceClientTemplate { Model = codeModel };

            var clientPath = $"{codeModel.Name}{ImplementationFileExtension}";
            project.FilePaths.Add(clientPath);

            await Write(serviceClientTemplate, clientPath);

            // Service client interface
            var serviceClientInterfaceTemplate = new ServiceClientInterfaceTemplate { Model = codeModel };

            var interfacePath = $"I{codeModel.Name}{ImplementationFileExtension}";
            project.FilePaths.Add(interfacePath);

            await Write(serviceClientInterfaceTemplate, interfacePath);

            var apiBaseTemplate = new ApiBaseTemplate {Model = codeModel};
            var apiBaseCsPath = "ApiBase.cs";
            project.FilePaths.Add(apiBaseCsPath);
            await Write(apiBaseTemplate, apiBaseCsPath);

            // operations
            foreach (var methodGroup1 in codeModel.Operations)
            {
                var methodGroup = (MethodGroupCs) methodGroup1;

                if (!methodGroup.Name.IsNullOrEmpty())
                {
                    // Operation
                    var operationsTemplate = new MethodGroupTemplate { Model = methodGroup };
                    var operationsFilePath = $"{operationsTemplate.Model.TypeName}{ImplementationFileExtension}";
                    project.FilePaths.Add(operationsFilePath);

                    await Write(operationsTemplate, operationsFilePath);

                    // Operation interface
                    var operationsInterfaceTemplate = new MethodGroupInterfaceTemplate { Model = methodGroup };
                    var operationsInterfacePath =
                        $"I{operationsInterfaceTemplate.Model.TypeName}{ImplementationFileExtension}";
                    project.FilePaths.Add(operationsInterfacePath);

                    await Write(operationsInterfaceTemplate, operationsInterfacePath);
                }
            }

            // Models
            foreach (CompositeTypeCs model in codeModel.ModelTypes.Union(codeModel.HeaderTypes))
            {
                if (model.Extensions.ContainsKey(SwaggerExtensions.ExternalExtension) &&
                    (bool)model.Extensions[SwaggerExtensions.ExternalExtension])
                {
                    continue;
                }

                var modelTemplate = new ModelTemplate{ Model = model };
                var modelPath = Path.Combine(Settings.Instance.ModelsName, $"{model.Name}{ImplementationFileExtension}");
                project.FilePaths.Add(modelPath);

                await Write(modelTemplate, modelPath);
            }

            // Enums
            foreach (EnumTypeCs enumType in codeModel.EnumTypes)
            {
                var enumTemplate = new EnumTemplate { Model = enumType };
                var enumFilePath = Path.Combine(Settings.Instance.ModelsName, $"{enumTemplate.Model.Name}{ImplementationFileExtension}");
                project.FilePaths.Add(enumFilePath);

                await Write(enumTemplate, enumFilePath);
            }

            // Exceptions
            foreach (CompositeTypeCs exceptionType in codeModel.ErrorTypes)
            {
                var exceptionTemplate = new ExceptionTemplate { Model = exceptionType, };
                var exceptionFilePath =
                    Path.Combine(Settings.Instance.ModelsName, $"{exceptionTemplate.Model.ExceptionTypeDefinitionName}{ImplementationFileExtension}");
                project.FilePaths.Add(exceptionFilePath);

                await Write(exceptionTemplate, exceptionFilePath);
            }
            
            // Xml Serialization
            if (codeModel.ShouldGenerateXmlSerialization)
            {
                var xmlSerializationTemplate = new XmlSerializationTemplate();
                var xmlSerializationPath = Path.Combine(Settings.Instance.ModelsName,
                    $"{XmlSerialization.XmlDeserializationClass}{ImplementationFileExtension}");
                project.FilePaths.Add(xmlSerializationPath);

                await Write(xmlSerializationTemplate, xmlSerializationPath);
            }
            
        }

        private async Task GenerateRestCode(CodeModelCs codeModel)
        {
            Logger.Instance.Log(Category.Info, "Defaulting to generate client side Code");
            await GenerateClientSideCode(codeModel);
        }

        /// <summary>
        /// Generates C# code for service client.
        /// </summary>
        /// <param name="cm"></param>
        /// <returns></returns>
        public override async Task Generate(CodeModel cm)
        {
            // get c# specific codeModel
            var codeModel = cm as CodeModelCs;
            if (codeModel == null)
            {
                throw new InvalidCastException("CodeModel is not a c# CodeModel");
            }
            if (Settings.Instance.CodeGenerationMode.IsNullOrEmpty() || Settings.Instance.CodeGenerationMode.ToLower().StartsWith("rest"))
            {
                Logger.Instance.Log(Category.Info, "Generating Rest Code");
                await GenerateRestCode(codeModel);
            }
            else
            {
                throw new ArgumentException(
                    string.Format(CultureInfo.InvariantCulture,
                        string.Format(AutoRest.Core.Properties.Resources.ParameterValueIsNotValid, Settings.Instance.CodeGenerationMode, "server/client"), "CodeGenerator"));
            }
        }
    }
}
