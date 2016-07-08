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
using System.Collections.Generic;

namespace Microsoft.Rest.Modeler.Swagger.Tests
{
    internal static class AssertExtensions
    {
        /*
        internal static void AssertOnlyValidationError(this IEnumerable<ValidationMessage> messages, ValidationExceptionName exception)
        {
            AssertOnlyValidationMessage(messages.Where(m => m.Severity == LogEntrySeverity.Error), exception);
        }
        */

        internal static void AssertOnlyValidationWarning(this IEnumerable<ValidationMessage> messages, ValidationExceptionName exception)
        {
            AssertOnlyValidationMessage(messages.Where(m => m.Severity == LogEntrySeverity.Warning), exception);
        }

        internal static void AssertOnlyValidationMessage(this IEnumerable<ValidationMessage> messages, ValidationExceptionName exception)
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
            messages.AssertOnlyValidationMessage(ValidationExceptionName.DescriptionRequired);
        }

        [Fact]
        public void DefaultValueInEnumValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "default-value-not-in-enum.json"));
            messages.AssertOnlyValidationMessage(ValidationExceptionName.DefaultMustAppearInEnum);
        }

        /*
        [Fact]
        public void InvalidFormatValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "invalid-format.json"));
            //messages.AssertOnlyValidationMessage(ValidationException.FormatMustExist);
            throw new NotImplementedException();
        }
        */

        [Fact]
        public void EmptyClientNameValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "empty-client-name-extension.json"));
            messages.AssertOnlyValidationWarning(ValidationExceptionName.ClientNameMustNotBeEmpty);
        }

        [Fact]
        public void RefSiblingPropertiesValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "ref-sibling-properties.json"));
            messages.AssertOnlyValidationWarning(ValidationExceptionName.RefsMustNotHaveSiblings);
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

        /*
        [Fact]
        public void RequiredPropertiesMustExistValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "required-property-not-in-properties.json"));
            messages.AssertOnlyValidationError(ValidationExceptionName.RequiredPropertiesMustExist);
        }
        */

        /*
        [Fact]
        public void OnlyOneBodyParameterValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "operations-multiple-body-parameters.json"));
            //messages.AssertOnlyValidationMessage(ValidationException.OnlyOneBodyParameterAllowed);
            throw new NotImplementedException();
        }
        */

        [Fact]
        public void NoResponsesValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "operations-no-responses.json"));
            messages.AssertOnlyValidationMessage(ValidationExceptionName.DefaultResponseRequired);
        }

        [Fact]
        public void AnonymousSchemasDiscouragedValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "anonymous-response-type.json"));
            messages.AssertOnlyValidationMessage(ValidationExceptionName.AnonymousTypesDiscouraged);
        }

        [Fact]
        public void AnonymousParameterSchemaValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "anonymous-parameter-type.json"));
            messages.AssertOnlyValidationMessage(ValidationExceptionName.AnonymousTypesDiscouraged);
        }

        [Fact]
        public void OperationGroupSingleUnderscoreValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "operation-group-underscores.json"));
            messages.AssertOnlyValidationMessage(ValidationExceptionName.OnlyOneUnderscoreInOperationId);
        }

        [Fact]
        public void MissingDefaultResponseValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "operations-no-default-response.json"));
            messages.AssertOnlyValidationMessage(ValidationExceptionName.DefaultResponseRequired);
        }

        [Fact]
        public void XMSPathNotInPathsValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validator", "xms-path-not-in-paths.json"));
            messages.AssertOnlyValidationMessage(ValidationExceptionName.XmsPathsMustOverloadPaths);
        }
    }
}
