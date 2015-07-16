namespace Fixtures.Azure.SwaggerBatAzureReport
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Microsoft.Azure;
    using Models;

    public static partial class AutoRestReportServiceForAzureExtensions
    {
            /// <summary>
            /// Get test coverage report
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static IDictionary<string, int?> GetReport(this IAutoRestReportServiceForAzure operations)
            {
                return Task.Factory.StartNew(s => ((IAutoRestReportServiceForAzure)s).GetReportAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get test coverage report
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, int?>> GetReportAsync( this IAutoRestReportServiceForAzure operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                AzureOperationResponse<IDictionary<string, int?>> result = await operations.GetReportWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

    }
}
