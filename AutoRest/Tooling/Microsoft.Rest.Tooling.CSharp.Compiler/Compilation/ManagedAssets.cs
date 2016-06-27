// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices;
using Microsoft.CodeAnalysis;

namespace Microsoft.Rest.CSharp.Compiler.Compilation
{
    public static class ManagedAssets
    {
        public static string RuntimeDirectory => RuntimeEnvironment.GetRuntimeDirectory();

        public static IEnumerable<string> FrameworkAssemblies => new[]
        {
                    "mscorlib.dll",
                    "System.dll",
                    "System.Core.dll",
                    "System.Linq.Expressions.dll",
                    "System.Net.dll",
                    "System.Net.Http.dll",
                    "System.Runtime.dll",
                    "System.Threading.Tasks.dll",
                    "System.Xml.dll",
                    "System.Xml.Linq.dll",
                    "Microsoft.CSharp.dll"
                }.Select(each => Path.Combine(RuntimeDirectory, each));

        // Framework assemblies
        private static readonly IEnumerable<MetadataReference> frameworkAssemblies =
            LoadReferences(
                RuntimeEnvironment.GetRuntimeDirectory(),
                "mscorlib.dll",
                "System.dll",
                "System.Core.dll",
                "System.Linq.Expressions.dll",
                "System.Net.dll",
                "System.Net.Http.dll",
                "System.Runtime.dll",
                "System.Threading.Tasks.dll",
                "System.Xml.dll",
                "System.Xml.Linq.dll",
                "Microsoft.CSharp.dll");


        public static IEnumerable<MetadataReference> All { get; } = frameworkAssemblies
            .ToArray();

        public static string ReferencesPath { get; } = "";

        #region Helpers

        private static string GetManifestResource(string name)
        {
            using (var reader = new StreamReader(
                typeof(ManagedAssets).GetTypeInfo().Assembly.GetManifestResourceStream(name)))
            {
                return reader.ReadToEnd();
            }
        }

        private static IEnumerable<MetadataReference> LoadReferences(string baseDirectory, params string[] assemblyNames)
        {
            var references =
                from assemblyName in assemblyNames
                let path = Path.Combine(baseDirectory, assemblyName)
                select MetadataReference.CreateFromFile(path, MetadataReferenceProperties.Assembly);

            return references.ToArray();
        }

        #endregion
    }
}