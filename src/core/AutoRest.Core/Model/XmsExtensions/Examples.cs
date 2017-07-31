// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Newtonsoft.Json.Linq;
using System.Collections.Generic;

namespace AutoRest.Core.Model.XmsExtensions
{
    public static class Examples
    {
        public const string Name = "x-ms-examples";

        public static Dictionary<string, Example> FromJObject(JObject obj) =>
            obj?.ToObject<Dictionary<string, Example>>() ?? new Dictionary<string, Example>();
    }

    public class Example
    {
        public Dictionary<string, JToken> Parameters { get; set; }
        public Dictionary<string, ExampleResponse> Responses { get; set; }
    }

    public class ExampleResponse
    {
        public Dictionary<string, string> Headers { get; set; }
        public Dictionary<string, JToken> Body { get; set; }
    }
}
