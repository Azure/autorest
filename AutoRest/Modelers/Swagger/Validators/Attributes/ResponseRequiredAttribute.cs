using System;
using Microsoft.Rest.Generators.Validation;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Collections.Generic;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    [AttributeUsage(AttributeTargets.Property, Inherited = true)]
    public class ResponseRequiredAttribute : RuleAttribute
    {
        public override bool IsSatisfiedBy(object obj, out object[] formatParams)
        {
            bool valid = true;

            var entity = obj as IDictionary<string, OperationResponse>;
            if (entity == null || entity.Count == 0)
            {
                valid = false;
            }

            formatParams = new object[0];
            return valid;
        }

        public override ValidationException Exception
        {
            get
            {
                return ValidationException.AResponseMustBeDefined;
            }
        }
    }
}
