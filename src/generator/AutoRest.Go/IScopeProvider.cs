// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.Go
{
    public interface IScopeProvider
    {
        string GetVariableName(string prefix, int suffix = 0);
    }
}