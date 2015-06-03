// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Newtonsoft.Json.Converters;

namespace Microsoft.Rest.Serialization
{
    /// <summary>
    /// JsonConverter that handles serialization for dates in yyyy-MM-dd format.
    /// </summary>
    public class DateJsonConverter : IsoDateTimeConverter
    {
        /// <summary>
        /// Initializes a new instance of DateJsonConverter.
        /// </summary>
        public DateJsonConverter()
        {
            DateTimeFormat = "yyyy-MM-dd";
        }
    }
}