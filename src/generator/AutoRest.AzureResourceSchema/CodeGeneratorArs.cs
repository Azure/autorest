// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.AzureResourceSchema
{
    public class CodeGeneratorArs : CodeGenerator
    {
        public CodeGeneratorArs()
        {
        }

        public override string ImplementationFileExtension => ".json";

        public override string UsageInstructions => $"Your Azure Resource Schema(s) can be found in {Settings.Instance.OutputDirectory}";

 
        public override async Task Generate(CodeModel serviceClient)
        {
            IDictionary<string, ResourceSchema> resourceSchemas = ResourceSchemaParser.Parse(serviceClient);

            foreach (string resourceProvider in resourceSchemas.Keys)
            {
                StringWriter stringWriter = new StringWriter();
                ResourceSchemaWriter.Write(stringWriter, resourceSchemas[resourceProvider]);
                await Write(stringWriter.ToString(), resourceProvider + ".json", true);

                stringWriter = new StringWriter();
                ResourceMarkdownWriter.Write(stringWriter, resourceSchemas[resourceProvider]);
                await Write(stringWriter.ToString(), resourceProvider + ".md", false);
            }
        }
    }
}
