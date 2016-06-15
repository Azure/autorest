using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Modeler.Swagger.Model;
using Microsoft.Rest.Modeler.Swagger.Properties;
using System.Collections.Generic;
using System.Linq;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public class SwaggerObjectValidator : IValidator<SwaggerObject>
    {
        public bool IsValid(SwaggerObject entity)
        {
            return !ValidationExceptions(entity).Any();
        }

        public IEnumerable<string> ValidationExceptions(SwaggerObject entity)
        {
            if (string.IsNullOrEmpty(entity.Description) && string.IsNullOrEmpty(entity.Reference))
            {
                // TODO: need to have a way to include warning, error level
                yield return Resources.MissingDescription;
            }
            yield break;
        }
    }
}
