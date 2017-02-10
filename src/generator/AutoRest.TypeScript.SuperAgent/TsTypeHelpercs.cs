using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Model;

namespace AutoRest.TypeScript.SuperAgent
{
    public static class TsTypeHelpercs
    {
        private static Dictionary<KnownPrimaryType, string> _primitiveTypeMappings =
            new Dictionary<KnownPrimaryType, string>
            {
                {KnownPrimaryType.Boolean, "Boolean"},
                {KnownPrimaryType.Date, "Date"},
                {KnownPrimaryType.String, "String"}
            };


        public static bool IsPrimitiveType(this KnownPrimaryType type)
        {
            return _primitiveTypeMappings.Keys.Contains(type);
        }
    }
}
