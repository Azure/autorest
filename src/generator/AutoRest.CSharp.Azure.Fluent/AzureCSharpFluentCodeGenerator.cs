// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.ClientModel;
using AutoRest.CSharp.Azure.TemplateModels;
using AutoRest.CSharp.Azure.Templates;
using AutoRest.CSharp.TemplateModels;
using AutoRest.CSharp.Templates;
using AutoRest.Extensions.Azure;

namespace AutoRest.CSharp.Azure.Fluent
{
    public class AzureCSharpFluentCodeGenerator : AzureCSharpCodeGenerator
    {
        private readonly AzureCSharpFluentCodeNamer _namer;

        private const string ClientRuntimePackage = "Microsoft.Rest.ClientRuntime.Azure.3.2.0";

        public AzureCSharpFluentCodeGenerator(Settings settings) : base(settings)
        {
            _namer = new AzureCSharpFluentCodeNamer(settings);
        }

        public override string Name
        {
            get { return "Azure.CSharp.Fluent"; }
        }

        public override string Description
        {
            get { return "Azure specific C#  fluent code generator."; }
        }

        /// <summary>
        /// Normalizes client model by updating names and types to be language specific.
        /// </summary>
        /// <param name="serviceClient"></param>
        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
            AzureExtensions.NormalizeAzureClientModel(serviceClient, Settings, _namer);
            _namer.NormalizeClientModel(serviceClient);
            _namer.ResolveNameCollisions(serviceClient, Settings.Namespace,
                Settings.Namespace + ".Models");
            _namer.NormalizeResourceTypes(serviceClient);
            _namer.NormalizeTopLevelTypes(serviceClient);
            _namer.NormalizeModelProperties(serviceClient);
            _namer.NormalizePaginatedMethods(serviceClient, PageClasses);
            _namer.NormalizeODataMethods(serviceClient);
        }

        /// <summary>
        /// Generates C# code for service client.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <returns></returns>
        public override async Task Generate(ServiceClient serviceClient)
        {
            // Service client
            var serviceClientTemplate = new AzureServiceClientTemplate
            {
                Model = new AzureServiceClientTemplateModel(serviceClient, InternalConstructors),
            };
            await Write(serviceClientTemplate, serviceClient.Name + ".cs");

            // Service client extensions
            if (serviceClient.Methods.Any(m => m.Group == null))
            {
                var extensionsTemplate = new ExtensionsTemplate
                {
                    Model = new AzureExtensionsTemplateModel(serviceClient, null, SyncMethods),
                };
                await Write(extensionsTemplate, serviceClient.Name + "Extensions.cs");
            }

            // Service client interface
            var serviceClientInterfaceTemplate = new ServiceClientInterfaceTemplate
            {
                Model = new AzureServiceClientTemplateModel(serviceClient, InternalConstructors),
            };
            await Write(serviceClientInterfaceTemplate, "I" + serviceClient.Name + ".cs");

            // Operations
            foreach (var group in serviceClient.MethodGroups)
            {
                // Operation
                var operationsTemplate = new AzureMethodGroupTemplate
                {
                    Model = new AzureMethodGroupTemplateModel(serviceClient, group),
                };
                await Write(operationsTemplate, operationsTemplate.Model.MethodGroupType + ".cs");

                // Service client extensions
                var operationExtensionsTemplate = new ExtensionsTemplate
                {
                    Model = new AzureExtensionsTemplateModel(serviceClient, group, SyncMethods),
                };
                await Write(operationExtensionsTemplate, operationExtensionsTemplate.Model.ExtensionName + "Extensions.cs");

                // Operation interface
                var operationsInterfaceTemplate = new MethodGroupInterfaceTemplate
                {
                    Model = new AzureMethodGroupTemplateModel(serviceClient, group),
                };
                await Write(operationsInterfaceTemplate, "I" + operationsInterfaceTemplate.Model.MethodGroupType + ".cs");
            }

            // Models
            foreach (var model in serviceClient.ModelTypes.Concat(serviceClient.HeaderTypes))
            {
                if (model.Extensions.ContainsKey(AzureExtensions.ExternalExtension) && 
                    (bool) model.Extensions[AzureExtensions.ExternalExtension])
                {
                    continue;
                }
                if (model.IsResource())
                {
                    continue;
                }

                var modelTemplate = new ModelTemplate
                {
                    Model = new AzureModelTemplateModel(model),
                };

                await Write(modelTemplate, Path.Combine("Models", model.Name + ".cs"));
            }

            // Enums
            foreach (var enumType in serviceClient.EnumTypes)
            {
                var enumTemplate = new EnumTemplate
                {
                    Model = new EnumTemplateModel(enumType),
                };
                await Write(enumTemplate, Path.Combine("Models", enumTemplate.Model.TypeDefinitionName + ".cs"));
            }

            // Page class
            foreach (var pageClass in PageClasses)
            {
                var pageTemplate = new PageTemplate
                {
                    Model = new PageTemplateModel(pageClass.Value, pageClass.Key.Key, pageClass.Key.Value),
                };
                await Write(pageTemplate, Path.Combine("Models", pageTemplate.Model.TypeDefinitionName + ".cs"));
            }

            // Exceptions
            foreach (var exceptionType in serviceClient.ErrorTypes)
            {
                if (exceptionType.Name == "CloudError")
                {
                    continue;
                }

                var exceptionTemplate = new ExceptionTemplate
                {
                    Model = new ModelTemplateModel(exceptionType),
                };
                await Write(exceptionTemplate, Path.Combine("Models", exceptionTemplate.Model.ExceptionTypeDefinitionName + ".cs"));
            }
        }
    }
}
