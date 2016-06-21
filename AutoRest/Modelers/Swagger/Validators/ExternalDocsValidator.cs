using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Modeler.Swagger.Model;
using Microsoft.Rest.Modeler.Swagger.Properties;
using System;
using System.Collections.Generic;
using System.Globalization;
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
            throw new NotImplementedException();
        }
    }
}
