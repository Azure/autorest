// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Threading.Tasks;

using AutoRest.Core;
using AutoRest.Core.ClientModel;
using AutoRest.Go.TemplateModels;
using AutoRest.Go.Templates;

namespace AutoRest.Go
{
    public class GoCodeGenerator : CodeGenerator
    {
        private readonly GoCodeNamer _namingFramework;

        public GoCodeGenerator(Settings settings) : base(settings)
        {
            _namingFramework = new GoCodeNamer();
        }

        public override string Name
        {
            get { return "Go"; }
        }

        public override string Description
        {
            get { return "Go Client Libraries"; }
        }

        public override string UsageInstructions
        {
            get { return ""; }
        }

        public override string ImplementationFileExtension
        {
            get { return ".go"; }
        }

        /// <summary>
        /// Normalizes client model by updating names and types to be language specific.
        /// </summary>
        /// <param name="serviceClientModel"></param>
        public override void NormalizeClientModel(ServiceClient serviceClientModel)
        {
            // Add the current package name as a reserved keyword
            _namingFramework.ReserveNamespace(Settings.Namespace);
            _namingFramework.NormalizeClientModel(serviceClientModel);
            _namingFramework.ResolveNameCollisions(serviceClientModel, Settings.Namespace,
                Settings.Namespace + ".Models");
        }

        /// <summary>
        /// Generates Go code for service client.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <returns></returns>
        public override async Task Generate(ServiceClient serviceClient)
        {
            string packageName = GoCodeNamer.PackageNameFromNamespace(Settings.Namespace);

            // If version is passed in command line then pick that, else keep it 0.0.0(to make it optional for testing).
            string[] version = GoCodeNamer.SDKVersionFromPackageVersion(
                                            !string.IsNullOrEmpty(Settings.PackageVersion)
                                                    ? Settings.PackageVersion
                                                    : "0.0.0");
            // Service client
            var serviceClientTemplate = new ServiceClientTemplate
            {
                Model = new ServiceClientTemplateModel(serviceClient, packageName),
            };
            await Write(serviceClientTemplate, GoCodeNamer.FormatFileName("client"));

            foreach (var methodGroupName in serviceClient.MethodGroups)
            {
                var groupedMethodTemplate = new MethodGroupTemplate
                {
                    Model = new MethodGroupTemplateModel(serviceClient, packageName, methodGroupName),
                };
                await Write(groupedMethodTemplate, GoCodeNamer.FormatFileName(methodGroupName.ToLowerInvariant()));
            }

            // Models
            var modelsTemplate = new ModelsTemplate
            {
                Model = new ModelsTemplateModel(serviceClient, packageName),
            };
            await Write(modelsTemplate, GoCodeNamer.FormatFileName("models"));

            // Version
            var versionTemplate = new VersionTemplate
            {
                Model = new VersionTemplateModel(serviceClient, packageName, version),
            };
            await Write(versionTemplate, GoCodeNamer.FormatFileName("version"));
        }
    }
}
