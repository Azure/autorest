using Microsoft.Rest.Generator.Validation;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Collections.Generic;
using System.Linq;

namespace Microsoft.Rest.Modeler.Swagger
{
    public class ExternalDocsValidator : SwaggerBaseValidator, IValidator<ExternalDoc>
    {
        public bool IsValid(ExternalDoc entity)
        {
            return !ValidationExceptions(entity).Any();
        }

        public IEnumerable<ValidationMessage> ValidationExceptions(ExternalDoc entity)
        {
            foreach (var exception in base.ValidationExceptions(entity))
            {
                yield return exception;
            }
        }
    }
}
