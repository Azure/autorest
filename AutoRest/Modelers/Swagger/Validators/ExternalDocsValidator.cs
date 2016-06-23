using Microsoft.Rest.Generator.Validation;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator;

namespace Microsoft.Rest.Modeler.Swagger
{
    public class ExternalDocsValidator : SwaggerBaseValidator, IValidator<ExternalDoc>
    {
        public ExternalDocsValidator(SourceContext source) : base(source)
        {
        }

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
