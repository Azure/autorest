// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks.Async {
    using System.Collections.Generic;
    using System.Runtime.CompilerServices;

    /// <summary>
    ///     Represents an interface that satisfies the compiler's requirements for supporting the await keyword
    ///     for the completion of an asynchronous operation and provides a parameter for the result.
    /// </summary>
    /// <typeparam name="T">
    ///     The type of objects to enumerate.This type parameter is covariant. That is, you can use either the
    ///     type you specified or any type that is more derived. For more information about covariance and contravariance, see
    ///     Covariance and Contravariance in Generics.
    /// </typeparam>
    /// <filterpriority>1</filterpriority>
    public interface IAwaitableEnumerable<out T> : INotifyCompletion, IEnumerable<T> {
        /// <summary>
        ///     Gets a value that indicates whether the asynchronous operation has completed.
        /// </summary>
        /// <returns>
        ///     true if the operation completed; otherwise, false.
        /// </returns>
        bool IsCompleted {get;}

        /// <summary>
        ///     Ends the wait for the completion of the asynchronous operation.
        /// </summary>
        /// <returns>
        ///     The result of the completed task (a reference to this <see cref="IAwaitableEnumerable{T}" /> ).
        /// </returns>
        IAwaitableEnumerable<T> GetResult();
    }
}