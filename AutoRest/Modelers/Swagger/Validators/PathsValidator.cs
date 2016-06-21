using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Modeler.Swagger.Model;
using Microsoft.Rest.Modeler.Swagger.Properties;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Microsoft.Rest.Modeler.Swagger
{
    public class PathsValidator : SwaggerBaseValidator, IValidator<Dictionary<string, Dictionary<string, Operation>>>
    {
        public Dictionary<string, SwaggerParameter> Parameters { get; internal set; }

        public PathsValidator(Dictionary<string, SwaggerParameter> parameters)
        {
            Parameters = parameters;
        }

        public bool IsValid(Dictionary<string, Dictionary<string, Operation>> entity)
        {
            return !ValidationExceptions(entity).Any();
        }

        public IEnumerable<ValidationMessage> ValidationExceptions(Dictionary<string, Dictionary<string, Operation>> paths)
        {
            foreach (var path in paths)
            {
                foreach (var operation in path.Value)
                {
                    var operationsValidator = new OperationsValidator(path.Key, Parameters);
                    foreach (var exception in operationsValidator.ValidationExceptions(operation.Value))
                    {
                        yield return exception;
                    }
                    // TODO: validate properties
                    //if (schema.Properties != null)
                    //{
                    //    foreach (var prop in schema.Properties)
                    //    {
                    //        context.PushTitle(context.Title + "/" + prop.Key);
                    //        prop.Value.Validate(context);
                    //        context.PopTitle();
                    //    }
                    //}

                    // TODO: validate external docs
                    //if (schema.ExternalDocs != null)
                    //{
                    //    ExternalDocs.Validate(context);
                    //}

                    yield break;
                }
            }
        }
    }
}
