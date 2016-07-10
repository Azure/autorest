// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Properties;
using System.Collections.Generic;

namespace AutoRest.Core.Validation
{
    public static class ValidationExceptionConstants
    {
        public static class Info
        {
            public static readonly IReadOnlyDictionary<ValidationExceptionName, string> Messages = new Dictionary<ValidationExceptionName, string>
            {
                { ValidationExceptionName.AnonymousTypesDiscouraged, Resources.AnonymousTypesDiscouraged },
            };
        }

        public static class Warnings
        {
            public static readonly IReadOnlyDictionary<ValidationExceptionName, string> Messages = new Dictionary<ValidationExceptionName, string>
            {
                { ValidationExceptionName.DescriptionRequired, Resources.MissingDescription },
                { ValidationExceptionName.NonEmptyClientName, Resources.EmptyClientName },
                { ValidationExceptionName.RefsMustNotHaveSiblings, Resources.ConflictingRef },
                { ValidationExceptionName.DefaultResponseRequired, Resources.NoDefaultResponse },
                { ValidationExceptionName.XmsPathsMustOverloadPaths, Resources.XMSPathBaseNotInPaths },
                { ValidationExceptionName.DescriptiveDescription, Resources.DescriptionNotDescriptive },
                { ValidationExceptionName.OperationIdNounsNotInVerbs, Resources.OperationIdNounInVerb },
            };
        }

        public static class Errors
        {
            public static readonly IReadOnlyDictionary<ValidationExceptionName, string> Messages = new Dictionary<ValidationExceptionName, string>
            {
                { ValidationExceptionName.DefaultMustBeInEnum, Resources.InvalidDefault },
                { ValidationExceptionName.OneUnderscoreInOperationId, Resources.OnlyOneUnderscoreAllowedInOperationId },
            };
        }
    }
}
