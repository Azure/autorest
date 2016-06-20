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

            //context.PushTitle("Definitions");
            //foreach (var def in Definitions)    
            //{
            //    context.PushTitle("Definitions/" + def.Key);
            //    def.Value.Validate(context);
            //    context.PopTitle();
            //}
            //context.PopTitle();
            //context.PushTitle("Paths");
            //foreach (var path in Paths)
            //{
            //    context.Path = path.Key;
            //    foreach (var operation in path.Value.Values)
            //    {
            //        context.PushTitle(operation.OperationId);
            //        operation.Validate(context);
            //        context.PopTitle();
            //    }
            //    context.Path = null;
            //}
            //context.PopTitle();
            //context.PushTitle("CustomPaths");
            //foreach (var path in CustomPaths)
            //{
            //    context.Path = path.Key;
            //    foreach (var operation in path.Value.Values)
            //    {
            //        context.PushTitle(operation.OperationId);
            //        operation.Validate(context);
            //        context.PopTitle();
            //    }
            //    context.Path = null;
            //}
            //context.PopTitle();
            //context.PushTitle("Parameters");
            //foreach (var param in Parameters)
            //{
            //    context.PushTitle("Parameters/" + param.Key);
            //    param.Value.Validate(context);
            //    context.PopTitle();
            //}
            //context.PopTitle();
            //context.PushTitle("Responses");
            //foreach (var response in Responses)
            //{
            //    context.PushTitle("Parameters/" + response.Key);
            //    response.Value.Validate(context);
            //    context.PopTitle();
            //}
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

            //context.PushTitle("ExternalDocs");
            //if (ExternalDocs != null)
            //    ExternalDocs.Validate(context);
            //context.PopTitle();

            //return context.ValidationErrors.Count == errorCount;
        }
    }
}
