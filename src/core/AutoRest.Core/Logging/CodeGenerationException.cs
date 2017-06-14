// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Core.Logging
{
    /// <summary>
    /// Code generation aggregate exception.
    /// </summary>
    public class CodeGenerationException : AggregateException
    {
        /// <summary>
        /// Instantiates a new instance of the CodeGenerationException class.
        /// </summary>
        /// <param name="message">The exception message.</param>
        public CodeGenerationException(string message) : base(message)
        {
        }
    }
}