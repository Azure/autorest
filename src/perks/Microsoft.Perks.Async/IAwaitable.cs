// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks.Async {
    using System.Runtime.CompilerServices;

    /// <summary>
    ///     Represents an interface that satisfies the compiler's requirements for supporting the await keyword for the
    ///     completion of an asynchronous operation.
    /// </summary>
    public interface IAwaitable : INotifyCompletion {
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
        void GetResult();
    }

    /// <summary>
    ///     Represents an interface that satisfies the compiler's requirements for supporting the await keyword
    ///     for the completion of an asynchronous operation and provides a parameter for the result.
    /// </summary>
    /// <typeparam name="TResult">The result for the task.</typeparam>
    public interface IAwaitable<out TResult> : INotifyCompletion {
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
        ///     The result of the completed task.
        /// </returns>
        TResult GetResult();
    }
}