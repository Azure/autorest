using System;
using Microsoft.Rest.Generators.Validation;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Linq;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    [AttributeUsage(AttributeTargets.Class, Inherited = true)]
    public class RequiredPropertiesMustExistAttribute : RuleAttribute
    {
        public override bool IsSatisfiedBy(object obj, out object[] formatParams)
        {
            bool valid = true;

            var entity = obj as Schema;
            if (entity != null && entity.Required != null)
            {
                foreach (var req in entity.Required.Where(r => !string.IsNullOrEmpty(r)))
                {
                    Schema value = null;
                    if (entity.Properties == null || !entity.Properties.TryGetValue(req, out value))
                    {
                        valid = false;
                    }
                }
            }

            // TODO: need to be able to return multiple errors from a IsSatisfiedBy call
            formatParams = new object[] { string.Empty };
            return valid;
        }

        public override ValidationException Exception
        {
            get
            {
                return ValidationException.RequiredPropertiesMustExist;
            }
        }
    }
}
