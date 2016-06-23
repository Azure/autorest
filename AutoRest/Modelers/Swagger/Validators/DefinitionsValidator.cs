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
                    exception.Source.Path.Add(pair.Key);
                    yield return exception;
                }
                if (schema.Required != null)
                {
                    foreach (var req in schema.Required.Where(r => !string.IsNullOrEmpty(r)))
                    {
                        Schema value = null;
                        if (schema.Properties == null || !schema.Properties.TryGetValue(req, out value))
                        {
                            yield return CreateException(Source, ValidationException.MissingRequiredProperty, req);
                        }
                    }
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
            }

            yield break;
        }
    }
}
