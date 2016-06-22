﻿// Copyright (c) Microsoft Corporation. All rights reserved.
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
    [Collection("Validation Tests")]
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
        
        [Fact]
        public void ConsumesMustBeValidType()
        {
            Generator.Modeler modeler = new SwaggerModeler(new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "Validator", "consumes-invalid-type.json")
            });
            modeler.Build();
            Assert.Equal(1, Logger.Entries.Count(l => l.Message.Equals("Currently, only JSON-based request payloads are supported, so 'application/xml' won't work.")));
        }
        
        [Fact]
        public void ProducesMustBeValidType()
        {
            Generator.Modeler modeler = new SwaggerModeler(new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "Validator", "produces-invalid-type.json")
            });
            modeler.Build();
            Assert.Equal(1, Logger.Entries.Count(l => l.Message.Equals("Currently, only JSON-based response payloads are supported, so 'application/xml' won't work.")));
        }
        
        [Fact]
        public void InOperationsConsumesMustBeValidType()
        {
            Generator.Modeler modeler = new SwaggerModeler(new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "Validator", "operations-consumes-invalid-type.json")
            });
            modeler.Build();
            Assert.Equal(1, Logger.Entries.Count(l => l.Message.Equals("Currently, only JSON-based request payloads are supported, so 'application/xml' won't work.")));
        }
        
        [Fact]
        public void InOperationsProducesMustBeValidType()
        {
            Generator.Modeler modeler = new SwaggerModeler(new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "Validator", "operations-produces-invalid-type.json")
            });
            modeler.Build();
            Assert.Equal(1, Logger.Entries.Count(l => l.Message.Equals("Currently, only JSON-based response payloads are supported, so 'application/xml' won't work.")));
        }
        
        [Fact]
        public void RequiredPropertiesMustExist()
        {
            Generator.Modeler modeler = new SwaggerModeler(new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "Validator", "required-property-not-in-properties.json")
            });
            Assert.Throws<CodeGenerationException>(() =>
            {
                modeler.Build();
            });
            Assert.Equal(1, Logger.Entries.Count(l => l.Message.Equals("'foo' is supposedly required, but no such property exists.")));
        }
        
        [Fact]
        public void OnlyOneBodyParameter()
        {
            Generator.Modeler modeler = new SwaggerModeler(new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "Validator", "operations-multiple-body-parameters.json")
            });
            Assert.Throws<CodeGenerationException>(() =>
            {
                modeler.Build();
            });
            Assert.Equal(1, Logger.Entries.Count(l => l.Message.Equals("Operations can not have more than one 'body' parameter. The following were found: 'test,test2'")));
        }
    }
}
