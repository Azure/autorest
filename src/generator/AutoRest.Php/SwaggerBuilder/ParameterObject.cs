using System.Collections.Generic;
using AutoRest.Php.JsonBuilder;

namespace AutoRest.Php.SwaggerBuilder
{
    /// <summary>
    /// https://swagger.io/specification/#parameter-object-49
    /// </summary>
    public sealed class ParameterObject : Object
    {
        public string Name { get; }

        public string In { get; }

        public bool Required { get; }

        public bool XMsSkipUrlEncoding { get; }

        public SchemaObject Schema { get; }

        public override IEnumerable<Property> GetProperties()
        {
            yield return Json.Property("name", Name);
            yield return Json.Property("in", In);
            yield return Json.Property("required", Required);
            if (XMsSkipUrlEncoding)
            {
                yield return Json.Property("x-ms-skip-url-encoding", true);
            }
            if (In == "body")
            {
                yield return Json.Property("schema", Schema);
            }
            else
            {
                foreach (var token in Schema.GetProperties())
                {
                    yield return token;
                }
            }
        }

        public static ParameterObject Create(Core.Model.Parameter parameter)
            => new ParameterObject(                
                name: parameter.SerializedName,
                @in: parameter.Location.ToString().ToLower(),
                required: parameter.IsRequired,
                xMsSkipUrlEncoding: parameter.XMsSkipUrlEncoding(),
                schema: 
                    parameter.IsConstant
                        ? SchemaObject.Const(parameter.ModelType, parameter.DefaultValue)
                    : parameter.IsApiVersion()
                        ? SchemaObject.Const(parameter.ModelType, parameter.Method.CodeModel.ApiVersion)
                        : SchemaObject.Create(parameter.ModelType));

        private ParameterObject(
            string name,
            string @in,
            bool required,
            bool xMsSkipUrlEncoding,
            SchemaObject schema)
        {
            Name = name;
            In = @in;
            Required = required;
            XMsSkipUrlEncoding = xMsSkipUrlEncoding;
            Schema = schema;
        }
    }
}
