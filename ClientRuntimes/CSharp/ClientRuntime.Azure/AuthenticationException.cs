// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.Runtime.Serialization;
using Microsoft.Rest;
#if !PORTABLE
using System.Security.Permissions;
#endif

namespace Microsoft.Azure
{
    /// <summary>
    /// Validation exception for Microsoft Rest Client. 
    /// </summary>
#if !PORTABLE
    [Serializable]
#endif
    public class AuthenticationException : RestException
    {

        /// <summary>
        /// Initializes a new instance of the ValidationException class.
        /// </summary>
        public AuthenticationException()
            : base()
        {
        }

        /// <summary>
        /// Initializes a new instance of the ValidationException class.
        /// </summary>
        /// <param name="message">Exception message.</param>
        public AuthenticationException(string message)
            : base(message, null)
        {
        }

#if !PORTABLE
        /// <summary>
        /// Initializes a new instance of the ValidationException class.
        /// </summary>
        /// <param name="info">Serialization info.</param>
        /// <param name="context">Streaming context.</param>
        protected AuthenticationException(SerializationInfo info, StreamingContext context)
            : base(info, context)
        {
        }

        /// <summary>
        /// Serializes content of the exception.
        /// </summary>
        /// <param name="info">Serialization info.</param>
        /// <param name="context">Streaming context.</param>
        [SecurityPermission(SecurityAction.Demand, SerializationFormatter = true)]
        public override void GetObjectData(SerializationInfo info, StreamingContext context)
        {
            base.GetObjectData(info, context);
            if (info == null)
            {
                throw new ArgumentNullException("info");
            }
        }
#endif
    }
}