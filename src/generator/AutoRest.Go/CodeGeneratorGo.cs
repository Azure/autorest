// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Go.Model;
using AutoRest.Go.Templates;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace AutoRest.Go
{
    public class CodeGeneratorGo : CodeGenerator
    {
        public string Name
        {
            get { return "Go"; }
        }

        public override string UsageInstructions
        {
            get { return string.Empty; }
        }

        public override string ImplementationFileExtension
        {
            get { return ".go"; }
        }

        /// <summary>
        /// Generates Go code for service client.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <returns></returns>
        public override async Task Generate(CodeModel cm)
        {

            var codeModel = cm as CodeModelGo;
            if (codeModel == null)
            {
                throw new Exception("Code model is not a Go Code Model");
            }

            // unfortunately there is an ordering issue here.  during model generation we might
            // flatten some types (but not all depending on type).  then during client generation
            // the validation codegen needs to know if a type was flattened so it can generate
            // the correct code, so we need to generate models before clients.

            // Models
            var modelsTemplate = new ModelsTemplate
            {
                Model = codeModel
            };
            await Write(modelsTemplate, FormatFileName("models"));

            // Service client
            var serviceClientTemplate = new ServiceClientTemplate
            {
                Model = codeModel
            };

            await Write(serviceClientTemplate, FormatFileName("client"));

            // by convention the methods in the method group with an empty
            // name go into the client template so skip them here.
            foreach (var methodGroup in codeModel.MethodGroups.Where(mg => !string.IsNullOrEmpty(mg.Name)))
            {
                var methodGroupTemplate = new MethodGroupTemplate
                {
                    Model = methodGroup
                };
                await Write(methodGroupTemplate, FormatFileName(methodGroup.Name).ToLowerInvariant());
            }

            // Version
            var versionTemplate = new VersionTemplate { Model = codeModel };
            await Write(versionTemplate, FormatFileName("version"));
        }

        private string FormatFileName(string fileName)
        {
            return $"{fileName}{ImplementationFileExtension}";
        }
    }
}
