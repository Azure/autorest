// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsCustomBaseUri
{
    using System.Threading.Tasks;
   using Models;

    /// <summary>
    /// Extension methods for Paths.
    /// </summary>
    public static partial class PathsExtensions
    {
            /// <summary>
            /// Get a 200 to test a valid base uri
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='accountName'>
            /// Account Name
            /// </param>
            public static void GetEmpty(this IPaths operations, string accountName)
            {
                System.Threading.Tasks.Task.Factory.StartNew(s => ((IPaths)s).GetEmptyAsync(accountName), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None,  System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get a 200 to test a valid base uri
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='accountName'>
            /// Account Name
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task GetEmptyAsync(this IPaths operations, string accountName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                await operations.GetEmptyWithHttpMessagesAsync(accountName, null, cancellationToken).ConfigureAwait(false);
            }

    }
}
