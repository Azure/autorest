// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;

namespace AutoRest.Core.Utilities
{
    public class EqualityComparer<T> : IEqualityComparer<T>
    {
        private readonly Func<T, T, bool> _compareFn;
        private readonly Func<T, int> _hashFn;

        public EqualityComparer(Func<T, T, bool> compareFn, Func<T, int> hashFn)
        {
            _compareFn = compareFn;
            _hashFn = hashFn;
        }

        public EqualityComparer(Func<T, T, bool> compareFn)
        {
            _compareFn = compareFn;
            _hashFn = (obj) => obj.GetHashCode();
        }

        public bool Equals(T x, T y)
        {
            return _compareFn(x, y);
        }

        public int GetHashCode(T obj)
        {
            return _hashFn(obj);
        }
    }
}
