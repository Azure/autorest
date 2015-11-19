// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.Azure.Python.Properties;
using Microsoft.Rest.Generator.Azure.Python.Templates;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Python;
using Microsoft.Rest.Generator.Python.Templates;
using Microsoft.Rest.Generator.Utilities;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace Microsoft.Rest.Generator.Azure.Python
{
    public class AzurePythonCodeGenerator : PythonCodeGenerator
    {
        private const string ClientRuntimePackage = "runtime.msrestazure version 1.1.0";

        private AzurePythonCodeNamer _namer;

        // page extensions class dictionary.
        private IDictionary<Tuple<string, string>, Tuple<string, string>> pageClasses;

        public AzurePythonCodeGenerator(Settings settings)
            : base(settings)
        {
            _namer = new AzurePythonCodeNamer();
            pageClasses = new Dictionary<Tuple<string, string>, Tuple<string, string>>();
        }

        public override string Name
        {
            get { return "Azure.Python"; }
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

        /// <summary>
        /// Normalizes client model by updating names and types to be language specific.
        /// </summary>
        /// <param name="serviceClient"></param>
        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
            AzureExtensions.NormalizeAzureClientModel(serviceClient, Settings);
            _namer.NormalizeClientModel(serviceClient);
            _namer.ResolveNameCollisions(serviceClient, Settings.Namespace,
                Settings.Namespace + "_models");
            _namer.NormalizePaginatedMethods(serviceClient, pageClasses);

            if (serviceClient != null)
            {
                foreach (var model in serviceClient.ModelTypes)
                {
                    if (model.Extensions.ContainsKey(AzureExtensions.AzureResourceExtension) &&
                        (bool)model.Extensions[AzureExtensions.AzureResourceExtension])
                    {
                        model.BaseModelType = new CompositeType { Name = "IResource", SerializedName = "IResource" };
                    }
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
                var serviceClientTemplateModel = new AzureServiceClientTemplateModel(serviceClient);
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
                await Write(serviceClientInitTemplate, Path.Combine(serviceClient.Name.ToPythonCase(), "__init__.py"));

                var serviceClientTemplate = new AzureServiceClientTemplate
                {
                    Model = serviceClientTemplateModel,
                };
                await Write(serviceClientTemplate, Path.Combine(serviceClient.Name.ToPythonCase(), "api_client.py"));

                //Models
                if (serviceClient.ModelTypes.Any())
                {
                    var modelInitTemplate = new AzureModelInitTemplate
                    {
                        Model = new AzureModelInitTemplateModel(serviceClient, pageClasses.Values)
                    };
                    await Write(modelInitTemplate, Path.Combine(serviceClient.Name.ToPythonCase(), "models", "__init__.py"));

                    foreach (var modelType in serviceClientTemplateModel.ModelTemplateModels)
                    {
                        var modelTemplate = new ModelTemplate
                        {
                            Model = modelType
                        };
                        await Write(modelTemplate, Path.Combine(serviceClient.Name.ToPythonCase(), "models", modelType.Name.ToPythonCase() + ".py"));
                    }
                }

                //MethodGroups
                if (serviceClientTemplateModel.MethodGroupModels.Any())
                {
                    var methodGroupIndexTemplate = new MethodGroupInitTemplate
                    {
                        Model = serviceClientTemplateModel
                    };
                    await Write(methodGroupIndexTemplate, Path.Combine(serviceClient.Name.ToPythonCase(), "operations", "__init__.py"));

                    foreach (var methodGroupModel in serviceClientTemplateModel.MethodGroupModels)
                    {
                        var methodGroupTemplate = new AzureMethodGroupTemplate
                        {
                            Model = methodGroupModel as AzureMethodGroupTemplateModel
                        };
                        await Write(methodGroupTemplate, Path.Combine(serviceClient.Name.ToPythonCase(), "operations", methodGroupModel.MethodGroupType.ToPythonCase() + ".py"));
                    }
                }

                // Enums
                if (serviceClient.EnumTypes.Any())
                {
                    var enumTemplate = new EnumTemplate
                    {
                        Model = new EnumTemplateModel(serviceClient.EnumTypes),
                    };
                    await Write(enumTemplate, Path.Combine(serviceClient.Name.ToPythonCase(), "models", "enums.py"));
                }

                // Page class
                foreach (var pageClass in pageClasses)
                {
                    var pageTemplate = new PageTemplate
                    {
                        Model = new PageTemplateModel(pageClass.Value.Item1, pageClass.Key.Item1, pageClass.Key.Item2, pageClass.Value.Item2),
                    };
                    await Write(pageTemplate, Path.Combine(serviceClient.Name.ToPythonCase(), "models",  pageTemplate.Model.TypeDefinitionName.ToPythonCase() + ".py"));
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
