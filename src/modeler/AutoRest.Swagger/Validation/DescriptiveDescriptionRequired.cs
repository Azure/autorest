// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Validation;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Swagger.Validation
{
    internal static class DescriptiveDescriptionsExtensions
    {
        private static IEnumerable<string> ImpermissibleDescriptions = new List<string>()
        {
            "description"
        };

        /// <summary>
        /// Determines if the string is a value that is not allowed (case insensitive)
        /// </summary>
        internal static bool IsImpermissibleValue(this string description)
        {
            return ImpermissibleDescriptions.Any(s => s.Equals(description, System.StringComparison.InvariantCultureIgnoreCase));
        }
    }

    public class DescriptiveDescriptionRequired : TypedRule<string>
    {
        /// <summary>
        /// This test passes if the <paramref name="description"/> is not just empty or whitespace and not explictly blocked
        /// </summary>
        /// <param name="description"></param>
        /// <returns></returns>
        public override bool IsValid(string description)
            => !string.IsNullOrWhiteSpace(description) && !description.IsImpermissibleValue();

        public override ValidationExceptionName Exception => ValidationExceptionName.DescriptiveDescription;
    }
}
