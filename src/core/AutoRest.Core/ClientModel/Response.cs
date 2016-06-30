// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Globalization;

namespace AutoRest.Core.ClientModel
{
    /// <summary>
    /// Defines a structure for operation response.
    /// </summary>
    public struct Response
    {
        /// <summary>
        /// Initializes a new instance of Response.
        /// </summary>
        /// <param name="body">Body type.</param>
        /// <param name="headers">Headers type.</param>
        public Response(IType body, IType headers) : this()
        {
            Body = body;
            Headers = headers;
        }

        /// <summary>
        /// Gets or sets the body type.
        /// </summary>
        public IType Body{ get; set; }

        /// <summary>
        /// Gets or sets the headers type.
        /// </summary>
        public IType Headers { get; set; }

        /// <summary>
        /// Overrides default Equals method comparing Body and Header properties.
        /// </summary>
        /// <param name="obj">Another Response object.</param>
        /// <returns>True is objects are the same.</returns>
        public override bool Equals(object obj)
        {
            if (obj is Response)
            {
                var objResponse = (Response) obj;
                return this == objResponse;
            }
            else
            {
                return false;
            }
        }

        public static bool operator ==(Response obj1, Response obj2)
        {
            if (ReferenceEquals(obj1, null))
            {
                return false;
            }
            if (ReferenceEquals(obj2, null))
            {
                return false;
            }

            return obj1.Body == obj2.Body
                     && obj1.Headers == obj2.Headers;
        }

        public static bool operator !=(Response obj1, Response obj2)
        {
            return !(obj1 == obj2);
        }

        /// <summary>
        /// Overrides default GetHashCode
        /// </summary>
        /// <returns>Hash code.</returns>
        public override int GetHashCode()
        {
            if (Body != null && Headers != null)
            {
                return Body.GetHashCode() + Headers.GetHashCode();
            }
            else if (Body != null)
            {
                return Body.GetHashCode();
            }
            else if (Headers != null)
            {
                return Headers.GetHashCode();
            }
            else
            {
                return 0;
            }
        }

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