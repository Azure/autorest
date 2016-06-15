// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Python.Properties;
using Microsoft.Rest.Generator.Python.Templates;
using Microsoft.Rest.Generator.Python.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using System;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace Microsoft.Rest.Generator.Python
{
    public class PythonCodeGenerator : CodeGenerator
    {
        private const string ClientRuntimePackage = "msrest version 0.4.0";

        public PythonCodeGenerator(Settings settings) : base(settings)
        {
            Namer = new PythonCodeNamer();
        }

        public PythonCodeNamer Namer { get; set; }

        public override string Name
        {
            get { return "Python"; }
        }

        public override string Description
        {
            // TODO resource string.
            get { return "Generic Python code generator."; }
        }

        [SettingsInfo("The SDK version for generated setup.py.")]
        public string Version { get; set; }

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
            get { return ".py"; }
        }

        /// <summary>
        /// Normalizes client model by updating names and types to be language specific.
        /// </summary>
        /// <param name="serviceClient"></param>
        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
            Extensions.NormalizeClientModel(serviceClient, Settings);
            PopulateAdditionalProperties(serviceClient);
            Namer.NormalizeClientModel(serviceClient);
            Namer.ResolveNameCollisions(serviceClient, Settings.Namespace,
                Settings.Namespace + "_models");
        }

        private void PopulateAdditionalProperties(ServiceClient serviceClient)
        {
            if (Settings.AddCredentials)
            {
                if (!serviceClient.Properties.Any(p => p.Type.IsPrimaryType(KnownPrimaryType.Credentials)))
                {
                    serviceClient.Properties.Add(new Property
                    {
                        Name = "credentials",
                        SerializedName = "credentials",
                        Type = new PrimaryType(KnownPrimaryType.Credentials),
                        IsRequired = true,
                        Documentation = "Subscription credentials which uniquely identify client subscription."
                    });
                }
            }
        }

        /// <summary>
        /// Generate Python client code for given ServiceClient.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <returns></returns>
        public override async Task Generate(ServiceClient serviceClient)
        {
            var serviceClientTemplateModel = new ServiceClientTemplateModel(serviceClient);

            if (!string.IsNullOrWhiteSpace(Version))
            {
                serviceClientTemplateModel.Version = Version;
            }

            // Service client
            var setupTemplate = new SetupTemplate
            {
                Model = serviceClientTemplateModel
            };
            await Write(setupTemplate, "setup.py");

            var serviceClientInitTemplate = new ServiceClientInitTemplate
            {
                Model = serviceClientTemplateModel
            };
            await Write(serviceClientInitTemplate, Path.Combine(serviceClientTemplateModel.PackageName, "__init__.py"));

            var serviceClientTemplate = new ServiceClientTemplate
            {
                Model = serviceClientTemplateModel,
            };
            await Write(serviceClientTemplate, Path.Combine(serviceClientTemplateModel.PackageName, serviceClientTemplateModel.Name.ToPythonCase() + ".py"));

            var versionTemplate = new VersionTemplate
            {
                Model = serviceClientTemplateModel,
            };
            await Write(versionTemplate, Path.Combine(serviceClientTemplateModel.PackageName, "version.py"));

            var exceptionTemplate = new ExceptionTemplate
            {
                Model = serviceClientTemplateModel,
            };
            await Write(exceptionTemplate, Path.Combine(serviceClientTemplateModel.PackageName, "exceptions.py"));

            var credentialTemplate = new CredentialTemplate
            {
                Model = serviceClientTemplateModel,
            };
            await Write(credentialTemplate, Path.Combine(serviceClientTemplateModel.PackageName, "credentials.py"));

            //Models
            if (serviceClient.ModelTypes.Any())
            {
                var modelInitTemplate = new ModelInitTemplate
                {
                    Model = new ModelInitTemplateModel(serviceClient)
                };
                await Write(modelInitTemplate, Path.Combine(serviceClientTemplateModel.PackageName, "models", "__init__.py"));

                foreach (var modelType in serviceClientTemplateModel.ModelTemplateModels)
                {
                    var modelTemplate = new ModelTemplate
                    {
                        Model = modelType
                    };
                    await Write(modelTemplate, Path.Combine(serviceClientTemplateModel.PackageName, "models", modelType.Name.ToPythonCase() + ".py"));
                }
            }

            //MethodGroups
            if (serviceClientTemplateModel.MethodGroupModels.Any())
            {
                var methodGroupIndexTemplate = new MethodGroupInitTemplate
                {
                    Model = serviceClientTemplateModel
                };
                await Write(methodGroupIndexTemplate, Path.Combine(serviceClientTemplateModel.PackageName, "operations", "__init__.py"));

                foreach (var methodGroupModel in serviceClientTemplateModel.MethodGroupModels)
                {
                    var methodGroupTemplate = new MethodGroupTemplate
                    {
                        Model = methodGroupModel
                    };
                    await Write(methodGroupTemplate, Path.Combine(serviceClientTemplateModel.PackageName, "operations", methodGroupModel.MethodGroupType.ToPythonCase() + ".py"));
                }
            }

            // Enums
            if (serviceClient.EnumTypes.Any())
            {
                var enumTemplate = new EnumTemplate
                {
                    Model = new EnumTemplateModel(serviceClient.EnumTypes),
                };
                await Write(enumTemplate, Path.Combine(serviceClientTemplateModel.PackageName, "models", serviceClientTemplateModel.Name.ToPythonCase() + "_enums.py"));
            }
        }
    }
}
