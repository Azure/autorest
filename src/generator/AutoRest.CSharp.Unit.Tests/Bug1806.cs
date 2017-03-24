// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.CodeAnalysis;
using Xunit;
using Xunit.Abstractions;

namespace AutoRest.CSharp.Unit.Tests
{
    public class Bug1806 : BugTest
    {
        public Bug1806(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/1806
        ///     Verifies try catch block exists for operation without default response
        ///     Also verifies the errorbody is being set for the error
        /// </summary>
        [Fact]
        public async Task EmptyDefaultResponseExceptionHandling()
        {
            // simplified test pattern for unit testing aspects of code generation
            using (var fileSystem = GenerateCodeForTestFromSpec(codeGenerator: "Azure.CSharp"))
            {
                // check for the expected class.
                Assert.True(fileSystem.FileExists(@"ContainerServicesOperations.cs"));

                var result = await Compile(fileSystem);

                // filter the warnings
                var warnings = result.Messages.Where(
                    each => each.Severity == DiagnosticSeverity.Warning
                            && !SuppressWarnings.Contains(each.Id)).ToArray();

                // filter the errors
                var errors = result.Messages.Where(each => each.Severity == DiagnosticSeverity.Error).ToArray();

                Write(warnings, fileSystem);
                Write(errors, fileSystem);

                // Don't proceed unless we have zero Warnings.
                Assert.Empty(warnings);

                // Don't proceed unless we have zero Errors.
                Assert.Empty(errors);

                // Should also succeed.
                Assert.True(result.Succeeded);

                // now read from the file to ensure we have the try catch block as expected
                var codeText = fileSystem.ReadAllText(@"ContainerServicesOperations.cs");
                
                Assert.NotEmpty(codeText);
                // is a CloudException object created?
                Assert.True(codeText.Contains("new Microsoft.Rest.Azure.CloudException"));
                // are we deserializing response into CloudError object?
                Assert.True(codeText.Contains("Microsoft.Rest.Serialization.SafeJsonConvert.DeserializeObject<CloudError>"));
                // are we setting the errorbody in exception?
                Assert.True(codeText.Contains("ex.Body = _errorBody;"));

            }
        }
    }
}