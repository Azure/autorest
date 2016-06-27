using System;
using Microsoft.Rest.Generators.Validation;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Linq;
using System.Collections;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    [AttributeUsage(AttributeTargets.Property, Inherited = true)]
    public class AnonymousTypesAttribute : RequiredAttribute
    {
        public override bool IsSatisfiedBy(object obj, out object[] formatParams)
        {
            bool valid = true;


            formatParams = new object[0];
            return valid;
        }

        public override ValidationException Exception
        {
            get
            {
                return ValidationException.AnonymousTypesDiscouraged;
            }
        }
    }
}
