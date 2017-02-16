// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

namespace AutoRest.CSharp.Unit.Tests {
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Runtime.Serialization;
    using System.Threading.Tasks;
    using Core.Utilities;
    using Microsoft.Rest;
    using Microsoft.Rest.Azure;
    using Microsoft.Rest.CSharp.Compiler.Compilation;
    using Newtonsoft.Json;
    using OutputKind = Microsoft.Rest.CSharp.Compiler.Compilation.OutputKind;
    using System.Reflection;
    

    public class BugTest {
        internal static string[] SuppressWarnings = {"CS1701","CS1702", "CS1591"};
        //Todo: Remove CS1591 when issue https://github.com/Azure/autorest/issues/1387 is fixed

        internal static string[] VsCode = new string[] {
            @"C:\Program Files (x86)\Microsoft VS Code Insiders\Code - Insiders.exe",
            @"C:\Program Files (x86)\Microsoft VS Code\Code.exe"
        };

        protected Assembly LoadAssembly(MemoryStream stream) {
           return Assembly.Load(stream.ToArray());
        }

        protected static string DOTNET = Path.GetDirectoryName( System.Diagnostics.Process.GetCurrentProcess().MainModule.FileName);
        protected static string Shared = Path.Combine( DOTNET, "shared", "Microsoft.NETCore.App" );

        private static int VerNum(string version) 	{
            int n = 0;
            foreach (var i in version.Split('.'))
            {
                int p;
                if (!Int32.TryParse(i, out p))
                {
                    return n;
                }
                n = (n << 8) + p;
            }
            return n;
        }
        private static string _framework;
        protected static string FRAMEWORK { 
            get {
                if (string.IsNullOrEmpty(_framework ) ) {
                    _framework = Path.Combine( Shared, Directory.EnumerateDirectories(Shared).OrderBy( each => VerNum(each) ).FirstOrDefault());
                }
                return _framework;
            }
        }

        protected static readonly string[] _assemblies = new[] {
            
            Path.Combine(FRAMEWORK, "System.Runtime.dll"),
            Path.Combine(FRAMEWORK, "System.Net.Http.dll"),
            Path.Combine(FRAMEWORK, "mscorlib.dll"),
            Path.Combine(FRAMEWORK, "System.Threading.Tasks.dll"),
            Path.Combine(FRAMEWORK, "System.Net.Primitives.dll"),
            Path.Combine(FRAMEWORK, "System.Collections.dll"),
            Path.Combine(FRAMEWORK, "System.Text.Encoding.dll"),
            Path.Combine(FRAMEWORK, "System.Text.RegularExpressions.dll"),
            Path.Combine(FRAMEWORK, "System.IO.dll"),
            

            typeof(Object).GetAssembly().Location,
            typeof(Attribute).GetAssembly().Location,
            typeof(IAzureClient).GetAssembly().Location,
            typeof(RestException).GetAssembly().Location,
            typeof(Uri).GetAssembly().Location,
            typeof(File).GetAssembly().Location,
            //typeof(ActionContext).GetAssembly().Location,
            //typeof(Controller).GetAssembly().Location,
            typeof(Enumerable).GetAssembly().Location,
            typeof(JsonArrayAttribute).GetAssembly().Location,
            typeof(EnumMemberAttribute).GetAssembly().Location,
            //typeof(InlineRouteParameterParser).GetAssembly().Location,
            //typeof(ControllerBase).GetAssembly().Location,
        };

        protected async Task<Microsoft.Rest.CSharp.Compiler.Compilation.CompilationResult> Compile(IFileSystem fileSystem) {
            var compiler = new CSharpCompiler(fileSystem.GetFiles("", "*.cs", SearchOption.AllDirectories)
                .Select(each => new KeyValuePair<string, string>(each, fileSystem.ReadAllText(each))).ToArray(), _assemblies);
            return await compiler.Compile(OutputKind.DynamicallyLinkedLibrary);
        }
    }
}