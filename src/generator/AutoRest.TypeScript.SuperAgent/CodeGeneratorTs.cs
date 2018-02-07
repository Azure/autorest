using System;
using System.Globalization;
using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.TypeScript.SuperAgent.Model;
using AutoRest.TypeScript.SuperAgent.ModelBinder;
using AutoRest.TypeScript.SuperAgent.Properties;
using AutoRest.TypeScript.SuperAgent.Templates;

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
        /// <returns></returns>
        public override async Task Generate(CodeModel cm)
        {
            var codeModel = cm as CodeModelTs;

            if (codeModel == null)
            {
                throw new InvalidCastException("CodeModel is not a TypeScript code model.");
            }

            try
            {
                var modelsBinder = new ModelsModelBinder();
                var clientModelsBinder = new ClientGroupsModelBinder();

                var models = modelsBinder.Bind(codeModel);
                var clientModels = clientModelsBinder.Bind(codeModel);

                var modelTemplate = new ModelTemplate {Model = models};
                await Write(modelTemplate, "model.ts");

                var clientTemplate = new ClientTemplate {Model = clientModels};
                await Write(clientTemplate, "api.ts");

            }
            catch (Exception ex)
            {
                throw;
            }

        }
    }
}
