// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.NodeJS.Properties;
using Microsoft.Rest.Generator.NodeJS.Templates;
using Microsoft.Rest.Generator.Utilities;
using System.Linq;
using System.Threading.Tasks;
using System.IO;

namespace Microsoft.Rest.Generator.NodeJS
{
    public class NodeJSCodeGenerator : CodeGenerator
    {
        public NodeJsCodeNamer Namer { get; private set; }

        public NodeJSCodeGenerator(Settings settings) : base(settings)
        {
            Namer = new NodeJsCodeNamer();
        }

        public override string Name
        {
            get { return "NodeJS"; }
        }

        public override string Description
        {
            // TODO resource string.
            get { return "NodeJS for Http Client Libraries"; }
        }

        public override string UsageInstructions
        {
            // TODO: resource string with correct usage message.
            get { return Resources.UsageInstructions; }
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
            Namer.NormalizeClientModel(serviceClient);
            Namer.ResolveNameCollisions(serviceClient, Settings.Namespace,
                Settings.Namespace + ".Models");
        }

        /// <summary>
        /// Generate NodeJS client code for given ServiceClient.
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
            await Write(serviceClientTemplate, serviceClient.Name.ToCamelCase() + ".js");

            //Models
            if (serviceClient.ModelTypes.Any())
            {
                var modelIndexTemplate = new ModelIndexTemplate
                {
                    Model = serviceClientTemplateModel
                };
                await Write(modelIndexTemplate, Path.Combine("models", "index.js"));
                foreach (var modelType in serviceClientTemplateModel.ModelTemplateModels)
                {
                    var modelTemplate = new ModelTemplate
                    {
                        Model = modelType
                    };
                    await Write(modelTemplate, Path.Combine("models", modelType.Name.ToCamelCase() + ".js"));
                }
            }

            //MethodGroups
            if (serviceClientTemplateModel.MethodGroupModels.Any())
            {
                var methodGroupIndexTemplate = new MethodGroupIndexTemplate
                {
                    Model = serviceClientTemplateModel
                };
                await Write(methodGroupIndexTemplate, Path.Combine("operations", "index.js"));
                foreach (var methodGroupModel in serviceClientTemplateModel.MethodGroupModels)
                {
                    var methodGroupTemplate = new MethodGroupTemplate
                    {
                        Model = methodGroupModel
                    };
                    await Write(methodGroupTemplate, Path.Combine("operations", methodGroupModel.MethodGroupType.ToCamelCase() + ".js"));
                }
            }
        }
    }
}
