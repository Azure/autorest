// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using Newtonsoft.Json;

namespace Microsoft.Rest.Serialization
{
    /// <summary>
    /// JsonConverter that handles serialization for dates.
    /// </summary>
    public class DateJsonConverter : JsonConverter
    {
        /// <summary>
        /// Returns true if the object being serialized is assignable from DateTime or DateTimeOffset. False otherwise.
        /// </summary>
        /// <param name="objectType">The type of the object to check.</param>
        /// <returns>True if the object being serialized is assignable from DateTime or DateTimeOffset. False otherwise.</returns>
        public override bool CanConvert(Type objectType)
        {
            // Explicitly check for supported types
            return objectType == typeof (DateTime) || objectType == typeof (DateTime?)
                   || objectType == typeof (DateTimeOffset) || objectType == typeof (DateTimeOffset?);
        }

        /// <summary>
        /// Deserializes an object into a valid DateTime.
        /// </summary>
        /// <param name="reader">The JSON reader.</param>
        /// <param name="objectType">The type of the object.</param>
        /// <param name="existingValue">The existing value.</param>
        /// <param name="serializer">The JSON serializer.</param>
        /// <returns></returns>
        public override object ReadJson(JsonReader reader,
            Type objectType, object existingValue, JsonSerializer serializer)
        {
            if (reader == null)
            {
                throw new ArgumentNullException("reader");
            }
            if (objectType == null)
            {
                throw new ArgumentNullException("objectType");
            }

            var value = reader.Value as string;
            if (value == null)
            {
                return null;
            }

            return DateTime.Parse(value, null, DateTimeStyles.AdjustToUniversal).ToLocalTime();
        }

        /// <summary>
        /// Serializes an object into a JSON representation of a date using yyyy-MM-dd format.
        /// </summary>
        /// <param name="writer">The JSON writer.</param>
        /// <param name="value">The value to serialize.</param>
        /// <param name="serializer">The JSON serializer.</param>
        public override void WriteJson(JsonWriter writer,
            object value, JsonSerializer serializer)
        {
            if (writer == null)
            {
                throw new ArgumentNullException("writer");
            }
            if (serializer == null)
            {
                throw new ArgumentNullException("serializer");
            }

            if (value == null)
            {
                writer.WriteNull();
            }
            else
            {
                writer.WriteValue(string.Format(CultureInfo.InvariantCulture, "{0:yyyy-MM-dd}", value));
            }
        }
    }
}