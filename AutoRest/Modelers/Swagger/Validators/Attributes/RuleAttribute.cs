using Microsoft.Rest.Generator;
using Microsoft.Rest.Generator.Logging;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Property, AllowMultiple = true, Inherited = true)]
    public class RuleAttribute : Attribute
    {
        protected Rule Rule;

        public RuleAttribute(Type type)
        {
            if (typeof(Rule).IsAssignableFrom(type))
            {
                Rule = (Rule)Activator.CreateInstance(type);
            }
        }

        public virtual IEnumerable<ValidationMessage> GetValidationMessages(object obj)
        {
            if (Rule != null)
            {
                foreach(var message in Rule.GetValidationMessages(obj))
                {
                    yield return message;
                }
            }
            yield break;
        }
    }
}
