// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using System.Text.RegularExpressions;
using Microsoft.CodeAnalysis;
using Xunit;
using Xunit.Abstractions;

namespace AutoRest.CSharp.Unit.Tests
{
    public class Bug1763 : BugTest
    {
        public Bug1763(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/1763
        ///     Verifies autorest succesfully generates code for models with properties starting with '_'
        /// </summary>
        [Fact]
        public async Task VerifyUnderscoredClassMembers()
        {
            using (var fileSystem = GenerateCodeForTestFromSpec())
            {
                var result = await Compile(fileSystem);

                // Expected Files
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\Pet.cs"));

                // filter the warnings
                var warnings = result.Messages.Where(
                    each => each.Severity == DiagnosticSeverity.Warning
                            && !SuppressWarnings.Contains(each.Id)).ToArray();

                // filter the errors
                var errors = result.Messages.Where(each => each.Severity == DiagnosticSeverity.Error).ToArray();

                Write(warnings, fileSystem);
                Write(errors, fileSystem);

                // Don't proceed unless we have zero warnings.
                Assert.Empty(warnings);
                // Don't proceed unless we have zero Errors.
                Assert.Empty(errors);

                // Should also succeed.
                Assert.True(result.Succeeded);

                // try to load the assembly
                var asm = LoadAssembly(result.Output);
                Assert.NotNull(asm);

                var petModel = asm.ExportedTypes.First(type => type.FullName == "Test.Models.Pet" );
                var idMember = petModel.GetMembers().First(member => member.Name == "_id" );
                Assert.NotNull(idMember);

                // now read from the file to ensure we use this. to access the members
                var codeText = fileSystem.ReadFileAsText(@"GeneratedCode\Models\Pet.cs");
                // get hold of the ctor
                var regex = new Regex(Regex.Escape("public Pet(int _id, string name = default(string))") + @"[^}]+");
                var match = regex.Match(codeText);
                Assert.NotNull(match);
                // verify the ctor has proper assignments
                Assert.True(match.Groups[0].Value.Contains("this._id = _id"));
                Assert.True(match.Groups[0].Value.Contains("this.Name = name"));
            }
        }
    }
}