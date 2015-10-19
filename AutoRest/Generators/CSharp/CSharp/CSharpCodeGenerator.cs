// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.IO;
using System.Globalization;
using System.Threading.Tasks;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.CSharp.Templates;

namespace Microsoft.Rest.Generator.CSharp
{
    public class CSharpCodeGenerator : CodeGenerator
    {
        private readonly CSharpCodeNamer _namer;
        private const string ClientRuntimePackage = "Microsoft.Rest.ClientRuntime.1.4.0";

        public CSharpCodeGenerator(Settings settings) : base(settings)
        {
            _namer = new CSharpCodeNamer();
            IsSingleFileGenerationSupported = true;
        }

        public override string Name
        {
            get { return "CSharp"; }
        }

        public override string Description
        {
            // TODO resource string.
            get { return "C# for Http Client Libraries"; }
        }

        public override string UsageInstructions
        {
            get {
                return string.Format(CultureInfo.InvariantCulture,
                    Properties.Resources.UsageInformation, ClientRuntimePackage);
            }
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
            PopulateAdditionalProperties(serviceClient);
            _namer.NormalizeClientModel(serviceClient);
            _namer.ResolveNameCollisions(serviceClient, Settings.Namespace,
                Settings.Namespace + ".Models");
        }

        private void PopulateAdditionalProperties(ServiceClient serviceClient)
        {
            if (Settings.AddCredentials)
            {
                serviceClient.Properties.Add(new Property
                {
                    Name = "Credentials",
                    Type = new CompositeType
                    {
                        Name = "ServiceClientCredentials"
                    },
                    IsRequired = true,
                    Documentation = "Subscription credentials which uniquely identify client subscription."
                });
            }
        }

        /// <summary>
        /// Generates C# code for service client.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <returns></returns>
        public override async Task Generate(ServiceClient serviceClient)
        {
            // Service client
            var serviceClientTemplate = new ServiceClientTemplate
            {
                Model = new ServiceClientTemplateModel(serviceClient),
            };
            await Write(serviceClientTemplate, serviceClient.Name + ".cs");

            // Service client extensions
            var extensionsTemplate = new ExtensionsTemplate
            {
                Model = new ExtensionsTemplateModel(serviceClient, null),
            };
            await Write(extensionsTemplate, serviceClient.Name + "Extensions.cs");

            // Service client interface
            var serviceClientInterfaceTemplate = new ServiceClientInterfaceTemplate
            {
                Model = new ServiceClientTemplateModel(serviceClient),
            };
            await Write(serviceClientInterfaceTemplate, "I" + serviceClient.Name + ".cs");

            // Operations
            foreach (var group in serviceClient.MethodGroups)
            {
                // Operation
                var operationsTemplate = new MethodGroupTemplate
                {
                    Model = new MethodGroupTemplateModel(serviceClient, group),
                };
                await Write(operationsTemplate, operationsTemplate.Model.MethodGroupType + ".cs");

                // Service client extensions
                var operationExtensionsTemplate = new ExtensionsTemplate
                {
                    Model = new ExtensionsTemplateModel(serviceClient, group),
                };
                await Write(operationExtensionsTemplate, group + "Extensions.cs");

                // Operation interface
                var operationsInterfaceTemplate = new MethodGroupInterfaceTemplate
                {
                    Model = new MethodGroupTemplateModel(serviceClient, group),
                };
                await Write(operationsInterfaceTemplate, "I" + operationsInterfaceTemplate.Model.MethodGroupType + ".cs");
            }

            // Models
            foreach (var model in serviceClient.ModelTypes)
            {
                var modelTemplate = new ModelTemplate
                {
                    Model = new ModelTemplateModel(model),
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
        }
    }
}
