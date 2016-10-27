// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.MirrorPolymorphic.Models
{
    using Microsoft.Rest;		
    using System;		
    using System.Net.Http;		
    using System.Runtime.Serialization;		
 #if !PORTABLE 		
    using System.Security.Permissions;		
 #endif

    /// <summary>
    /// Exception thrown for an invalid response with Error2 information.
    /// </summary>
#if !PORTABLE 
    [System.Serializable]
#endif
    public class Error2Exception : Microsoft.Rest.RestException
    {
        /// <summary>
        /// Gets information about the associated HTTP request.
        /// </summary>
        public Microsoft.Rest.HttpRequestMessageWrapper Request { get; set; }

        /// <summary>
        /// Gets information about the associated HTTP response.
        /// </summary>
        public Microsoft.Rest.HttpResponseMessageWrapper Response { get; set; }

        /// <summary>
        /// Gets or sets the body object.
        /// </summary>
        public Error2 Body { get; set; }

        /// <summary>
        /// Initializes a new instance of the Error2Exception class.
        /// </summary>
        public Error2Exception()
        {
        }

        /// <summary>
        /// Initializes a new instance of the Error2Exception class.
        /// </summary>
        /// <param name="message">The exception message.</param>
        public Error2Exception(string message)
            : this(message, null)
        {
        }

        /// <summary>
        /// Initializes a new instance of the Error2Exception class.
        /// </summary>
        /// <param name="message">The exception message.</param>
        /// <param name="innerException">Inner exception.</param>
        public Error2Exception(string message, System.Exception innerException)
            : base(message, innerException)
        {
        }

#if !PORTABLE 
        /// <summary>
        /// Initializes a new instance of the Error2Exception class.
        /// </summary>
        /// <param name="info">Serialization info.</param>
        /// <param name="context">Streaming context.</param>
        protected Error2Exception(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context)
            : base(info, context)
        {
        }

        /// <summary>
        /// Serializes content of the exception.
        /// </summary>
        /// <param name="info">Serialization info.</param>
        /// <param name="context">Streaming context.</param>
        /// <exception cref="System.ArgumentNullException">
        /// Thrown when a required parameter is null
        /// </exception>
        [System.Security.Permissions.SecurityPermission(System.Security.Permissions.SecurityAction.Demand, SerializationFormatter = true)]
        public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context)
        {
            base.GetObjectData(info, context);
            if (info == null)
            {
                throw new System.ArgumentNullException("info");
            }

            info.AddValue("Request", Request);
            info.AddValue("Response", Response);
            info.AddValue("Body", Body);
        }
#endif
    }
}
