// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.Core.Utilities
{
    public interface IScopeProvider
    {
        string GetUniqueName(string variableName);
    }
}