namespace Fixtures.SwaggerBatBodyString
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    /// <summary>
    /// Test Infrastructure for AutoRest Swagger BAT
    /// </summary>
    public partial interface IEnumModel
    {
        /// <summary>
        /// Get enum value 'red color' from enumeration of 'red color',
        /// 'green-color', 'blue_color'.
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Colors?>> GetNotExpandableWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Sends value 'red color' from enumeration of 'red color',
        /// 'green-color', 'blue_color'
        /// </summary>
        /// <param name='stringBody'>
        /// Possible values for this parameter include: 'red color',
        /// 'green-color', 'blue_color'
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutNotExpandableWithOperationResponseAsync(Colors? stringBody, CancellationToken cancellationToken = default(CancellationToken));
    }
}
