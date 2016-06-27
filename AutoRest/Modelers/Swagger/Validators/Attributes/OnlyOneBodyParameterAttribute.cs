using System;
using Microsoft.Rest.Generators.Validation;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Collections.Generic;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    [AttributeUsage(AttributeTargets.Class, Inherited = true)]
    public class OnlyOneBodyParameterAttribute : RuleAttribute
    {
        public override bool IsSatisfiedBy(object obj, out object[] formatParams)
        {
            bool valid = true;

            var entity = obj as Operation;
            formatParams = new object[0];

            if (entity.Parameters != null)
            {
                var bodyParameters = new HashSet<string>();

                foreach (var param in entity.Parameters)
                {
                    if (param.In == ParameterLocation.Body)
                        bodyParameters.Add(param.Name);
                    if (param.Reference != null)
                    {
                        /*
                        TODO: get all parameters routed into this class
                        var pRef = FindReferencedParameter(param.Reference, Parameters);
                        if (pRef != null && pRef.In == ParameterLocation.Body)
                        {
                            bodyParameters.Add(pRef.Name);
                        }
                        */
                    }
                }

                if (bodyParameters.Count > 1)
                {
                    valid = false;
                }
                formatParams = new object[] { string.Join(",", bodyParameters) };
            }

            return valid;
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


        public override ValidationException Exception
        {
            get
            {
                return ValidationException.OnlyOneBodyParameterAllowed;
            }
        }
    }
}
