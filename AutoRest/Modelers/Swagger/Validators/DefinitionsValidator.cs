using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Modeler.Swagger.Model;
using Microsoft.Rest.Modeler.Swagger.Properties;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Microsoft.Rest.Modeler.Swagger
{
    public class DefinitionsValidator : SwaggerObjectValidator, IValidator<Dictionary<string, Schema>>
    {
        public bool IsValid(Dictionary<string, Schema> entity)
        {
            return !ValidationExceptions(entity).Any();
        }

        public IEnumerable<ValidationMessage> ValidationExceptions(Dictionary<string, Schema> entity)
        {
            foreach (var schema in entity.Select(e => e.Value))
            {
                foreach (var exception in base.ValidationExceptions(schema))
                {
                    yield return exception;
                }
                if (schema.Required != null)
                {
                    foreach (var req in schema.Required.Where(r => !string.IsNullOrEmpty(r)))
                    {
                        Schema value = null;
                        if (schema.Properties == null || !schema.Properties.TryGetValue(req, out value))
                        {
                            yield return new ValidationMessage()
                            {
                                Severity = LogEntrySeverity.Error,
                                Message = string.Format(CultureInfo.InvariantCulture, Resources.MissingRequiredProperty, req),
                                Source = entity
                            };
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

                yield break;
            }
        }
    }
}
