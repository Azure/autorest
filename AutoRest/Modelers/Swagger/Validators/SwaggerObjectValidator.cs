using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Generator.Validation;
using Microsoft.Rest.Generators.Validation;
using Microsoft.Rest.Modeler.Swagger.Model;
using Microsoft.Rest.Modeler.Swagger.Properties;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator;

namespace Microsoft.Rest.Modeler.Swagger
{
    public class SwaggerObjectValidator : SwaggerBaseValidator, IValidator<SwaggerObject>
    {
        public SwaggerObjectValidator(SourceContext source) : base(source)
        {
        }

        public bool IsValid(SwaggerObject entity)
        {
            return !ValidationExceptions(entity).Any();
        }

        public IEnumerable<ValidationMessage> ValidationExceptions(SwaggerObject entity)
        {
            if (string.IsNullOrEmpty(entity.Description) && string.IsNullOrEmpty(entity.Reference))
            {
                yield return CreateException(entity.Source, ValidationException.MissingDescription);
            }

            if (!string.IsNullOrEmpty(entity.Default) && entity.Enum != null)
            {
                // There's a default, and there's an list of valid values. Make sure the default is one 
                // of them.
                if (!entity.Enum.Contains(entity.Default))
                {
                    yield return CreateException(entity.Source, ValidationException.InvalidDefault);
                }
            }
            yield break;
        }
    }
}
