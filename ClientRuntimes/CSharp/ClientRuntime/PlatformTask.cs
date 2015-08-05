// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Threading;
using System.Threading.Tasks;

namespace Microsoft.Rest
{
    /// <summary>
    /// Provides a platform-neutral abstraction for Task and TaskEx.
    /// </summary>
    public static class PlatformTask
    {
        /// <summary>
        /// Starts a Task that will complete after the specified time interval.
        /// </summary>
        /// <param name="delayTime">time interval.</param>
        /// <returns>The timed Task.</returns>
        public static Task Delay(TimeSpan delayTime)
        {
#if NET45
            return Task.Delay(delayTime);
#else
            return TaskEx.Delay(delayTime);
#endif
        }

        /// <summary>
        /// Starts a Task that will complete after the specified due time.
        /// </summary>
        /// <param name="millisecondsDelay">The delay in milliseconds before the returned task completes.</param>
        /// <param name="cancellationToken">Propagates notification that operations should be canceled.</param>
        /// <returns>The timed Task.</returns>
        public static Task Delay(int millisecondsDelay, CancellationToken cancellationToken)
        {
#if NET45
            return Task.Delay(millisecondsDelay, cancellationToken);
#else
            return TaskEx.Delay(millisecondsDelay, cancellationToken);
#endif
        }

        /// <summary>
        /// Creates an already completed Task from the specified result.
        /// </summary>
        /// <param name="result">The result from which to create the completed task.</param>
        /// <returns>The completed Task.</returns>
        public static Task<T> FromResult<T>(T result)
        {
#if NET45
            return Task.FromResult<T>(result);
#else
            return TaskEx.FromResult<T>(result);
#endif
        }

    }
}