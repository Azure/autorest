// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Java.Templates;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Generator.Java.Azure.Templates;
using System.Collections.Generic;
using Microsoft.Rest.Generator.Azure;

namespace Microsoft.Rest.Generator.Java.Azure
{
    public class AzureJavaCodeGenerator : JavaCodeGenerator
    {
        private readonly AzureJavaCodeNamer _namer;

        private const string ClientRuntimePackage = "com.microsoft.rest:azure-client-runtime:0.0.1-SNAPSHOT";
        private const string _packageInfoFileName = "package-info.java";

        // page extensions class dictionary.
        private IDictionary<KeyValuePair<string, string>, string> pageClasses;

        public AzureJavaCodeGenerator(Settings settings) : base(settings)
        {
            _namer = new AzureJavaCodeNamer(settings.Namespace);
            IsSingleFileGenerationSupported = true;
            pageClasses = new Dictionary<KeyValuePair<string, string>, string>();
        }

        public override string Name
        {
            get { return "Azure.Java"; }
        }

        public override string Description
        {
            get { return "Azure specific Java code generator."; }
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
            AzureExtensions.NormalizeAzureClientModel(serviceClient, Settings, _namer);
            _namer.NormalizeClientModel(serviceClient);
            _namer.ResolveNameCollisions(serviceClient, Settings.Namespace,
                Settings.Namespace + ".Models");
            _namer.NormalizePaginatedMethods(serviceClient, pageClasses);
            _namer.NormalizeTopLevelTypes(serviceClient);
        }

        /// <summary>
        /// Generates C# code for service client.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <returns></returns>
        public override async Task Generate(ServiceClient serviceClient)
        {
            var serviceClientTemplateModel = new AzureServiceClientTemplateModel(serviceClient);
            // Service client
            var serviceClientTemplate = new AzureServiceClientTemplate
            {
                Model = serviceClientTemplateModel,
            };
            await Write(serviceClientTemplate, Path.Combine("implementation", "api", serviceClient.Name.ToPascalCase() + "Impl.java"));

            //Models
            foreach (var modelType in serviceClient.ModelTypes.Concat(serviceClient.HeaderTypes))
            {
                if (modelType.Extensions.ContainsKey(AzureExtensions.ExternalExtension) &&
                    (bool)modelType.Extensions[AzureExtensions.ExternalExtension])
                {
                    continue;
                }
                if (modelType.IsResource())
                {
                    continue;
                }

                var modelTemplate = new ModelTemplate
                {
                    Model = new AzureModelTemplateModel(modelType, serviceClient)
                };
                await Write(modelTemplate, Path.Combine("models", "implementation", "api", modelType.Name.ToPascalCase() + ".java"));
            }

            //MethodGroups
            if (serviceClientTemplateModel.MethodGroupModels.Any())
            {
                foreach (var methodGroupModel in serviceClientTemplateModel.MethodGroupModels)
                {
                    var methodGroupTemplate = new AzureMethodGroupTemplate
                    {
                        Model = (AzureMethodGroupTemplateModel)methodGroupModel
                    };
                    await Write(methodGroupTemplate, Path.Combine("implementation", "api", methodGroupModel.MethodGroupType.ToPascalCase() + "Inner.java"));
                }
            }

            //Enums
            foreach (var enumType in serviceClient.EnumTypes)
            {
                var enumTemplate = new EnumTemplate
                {
                    Model = new AzureEnumTemplateModel(enumType),
                };
                await Write(enumTemplate, Path.Combine("models", "implementation", "api", enumTemplate.Model.Name.ToPascalCase() + ".java"));
            }

            // Page class
            foreach (var pageClass in pageClasses)
            {
                var pageTemplate = new PageTemplate
                {
                    Model = new PageTemplateModel(pageClass.Value, pageClass.Key.Key, pageClass.Key.Value),
                };
                await Write(pageTemplate, Path.Combine("models", "implementation", "api", pageTemplate.Model.TypeDefinitionName + ".java"));
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
                    Model = new AzureModelTemplateModel(exceptionType, serviceClient),
                };
                await Write(exceptionTemplate, Path.Combine("models", "implementation", "api", exceptionTemplate.Model.ExceptionTypeDefinitionName + ".java"));
            }

            // package-info.java
            await Write(new PackageInfoTemplate
            {
                Model = new PackageInfoTemplateModel(serviceClient, serviceClient.Name)
            }, _packageInfoFileName);
            await Write(new PackageInfoTemplate
            {
                Model = new PackageInfoTemplateModel(serviceClient, serviceClient.Name, "implementation")
            }, Path.Combine("implementation", _packageInfoFileName));
            await Write(new PackageInfoTemplate
            {
                Model = new PackageInfoTemplateModel(serviceClient, serviceClient.Name, "implementation.api")
            }, Path.Combine("implementation", "api", _packageInfoFileName));
            await Write(new PackageInfoTemplate
            {
                Model = new PackageInfoTemplateModel(serviceClient, serviceClient.Name, "models")
            }, Path.Combine("models", _packageInfoFileName));
            await Write(new PackageInfoTemplate
            {
                Model = new PackageInfoTemplateModel(serviceClient, serviceClient.Name, "models.implementation")
            }, Path.Combine("models", "implementation", _packageInfoFileName));
            await Write(new PackageInfoTemplate
            {
                Model = new PackageInfoTemplateModel(serviceClient, serviceClient.Name, "models.implementation.api")
            }, Path.Combine("models", "implementation", "api", _packageInfoFileName));
        }
    }
}
