// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using Microsoft.Rest.Modeler.Swagger.Model;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Microsoft.Rest.Generator;
using System.IO;

namespace Microsoft.Rest.Modeler.Swagger.JsonConverters
{
    public class SwaggerSourceConverter : SwaggerJsonConverter
    {
        //private string swaggerDocument;
        //private JObject swaggerObj;

        public SwaggerSourceConverter()
        {
            //this.swaggerDocument = swaggerDocument;
            //this.swaggerObj = JObject.Parse(swaggerDocument);
        }

        public override bool CanConvert(Type objectType)
        {
            if (objectType == null)
            {
                return false;
            }
            return (objectType.IsGenericType || (typeof(SwaggerBase)).IsAssignableFrom(objectType)) && !objectType.IsValueType;
        }

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue,
            JsonSerializer serializer)
        {
            object obj = null;
            if (reader != null && reader.TokenType != JsonToken.Null && serializer != null)
            {
                JToken rawObj;
                string rawJson;
                if (reader.TokenType == JsonToken.StartArray)
                {
                    rawObj = JArray.Load(reader);
                }
                else
                {
                    rawObj = JObject.Load(reader);
                }
                rawJson = rawObj.ToString();
                if (objectType != null && objectType.IsGenericType && objectType.GetGenericTypeDefinition() == typeof(IList<>))
                {
                    var listType = typeof(List<>);
                    var constructedListType = listType.MakeGenericType(objectType.GetGenericArguments());
                    obj = Activator.CreateInstance(constructedListType);
                }
                else
                {
                    obj = Activator.CreateInstance(objectType);
                }
                var source = new JsonSourceContext(rawJson);

                try
                {
                    using (var sourceReader = new StringReader(rawJson.ToString()))
                    using (var nestedReader = new NestedJsonReader(sourceReader, reader))
                    {
                        serializer.Populate(nestedReader, obj);
                    }
                }
                catch (JsonException)
                {
                    throw;
                }
                if (typeof(SwaggerBase).IsAssignableFrom(objectType))
                {
                    var swaggerObject = obj as SwaggerBase;
                    swaggerObject.Source = source;
                }
            }
            return obj;
        }
    }
}