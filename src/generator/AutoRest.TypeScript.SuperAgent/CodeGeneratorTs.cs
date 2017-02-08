using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.TypeScript.SuperAgent.Model;
using AutoRest.TypeScript.SuperAgent.Properties;

namespace AutoRest.TypeScript.SuperAgent
{
    public class CodeGeneratorTs : CodeGenerator
    {
        private const string ClientRuntimePackage = "ms-rest version 1.15.0";

        public override string ImplementationFileExtension => ".ts";

        /// <summary>
        /// Text to inform the user of required package/module/gem/jar.
        /// </summary>
        public override string UsageInstructions => string.Format(CultureInfo.InvariantCulture, Resources.UsageInformation, ClientRuntimePackage);

        /// <summary>
        /// Generates TypeScript code and outputs it in the file system.
        /// </summary>
        /// <param name="codeModel"></param>
        /// <returns></returns>
        public override Task Generate(CodeModel cm)
        {
            //var disableTypeScriptGeneration = DependencyInjection.Singleton<GeneratorSettingsTs>.Instance.DisableTypeScriptGeneration;

            var codeModel = cm as CodeModelTs;
            if (codeModel == null)
            {
                throw new InvalidCastException("CodeModel is not a TypeScript code model.");
            }

            throw new NotImplementedException();

            /*

            // Service client
            var serviceClientTemplate = new ServiceClientTemplate { Model = codeModel };
            await Write(serviceClientTemplate, codeModel.Name.ToCamelCase() + ".js");

            if (!disableTypeScriptGeneration)
            {
                var serviceClientTemplateTS = new ServiceClientTemplateTS { Model = codeModel };
                await Write(serviceClientTemplateTS, codeModel.Name.ToCamelCase() + ".d.ts");
            }

            //Models
            if (codeModel.ModelTypes.Any())
            {
                var modelIndexTemplate = new ModelIndexTemplate { Model = codeModel };
                await Write(modelIndexTemplate, Path.Combine("models", "index.js"));

                if (!disableTypeScriptGeneration)
                {
                    var modelIndexTemplateTS = new ModelIndexTemplateTS { Model = codeModel };
                    await Write(modelIndexTemplateTS, Path.Combine("models", "index.d.ts"));
                }

                foreach (var modelType in codeModel.ModelTemplateModels)
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
                    var methodGroupTemplate = new MethodGroupTemplate { Model = methodGroupModel };
                    await
                        Write(methodGroupTemplate,
                            Path.Combine("operations", methodGroupModel.TypeName.ToCamelCase() + ".ts"));
                }
            }*/
        }
    }
}
