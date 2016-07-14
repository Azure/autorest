// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.IO;
using System.Linq;
using Xunit;
using System.Collections.Generic;
using AutoRest.Core.Validation;
using AutoRest.Core.Logging;
using AutoRest.Core;

namespace AutoRest.Swagger.Tests
{
    internal static class AssertExtensions
    {
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
            var modeler = new SwaggerModeler(new Settings
            {
                Namespace = "Test",
                Input = input
            });
            IEnumerable<ValidationMessage> messages = new List<ValidationMessage>();
            modeler.Build(out messages);
            return messages;
        }

        /// <summary>
        /// Verifies that a clean Swagger file does not result in any validation errors
        /// </summary>
        [Fact]
        public void CleanFileValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "clean-complex-spec.json"));
            Assert.Empty(messages.Where(m => m.Severity >= LogEntrySeverity.Warning));
        }

        [Fact]
        public void MissingDescriptionValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "definition-missing-description.json"));
            messages.AssertOnlyValidationMessage(ValidationExceptionName.DescriptionRequired);
        }

        [Fact]
        public void DefaultValueInEnumValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "default-value-not-in-enum.json"));
            messages.AssertOnlyValidationMessage(ValidationExceptionName.DefaultMustBeInEnum);
        }

        [Fact]
        public void EmptyClientNameValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "empty-client-name-extension.json"));
            messages.AssertOnlyValidationWarning(ValidationExceptionName.NonEmptyClientName);
        }

        [Fact]
        public void RefSiblingPropertiesValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "ref-sibling-properties.json"));
            messages.AssertOnlyValidationWarning(ValidationExceptionName.RefsMustNotHaveSiblings);
        }

        [Fact]
        public void NoResponsesValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "operations-no-responses.json"));
            messages.AssertOnlyValidationMessage(ValidationExceptionName.DefaultResponseRequired);
        }

        [Fact]
        public void AnonymousSchemasDiscouragedValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "anonymous-response-type.json"));
            messages.AssertOnlyValidationMessage(ValidationExceptionName.AnonymousTypesDiscouraged);
        }

        [Fact]
        public void AnonymousParameterSchemaValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "anonymous-parameter-type.json"));
            messages.AssertOnlyValidationMessage(ValidationExceptionName.AnonymousTypesDiscouraged);
        }

        [Fact]
        public void OperationGroupSingleUnderscoreValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "operation-group-underscores.json"));
            messages.AssertOnlyValidationMessage(ValidationExceptionName.OneUnderscoreInOperationId);
        }

        [Fact]
        public void MissingDefaultResponseValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "operations-no-default-response.json"));
            messages.AssertOnlyValidationMessage(ValidationExceptionName.DefaultResponseRequired);
        }

        [Fact]
        public void XMSPathNotInPathsValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "xms-path-not-in-paths.json"));
            messages.AssertOnlyValidationMessage(ValidationExceptionName.XmsPathsMustOverloadPaths);
        }
    }
}
