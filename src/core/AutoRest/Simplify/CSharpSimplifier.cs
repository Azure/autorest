// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.Simplification;
using Microsoft.CodeAnalysis.Text;
using Microsoft.Rest;
using Microsoft.Rest.Azure;

namespace AutoRest.Simplify
{
    public class CSharpSimplifier
    {
        private static MetadataReference mscorlib;

        private static MetadataReference Mscorlib
        {
            get
            {
                if (mscorlib == null)
                {
                    mscorlib = MetadataReference.CreateFromFile(typeof(object).Assembly.Location);
                }

                return mscorlib;
            }
        }

        public async Task Run()
        {
            var op = new AzureAsyncOperation();
            var restOp = new RestException();

            var files = Settings.Instance.FileSystem.GetFiles(Settings.Instance.OutputDirectory, "*.cs",
                    SearchOption.AllDirectories).
                ToDictionary(each => each, each => Settings.Instance.FileSystem.ReadFileAsText(each));

            var projectId = ProjectId.CreateNewId();
            var solution = new AdhocWorkspace().CurrentSolution
                .AddProject(projectId, "MyProject", "MyProject", LanguageNames.CSharp)
                .AddMetadataReference(projectId, Mscorlib)
                .AddMetadataReference(projectId, AppDomain.CurrentDomain.GetAssemblies()
                    .Where(
                        a =>
                            string.Compare(a.GetName().Name, "Microsoft.Rest.ClientRuntime.Azure",
                                StringComparison.OrdinalIgnoreCase) == 0)
                    .Select(a => MetadataReference.CreateFromFile(a.Location)).Single())
                .AddMetadataReference(projectId, AppDomain.CurrentDomain.GetAssemblies()
                    .Where(
                        a =>
                            string.Compare(a.GetName().Name, "Microsoft.Rest.ClientRuntime",
                                StringComparison.OrdinalIgnoreCase) == 0)
                    .Select(a => MetadataReference.CreateFromFile(a.Location)).Single())
                .AddMetadataReference(projectId, AppDomain.CurrentDomain.GetAssemblies()
                    .Where(a => string.Compare(a.GetName().Name, "System", StringComparison.OrdinalIgnoreCase) == 0)
                    .Select(a => MetadataReference.CreateFromFile(a.Location)).Single());

            // Add existing files
            foreach (var file in files.Keys)
            {
                var documentId = DocumentId.CreateNewId(projectId);
                solution = solution.AddDocument(documentId, file, SourceText.From(files[file]));
            }

            // Simplify docs and add to 
            foreach (var proj in solution.Projects)
            {
                foreach (var document in proj.Documents)
                {
                    var newRoot = await document.GetSyntaxRootAsync();

                    // get the namespaces used in the file
                    var names = new GetQualifiedNames().GetNames(newRoot).Where( each => each != "System.Security.Permissions").ToArray();

                    // add the usings that we found
                    newRoot = new AddUsingsRewriter(names).Visit(newRoot);

                    // tell roslyn to simplify where it can
                    newRoot = new SimplifyNamesRewriter().Visit(newRoot);
                    var doc = document.WithSyntaxRoot(newRoot);

                    // reduce the code 
                    var text = Simplifier.ReduceAsync(doc)
                        .Result.GetTextAsync()
                        .Result.ToString()
                        // get rid of any BOMs 
                        .Trim('\x00EF', '\x00BB', '\x00BF', '\uFEFF', '\u200B');


                    // special cases the simplifier can't handle.
                    text = text.
                        Replace("[Newtonsoft.Json.JsonConverter(", "[JsonConverter(").
                        Replace("[System.Runtime.Serialization.EnumMember(", "[EnumMember(").
                        Replace("[Newtonsoft.Json.JsonProperty(", "[JsonProperty(").
                        Replace("[Newtonsoft.Json.JsonProperty]", "[JsonProperty]").
                        Replace("[Newtonsoft.Json.JsonObject]", "[JsonObject]").
                        Replace("[Microsoft.Rest.Serialization.JsonTransformation]", "[JsonTransformation]").
                        Replace("[Newtonsoft.Json.JsonExtensionData]", "[JsonExtensionData]");

                    // Write out the files back to their original location
                    var output = Path.Combine(Settings.Instance.FileSystem.CurrentDirectory, document.Name);
                    Settings.Instance.FileSystem.WriteFile(output, text);
                }
            }
        }
    }
}