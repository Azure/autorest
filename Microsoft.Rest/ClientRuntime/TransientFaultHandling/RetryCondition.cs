// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace Microsoft.Rest.TransientFaultHandling
{
    /// <summary>
    /// Defines a retry condition.
    /// </summary>
    public class RetryCondition
    {
        /// <param name="retryAllowed">is retry allowed</param>
        /// <param name="delay">The delay that indicates how long the current thread will be suspended before
        /// the next iteration is invoked.</param>
        public RetryCondition(bool retryAllowed, TimeSpan delay)
        {
            RetryAllowed = retryAllowed;
            DelayBeforeRetry = delay;
        }

        public Boolean RetryAllowed { get; set; }

        public TimeSpan DelayBeforeRetry { get; set; }
    }
}
