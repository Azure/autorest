// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.NodeJS.Model;
using AutoRest.NodeJS.Properties;
using AutoRest.NodeJS.Templates;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.NodeJS
{
    public class CodeGeneratorJs : CodeGenerator
    {
        private const string ClientRuntimePackage = "ms-rest version 1.15.0";


        public override string ImplementationFileExtension => ".js";


        public override string UsageInstructions => string.Format(CultureInfo.InvariantCulture,
            Resources.UsageInformation, ClientRuntimePackage);

        /// <summary>
        ///     Generate NodeJS client code 
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <returns></returns>
        public override async Task Generate(CodeModel cm)
        {
            var disableTypeScriptGeneration = Singleton<GeneratorSettingsJs>.Instance.DisableTypeScriptGeneration;

            var codeModel = cm as CodeModelJs;
            if (codeModel == null)
            {
                throw new InvalidCastException("CodeModel is not a NodeJS code model.");
            }

            // Service client
            var serviceClientTemplate = new ServiceClientTemplate {Model = codeModel};
            await Write(serviceClientTemplate, codeModel.Name.ToCamelCase() + ".js");

            if (!disableTypeScriptGeneration)
            {
                var serviceClientTemplateTS = new ServiceClientTemplateTS {Model = codeModel};
                await Write(serviceClientTemplateTS, codeModel.Name.ToCamelCase() + ".d.ts");
            }

            //Models
            if (codeModel.ModelTypes.Any())
            {
                var modelIndexTemplate = new ModelIndexTemplate {Model = codeModel};
                await Write(modelIndexTemplate, Path.Combine("models", "index.js"));

                if (!disableTypeScriptGeneration)
                {
                    var modelIndexTemplateTS = new ModelIndexTemplateTS {Model = codeModel};
                    await Write(modelIndexTemplateTS, Path.Combine("models", "index.d.ts"));
                }

                foreach (var modelType in codeModel.ModelTemplateModels)
                {
                    var modelTemplate = new ModelTemplate {Model = modelType};
                    await Write(modelTemplate, Path.Combine("models", modelType.NameAsFileName.ToCamelCase() + ".js"));
                }
            }

            //MethodGroups
            if (codeModel.MethodGroupModels.Any())
            {
                var methodGroupIndexTemplate = new MethodGroupIndexTemplate {Model = codeModel};
                await Write(methodGroupIndexTemplate, Path.Combine("operations", "index.js"));

                if (!disableTypeScriptGeneration)
                {
                    var methodGroupIndexTemplateTS = new MethodGroupIndexTemplateTS {Model = codeModel};
                    await Write(methodGroupIndexTemplateTS, Path.Combine("operations", "index.d.ts"));
                }

                foreach (var methodGroupModel in codeModel.MethodGroupModels)
                {
                    var methodGroupTemplate = new MethodGroupTemplate {Model = methodGroupModel};
                    await
                        Write(methodGroupTemplate,
                            Path.Combine("operations", methodGroupModel.TypeName.ToCamelCase() + ".js"));
                }
            }
        }
    }
}