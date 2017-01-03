// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;
using Microsoft.AspNetCore.Razor;
using Microsoft.AspNetCore.Razor.CodeGenerators;

namespace Microsoft.Rest.RazorCompiler
{
    public class Compiler
    {
        public Compiler()
        {
            Namespace = "Microsoft.Rest.Generators";
            CopyrightHeader = @"// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.";
        }

        /// <summary>
        /// Gets or sets copyright header for the razor-generated file.
        /// </summary>
        public string CopyrightHeader { get; set; }

        /// <summary>
        /// Specifies the base namespace for the razor-generated compilable outputs. 
        /// Defaults to Microsoft.Rest.Generators.
        /// </summary>
        public string Namespace { get; set; }

        /// <summary>
        /// Generates code files for every razor template in the given directory.
        /// </summary>
        /// <param name="directory">Directory containing razor templates.</param>
        public void Compile(string directory)
        {
            if (Directory.Exists(directory))
            {
                foreach (string file in Directory.EnumerateFiles(directory, "*.cshtml"))
                {
                    GenerateCodeFile(file, Namespace);
                }
            }
        }

        /// <summary>
        /// Generates code for a razor template in the specified namespace.
        /// </summary>
        /// <param name="cshtmlFilePath">Full path to razor template.</param>
        /// <param name="rootNamespace">Root namespace for razor-generated class.</param>
        private void GenerateCodeFile(string cshtmlFilePath, string rootNamespace)
        {
            var basePath = Path.GetDirectoryName(cshtmlFilePath);
            var fileName = Path.GetFileName(cshtmlFilePath);
            var fileNameNoExtension = Path.GetFileNameWithoutExtension(fileName);
            var codeLang = new CSharpRazorCodeLanguage();
            var host = new RazorEngineHost(codeLang);
            host.GeneratedClassContext = new GeneratedClassContext(
                executeMethodName: GeneratedClassContext.DefaultExecuteMethodName,
                writeMethodName: GeneratedClassContext.DefaultWriteMethodName,
                writeLiteralMethodName: GeneratedClassContext.DefaultWriteLiteralMethodName,
                writeToMethodName: "WriteTo",
                writeLiteralToMethodName: "WriteLiteralTo",
                templateTypeName: "HelperResult",
                defineSectionMethodName: "DefineSection",
                generatedTagHelperContext: new GeneratedTagHelperContext());
            var engine = new RazorTemplateEngine(host);

            using (var fileStream = File.OpenText(cshtmlFilePath))
            {
                var code = engine.GenerateCode(
                    input: fileStream,
                    className: fileNameNoExtension,
                    rootNamespace: rootNamespace,
                    sourceFileName: fileName);

                var source = code.GeneratedCode;
                source = CopyrightHeader + "\r\n\r\n" + source;
                var startIndex = 0;
                while (startIndex < source.Length)
                {
                    var startMatch = @"<%$ include: ";
                    var endMatch = @" %>";
                    startIndex = source.IndexOf(startMatch, startIndex);
                    if (startIndex == -1)
                    {
                        break;
                    }
                    var endIndex = source.IndexOf(endMatch, startIndex);
                    if (endIndex == -1)
                    {
                        break;
                    }
                    var includeFileName = source.Substring(startIndex + startMatch.Length,
                        endIndex - (startIndex + startMatch.Length));
                    Console.WriteLine("    Inlining file {0}", includeFileName);
                    var replacement =
                        File.ReadAllText(Path.Combine(basePath, includeFileName))
                            .Replace("\"", "\\\"")
                            .Replace("\r\n", "\\r\\n");
                    source = source.Substring(0, startIndex) + replacement +
                             source.Substring(endIndex + endMatch.Length);
                    startIndex = startIndex + replacement.Length;
                }
                File.WriteAllText(Path.Combine(basePath, string.Format("{0}.cs", fileNameNoExtension)), source);
            }
        }
    }
}