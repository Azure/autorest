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
    public partial interface IStringModel
    {
        /// <summary>
        /// Get null string value value
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<string>> GetNullWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set string value null
        /// </summary>
        /// <param name='stringBody'>
        /// Possible values for this parameter include: &apos;&apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutNullWithOperationResponseAsync(string stringBody = default(string), CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get empty string value value &apos;&apos;
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<string>> GetEmptyWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set string value empty &apos;&apos;
        /// </summary>
        /// <param name='stringBody'>
        /// Possible values for this parameter include: &apos;&apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutEmptyWithOperationResponseAsync(string stringBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get mbcs string value
        /// &apos;啊齄丂狛狜隣郎隣兀﨩ˊ▇█〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€
        /// &apos;
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<string>> GetMbcsWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set string value mbcs
        /// &apos;啊齄丂狛狜隣郎隣兀﨩ˊ▇█〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€
        /// &apos;
        /// </summary>
        /// <param name='stringBody'>
        /// Possible values for this parameter include:
        /// &apos;啊齄丂狛狜隣郎隣兀﨩ˊ▇█〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€
        /// &apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutMbcsWithOperationResponseAsync(string stringBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get string value with leading and trailing whitespace
        /// &apos;&lt;tab&gt;&lt;space&gt;&lt;space&gt;Now is the time for
        /// all good men to come to the aid of their
        /// country&lt;tab&gt;&lt;space&gt;&lt;space&gt;&apos;
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<string>> GetWhitespaceWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Set String value with leading and trailing whitespace
        /// &apos;&lt;tab&gt;&lt;space&gt;&lt;space&gt;Now is the time for
        /// all good men to come to the aid of their
        /// country&lt;tab&gt;&lt;space&gt;&lt;space&gt;&apos;
        /// </summary>
        /// <param name='stringBody'>
        /// Possible values for this parameter include: &apos;    Now is the
        /// time for all good men to come to the aid of their country
        /// &apos;
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> PutWhitespaceWithOperationResponseAsync(string stringBody, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Get String value when no string value is sent in response payload
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<string>> GetNotProvidedWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));
    }
}
