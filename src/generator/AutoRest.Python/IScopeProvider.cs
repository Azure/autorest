// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.Python
{
    public interface IScopeProvider
    {
        string GetVariableName(string prefix);
    }
}