// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;
using System.Linq;
using Xunit;
using System.Collections.Generic;
using AutoRest.Core.Validation;
using AutoRest.Core.Logging;
using AutoRest.Core;
using AutoRest.Core.Utilities.Collections;
using AutoRest.Swagger.Validation;

namespace AutoRest.Swagger.Tests
{
    [Collection("Comparison Tests")]
    public class SwaggerModelerCompareTests
    {
        private IEnumerable<ComparisonMessage> CompareSwagger(string input)
        {
            var settings = new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "Comparison", "Modified", input),
                Previous = Path.Combine("Swagger", "Comparison", "Original", input)
            };

            var modeler = new SwaggerModeler(settings);
            IEnumerable<ComparisonMessage> messages = modeler.Compare();

            // remove debug-level messages
            messages = messages.Where(each => each.Severity > LogEntrySeverity.Debug);

            return messages;
        }

        /// <summary>
        /// Verifies that raising the version number results in a non-strict comparison.
        /// </summary>
        [Fact]
        public void UpdatedVersionNumberNotStrict()
        {
            var messages = CompareSwagger("version_check_01.json").ToArray();
            Assert.NotEmpty(messages.Where(m => m.Severity == LogEntrySeverity.Warning));
            Assert.Empty(messages.Where(m => m.Severity >= LogEntrySeverity.Error));
        }
    }
}
