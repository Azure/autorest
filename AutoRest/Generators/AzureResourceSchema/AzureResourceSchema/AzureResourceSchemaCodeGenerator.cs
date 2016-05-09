// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using System.IO;
using System.Threading.Tasks;

namespace Microsoft.Rest.Generator.AzureResourceSchema
{
    public class AzureResourceSchemaCodeGenerator : CodeGenerator
    {
        public AzureResourceSchemaCodeGenerator(Settings settings)
            : base(settings)
        {
        }

        public string SchemaPath
        {
            get
            {
                string defaultSchemaFileName = Path.GetFileNameWithoutExtension(Settings.Input) + ".schema.json";
                return Path.Combine(Settings.OutputDirectory, Settings.OutputFileName ?? defaultSchemaFileName);
            }
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
            get { return "Your Azure Resource Schema can be found at " + SchemaPath; }
        }

        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
        }

        public override async Task Generate(ServiceClient serviceClient)
        {
            ResourceSchemaModel resourceSchema = ResourceSchemaParser.Parse(serviceClient);

            StringWriter stringWriter = new StringWriter();
            ResourceSchemaWriter.Write(stringWriter, resourceSchema);

            await Write(stringWriter.ToString(), SchemaPath);
        }
    }
}
