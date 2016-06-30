// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.ClientModel;

namespace AutoRest.AzureResourceSchema
{
    public class AzureResourceSchemaCodeGenerator : CodeGenerator
    {
        public AzureResourceSchemaCodeGenerator(Settings settings)
            : base(settings)
        {
        }

        public override string Description
        {
            get { return "Azure Resource Schema generator"; }
        }

        public override string ImplementationFileExtension
        {
            get { return ".json"; }
        }

        public override string Name
        {
            get { return "AzureResourceSchema"; }
        }

        public override string UsageInstructions
        {
            get { return "Your Azure Resource Schema(s) can be found in " + Settings.OutputDirectory; }
        }

        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
        }

        public override async Task Generate(ServiceClient serviceClient)
        {
            IDictionary<string, ResourceSchema> resourceSchemas = ResourceSchemaParser.Parse(serviceClient);

            foreach (string resourceProvider in resourceSchemas.Keys)
            {
                StringWriter stringWriter = new StringWriter();
                ResourceSchemaWriter.Write(stringWriter, resourceSchemas[resourceProvider]);

                string schemaPath = Path.Combine(Settings.OutputDirectory, resourceProvider + ".json");
                await Write(stringWriter.ToString(), schemaPath);
            }
        }
    }
}
