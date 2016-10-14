// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.NodeJS.Azure.Model;
using AutoRest.NodeJS.Azure.Properties;
using AutoRest.NodeJS.Azure.Templates;
using AutoRest.NodeJS.Templates;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.NodeJS.Azure
{
    public class CodeGeneratorJsa : NodeJS.CodeGeneratorJs
    {
        private const string ClientRuntimePackage = "ms-rest-azure version 1.15.0";

        public override string UsageInstructions => string.Format(CultureInfo.InvariantCulture,
            Resources.UsageInformation, ClientRuntimePackage);

        public override string ImplementationFileExtension => ".js";


        /// <summary>
        /// Generate Azure NodeJS client code 
        /// </summary>
        /// <param name="cm"></param>
        /// <returns></returns>
        public override async Task Generate(CodeModel cm)
        {
            var disableTypeScriptGeneration = Singleton<GeneratorSettingsJs>.Instance.DisableTypeScriptGeneration;

            var codeModel = cm as CodeModelJsa;
            if (codeModel == null)
            {
                throw new InvalidCastException("CodeModel is not a Azure NodeJS code model.");
            }

            // Service client
            var serviceClientTemplate = new AzureServiceClientTemplate { Model = codeModel };
            await Write(serviceClientTemplate, codeModel.Name.ToCamelCase() + ".js");

            if (!disableTypeScriptGeneration)
            {
                var serviceClientTemplateTS = new AzureServiceClientTemplateTS { Model = codeModel, };
                await Write(serviceClientTemplateTS, codeModel.Name.ToCamelCase() + ".d.ts");
            }

            var modelIndexTemplate = new AzureModelIndexTemplate { Model = codeModel };
            await Write(modelIndexTemplate, Path.Combine("models", "index.js"));

            if (!disableTypeScriptGeneration)
            {
                var modelIndexTemplateTS = new AzureModelIndexTemplateTS { Model = codeModel };
                await Write(modelIndexTemplateTS, Path.Combine("models", "index.d.ts"));
            }

            //Models
            if (codeModel.ModelTemplateModels.Any())
            {
                // Paged Models
                foreach (var pageModel in codeModel.PageTemplateModels)
                {
                    var pageTemplate = new PageModelTemplate { Model = pageModel };
                    await Write(pageTemplate, Path.Combine("models", pageModel.Name.ToCamelCase() + ".js"));
                }
                
                foreach (var modelType in codeModel.ModelTemplateModels.Where( each => !codeModel.PageTemplateModels.Any( ptm=> ptm.Name.EqualsIgnoreCase(each.Name)) ))
                {
                    var modelTemplate = new ModelTemplate { Model = modelType };
                    await Write(modelTemplate, Path.Combine("models", modelType.NameAsFileName.ToCamelCase() + ".js"));
                }
            }

            //MethodGroups
            if (codeModel.MethodGroupModels.Any())
            {
                var methodGroupIndexTemplate = new MethodGroupIndexTemplate { Model = codeModel };
                await Write(methodGroupIndexTemplate, Path.Combine("operations", "index.js"));

                if (!disableTypeScriptGeneration)
                {
                    var methodGroupIndexTemplateTS = new MethodGroupIndexTemplateTS { Model = codeModel };
                    await Write(methodGroupIndexTemplateTS, Path.Combine("operations", "index.d.ts"));
                }
                
                foreach (var methodGroupModel in codeModel.MethodGroupModels)
                {
                    var methodGroupTemplate = new AzureMethodGroupTemplate { Model = methodGroupModel };
                    await Write(methodGroupTemplate, Path.Combine("operations", methodGroupModel.TypeName.ToCamelCase() + ".js"));
                }
            }
        }
    }
}
