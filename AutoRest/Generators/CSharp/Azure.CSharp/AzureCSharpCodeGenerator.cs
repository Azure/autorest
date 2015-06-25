// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Threading.Tasks;
using Microsoft.Rest.Generator.Azure;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.CSharp.Azure.Templates;
using Microsoft.Rest.Generator.CSharp.Templates;

namespace Microsoft.Rest.Generator.CSharp.Azure
{
    public class AzureCSharpCodeGenerator : AzureCodeGenerator
    {
        private readonly AzureCSharpCodeNamer _namer;

        public AzureCSharpCodeGenerator(Settings settings) : base(settings)
        {
            _namer = new AzureCSharpCodeNamer();
        }

        public override string Name
        {
            get { return "Azure.CSharp"; }
        }

        public override string Description
        {
            get { return "C# for Http Client Libraries"; }
        }

        public override string UsageInstructions
        {
            get { return Properties.Resources.UsageInformation; }
        }

        public override string ImplementationFileExtension
        {
            get { return ".cs"; }
        }

        /// <summary>
        /// Normalizes client model by updating names and types to be language specific.
        /// </summary>
        /// <param name="serviceClient"></param>
        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
            base.NormalizeClientModel(serviceClient);
            _namer.NormalizeClientModel(serviceClient);
            _namer.ResolveNameCollisions(serviceClient, Settings.Namespace,
                Settings.Namespace + ".Models");
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
                Model = new AzureServiceClientTemplateModel(serviceClient),
            };
            await Write(serviceClientTemplate, serviceClient.Name + ".cs");

            // Service client extensions
            var extensionsTemplate = new ExtensionsTemplate
            {
                Model = new AzureExtensionsTemplateModel(serviceClient, null),
            };
            await Write(extensionsTemplate, serviceClient.Name + "Extensions.cs");

            // Service client interface
            var serviceClientInterfaceTemplate = new ServiceClientInterfaceTemplate
            {
                Model = new AzureServiceClientTemplateModel(serviceClient),
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
                    Model = new AzureExtensionsTemplateModel(serviceClient, group),
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
            foreach (var model in serviceClient.ModelTypes)
            {
                if (model.Extensions.ContainsKey(ExternalExtension))
                {
                    continue;
                }

                var modelTemplate = new ModelTemplate
                {
                    Model = new AzureModelTemplateModel(model),
                };

                await Write(modelTemplate, "Models\\" + model.Name + ".cs");
            }


            // Enums
            foreach (var enumType in serviceClient.EnumTypes)
            {
                var enumTemplate = new EnumTemplate
                {
                    Model = new EnumTemplateModel(enumType),
                };
                await Write(enumTemplate, "Models\\" + enumTemplate.Model.TypeDefinitionName + ".cs");
            }
        }
    }
}
