using Microsoft.Rest.Generator.Validation;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator;

namespace Microsoft.Rest.Modeler.Swagger
{
    public class ServiceDefinitionValidator : SwaggerBaseValidator, IValidator<ServiceDefinition>
    {
        public ServiceDefinitionValidator(SourceContext source) : base(source)
        {
        }

        public bool IsValid(ServiceDefinition entity)
        {
            return !ValidationExceptions(entity).Any();
        }

        public IEnumerable<ValidationMessage> ValidationExceptions(ServiceDefinition entity)
        {
            foreach (var exception in base.ValidationExceptions(entity))
            {
                exception.Path.Add("root");
                yield return exception;
            }

            var consumesValidator = new ConsumesValidator(entity.Source);
            foreach (var exception in consumesValidator.ValidationExceptions(entity.Consumes))
            {
                exception.Path.Add("Consumes");
                exception.Path.Add("root");
                yield return exception;
            }

            var producesValidator = new ProducesValidator(entity.Source);
            foreach (var exception in producesValidator.ValidationExceptions(entity.Produces))
            {
                exception.Path.Add("Produces");
                exception.Path.Add("root");
                yield return exception;
            }

            var definitionsValidator = new DefinitionsValidator(entity.Source);
            foreach (var exception in definitionsValidator.ValidationExceptions(entity.Definitions))
            {
                exception.Path.Add("Definitions");
                exception.Path.Add("root");
                yield return exception;
            }

            var pathsValidator = new PathsValidator(entity.Source, entity.Parameters);
            foreach (var exception in pathsValidator.ValidationExceptions(entity.Paths))
            {
                exception.Path.Add("Paths");
                exception.Path.Add("root");
                yield return exception;
            }

            var customPathsValidator = new PathsValidator(entity.Source, entity.Parameters);
            foreach (var exception in pathsValidator.ValidationExceptions(entity.CustomPaths))
            {
                exception.Path.Add("Paths");
                exception.Path.Add("root");
                yield return exception;
            }

            foreach (var param in entity.Parameters)
            {
                var parameterValidator = new ParameterValidator(entity.Source);
                foreach (var exception in parameterValidator.ValidationExceptions(param.Value))
                {
                    exception.Path.Add("Parameters");
                    exception.Path.Add("root");
                    exception.Path.Add(param.Key);
                    yield return exception;
                }
            }

            foreach (var response in entity.Responses)
            {
                var responseValidator = new ResponseValidator(entity.Source);
                foreach (var exception in responseValidator.ValidationExceptions(response.Value))
                {
                    exception.Path.Add("Parameters");
                    exception.Path.Add("root");
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

            var externalDocsValidator = new ExternalDocsValidator(entity.Source);
            foreach (var exception in externalDocsValidator.ValidationExceptions(entity.ExternalDocs))
            {
                exception.Path.Add("root");
                yield return exception;
            }
        }
    }
}
