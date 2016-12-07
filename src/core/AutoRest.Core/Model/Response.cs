// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;

namespace AutoRest.Core.Model
{
    /// <summary>
    /// Defines a structure for operation response.
    /// </summary>
    public class Response
    {
        /// <summary>
        /// Initializes a new instance of Response.
        /// </summary>
        /// <param name="body">Body type.</param>
        /// <param name="headers">Headers type.</param>
        public Response(IModelType body, IModelType headers) 
        {
            Body = body;
            Headers = headers;
        }

        public Response()
        {
            
        }
        /// <summary>
        /// Gets or sets the body type.
        /// </summary>
        public IModelType Body{ get; set; }

        /// <summary>
        /// Gets or sets the headers type.
        /// </summary>
        public IModelType Headers { get; set; }

        /// <summary>
        /// Determines whether the specified response is structurally equal to this object.
        /// </summary>
        /// <param name="other">The object to compare with this object.</param>
        public bool StructurallyEquals(Response other)
        {
            if (other == null)
            {
                return false;
            }
            return (Body == null ? other.Body == null : Body.StructurallyEquals(other.Body))
                && (Headers == null ? other.Headers == null : Headers.StructurallyEquals(other.Headers));
        }
    }
}