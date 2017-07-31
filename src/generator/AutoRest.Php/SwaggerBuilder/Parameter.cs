using System.Collections.Generic;
using AutoRest.Php.JsonBuilder;

namespace AutoRest.Php.SwaggerBuilder
{
    /// <summary>
    /// https://swagger.io/specification/#parameter-object-49
    /// </summary>
    public sealed class Parameter : Object
    {
        public string Name { get; }

        public string In { get; }

        public Schema Schema { get; }

        public override IEnumerable<KeyValuePair<string, Token>> GetProperties()
        {
            if (Name != null)
            {
                yield return Json.Property("name", Name);
            }
            if (In != null)
            {
                yield return Json.Property("in", In);
            }
            foreach (var token in Schema.GetProperties())
            {
                yield return token;
            }
        }

        public static Parameter Create(Core.Model.Parameter parameter)
            => new Parameter(                
                name: parameter.SerializedName,
                @in: parameter.Location.ToString().ToLower(),
                schema: Schema.Create(parameter.ModelType));

        private Parameter(
            string name,
            string @in,
            Schema schema)
        {
            Name = name;
            In = @in;
            Schema = schema;
        }
    }
}
