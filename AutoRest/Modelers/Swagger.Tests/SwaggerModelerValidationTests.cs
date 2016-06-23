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
using Microsoft.Rest.Generator.Validation;
using System.Collections.Generic;
using Microsoft.Rest.Generators.Validation;

namespace Microsoft.Rest.Modeler.Swagger.Tests
{
    internal static class AssertExtensions
    {
        internal static void AssertOnlyValidationMessage(this IEnumerable<ValidationMessage> messages, ValidationException exception)
        {
            Assert.Equal(1, messages.Count());
            Assert.Equal(exception, messages.First().ValidationException);
        }
    }

    [Collection("Validation Tests")]
    public class SwaggerModelerValidationTests
    {
        private IEnumerable<ValidationMessage> ValidateSwagger(string input)
        {
            Generator.Modeler modeler = new SwaggerModeler(new Settings
            {
                Namespace = "Test",
                Input = input
            });
            IEnumerable<ValidationMessage> messages = new List<ValidationMessage>();
            modeler.Build(out messages);
            return messages;
        }

        [Fact]
        public void MissingDescriptionValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "definition-missing-description.json"));
            messages.AssertOnlyValidationMessage(ValidationException.DescriptionRequired);
        }

        [Fact]
        public void DefaultValueInEnumValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "default-value-not-in-enum.json"));
            Assert.Equal(1, messages.Count(l => l.Message.Contains("The default value is not one of the values enumerated as valid for this element.")));
        }

        [Fact]
        public void ConsumesMustBeValidType()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "consumes-invalid-type.json"));
            messages.AssertOnlyValidationMessage(ValidationException.OnlyJSONInRequest);
        }

        [Fact]
        public void ProducesMustBeValidType()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "produces-invalid-type.json"));
            messages.AssertOnlyValidationMessage(ValidationException.OnlyJSONInResponse);
        }

        [Fact]
        public void InOperationsConsumesMustBeValidType()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "operations-consumes-invalid-type.json"));
            Assert.Equal(1, messages.Count(l => l.Message.Equals("Currently, only JSON-based request payloads are supported, so 'application/xml' won't work.")));
            messages.AssertOnlyValidationMessage(ValidationException.OnlyJSONInRequest);
        }

        [Fact]
        public void InOperationsProducesMustBeValidType()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "operations-produces-invalid-type.json"));
            messages.AssertOnlyValidationMessage(ValidationException.OnlyJSONInResponse);
        }

        [Fact]
        public void RequiredPropertiesMustExist()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "required-property-not-in-properties.json"));
            Assert.Equal(1, messages.Count(l => l.Message.Equals("'foo' is supposedly required, but no such property exists.")));
        }

        [Fact]
        public void OnlyOneBodyParameter()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "operations-multiple-body-parameters.json"));
            Assert.Equal(1, messages.Count(l => l.Message.Equals("Operations can not have more than one 'body' parameter. The following were found: 'test,test2'")));
        }
    }
}
