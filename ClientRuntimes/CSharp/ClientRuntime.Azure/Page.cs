// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Newtonsoft.Json;
using System;
using System.Collections.Generic;

namespace Microsoft.Azure
{
    public class Page<T> : IEnumerable<T> 
    {
        /// <summary>
        /// 
        /// </summary>
        [JsonProperty(PropertyName = "value")]
        public IList<T> Value { get; set; }

        /// <summary>
        /// URL the client should use to fetch the next page 
        /// </summary>
        [JsonProperty(PropertyName = "nextLink")]
        public string NextPage { get; set; }

        /// <summary>
        /// Odata URL the client should use to fetch the next page 
        /// </summary>
        [JsonProperty(PropertyName = "@odata.nextLink")]
        public string NextOdataPage { get; set; }

        public IEnumerator<T> GetEnumerator()
        {
            return Value.GetEnumerator();
        }

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }
    }
}
