// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using Newtonsoft.Json;

namespace Microsoft.Rest.Azure
{
    /// <summary>
    /// Defines a page in Azure responses.
    /// </summary>
    /// <typeparam name="T">Type of the page content items</typeparam>
    [JsonObject]
    public class Page<T> : IEnumerable<T>
    {
        [JsonProperty("nextLink")]
        private string NextLink 
        {
            set
            {
                NextPageLink = value;
            }
        }

        [JsonProperty("@odata.nextLink")]
        private string NextOdataLink 
        { 
            set
            {
                NextPageLink = value;
            }
        }

        [JsonProperty("value")]
        private IList<T> Items { get; set; }

        /// <summary>
        /// Gets the link to the next page.
        /// </summary>
        public string NextPageLink { get; private set; }

        /// <summary>
        /// Returns an enumerator that iterates through the collection.
        /// </summary>
        /// <returns>A an enumerator that can be used to iterate through the collection.</returns>
        public IEnumerator<T> GetEnumerator()
        {

            return (Items == null) ? Enumerable.Empty<T>().GetEnumerator() : Items.GetEnumerator();
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
