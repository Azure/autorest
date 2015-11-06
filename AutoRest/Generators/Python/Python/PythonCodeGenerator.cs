// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Python.Properties;
using Microsoft.Rest.Generator.Python.Templates;
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
        private const string ClientRuntimePackage = "runtime.msrest version 1.1.0";

        public PythonCodeNamer Namer { get; private set; }

        public PythonCodeGenerator(Settings settings) : base(settings)
        {
            Namer = new PythonCodeNamer();
        }

        public override string Name
        {
            get { return "Python"; }
        }

        public override string Description
        {
            // TODO resource string.
            get { return "Python for Http Client Libraries"; }
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
            get { return ".py"; }
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
                Settings.Namespace + "_models");
        }

        private void PopulateAdditionalProperties(ServiceClient serviceClient)
        {
            // TODO???
            if (Settings.AddCredentials)
            {
                if (serviceClient.Properties.FirstOrDefault(
                    p => p.Name.Equals("Credentials", StringComparison.OrdinalIgnoreCase) &&
                         p.SerializedName.Equals("credentials", StringComparison.OrdinalIgnoreCase)) == null)
                {
                    serviceClient.Properties.Add(new Property
                    {
                        Name = "credentials",
                        SerializedName = "credentials",
                        Type = new CompositeType
                        {
                            Name = "ServiceClientCredentials"
                        },
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
            try
            {
                var serviceClientTemplateModel = new ServiceClientTemplateModel(serviceClient);
                // Service client
                var serviceClientInitTemplate = new ServiceClientInitTemplate
                {
                    Model = serviceClientTemplateModel
                };
                await Write(serviceClientInitTemplate, "__init__.py");

                var serviceClientTemplate = new ServiceClientTemplate
                {
                    Model = serviceClientTemplateModel,
                };
                await Write(serviceClientTemplate, serviceClient.Name.ToPythonCase() + ".py");

                //Models
                if (serviceClient.ModelTypes.Any())
                {
                    var modelInitTemplate = new ModelInitTemplate
                    {
                        Model = new ModelInitTemplateModel(serviceClient)
                    };
                    await Write(modelInitTemplate, Path.Combine("models", "__init__.py"));

                    foreach (var modelType in serviceClientTemplateModel.ModelTemplateModels)
                    {
                        var modelTemplate = new ModelTemplate
                        {
                            Model = modelType
                        };
                        await Write(modelTemplate, Path.Combine("models", modelType.Name.ToPythonCase() + ".py"));
                    }
                }

                //MethodGroups
                if (serviceClientTemplateModel.MethodGroupModels.Any())
                {
                    var methodGroupIndexTemplate = new MethodGroupInitTemplate
                    {
                        Model = serviceClientTemplateModel
                    };
                    await Write(methodGroupIndexTemplate, Path.Combine("operations", "__init__.py"));

                    foreach (var methodGroupModel in serviceClientTemplateModel.MethodGroupModels)
                    {
                        var methodGroupTemplate = new MethodGroupTemplate
                        {
                            Model = methodGroupModel
                        };
                        await Write(methodGroupTemplate, Path.Combine("operations", methodGroupModel.MethodGroupType.ToPythonCase() + ".py"));
                    }
                }

                // Enums
                if (serviceClient.EnumTypes.Any())
                {
                    var enumTemplate = new EnumTemplate
                    {
                        Model = new EnumTemplateModel(serviceClient.EnumTypes),
                    };
                    await Write(enumTemplate, Path.Combine("models", "enums.py"));
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                throw;
            }
        }
    }
}
