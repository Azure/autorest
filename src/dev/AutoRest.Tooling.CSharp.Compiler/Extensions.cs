using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using Newtonsoft.Json.Serialization;

namespace Microsoft.Rest.CSharp.Compiler
{
    public static class Extensions
    {
        public static string ToJson(this object @object)
        {
            return JsonConvert.SerializeObject(
                @object,
                Formatting.Indented,
                new JsonSerializerSettings
                {
                    Converters = new JsonConverter[] { new StringEnumConverter() },
                    ContractResolver = new CamelCasePropertyNamesContractResolver(),
                    NullValueHandling = NullValueHandling.Ignore,
                    ObjectCreationHandling = ObjectCreationHandling.Reuse
                });
        }
    }
}
