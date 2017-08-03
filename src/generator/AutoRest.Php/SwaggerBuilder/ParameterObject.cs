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

        public SchemaObject Schema { get; }

        public override IEnumerable<Property> GetProperties()
        {
            if (Name != null)
            {
                yield return Json.Property("name", Name);
            }
            if (In != null)
            {
                yield return Json.Property("in", In);
            }
            yield return Json.Property("required", Required);
            foreach (var token in Schema.GetProperties())
            {
                yield return token;
            }
        }

        public static ParameterObject Create(Core.Model.Parameter parameter)
            => new ParameterObject(                
                name: parameter.SerializedName,
                @in: parameter.Location.ToString().ToLower(),
                required: parameter.IsRequired,
                schema: 
                    parameter.IsApiVersion() 
                        ? SchemaObject.Const(parameter.ModelType, parameter.Method.CodeModel.ApiVersion)
                    : parameter.IsConstant
                        ? SchemaObject.Const(parameter.ModelType, parameter.DefaultValue)
                        : SchemaObject.Create(parameter.ModelType));

        private ParameterObject(
            string name,
            string @in,
            bool required,
            SchemaObject schema)
        {
            Name = name;
            In = @in;
            Required = required;
            Schema = schema;
        }
    }
}
