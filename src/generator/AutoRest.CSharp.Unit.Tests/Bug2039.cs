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
    public class Bug2039 : BugTest
    {
        public Bug2039(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/Bug2039
        ///     StackOverflowException on circular references in Swagger Doc (caused by recursive IsConstant getter)
        /// </summary>
        [Fact]
        public void CircularReferenceBreaksIsConstant()
        {
            using (var fileSystem = GenerateCodeForTestFromSpec(codeGenerator: "Azure.CSharp"))
            {
                // if we reach this, apparently no stack overflow has happened :-)
                Assert.True(fileSystem.FileExists(@"Models\Node.cs"));
            }
        }
    }
}