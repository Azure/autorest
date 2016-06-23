using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Generator.Validation;
using Microsoft.Rest.Modeler.Swagger.Model;
using Microsoft.Rest.Modeler.Swagger.Properties;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator;
using Microsoft.Rest.Generators.Validation;

namespace Microsoft.Rest.Modeler.Swagger
{
    public class DefinitionsValidator : SwaggerObjectValidator, IValidator<Dictionary<string, Schema>>
    {
        public DefinitionsValidator(SourceContext source) : base(source)
        {
        }

        public bool IsValid(Dictionary<string, Schema> entity)
        {
            return !ValidationExceptions(entity).Any();
        }

        public IEnumerable<ValidationMessage> ValidationExceptions(Dictionary<string, Schema> entity)
        {
            foreach (var pair in entity)
            {
                var schema = pair.Value;
                foreach (var exception in base.ValidationExceptions(schema))
                {
                    exception.Path.Add(pair.Key);
                    yield return exception;
                }
                if (schema.Required != null)
                {
                    foreach (var req in schema.Required.Where(r => !string.IsNullOrEmpty(r)))
                    {
                        Schema value = null;
                        if (schema.Properties == null || !schema.Properties.TryGetValue(req, out value))
                        {
                            yield return CreateException(Source, ValidationException.RequiredPropertiesMustExist, req);
                        }
                    }
                }

                if (schema.Properties != null)
                {
                    var definitionsValidator = new DefinitionsValidator(Source);
                    foreach (var exception in definitionsValidator.ValidationExceptions(schema.Properties))
                    {
                        exception.Path.Add("Properties");
                        exception.Path.Add(pair.Key);
                        yield return exception;
                    }
                }

                var externalDocsValidator = new ExternalDocsValidator(Source);
                foreach (var exception in externalDocsValidator.ValidationExceptions(schema.ExternalDocs))
                {
                    exception.Path.Add("ExternalDocs");
                    exception.Path.Add(pair.Key);
                    yield return exception;
                }
            }

            yield break;
        }
    }
}
