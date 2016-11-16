// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections.Generic;

namespace AutoRest.Simplify
{
    public class AdHocEqualityComparer<T> : IEqualityComparer<T>
    {
        private readonly Func<T, T, bool> _compareFunction;

        public AdHocEqualityComparer(Func<T, T, bool> compareFunction)
        {
            _compareFunction = compareFunction;
        }

        /// <summary>When overridden in a derived class, determines whether two objects of type <paramref name="T" /> are equal.</summary>
        /// <returns>true if the specified objects are equal; otherwise, false.</returns>
        /// <param name="x">The first object to compare.</param>
        /// <param name="y">The second object to compare.</param>
        public bool Equals(T x, T y) => _compareFunction(x, y);

        /// <summary>
        ///     When overridden in a derived class, serves as a hash function for the specified object for hashing algorithms
        ///     and data structures, such as a hash table.
        /// </summary>
        /// <returns>A hash code for the specified object.</returns>
        /// <param name="obj">The object for which to get a hash code.</param>
        /// <exception cref="T:System.ArgumentNullException">
        ///     The type of <paramref name="obj" /> is a reference type and
        ///     <paramref name="obj" /> is null.
        /// </exception>
        public int GetHashCode(T obj) => 0;
    }
}