// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks {
    using System;
    using System.Collections.Generic;

    /// <summary>
    ///     A generic implementation of a IComparer that takes a delegate to compare with
    /// </summary>
    /// <typeparam name="T"> </typeparam>
    /// <remarks>
    /// </remarks>
    public class Comparer<T> : IComparer<T> {
        /// <summary>
        /// </summary>
        private readonly Func<T, T, int> _compareFuction;

        /// <summary>
        ///     Initializes a new instance of the <see cref="Comparer&lt;T&gt;" /> class.
        /// </summary>
        /// <param name="compareFn"> The compare fn. </param>
        /// <remarks>
        /// </remarks>
        public Comparer(Func<T, T, int> compareFn) {
            _compareFuction = compareFn;
        }

        /// <summary>
        ///     Compares two objects and returns a value indicating whether one is less than, equal to, or greater than the other.
        /// </summary>
        /// <param name="x"> The first object to compare. </param>
        /// <param name="y"> The second object to compare. </param>
        /// <returns>
        ///     Value Condition Less than zero <paramref name="x" /> is less than <paramref name="y" /> . Zero
        ///     <paramref
        ///         name="x" />
        ///     equals <paramref name="y" /> . Greater than zero <paramref name="x" /> is greater than <paramref name="y" /> .
        /// </returns>
        /// <remarks>
        /// </remarks>
        public int Compare(T x, T y) => 
            _compareFuction(x, y);
    }
}