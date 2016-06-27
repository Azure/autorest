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
            messages.AssertOnlyValidationMessage(ValidationException.DefaultMustAppearInEnum);
        }

        [Fact]
        public void InvalidTypeValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "invalid-format.json"));
            messages.AssertOnlyValidationMessage(ValidationException.DefaultMustAppearInEnum);
        }

        [Fact]
        public void EmptyClientName()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "empty-client-name-extension.json"));
            messages.AssertOnlyValidationMessage(ValidationException.ClientNameMustNotBeEmpty);
        }

        [Fact]
        public void RefSiblingProperties()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "ref-sibling-properties.json"));
            messages.AssertOnlyValidationMessage(ValidationException.RefsMustNotHaveSiblings);
        }

        /*
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
            messages.AssertOnlyValidationMessage(ValidationException.OnlyJSONInRequest);
        }

        [Fact]
        public void InOperationsProducesMustBeValidType()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "operations-produces-invalid-type.json"));
            messages.AssertOnlyValidationMessage(ValidationException.OnlyJSONInResponse);
        }
        */

        [Fact]
        public void RequiredPropertiesMustExist()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "required-property-not-in-properties.json"));
            messages.AssertOnlyValidationMessage(ValidationException.RequiredPropertiesMustExist);
        }

        [Fact]
        public void OnlyOneBodyParameter()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "operations-multiple-body-parameters.json"));
            messages.AssertOnlyValidationMessage(ValidationException.OnlyOneBodyParameterAllowed);
        }

        [Fact]
        public void ResponseRequiredValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "operations-no-responses.json"));
            messages.AssertOnlyValidationMessage(ValidationException.AResponseMustBeDefined);
        }
    }
}
