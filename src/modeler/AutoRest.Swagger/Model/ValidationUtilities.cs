using AutoRest.Core.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace AutoRest.Swagger.Model.Utilities
{
    public static class ValidationUtilities
    {
        private static readonly string XmsPageable = "x-ms-pageable";
        private static readonly Regex TrackedResRegEx = new Regex(@".+/Resource$", RegexOptions.IgnoreCase);

        public static bool IsTrackedResource(Schema schema, Dictionary<string, Schema> definitions)
        {
            if (schema.AllOf != null)
            {
                foreach (Schema item in schema.AllOf)
                {
                    if (TrackedResRegEx.IsMatch(item.Reference))
                    {
                        return true;
                    }
                    else
                    {
                        return IsTrackedResource(Schema.FindReferencedSchema(item.Reference, definitions), definitions);
                    }
                }
            }
            return false;
        }

        // determine if the operation is xms pageable or returns an object of array type
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

        public static List<Operation> GetOperationsByRequestMethod(string id, ServiceDefinition serviceDefinition)
        {
            List<Operation> result = new List<Operation>();
            foreach (KeyValuePair<string, Dictionary<string, Operation>> path in serviceDefinition.Paths)
            {
                foreach (KeyValuePair<string, Operation> operation in path.Value)
                {
                    if (operation.Key.ToLower().Equals(id.ToLower()))
                    {
                        result.Add(operation.Value);
                    }
                }
            }
            return result;
        }
    }
}
