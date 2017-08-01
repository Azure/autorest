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
using Newtonsoft.Json.Linq;
using System.Linq;

namespace AutoRest.Core
{
    [JsonObject(MemberSerialization.OptIn)]
    public abstract class CodeGenerator
    {
        protected CodeGenerator()
        {
        }

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
        public virtual Task Generate(CodeModel codeModel)
        {
            ResetFileList();

            // since we're not actually async, return a completed task.
            return "".AsResultTask();
        }

        /// <summary>
        /// Generates example code from an x-ms-examples section.
        /// </summary>
        public virtual string GenerateSample(bool isolateSnippet, CodeModel cm, MethodGroup g, Method m, string exampleName, Model.XmsExtensions.Example example) => null;

        /// <summary>
        /// Generates code samples and outputs them in the file system.
        /// </summary>
        public async Task GenerateSamples(CodeModel codeModel)
        {
            var singleFile = Settings.Instance.OutputFileName != null;
            var outputs = new List<Tuple<MethodGroup, Method, string, string>>();
            foreach (var group in codeModel.Operations)
            {
                foreach (var method in group.Methods)
                {
                    var examplesRaw = method.Extensions.GetValue<JObject>(Model.XmsExtensions.Examples.Name);
                    var examples = Model.XmsExtensions.Examples.FromJObject(examplesRaw);
                    foreach (var example in examples)
                    {
                        Logger.Instance.Log(Category.Info, $"Generating example '{example.Key}' of '{group.Name}/{method.Name}'");
                        var content = GenerateSample(singleFile, codeModel, group, method, example.Key, example.Value);
                        if (content != null)
                        {
                            outputs.Add(new Tuple<MethodGroup, Method, string, string>(group, method, example.Key, content));
                        }
                        else
                        {
                            Logger.Instance.Log(Category.Warning, $"Did not generate example '{example.Key}' of '{group.Name}/{method.Name}'");
                        }
                    }
                }
            }

            if (singleFile)
            {
                await Write(string.Join("\n\n", outputs.Select(output => output.Item4)), Settings.Instance.OutputFileName);
            }
            else
            {
                foreach (var output in outputs)
                {
                    var folder = string.IsNullOrEmpty(output.Item1.Name) ? "" : (output.Item1.Name + "/");
                    await Write(output.Item4, $"{folder}{output.Item2.Name} ({output.Item3}){ImplementationFileExtension}");
                }
            }
        }

        /// <summary>
        /// Writes a template into the specified relative path.
        /// </summary>
        /// <param name="template"></param>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public virtual async Task Write(ITemplate template, string fileName)
        {
            Logger.Instance.Log(Category.Info, $"[WRITING] {template.GetType().Name} => {fileName}");
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
        /// <param name="content"></param>
        /// <param name="fileName"></param>
        /// <param name="skipEmptyLines"></param>
        /// <returns></returns>
        public async Task Write(string content, string fileName, bool skipEmptyLines = false)
        {
            if (Settings.Instance.OutputFileName != null)
            {
                if (!IsSingleFileGenerationSupported)
                {
                    Logger.Instance.Log(Category.Error, // new ArgumentException(Settings.Instance.OutputFileName),
                        Resources.LanguageDoesNotSupportSingleFileGeneration, Settings.Instance.CodeGenerator);
                    return;
                }

                fileName = Settings.Instance.OutputFileName;
            }
            else
            {
                // cleans file before writing
                if (FileList.Contains(fileName))
                {
                    throw new Exception($"Duplicate File Generation: {fileName}");
                }
                FileList.Add(fileName);
            }
            // Make sure the directory exist
            Settings.Instance.FileSystemOutput.CreateDirectory(Path.GetDirectoryName(fileName));

            var lineEnding = fileName.LineEnding();

            using (StringReader streamReader = new StringReader(content))
            using (TextWriter textWriter = Settings.Instance.FileSystemOutput.GetTextWriter(fileName))
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