// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
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

            var requiredList = new List<string>();
            //Per JSON schema 4.0, each node uses the "IsRequired" field (an array) to call out mandatory properties.
            var requiredProperties = new JArray(schema.Required);
            foreach (var requiredProperty in requiredProperties)
            {
                requiredList.Add((string) requiredProperty);
            }
            schema.Required = requiredList;
            if (schema.Properties != null)
            {
                foreach (var key in schema.Properties.Keys)
                {
                    Schema value = schema.Properties[key];
                    bool inRequiredList = (requiredProperties.FirstOrDefault(p => (string) p == key) != null);
                    value.IsRequired = inRequiredList;
                }
            }

            return schema;
        }
    }
}