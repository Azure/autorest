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
using AutoRest.CSharp.LoadBalanced.Legacy.Model;
using AutoRest.CSharp.LoadBalanced.Legacy.Strategies;
using AutoRest.CSharp.LoadBalanced.Legacy.Templates.Rest.Client;
using AutoRest.CSharp.LoadBalanced.Legacy.Templates.Rest.Common;
using AutoRest.Extensions;

namespace AutoRest.CSharp.LoadBalanced.Legacy
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

            var usings = new List<string>();
            var methodGroups = codeModel.Operations.Cast<MethodGroupCs>();
            var methods = codeModel.Methods.Where(m => m.Group.IsNullOrEmpty()).Cast<MethodCs>().ToList();
            
            var project = new ProjectModel
            {
                RootNameSpace = codeModel.Namespace
            };

            var metricsTemplate = new MetricsTemplate {Model = methods};
            var metricsFilePath = "Metrics.cs";
            await Write(metricsTemplate, metricsFilePath);
			
            var brokenRuleTemplate = new BrokenRuleTemplate();
            var brokenRuleFilePath = "BrokenRule.cs";
            await Write(brokenRuleTemplate, brokenRuleFilePath);
			
            var responseTemplate = new ResponseTemplate();
            var responseFilePath = "Response.cs";
            await Write(responseTemplate, responseFilePath);

            usings.AddRange(new[]
                            {
                                "System", "System.Collections.Generic", "System.Linq", "System.Threading",
                                "System.Threading.Tasks", "Microsoft.Rest", "System.IO",
                                "Microsoft.Rest.Serialization", "Agoda.RoundRobin", "Newtonsoft.Json",
                                $"{codeModel.Namespace}.Models", "Agoda.RoundRobin.Constants", "System.ComponentModel",
                                "AutoRest.CSharp.LoadBalanced.Json"
                            });

            usings = usings.Where(u => !string.IsNullOrWhiteSpace(u)).Distinct().ToList();

            codeModel.Usings = usings;
            
            var clients = methods.GroupBy(m => m.Tags.First()).ToArray();

            var libPath = Path.Combine(Settings.Instance.OutputDirectory, "lib");
            
            await new LibFolderCreator(libPath).ExecuteAsync();

            foreach (var client in clients)
            {
                var clientName = $"{client.Key.ToPascalCase()}Client";
                var clientMethods = client.ToArray();
                var clientClassFileName = $"{clientName}{ImplementationFileExtension}";
                var clientInterfaceFileName = $"I{clientClassFileName}";

                var model = new Tuple<CodeModelCs, string, MethodCs[]>(codeModel, clientName, clientMethods);

                // Service client interface
                var serviceClientInterfaceTemplate = new ServiceClientInterfaceTemplate { Model = model };
                await Write(serviceClientInterfaceTemplate, clientInterfaceFileName);


                // Service client
                var serviceClientTemplate = new ServiceClientTemplate { Model = model };
                await Write(serviceClientTemplate, clientClassFileName);
            }

            var apiBaseTemplate = new ApiBaseTemplate {Model = codeModel};
            var apiBaseCsPath = "ApiBase.cs";
            await Write(apiBaseTemplate, apiBaseCsPath);

            // operations
            foreach (var methodGroup in methodGroups)
            {
                if (methodGroup.Name.IsNullOrEmpty())
                {
                    continue;
                }

                // Operation
                var operationsTemplate = new MethodGroupTemplate { Model = methodGroup };
                var operationsFilePath = $"{operationsTemplate.Model.TypeName}{ImplementationFileExtension}";

                await Write(operationsTemplate, operationsFilePath);

                // Operation interface
                var operationsInterfaceTemplate = new MethodGroupInterfaceTemplate { Model = methodGroup };
                var operationsInterfacePath =
                    $"I{operationsInterfaceTemplate.Model.TypeName}{ImplementationFileExtension}";

                await Write(operationsInterfaceTemplate, operationsInterfacePath);
            }

            // Models
            var models = codeModel.ModelTypes.Union(codeModel.HeaderTypes).Cast<CompositeTypeCs>();
            foreach (var model in models)
            {
                if (model.Extensions.ContainsKey(SwaggerExtensions.ExternalExtension) &&
                    (bool)model.Extensions[SwaggerExtensions.ExternalExtension])
                {
                    continue;
                }

                Template<CompositeTypeCs> modelTemplate = null;

                if (model.PropertyTypeSelectionStrategy.IsCollection(model))
                {
                    modelTemplate = new CollectionModelTemplate { Model = model };
                }
                else
                {
                    modelTemplate = new ModelTemplate { Model = model };
                }
                
                var modelPath = Path.Combine(Settings.Instance.ModelsName, $"{model.Name}{ImplementationFileExtension}");

                await Write(modelTemplate, modelPath);
            }
			
            // Enums
            foreach (EnumTypeCs enumType in codeModel.EnumTypes)
            {
                var enumTemplate = new EnumTemplate { Model = enumType };
                var enumFilePath = Path.Combine(Settings.Instance.ModelsName, $"{enumTemplate.Model.Name}{ImplementationFileExtension}");

                await Write(enumTemplate, enumFilePath);
            }

            // Exceptions
            foreach (CompositeTypeCs exceptionType in codeModel.ErrorTypes)
            {
                var exceptionTemplate = new ExceptionTemplate { Model = exceptionType, };
                var exceptionFilePath =
                    Path.Combine(Settings.Instance.ModelsName, $"{exceptionTemplate.Model.ExceptionTypeDefinitionName}{ImplementationFileExtension}");

                await Write(exceptionTemplate, exceptionFilePath);
            }

            // CB models
            var couchbaseModels = codeModel.ModelTypes.Union(codeModel.HeaderTypes).Cast<CompositeTypeCs>();
            foreach (var model in couchbaseModels)
            {
                model.isCouchbaseModel = true;
                if (model.Extensions.ContainsKey(SwaggerExtensions.ExternalExtension) &&
                    (bool)model.Extensions[SwaggerExtensions.ExternalExtension])
                {
                    continue;
                }

                Template<CompositeTypeCs> modelTemplate = null;

                if (model.PropertyTypeSelectionStrategy.IsCollection(model))
                {
                    modelTemplate = new CollectionModelTemplate { Model = model };
                }
                else
                {
                    modelTemplate = new ModelTemplate { Model = model };
                }
                var modelPath = Path.Combine(Settings.Instance.ModelsName, $"Couchbase/{model.Name}{ImplementationFileExtension}");
                project.FilePaths.Add(modelPath);

                await Write(modelTemplate, modelPath);
            }

            var projectTemplate = new CsProjTemplate { Model = project };
            var projFilePath = $"{project.RootNameSpace}.csproj";

            var solutionTemplate = new SlnTemplate { Model = project };
            var slnFilePath = $"{project.RootNameSpace}.sln";

            await Write(projectTemplate, projFilePath);
            await Write(solutionTemplate, slnFilePath);
            await Write(new PackagesTemplate(), "packages.config");
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
