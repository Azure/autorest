// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using AutoRest.Core.Model;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Utilities;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace AutoRest.Core
{
    [JsonObject(MemberSerialization.OptIn)]
    public abstract class CodeGenerator
    {
        private bool firstTimeWriteSingleFile = true;

        protected CodeGenerator()
        {
        }

        // TODO: header files aren't part of most target languages. Remove?
        public virtual string HeaderFileExtension => null;

        public abstract string ImplementationFileExtension { get; }

        /// <summary>
        /// Text to inform the user of required package/module/gem/jar.
        /// </summary>
        public abstract string UsageInstructions { get; }

        /// <summary>
        /// Gets or sets boolean value indicating if code generation language supports all the code to be generated in a single file.
        /// </summary>
        public virtual bool IsSingleFileGenerationSupported => false;

        private readonly List<string> FileList = new List<string>();
        private void ResetFileList()
        {
            FileList.Clear();
        }

        /// <summary>
        /// Generates code and outputs it in the file system.
        /// </summary>
        /// <param name="codeModel"></param>
        /// <returns></returns>
        public virtual /* async */ Task Generate(CodeModel codeModel)
        {
            ResetFileList();

            // since we're not actually async, return a completed task.
            return "".AsResultTask();
        }

        /// <summary>
        /// Writes a template into the specified relative path.
        /// </summary>
        /// <param name="template"></param>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public async Task Write(ITemplate template, string fileName)
        {
            if (Settings.Instance.Verbose)
            {
                Console.WriteLine($"[WRITING] {template.GetType().Name} => {fileName}");
            }
            template.Settings = Settings.Instance;
            var stringBuilder = new StringBuilder();
            using (template.TextWriter = new StringWriter(stringBuilder))
            {
                await template.ExecuteAsync().ConfigureAwait(false);
            }
            await Write(stringBuilder.ToString(), fileName, true);
        }

        /// <summary>
        /// Writes a template string into the specified relative path.
        /// </summary>
        /// <param name="template"></param>
        /// <param name="fileName"></param>
        /// <param name="skipEmptyLines"></param>
        /// <returns></returns>
        public async Task Write(string template, string fileName, bool skipEmptyLines)
        {
            string filePath = null;

            if (Settings.Instance.OutputFileName != null)
            {
                if (!IsSingleFileGenerationSupported)
                {
                    Logger.LogError(new ArgumentException(Settings.Instance.OutputFileName),
                        Resources.LanguageDoesNotSupportSingleFileGeneration, Settings.Instance.CodeGenerator);
                    ErrorManager.ThrowErrors();
                }

                filePath = Path.Combine(Settings.Instance.OutputDirectory, Settings.Instance.OutputFileName);

                if (firstTimeWriteSingleFile)
                {
                    // for SingleFileGeneration clean the file before writing only if its the first time
                    Settings.Instance.FileSystem.DeleteFile(filePath);
                    firstTimeWriteSingleFile = false;
                }
            }
            else
            {
                filePath = Path.Combine(Settings.Instance.OutputDirectory, fileName);
                // cleans file before writing
                if (FileList.Contains(filePath))
                {
                    throw new Exception($"Duplicate File Generation: {filePath}");
                }
                FileList.Add(filePath);
                Settings.Instance.FileSystem.DeleteFile(filePath);
            }
            // Make sure the directory exist
            Settings.Instance.FileSystem.CreateDirectory(Path.GetDirectoryName(filePath));

            var lineEnding = filePath.LineEnding();

            using (StringReader streamReader = new StringReader(template))
            using (TextWriter textWriter = Settings.Instance.FileSystem.GetTextWriter(filePath))
            {
                string line;
                while ((line = streamReader.ReadLine()) != null)
                {
                    // remove any errant line endings, and trim whitespace from the end too.
                    line = line.Replace("\r", "").Replace("\n", "").TrimEnd(' ','\r','\n','\t');

                    if (line.Contains(TemplateConstants.EmptyLine))
                    {
                        await textWriter.WriteAsync(lineEnding);
                    }
                    else if (!skipEmptyLines || !string.IsNullOrWhiteSpace(line))
                    {
                        await textWriter.WriteAsync(line);
                        await textWriter.WriteAsync(lineEnding);
                    }
                }
            }
        }
    }
}