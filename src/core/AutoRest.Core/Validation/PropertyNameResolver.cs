using Newtonsoft.Json;
using System.Linq;
using System.Reflection;

namespace AutoRest.Core.Validation
{
    public static class PropertyNameResolver
    {
        /// <summary>
        /// Returns the name specified by a JsonProperty attribute if it exists, otherwise the property name
        /// </summary>
        /// <param name="prop"></param>
        /// <returns>The [JsonProperty] name of property if it exists, or the property name</returns>
        public static string JsonName(PropertyInfo prop)
            => prop?.GetCustomAttributes<JsonPropertyAttribute>(true).Select(p => p.PropertyName).FirstOrDefault()
            ?? prop.Name;

        /// <summary>
        /// Returns the name of the property
        /// </summary>
        /// <param name="prop"></param>
        /// <returns>The name of the property</returns>
        public static string PropertyName(PropertyInfo prop) => prop.Name;
    }
}
