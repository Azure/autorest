// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Swagger.Model;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using AutoRest.Core.Logging;

namespace AutoRest.Swagger.JsonConverters
{
    public class PathLevelParameterConverter : SwaggerJsonConverter
    {
        public PathLevelParameterConverter(string json)
        {
            Document = JObject.Parse(json);
        }

        public override bool CanConvert(System.Type objectType)
        {
            return (objectType == typeof (Dictionary<string, Operation>));
        }

        /// <summary>
        /// To merge common parameters at the path level into the parameters at 
        /// the operation level if they do not exist at the operation level
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="objectType"></param>
        /// <param name="existingValue"></param>
        /// <param name="serializer"></param>
        /// <returns></returns>
        public override object ReadJson(JsonReader reader, System.Type objectType, object existingValue,
            JsonSerializer serializer)
        {
            JObject jo = JObject.Load(reader);
            if (jo["parameters"] != null)
            {
                var commonParameters = new Dictionary<string, JObject>();
                foreach (JObject param in jo["parameters"] as JArray)
                {
                    string key = GetParameterKey(param);
                    commonParameters[key] = param;
                }

                // Iterating over the operations to merge the common parameters if they do not exist
                foreach (JObject operation in jo.Properties()
                    .Where(p => p.Name != "parameters")
                    .Select(p => p.Value as JObject))
                {
                    if (operation["parameters"] == null)
                    {
                        operation["parameters"] = new JArray();
                    }
                    foreach (var key in commonParameters.Keys)
                    {
                        if (!(operation["parameters"] as JArray).Any(p => GetParameterKey(p as JObject) == key))
                        {
                            (operation["parameters"] as JArray).Add(commonParameters[key]);
                        }
                    }
                }

                // Removing the common parameters to avoid serialization errors
                jo.Remove("parameters");
            }

            var result = new Dictionary<string, Operation>();

            foreach (JProperty operation in jo.Children())
            {
                try
                {
                    if (operation.Name == null || operation.Name.StartsWith("x-"))
                    {
                        continue;
                    }

                    result[operation.Name] = JsonConvert.DeserializeObject<Operation>(operation.Value.ToString(),
                        GetSettings(serializer));
                }
                catch (JsonException exception)
                {
                    Logger.Instance.Log(Category.Error, exception.Message);
                }
            }

            return result;
        }

        /// <summary>
        /// Returns the value of the reference or the value of the name and locattion (query, path, body)
        /// </summary>
        /// <param name="param"></param>
        /// <returns></returns>
        private static string GetParameterKey(JObject param)
        {
            return (string) (param["$ref"] ?? param["name"] + "+" + param["in"]);
        }
    }
}