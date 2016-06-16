// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;
using System.Linq;
using System.Net;
using Microsoft.Rest.Generator;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.CSharp;
using Microsoft.Rest.Generator.Extensibility;
using Microsoft.Rest.Generator.Utilities;
using Xunit;
using Newtonsoft.Json.Linq;
using Microsoft.Rest.Generator.Logging;

namespace Microsoft.Rest.Modeler.Swagger.Tests
{
    [Collection("AutoRest Tests")]
    public class SwaggerModelerValidationTests
    {
        [Fact]
        public void MissingDescriptionValidation()
        {
            Generator.Modeler modeler = new SwaggerModeler(new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "Validator", "definition-missing-description.json")
            });
            modeler.Build();
            // TODO: we want to get errors from the modeler.Build or Validate step, with known error types. Not inspect logger
            Assert.Equal(1, Logger.Entries.Count(l => l.Message.Contains("Consider adding a 'description'")));
        }

        [Fact]
        public void DefaultValueInEnumValidation()
        {
            Generator.Modeler modeler = new SwaggerModeler(new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "Validator", "default-value-not-in-enum.json")
            });
            Assert.Throws<CodeGenerationException>(() =>
            {
                modeler.Build();
            });
            // TODO: we want to get errors from the modeler.Build or Validate step, with known error types. Not inspect logger
            Assert.Equal(1, Logger.Entries.Count(l => l.Message.Contains("The default value is not one of the values enumerated as valid for this element.")));
        }
    }
}
