// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.Azure.NodeJS.Templates;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.NodeJS;
using Microsoft.Rest.Generator.NodeJS.Templates;
using Microsoft.Rest.Generator.Utilities;
using System.Linq;
using System.Threading.Tasks;

namespace Microsoft.Rest.Generator.Azure.NodeJS
{
    public class AzureNodeJSCodeGenerator : NodeJSCodeGenerator
    {
        public AzureNodeJSCodeGenerator(Settings settings) 
            : base(settings)
        {
        }

        public override string Name
        {
            get { return "Azure.NodeJS"; }
        }

        public override string Description
        {
            // TODO resource string.
            get { return "Azure NodeJS for Http Client Libraries"; }
        }

        public override string UsageInstructions
        {
            // TODO: resource string with correct usage message.
            get { return string.Empty; }
        }

        public override string ImplementationFileExtension
        {
            get { return ".js"; }
        }

        /// <summary>
        /// Normalizes client model by updating names and types to be language specific.
        /// </summary>
        /// <param name="serviceClient"></param>
        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
            Settings.AddCredentials = true;
            AzureCodeGenerator.UpdateHeadMethods(serviceClient);
            AzureCodeGenerator.ParseODataExtension(serviceClient);
            AzureCodeGenerator.AddPageableMethod(serviceClient);
            AzureCodeGenerator.RemoveCommonPropertiesFromMethods(serviceClient);
            AzureCodeGenerator.AddLongRunningOperations(serviceClient);
            AzureCodeGenerator.AddAzureProperties(serviceClient);
            AzureCodeGenerator.SetDefaultResponses(serviceClient);
            NormalizeApiVersion(serviceClient);
            base.NormalizeClientModel(serviceClient);
        }

        private static void NormalizeApiVersion(ServiceClient serviceClient)
        {
            var property = serviceClient.Properties.First(p => p.Name == AzureCodeGenerator.ApiVersion);
            if (property != null)
            {
                property.DefaultValue = property.DefaultValue.Replace('"', '\'');
            }
        }

        /// <summary>
        /// Generate Azure NodeJS client code for given ServiceClient.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <returns></returns>
        public override async Task Generate(ServiceClient serviceClient)
        {
            var serviceClientTemplateModel = new AzureServiceClientTemplateModel(serviceClient);
            // Service client
            var serviceClientTemplate = new Microsoft.Rest.Generator.Azure.NodeJS.Templates.AzureServiceClientTemplate
            {
                Model = serviceClientTemplateModel
            };
            await Write(serviceClientTemplate, serviceClient.Name.ToCamelCase() + ".js");

            //Models
            if (serviceClient.ModelTypes.Any())
            {
                var modelIndexTemplate = new AzureModelIndexTemplate
                {
                    Model = serviceClientTemplateModel
                };
                await Write(modelIndexTemplate, "models\\index.js");
                foreach (var modelType in serviceClientTemplateModel.ModelTemplateModels)
                {
                    var modelTemplate = new ModelTemplate
                    {
                        Model = modelType
                    };
                    await Write(modelTemplate, "models\\" + modelType.Name.ToCamelCase() + ".js");
                }
            }

            //MethodGroups
            if (serviceClientTemplateModel.MethodGroupModels.Any())
            {
                var methodGroupIndexTemplate = new MethodGroupIndexTemplate
                {
                    Model = serviceClientTemplateModel
                };
                await Write(methodGroupIndexTemplate, "operations\\index.js");
                foreach (var methodGroupModel in serviceClientTemplateModel.MethodGroupModels)
                {
                    var methodGroupTemplate = new AzureMethodGroupTemplate
                    {
                        Model = methodGroupModel as AzureMethodGroupTemplateModel
                    };
                    await Write(methodGroupTemplate, "operations\\" + methodGroupModel.MethodGroupType.ToCamelCase() + ".js");
                }
            }
        }
    }
}