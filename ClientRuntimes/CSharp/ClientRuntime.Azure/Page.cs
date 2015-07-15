// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Newtonsoft.Json;
using System;
using System.Collections.Generic;

namespace Microsoft.Azure
{
    /// <summary>
    /// Defines a page in Azure responses.
    /// </summary>
    /// <typeparam name="T">Type of the page content items</typeparam>
    [JsonObject]
    public class Page<T> : IEnumerable<T>
    {
        [JsonProperty("nextLink")]
        private string NextLink { get; set; }

        [JsonProperty("@odata.nextLink")]
        private string NextOdataLink { get; set; }

        [JsonProperty("value")]
        private IList<T> Items { get; set; }

        /// <summary>
        /// Gets the link to the next page.
        /// </summary>
        public string NextPage
        {
            get
            {
                if(NextLink != null)
                {
                    return NextLink;
                }

                return NextOdataLink;
            }
        }

        /// <summary>
        /// Returns an enumerator that iterates through the collection.
        /// </summary>
        /// <returns>A an enumerator that can be used to iterate through the collection.</returns>
        public IEnumerator<T> GetEnumerator()
        {
            return Items.GetEnumerator();
        }

        /// <summary>
        /// Returns an enumerator that iterates through the collection.
        /// </summary>
        /// <returns>A an enumerator that can be used to iterate through the collection.</returns>
        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }
    }
}
