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
        private static string RuntimeDirectory => AppContext.BaseDirectory;

        public static string ReferencesPath { get; } = "";

        #region Helpers

        private static string GetManifestResource(string name)
        {
            using (var reader = new StreamReader(typeof(ManagedAssets).GetTypeInfo().Assembly.GetManifestResourceStream(name)))
            {
                return reader.ReadToEnd();
            }
        }
        
        private static IEnumerable<MetadataReference> LoadReferences(string baseDirectory, params string[] assemblyNames)
        {
            return (from assemblyName in assemblyNames
                let path = Path.Combine(baseDirectory, assemblyName)
                select MetadataReference.CreateFromFile(path, MetadataReferenceProperties.Assembly)).ToArray();
        }

        #endregion
    }
}