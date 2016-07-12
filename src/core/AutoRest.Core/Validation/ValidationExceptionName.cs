// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.Core.Validation
{
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", MessageId = "Xms")]
    public enum ValidationExceptionName
    {
        None = 0,
        DescriptionRequired,
        NonEmptyClientName,
        DefaultMustBeInEnum,
        RefsMustNotHaveSiblings,
        AnonymousTypesDiscouraged,
        OneUnderscoreInOperationId,
        DefaultResponseRequired,
        XmsPathsMustOverloadPaths,
        DescriptiveDescription,
        OperationIdNounsNotInVerbs,
    }
}