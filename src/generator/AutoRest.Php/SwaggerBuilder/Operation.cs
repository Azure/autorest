using System.Collections.Generic;
using AutoRest.Php.JsonBuilder;
using AutoRest.Core.Model;
using System.Linq;

namespace AutoRest.Php.SwaggerBuilder
{
    public sealed class Operation : Object
    {
        public string OperationId { get; }

        public Array<Parameter> Parameters { get; }

        public Object<Response> Responses { get; }

        public static Operation Create(Method m)
            => new Operation(
                m.SerializedName,
                Json.Array(m.Parameters.Select(Parameter.Create)),
                Json.Object(m.Responses.Select(r => Extensions.KeyValue(
                    ((int)r.Key).ToString(),
                    Response.Create(r.Value)))));

        public Operation(
            string operationId,
            Array<Parameter> parameters,
            Object<Response> responses)
        {
            OperationId = operationId;
            Parameters = parameters;
            Responses = responses;
        }

        public override IEnumerable<KeyValuePair<string, Token>> GetProperties()
        {
            yield return Json.Property("operationId", OperationId);
            yield return Json.Property("parameters", Parameters);
            yield return Json.Property("responses", Responses);
        }
    }
}
