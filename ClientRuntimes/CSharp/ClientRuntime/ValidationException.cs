// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Runtime.Serialization;

namespace Microsoft.Rest
{
    /// <summary>
    /// Validation exception for Microsoft Rest Client. 
    /// </summary>
#if !PORTABLE
    [Serializable]
#endif
    public class ValidationException : RestException
    {
        /// <summary>
        /// Initializes a new instance of the ValidationException class.
        /// </summary>
        public ValidationException()
            : base()
        {
        }

        /// <summary>
        /// Initializes a new instance of the ValidationException class.
        /// </summary>
        /// <param name="message">The exception message.</param>
        public ValidationException(string message)
            : this(message, null)
        {
        }

        /// <summary>
        /// Initializes a new instance of the ValidationException class.
        /// </summary>
        /// <param name="message">The exception message.</param>
        /// <param name="innerException">Inner exception.</param>
        public ValidationException(string message, Exception innerException)
            : base(message, innerException)
        {
        }

#if !PORTABLE
        /// <summary>
        /// Initializes a new instance of the ValidationException class.
        /// </summary>
        /// <param name="info">Serialization info.</param>
        /// <param name="context">Streaming context.</param>
        protected ValidationException(SerializationInfo info, StreamingContext context)
            : base(info, context)
        {
        }
#endif
    }
}