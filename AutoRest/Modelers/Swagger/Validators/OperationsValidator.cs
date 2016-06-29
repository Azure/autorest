using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Modeler.Swagger.Model;
using Microsoft.Rest.Modeler.Swagger.Properties;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator;

namespace Microsoft.Rest.Modeler.Swagger
{
    public class OperationsValidator : SwaggerObjectValidator, IValidator<Operation>
    {
        public Dictionary<string, SwaggerParameter> Parameters { get; internal set; }

        public string Path { get; internal set; }

        public OperationsValidator(SourceContext source, string path, Dictionary<string, SwaggerParameter> parameters) : base(source)
        {
            Parameters = parameters;
            Path = path;
        }

        public bool IsValid(Operation entity)
        {
            return !ValidationExceptions(entity).Any();
        }

        public IEnumerable<ValidationMessage> ValidationExceptions(Operation entity)
        {
            /*
            var consumesValidator = new ConsumesValidator(entity.Source);
            foreach (var exception in consumesValidator.ValidationExceptions(entity.Consumes))
            {
                yield return exception;
            }

            var producesValidator = new ProducesValidator(entity.Source);
            foreach (var exception in producesValidator.ValidationExceptions(entity.Produces))
            {
                yield return exception;
            }
            */

            if (entity.Parameters != null)
            {
                var bodyParameters = new HashSet<string>();

                foreach (var param in entity.Parameters)
                {
                    if (param.In == ParameterLocation.Body)
                        bodyParameters.Add(param.Name);
                    if (param.Reference != null)
                    {
                        var pRef = FindReferencedParameter(param.Reference, Parameters);
                        if (pRef != null && pRef.In == ParameterLocation.Body)
                        {
                            bodyParameters.Add(pRef.Name);
                        }
                    }
                }

                if (bodyParameters.Count > 1)
                {
                    yield return CreateException(entity.Source, ValidationException.OnlyOneBodyParameterAllowed, string.Join(",", bodyParameters));
                }

                // TODO: validate path parameters
                var parts = Path.Split("/?".ToCharArray());

                foreach (var part in parts.Where(p => !string.IsNullOrEmpty(p)))
                {
                    if (part[0] == '{' && part[part.Length - 1] == '}')
                    {
                        var pName = part.Trim('{', '}');
                        var found = FindParameter(entity, pName, Parameters);

                        if (found == null || found.In != ParameterLocation.Path)
                        {
                            yield return CreateException(entity.Source, ValidationException.PathParametersMustBeDefined, pName);
                        }
                    }
                }
            }

            // TODO: call base to check description
            //if (string.IsNullOrEmpty(Description))
            //{
            //    context.LogWarning(Resources.MissingDescription);
            //}

            yield break;
        }

        //private void FindAllPathParameters(Operation entity)
        //{
        //    var parts = Path.Split("/?".ToCharArray());

        //    foreach (var part in parts.Where(p => !string.IsNullOrEmpty(p)))
        //    {
        //        if (part[0] == '{' && part[part.Length - 1] == '}')
        //        {
        //            var pName = part.Trim('{', '}');
        //            var found = FindParameter(entity, pName, Parameters);

        //            if (found == null || found.In != ParameterLocation.Path)
        //            {
        //                context.LogError(string.Format(CultureInfo.InvariantCulture, Resources.NoDefinitionForPathParameter1, pName));
        //            }
        //        }
        //    }
        //}

        private SwaggerParameter FindParameter(Operation entity, string name, IDictionary<string, SwaggerParameter> parameters)
        {
            if (entity.Parameters != null)
            {
                foreach (var param in entity.Parameters)
                {
                    if (name.Equals(param.Name))
                        return param;

                    var pRef = FindReferencedParameter(param.Reference, parameters);

                    if (pRef != null && name.Equals(pRef.Name))
                    {
                        return pRef;
                    }
                }
            }
            return null;
        }

        private static SwaggerParameter FindReferencedParameter(string reference, IDictionary<string, SwaggerParameter> parameters)
        {
            if (reference != null && reference.StartsWith("#", StringComparison.Ordinal))
            {
                var parts = reference.Split('/');
                if (parts.Length == 3 && parts[1].Equals("parameters"))
                {
                    SwaggerParameter p = null;
                    if (parameters.TryGetValue(parts[2], out p))
                    {
                        return p;
                    }
                }
            }

            return null;
        }

    }
}
