// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsBodyFile.Models
{
    using Fixtures.AcceptanceTestsBodyFile;
    using Newtonsoft.Json;
    using System.Linq;

    public partial class Error
    {

        /// <summary>
        /// Initializes a new instance of the Error class.
        /// </summary>
        public Error(int? status = default(int?), string message = default(string))
        {
            Status = status;
            Message = message;
        }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "status")]
        public int? Status { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "message")]
        public string Message { get; set; }

    }
}
