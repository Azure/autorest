using Microsoft.Rest.Generator;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Collections.Generic;
using System.Linq;

namespace Microsoft.Rest.Modeler.Swagger
{
    public class PathsValidator : SwaggerBaseValidator, IValidator<Dictionary<string, Dictionary<string, Operation>>>
    {
        public Dictionary<string, SwaggerParameter> Parameters { get; internal set; }

        public PathsValidator(SourceContext source, Dictionary<string, SwaggerParameter> parameters) : base(source)
        {
            Parameters = parameters;
        }

        public bool IsValid(Dictionary<string, Dictionary<string, Operation>> entity)
        {
            return !ValidationExceptions(entity).Any();
        }

        public IEnumerable<ValidationMessage> ValidationExceptions(Dictionary<string, Dictionary<string, Operation>> paths)
        {
            yield break;
        }
    }
}
