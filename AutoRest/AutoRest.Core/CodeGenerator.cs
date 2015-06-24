// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.IO;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator
{
    public abstract class CodeGenerator
    {
        protected CodeGenerator(Settings settings)
        {
            Settings = settings;
        }

        public abstract string Name { get; }

        // TODO: who uses the Description? It doesn't appear to have any callers?
        public abstract string Description { get; }

        // TODO: header files aren't part of most target languages. Remove?
        public virtual string HeaderFileExtension
        {
            get { return null; }
        }

        // TODO: who uses this? It doesn't appear to have any callers?
        public abstract string ImplementationFileExtension { get; }

        /// <summary>
        /// Text to inform the user of required package/module/gem/jar.
        /// </summary>
        public abstract string UsageInstructions { get; }

        /// <summary>
        /// Gets the Settings passed when invoking AutoRest.
        /// </summary>
        public Settings Settings { get; private set; }

        /// <summary>
        /// Normalizes service model by updating names and types to be language specific.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <returns></returns>
        public abstract void NormalizeClientModel(ServiceClient serviceClient);

        /// <summary>
        /// Generates code and outputs it in the file system.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <returns></returns>
        public abstract Task Generate(ServiceClient serviceClient);

        /// <summary>
        /// Writes a template into the specified relative path.
        /// </summary>
        /// <param name="template"></param>
        /// <param name="relativeFilePath"></param>
        /// <returns></returns>
        public async Task Write(ITemplate template, string relativeFilePath)
        {
            template.Settings = Settings;
            var stringBuilder = new StringBuilder();
            using (template.TextWriter = new StringWriter(stringBuilder))
            {
                await template.ExecuteAsync().ConfigureAwait(false);
            }
            await Write(stringBuilder.ToString(), relativeFilePath);
        }

        /// <summary>
        /// Writes a template string into the specified relative path.
        /// </summary>
        /// <param name="template"></param>
        /// <param name="relativeFilePath"></param>
        /// <returns></returns>
        public async Task Write(string template, string relativeFilePath)
        {
            string filePath = Path.Combine(Settings.OutputDirectory, relativeFilePath);
            // Make sure the directory exist
            Settings.FileSystem.CreateDirectory(Path.GetDirectoryName(filePath));

            using (StringReader streamReader = new StringReader(template))
            using (TextWriter textWriter = Settings.FileSystem.WriteFileAsStream(filePath))
            {
                string line;
                while ((line = streamReader.ReadLine()) != null)
                {
                    if (line.Contains(TemplateConstants.EmptyLine))
                    {
                        await textWriter.WriteLineAsync();
                    }
                    else if (!string.IsNullOrWhiteSpace(line))
                    {
                        await textWriter.WriteLineAsync(line);
                    }
                }
            }
        }
    }
}