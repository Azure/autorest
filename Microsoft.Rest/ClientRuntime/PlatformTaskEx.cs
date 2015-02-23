// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Threading;
using System.Threading.Tasks;

namespace Microsoft.Rest
{
    public class PlatformTaskEx
    {
        //Per FxCop performance rule to prevent the compiler from generating a default constructor.
        private PlatformTaskEx() { }

        public static Task FromResult(object result)
        {
#if NET45
            return Task.FromResult<object>(result);
#else 
            return TaskEx.FromResult<object>(result);
#endif
        }

        public static Task Delay(TimeSpan delay)
        {
#if NET45
            return Task.Delay(delay);
#else
            return TaskEx.Delay(delay);
#endif
        }

        public static Task Delay(int millisecondsDelay, CancellationToken cancellationToken)
        {
#if NET45
            return Task.Delay(millisecondsDelay, cancellationToken);
#else
            return TaskEx.Delay(millisecondsDelay, cancellationToken);
#endif
        }
    }
}
