// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Validation;

namespace AutoRest.Swagger.Validation
{
    public class DescriptiveDescriptionRequired : TypedRule<string>
    {
        public override bool IsValid(string description)
        {
            return !string.IsNullOrWhiteSpace(description) && !description.Equals("description", System.StringComparison.InvariantCultureIgnoreCase);
        }

        public override ValidationExceptionName Exception
        {
            get
            {
                return ValidationExceptionName.DescriptiveDescription;
            }
        }
    }
}
