// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using AutoRest.Core.Utilities;
using Microsoft.CodeAnalysis;
using Microsoft.Rest.CSharp.Compiler.Compilation;
using Xunit.Abstractions;
using OutputKind = Microsoft.Rest.CSharp.Compiler.Compilation.OutputKind;

namespace AutoRest.CSharp.Unit.Tests
{
    public class BugTest
    {
        private ITestOutputHelper _output;
        internal static string[] SuppressWarnings = {"CS1701"};

        public BugTest(ITestOutputHelper output)
        {
            _output = output;
        }

        public BugTest()
        {
        }

        protected virtual MemoryFileSystem CreateMockFilesystem()
        {
            var fs = new MemoryFileSystem();
            fs.Copy(Path.Combine("Resource", "AutoRest.json"));
            return fs;
        }

        protected virtual MemoryFileSystem GenerateCodeForTestFromSpec()
        {
           return GenerateCodeForTestFromSpec($"{GetType().Name}.yaml");
        }

        protected virtual MemoryFileSystem GenerateCodeForTestFromSpec(string file)
        {
            var fs = CreateMockFilesystem();
            file.GenerateCodeInto(fs);
            return fs;
        }

        protected virtual void WriteLine(object value)
        {
            if (value != null)
            {
                _output?.WriteLine(value.ToString());
                Debug.WriteLine(value.ToString());
            }
            else
            {
                _output?.WriteLine("<null>");
                Debug.WriteLine("<null>");
            }
        }

        protected virtual void WriteLine(string format, params object[] values)
        {
            if (format != null)
            {
                if (values != null && values.Length > 0)
                {
                    _output?.WriteLine(format, values);
                    Debug.WriteLine(format, values);
                }
                else
                {
                    _output?.WriteLine(format);
                    Debug.WriteLine(format);
                }
            }
            else
            {
                _output?.WriteLine("<null>");
                Debug.WriteLine("<null>");
            }
        }

        protected void Write(IEnumerable<Diagnostic> messages, MemoryFileSystem fileSystem)
        {
            if (messages.Any())
            {
                foreach (var file in messages.GroupBy(each => each.Location?.SourceTree?.FilePath, each => each))
                {
                    var text = file.Key != null ? fileSystem.VirtualStore[file.Key].ToString() : string.Empty;

                    foreach (var error in file)
                    {
                        WriteLine(error.ToString());
                        // WriteLine(text.Substring(error.Location.SourceSpan.Start, error.Location.SourceSpan.Length));
                    }
                }
            }
        }

        protected async Task<CompilationResult> Compile(IFileSystem fileSystem)
        {
            var compiler = new CSharpCompiler(
                fileSystem.GetFiles("GeneratedCode", "*.cs", SearchOption.AllDirectories)
                    .Select(each => new KeyValuePair<string, string>(each, fileSystem.ReadFileAsText(each))).ToArray(),
                ManagedAssets.FrameworkAssemblies.Concat(
                    AppDomain.CurrentDomain.GetAssemblies()
                        .Where(each => !each.IsDynamic)
                        .Select(each => each.Location)
                        .Concat(new[]
                        {
                            Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location),
                                "Microsoft.Rest.ClientRuntime.dll")
                        })
                    ));
            return await compiler.Compile(OutputKind.DynamicallyLinkedLibrary);
        }
    }
}