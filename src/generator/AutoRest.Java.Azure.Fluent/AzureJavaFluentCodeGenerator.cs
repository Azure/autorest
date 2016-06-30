// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;
using AutoRest.Extensions.Azure;
using AutoRest.Java.Azure.Fluent.TemplateModels;
using AutoRest.Java.Azure.Templates;
using AutoRest.Java.TemplateModels;
using AutoRest.Java.Templates;

namespace AutoRest.Java.Azure.Fluent
{
    public class AzureJavaFluentCodeGenerator : AzureJavaCodeGenerator
    {
        private readonly AzureJavaFluentCodeNamer _namer;

        private const string ClientRuntimePackage = "com.microsoft.azure:azure-client-runtime:0.0.1-SNAPSHOT";
        private const string _packageInfoFileName = "package-info.java";

        // page extensions class dictionary.
        private IDictionary<KeyValuePair<string, string>, string> pageClasses;

        public AzureJavaFluentCodeGenerator(Settings settings) : base(settings)
        {
            _namer = new AzureJavaFluentCodeNamer(settings.Namespace);
            IsSingleFileGenerationSupported = true;
            pageClasses = new Dictionary<KeyValuePair<string, string>, string>();
        }

        public override string Name
        {
            get { return "Azure.Java.Fluent"; }
        }

        public override string Description
        {
            get { return "Azure specific Java fluent code generator."; }
        }

        public override string UsageInstructions
        {
            get
            {
                return string.Format(CultureInfo.InvariantCulture,
                    Properties.Resources.UsageInformation, ClientRuntimePackage);
            }
        }

        /// <summary>
        /// Normalizes client model by updating names and types to be language specific.
        /// </summary>
        /// <param name="serviceClient"></param>
        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
            Settings.AddCredentials = true;

            // This extension from general extensions must be run prior to Azure specific extensions.
            AzureExtensions.ProcessParameterizedHost(serviceClient, Settings);
            AzureExtensions.ProcessClientRequestIdExtension(serviceClient);
            AzureExtensions.UpdateHeadMethods(serviceClient);
            AzureExtensions.FlattenModels(serviceClient);
            AzureExtensions.FlattenMethodParameters(serviceClient, Settings);
            ParameterGroupExtensionHelper.AddParameterGroups(serviceClient);
            AzureExtensions.AddLongRunningOperations(serviceClient);
            AzureExtensions.AddAzureProperties(serviceClient);
            AzureExtensions.SetDefaultResponses(serviceClient);
            AzureExtensions.AddPageableMethod(serviceClient, _namer);
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
            var serviceClientTemplateModel = new AzureFluentServiceClientTemplateModel(serviceClient);
            // Service client
            var serviceClientTemplate = new AzureServiceClientTemplate
            {
                Model = serviceClientTemplateModel,
            };
            await Write(serviceClientTemplate, Path.Combine("implementation", serviceClient.Name.ToPascalCase() + "Impl.java"));

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

                var modelTemplateModel = new AzureFluentModelTemplateModel(modelType, serviceClient);
                var modelTemplate = new ModelTemplate
                {
                    Model = modelTemplateModel
                };
                await Write(modelTemplate, Path.Combine(modelTemplateModel.ModelsPackage.Replace(".", "/").TrimStart(new char[] { '/' }), modelType.Name.ToPascalCase() + ".java"));
            }

            //MethodGroups
            if (serviceClientTemplateModel.MethodGroupModels.Any())
            {
                foreach (var methodGroupModel in serviceClientTemplateModel.MethodGroupModels)
                {
                    var methodGroupTemplate = new AzureMethodGroupTemplate
                    {
                        Model = (AzureFluentMethodGroupTemplateModel)methodGroupModel
                    };
                    await Write(methodGroupTemplate, Path.Combine("implementation", methodGroupModel.MethodGroupType.ToPascalCase() + "Inner.java"));
                }
            }

            //Enums
            foreach (var enumType in serviceClient.EnumTypes)
            {
                var enumTemplateModel = new AzureFluentEnumTemplateModel(enumType);
                var enumTemplate = new EnumTemplate
                {
                    Model = enumTemplateModel,
                };
                await Write(enumTemplate, Path.Combine(enumTemplateModel.ModelsPackage.Replace(".", "/").TrimStart(new char[] { '/' }), enumTemplate.Model.Name.ToPascalCase() + ".java"));
            }

            // Page class
            foreach (var pageClass in pageClasses)
            {
                var pageTemplate = new PageTemplate
                {
                    Model = new FluentPageTemplateModel(pageClass.Value, pageClass.Key.Key, pageClass.Key.Value),
                };
                await Write(pageTemplate, Path.Combine("implementation", pageTemplate.Model.TypeDefinitionName + ".java"));
            }

            // Exceptions
            foreach (var exceptionType in serviceClient.ErrorTypes)
            {
                if (exceptionType.Name == "CloudError")
                {
                    continue;
                }

                var exceptionTemplateModel = new AzureFluentModelTemplateModel(exceptionType, serviceClient);
                var exceptionTemplate = new ExceptionTemplate
                {
                    Model = exceptionTemplateModel,
                };
                await Write(exceptionTemplate, Path.Combine(exceptionTemplateModel.ModelsPackage.Replace(".", "/").TrimStart(new char[] { '/' }), exceptionTemplate.Model.ExceptionTypeDefinitionName + ".java"));
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
        }
    }
}
