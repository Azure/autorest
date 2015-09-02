// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.Azure;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Java.Templates;
using Microsoft.Rest.Generator.Utilities;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace Microsoft.Rest.Generator.Java.Azure
{
    public class AzureJavaCodeGenerator : AzureCodeGenerator
    {
        private readonly AzureJavaCodeNamer _namer;

        private const string ClientRuntimePackage = "com.microsoft.rest.azure-client-runtime 0.0.1-SNAPSHOT";

        public AzureJavaCodeGenerator(Settings settings) : base(settings)
        {
            _namer = new AzureJavaCodeNamer();
            IsSingleFileGenerationSupported = true;
        }

        public override string Name
        {
            get { return "Azure.Java"; }
        }

        public override string Description
        {
            get { return "Java for Http Client Libraries"; }
        }

        public override string UsageInstructions
        {
            get
            {
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
            base.NormalizeClientModel(serviceClient);
            _namer.NormalizeClientModel(serviceClient);
            _namer.ResolveNameCollisions(serviceClient, Settings.Namespace,
                Settings.Namespace + ".Models");
            _namer.NormalizePaginatedMethods(serviceClient);
        }

        /// <summary>
        /// Generates C# code for service client.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <returns></returns>
        public override async Task Generate(ServiceClient serviceClient)
        {
            var serviceClientTemplateModel = new ServiceClientTemplateModel(serviceClient);
            // Service client
            var serviceClientTemplate = new ServiceClientTemplate
            {
                Model = serviceClientTemplateModel,
            };
            await Write(serviceClientTemplate, serviceClient.Name.ToPascalCase() + "Impl.java");

            var serviceClientInterfaceTemplate = new ServiceClientInterfaceTemplate
            {
                Model = serviceClientTemplateModel,
            };
            await Write(serviceClientInterfaceTemplate, serviceClient.Name.ToPascalCase() + ".java");

            //Models
            if (serviceClient.ModelTypes.Any())
            {
                foreach (var modelType in serviceClientTemplateModel.ModelTemplateModels)
                {
                    var modelTemplate = new ModelTemplate
                    {
                        Model = modelType
                    };
                    await Write(modelTemplate, Path.Combine("models", modelType.Name.ToPascalCase() + ".java"));
                }
            }

            //MethodGroups
            if (serviceClientTemplateModel.MethodGroupModels.Any())
            {
                foreach (var methodGroupModel in serviceClientTemplateModel.MethodGroupModels)
                {
                    var methodGroupTemplate = new MethodGroupTemplate
                    {
                        Model = methodGroupModel
                    };
                    await Write(methodGroupTemplate, methodGroupModel.MethodGroupType.ToPascalCase() + "Impl.java");
                    var methodGroupInterfaceTemplate = new MethodGroupInterfaceTemplate
                    {
                        Model = methodGroupModel
                    };
                    await Write(methodGroupInterfaceTemplate, methodGroupModel.MethodGroupType.ToPascalCase() + ".java");
                }
            }

            //Enums
            foreach (var enumType in serviceClient.EnumTypes)
            {
                var enumTemplate = new EnumTemplate
                {
                    Model = new EnumTemplateModel(enumType),
                };
                await Write(enumTemplate, Path.Combine("models", enumTemplate.Model.Name.ToPascalCase() + ".java"));
            }
        }
    }
}
