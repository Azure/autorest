// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Collections.Generic;
using AutoRest.Core.Utilities.Collections;

namespace AutoRest.Core.Model
{
    public interface IEnumerableWithIndex<out T> : IEnumerable<T>, ICopyFrom
    {
        T this[int index] { get; }
        int Count { get; }
    }
}