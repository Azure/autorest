// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Runtime.Serialization;

namespace AutoRest.Core.Logging
{
    /// <summary>
    /// Code generation aggregate exception.
    /// </summary>
#if !PORTABLE
    [Serializable]
#endif
    public class CodeGenerationException : AggregateException
    {
        /// <summary>
        /// Instantiates a new instance of the CodeGenerationException class.
        /// </summary>
        public CodeGenerationException()
        {
        }

        /// <summary>
        /// Instantiates a new instance of the CodeGenerationException class.
        /// </summary>
        /// <param name="message">The exception message.</param>
        public CodeGenerationException(string message) : base(message)
        {
        }

        /// <summary>
        /// Instantiates a new instance of the CodeGenerationException class.
        /// </summary>
        /// <param name="message">The exception message.</param>
        /// <param name="innerException">The inner exception.</param>
        public CodeGenerationException(string message, Exception innerException) : base(message, innerException)
        {
        }

#if !PORTABLE 
        /// <summary>
        /// Instantiates a new instance of the CodeGenerationException class.
        /// </summary>
        protected CodeGenerationException(SerializationInfo serializationInfo, StreamingContext context) : base (serializationInfo, context)
        {
        }
#endif

        /// <summary>
        /// Instantiates a new instance of the CodeGenerationException class.
        /// </summary>
        /// <param name="message">The exception message.</param>
        /// <param name="innerExceptions">An array of inner exceptions.</param>
        public CodeGenerationException(string message, params Exception[] innerExceptions)
            : base(message, innerExceptions)
        {
        }
    }
}