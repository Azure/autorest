// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using Microsoft.Rest.Modeler.Swagger.Model;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Microsoft.Rest.Modeler.Swagger.JsonConverters
{
    public class PathItemRefConverter : SwaggerJsonConverter
    {
        public PathItemRefConverter(string json)
        {
            Document = JObject.Parse(json);
        }

        public override bool CanConvert(System.Type objectType)
        {
            // Type of a path item object
            return objectType == typeof (Dictionary<string, Operation>);
        }

        public override object ReadJson(JsonReader reader, System.Type objectType, object existingValue,
            JsonSerializer serializer)
        {
            // is the leaf an vendor extension? "x-*..."
            if (reader == null || reader.Path.Substring(reader.Path.LastIndexOf(".", StringComparison.Ordinal) + 1).StartsWith("x-",StringComparison.CurrentCulture))
            {
                // skip x-* vendor extensions when used where the path would be.
                return new Dictionary < string, Operation >();
            }

            JObject jobject = JObject.Load(reader);
            if (jobject == null)
            {
                return null;
            }

            // Unwrap if it's a reference object.
            while (jobject.First.Path == "$ref")
            {
                jobject =
                    Document.SelectToken(jobject.GetValue("$ref", StringComparison.Ordinal).ToString().
                    Replace("#/", "").Replace("/", ".")) as
                        JObject;
            }
            return JsonConvert.DeserializeObject<Dictionary<string, Operation>>(jobject.ToString(),
                GetSettings(serializer));
        }
    }
}