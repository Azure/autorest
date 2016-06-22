using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Modeler.Swagger.Model;
using Microsoft.Rest.Modeler.Swagger.Properties;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Microsoft.Rest.Modeler.Swagger
{
    public class ConsumesValidator : SwaggerBaseValidator, IValidator<IList<string>>
    {
        public bool IsValid(IList<string> entity)
        {
            return !ValidationExceptions(entity).Any();
        }

        public IEnumerable<ValidationMessage> ValidationExceptions(IList<string> entity)
        {
            foreach (var consume in entity.Where(input => !string.IsNullOrEmpty(input) && !input.Contains("json")))
            {
                yield return CreateException(entity, ValidationExceptionConstants.Exceptions.OnlyJSONInRequest, consume);
            }
        }
    }
}
