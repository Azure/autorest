using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Modeler.Swagger.Model;
using Microsoft.Rest.Modeler.Swagger.Properties;
using System.Collections.Generic;
using System.Linq;

namespace Microsoft.Rest.Modeler.Swagger
{
    public class ServiceDefinitionValidator : SwaggerBaseValidator, IValidator<ServiceDefinition>
    {
        public bool IsValid(ServiceDefinition entity)
        {
            return !ValidationExceptions(entity).Any();
        }

        public IEnumerable<ValidationMessage> ValidationExceptions(ServiceDefinition entity)
        {
            foreach (var exception in base.ValidationExceptions(entity))
            {
                yield return exception;
            }

            var consumesValidator = new ConsumesValidator();
            foreach (var exception in consumesValidator.ValidationExceptions(entity.Consumes))
            {
                yield return exception;
            }

            var producesValidator = new ProducesValidator();
            foreach (var exception in producesValidator.ValidationExceptions(entity.Produces))
            {
                yield return exception;
            }

            var definitionsValidator = new DefinitionsValidator();
            foreach (var exception in definitionsValidator.ValidationExceptions(entity.Definitions))
            {
                yield return exception;
            }

            var pathsValidator = new PathsValidator(entity.Parameters);
            foreach (var exception in pathsValidator.ValidationExceptions(entity.Paths))
            {
                yield return exception;
            }

            var customPathsValidator = new PathsValidator(entity.Parameters);
            foreach (var exception in pathsValidator.ValidationExceptions(entity.CustomPaths))
            {
                yield return exception;
            }

            foreach (var param in entity.Parameters)
            {
                var parameterValidator = new ParameterValidator();
                foreach (var exception in parameterValidator.ValidationExceptions(param.Value))
                {
                    yield return exception;
                }
            }

            foreach (var response in entity.Responses)
            {
                var responseValidator = new ResponseValidator();
                foreach (var exception in responseValidator.ValidationExceptions(response.Value))
                {
                    yield return exception;
                }
            }

            //context.PopTitle();
            //context.PushTitle("SecurityDefinitions");
            //foreach (var secDef in SecurityDefinitions)
            //{
            //    context.PushTitle("SecurityDefinitions/" + secDef.Key);
            //    secDef.Value.Validate(context);
            //    context.PopTitle();
            //}
            //context.PopTitle();
            //foreach (var tag in Tags)
            //{
            //    tag.Validate(context);
            //}

            var externalDocsValidator = new ExternalDocsValidator();
            foreach (var exception in externalDocsValidator.ValidationExceptions(entity.ExternalDocs))
            {
                yield return exception;
            }
        }
    }
}
