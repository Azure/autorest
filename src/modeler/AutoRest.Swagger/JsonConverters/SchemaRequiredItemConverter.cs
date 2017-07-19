// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Utilities;
using AutoRest.Swagger.Model;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace AutoRest.Swagger.JsonConverters
{
    public class SchemaRequiredItemConverter : SwaggerJsonConverter
    {
        public override bool CanConvert(Type objectType)
        {
            return objectType == typeof (Schema);
        }

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue,
            JsonSerializer serializer)
        {
            JObject jo = JObject.Load(reader);
            var schema = JsonConvert.DeserializeObject<Schema>(jo.ToString(),
                GetSettings(serializer));

            //Per JSON schema 4.0, each node uses the "IsRequired" field (an array) to call out mandatory properties.
            foreach (var key in schema.Required ?? Enumerable.Empty<string>())
            {
                if (schema.Properties != null && schema.Properties.TryGetValue(key, out var value))
                {
                    value.IsRequired = true;
                }
                else
                {
                    // see https://github.com/Azure/autorest/issues/2210
                    // throw new Exception($"Required property '{key}' does not exist in the schema.");
                }
            }

            return schema;
        }
    }
}