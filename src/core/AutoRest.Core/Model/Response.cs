// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

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
        
        public override string ToString()
        {
            if (Body != null && Headers != null)
            {
                return string.Format(CultureInfo.InvariantCulture,
                    "HttpOperationResponse<{0},{1}>", Body, Headers);
            }
            else if (Body != null)
            {
                return Body.ToString();
            }
            else if (Headers != null)
            {
                return string.Format(CultureInfo.InvariantCulture,
                    "HttpOperationResponse<object,{0}>", Headers);
            }
            else
            {
                return "void";
            }
        }
    }
}