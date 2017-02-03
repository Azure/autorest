using AutoRest.Core.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AutoRest.Swagger.Model.Utilities
{
    public static class ValidationUtilities
    {
        private static readonly string XmsPageable = "x-ms-pageable";

        // determine if the 
        public static bool IsXmsPageableOrArrayResponseOperation(Operation op, ServiceDefinition entity)
        {
            if (op.Extensions.GetValue<object>(XmsPageable) != null) return true;

            if (!(op.Responses?.ContainsKey("200")??false)) return false;

            if (!((op.Responses["200"]?.Schema?.Reference?.Equals(string.Empty)) ?? true))
            {
                var modelLink = op.Responses["200"].Schema.Reference;
                if (entity.Definitions[modelLink.StripDefinitionPath()].Properties?.Values?.Any(type => type.Type == DataType.Array)??false)
                {
                    return true;
                }
            }
            return false;
        }

    }
}
