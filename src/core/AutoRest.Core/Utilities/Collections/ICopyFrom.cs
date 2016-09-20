// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

namespace AutoRest.Core.Utilities.Collections
{
    public interface ICopyFrom<in T> : ICopyFrom
    {
        bool CopyFrom(T source);
    }

    public interface ICopyFrom
    {
        bool CopyFrom(object source);
    }
}