// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsUrl
{
    using System;		
    using System.Collections.Generic;		
    using System.Net.Http;		
    using System.Threading;		
    using System.Threading.Tasks;		
    using Microsoft.Rest;
    using Models;

    /// <summary>
    /// PathItems operations.
    /// </summary>
    public partial interface IPathItems
    {
        /// <summary>
        /// send globalStringPath='globalStringPath',
        /// pathItemStringPath='pathItemStringPath',
        /// localStringPath='localStringPath',
        /// globalStringQuery='globalStringQuery',
        /// pathItemStringQuery='pathItemStringQuery',
        /// localStringQuery='localStringQuery'
        /// </summary>
        /// <param name='localStringPath'>
        /// should contain value 'localStringPath'
        /// </param>
        /// <param name='pathItemStringPath'>
        /// A string value 'pathItemStringPath' that appears in the path
        /// </param>
        /// <param name='localStringQuery'>
        /// should contain value 'localStringQuery'
        /// </param>
        /// <param name='pathItemStringQuery'>
        /// A string value 'pathItemStringQuery' that appears as a query
        /// parameter
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        /// <exception cref="ErrorException">
        /// Thrown when the operation returned an invalid status code
        /// </exception>
        /// <exception cref="Microsoft.Rest.ValidationException">
        /// Thrown when a required parameter is null
        /// </exception>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse> GetAllWithValuesWithHttpMessagesAsync(string localStringPath, string pathItemStringPath, string localStringQuery = default(string), string pathItemStringQuery = default(string), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
        /// <summary>
        /// send globalStringPath='globalStringPath',
        /// pathItemStringPath='pathItemStringPath',
        /// localStringPath='localStringPath', globalStringQuery=null,
        /// pathItemStringQuery='pathItemStringQuery',
        /// localStringQuery='localStringQuery'
        /// </summary>
        /// <param name='localStringPath'>
        /// should contain value 'localStringPath'
        /// </param>
        /// <param name='pathItemStringPath'>
        /// A string value 'pathItemStringPath' that appears in the path
        /// </param>
        /// <param name='localStringQuery'>
        /// should contain value 'localStringQuery'
        /// </param>
        /// <param name='pathItemStringQuery'>
        /// A string value 'pathItemStringQuery' that appears as a query
        /// parameter
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        /// <exception cref="ErrorException">
        /// Thrown when the operation returned an invalid status code
        /// </exception>
        /// <exception cref="Microsoft.Rest.ValidationException">
        /// Thrown when a required parameter is null
        /// </exception>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse> GetGlobalQueryNullWithHttpMessagesAsync(string localStringPath, string pathItemStringPath, string localStringQuery = default(string), string pathItemStringQuery = default(string), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
        /// <summary>
        /// send globalStringPath=globalStringPath,
        /// pathItemStringPath='pathItemStringPath',
        /// localStringPath='localStringPath', globalStringQuery=null,
        /// pathItemStringQuery='pathItemStringQuery', localStringQuery=null
        /// </summary>
        /// <param name='localStringPath'>
        /// should contain value 'localStringPath'
        /// </param>
        /// <param name='pathItemStringPath'>
        /// A string value 'pathItemStringPath' that appears in the path
        /// </param>
        /// <param name='localStringQuery'>
        /// should contain null value
        /// </param>
        /// <param name='pathItemStringQuery'>
        /// A string value 'pathItemStringQuery' that appears as a query
        /// parameter
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        /// <exception cref="ErrorException">
        /// Thrown when the operation returned an invalid status code
        /// </exception>
        /// <exception cref="Microsoft.Rest.ValidationException">
        /// Thrown when a required parameter is null
        /// </exception>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse> GetGlobalAndLocalQueryNullWithHttpMessagesAsync(string localStringPath, string pathItemStringPath, string localStringQuery = default(string), string pathItemStringQuery = default(string), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
        /// <summary>
        /// send globalStringPath='globalStringPath',
        /// pathItemStringPath='pathItemStringPath',
        /// localStringPath='localStringPath',
        /// globalStringQuery='globalStringQuery', pathItemStringQuery=null,
        /// localStringQuery=null
        /// </summary>
        /// <param name='localStringPath'>
        /// should contain value 'localStringPath'
        /// </param>
        /// <param name='pathItemStringPath'>
        /// A string value 'pathItemStringPath' that appears in the path
        /// </param>
        /// <param name='localStringQuery'>
        /// should contain value null
        /// </param>
        /// <param name='pathItemStringQuery'>
        /// should contain value null
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        /// <exception cref="ErrorException">
        /// Thrown when the operation returned an invalid status code
        /// </exception>
        /// <exception cref="Microsoft.Rest.ValidationException">
        /// Thrown when a required parameter is null
        /// </exception>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse> GetLocalPathItemQueryNullWithHttpMessagesAsync(string localStringPath, string pathItemStringPath, string localStringQuery = default(string), string pathItemStringQuery = default(string), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
    }
}
