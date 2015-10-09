// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Serialization
{
    using System.Diagnostics.CodeAnalysis;
    using Newtonsoft.Json.Converters;
    
    /// <summary>
    /// JsonConverter that handles serialization for dates in RFC1123 format.
    /// </summary>
    [SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", MessageId = "Rfc", Justification = "Rfc is correct spelling")]
    public class DateTimeRfc1123JsonConverter : IsoDateTimeConverter
    {
        /// <summary>
        /// Initializes a new instance of DateJsonConverter.
        /// </summary>
        public DateTimeRfc1123JsonConverter()
        {
            DateTimeFormat = "R";
        }
    }
}
