namespace Fixtures.SwaggerBatReport
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    public static partial class AutoRestReportServiceExtensions
    {
            /// <summary>
            /// Get test coverage report
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, int?> GetReport(this IAutoRestReportService operations)
            {
                return Task.Factory.StartNew(s => ((IAutoRestReportService)s).GetReportAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get test coverage report
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, int?>> GetReportAsync( this IAutoRestReportService operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, int?>> result = await operations.GetReportWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

    }
}
