using System.Collections.Generic;
using AutoRest.Php.JsonBuilder;
using AutoRest.Core.Model;
using System.Linq;

namespace AutoRest.Php.SwaggerBuilder
{
    public sealed class OperationObject : Object
    {
        public string OperationId { get; }

        public Array<ParameterObject> Parameters { get; }

        public Object<ResponseObject> Responses { get; }

        public static OperationObject Create(Method m)
            => new OperationObject(
                m.SerializedName,
                Json.Array(m.Parameters.Select(ParameterObject.Create)),
                Json.Object(m.Responses.Select(r => Json.Property(
                    ((int)r.Key).ToString(),
                    ResponseObject.Create(r.Value)))));

        public OperationObject(
            string operationId,
            Array<ParameterObject> parameters,
            Object<ResponseObject> responses)
        {
            OperationId = operationId;
            Parameters = parameters;
            Responses = responses;
        }

        public override IEnumerable<JsonBuilder.Property> GetProperties()
        {
            yield return Json.Property("operationId", OperationId);
            yield return Json.Property("parameters", Parameters);
            yield return Json.Property("responses", Responses);
        }
    }
}
