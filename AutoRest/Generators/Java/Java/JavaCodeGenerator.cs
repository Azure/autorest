// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Linq;
using System.Globalization;
using System.IO;
using System.Threading.Tasks;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Java.Properties;
using Microsoft.Rest.Generator.Java.Templates;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Java
{
    public class JavaCodeGenerator : CodeGenerator
    {
        private const string ClientRuntimePackage = "com.microsoft.rest:client-runtime:0.0.1-SNAPSHOT";
        private const string _packageInfoFileName = "package-info.java";

        public JavaCodeNamer Namer { get; private set; }

        public JavaCodeGenerator(Settings settings) : base(settings)
        {
            Namer = new JavaCodeNamer();
        }

        public override string Name
        {
            get { return "Java"; }
        }

        public override string Description
        {
            // TODO resource string.
            get { return "Java for Http Client Libraries"; }
        }

        public override string UsageInstructions
        {
            get
            {
                return string.Format(CultureInfo.InvariantCulture,
                    Resources.UsageInformation, ClientRuntimePackage);
            }
        }

        public override string ImplementationFileExtension
        {
            get { return ".java"; }
        }

        /// <summary>
        /// Normalizes client model by updating names and types to be language specific.
        /// </summary>
        /// <param name="serviceClient"></param>
        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
            PopulateAdditionalProperties(serviceClient);
            Namer.NormalizeClientModel(serviceClient);
            Namer.ResolveNameCollisions(serviceClient, Settings.Namespace,
                Settings.Namespace + ".Models");
        }

        private void PopulateAdditionalProperties(ServiceClient serviceClient)
        {
            if (Settings.AddCredentials)
            {
                serviceClient.Properties.Add(new Property
                {
                    Name = "credentials",
                    Type = PrimaryType.Credentials,
                    IsRequired = true,
                    Documentation = "Subscription credentials which uniquely identify client subscription."
                });
            }
        }

        /// <summary>
        /// Generate Java client code for given ServiceClient.
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
            foreach (var modelType in serviceClient.ModelTypes.Concat(serviceClient.HeaderTypes))
            {
                var modelTemplate = new ModelTemplate
                {
                    Model = new ModelTemplateModel(modelType, serviceClient)
                };
                await Write(modelTemplate, Path.Combine("models", modelType.Name.ToPascalCase() + ".java"));
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

            // Exception
            foreach (var exceptionType in serviceClient.ErrorTypes)
            {
                var exceptionTemplate = new ExceptionTemplate
                {
                    Model = new ModelTemplateModel(exceptionType, serviceClient),
                };
                await Write(exceptionTemplate, Path.Combine("models", exceptionTemplate.Model.ExceptionTypeDefinitionName.ToPascalCase() + ".java"));
            }

            // package-info.java
            await Write(new PackageInfoTemplate
            {
                Model = new PackageInfoTemplateModel(serviceClient, serviceClient.Name)
            }, _packageInfoFileName);
            await Write(new PackageInfoTemplate
            {
                Model = new PackageInfoTemplateModel(serviceClient, serviceClient.Name, true)
            }, Path.Combine("models", _packageInfoFileName));
        }
    }
}
