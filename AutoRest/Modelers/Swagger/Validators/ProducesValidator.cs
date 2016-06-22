using Microsoft.Rest.Generator.Validation;
using Microsoft.Rest.Generators.Validation;
using System.Collections.Generic;
using System.Linq;

namespace Microsoft.Rest.Modeler.Swagger
{
    public class ProducesValidator : SwaggerBaseValidator, IValidator<IList<string>>
    {
        public bool IsValid(IList<string> entity)
        {
            return !ValidationExceptions(entity).Any();
        }

        public IEnumerable<ValidationMessage> ValidationExceptions(IList<string> entity)
        {
            foreach (var produce in entity.Where(input => !string.IsNullOrEmpty(input) && !input.Contains("json")))
            {
                yield return CreateException(entity, ValidationException.OnlyJSONInResponse, produce);
            }
        }
    }
}
