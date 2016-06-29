using Microsoft.Rest.Generator;
using Microsoft.Rest.Generator.Logging;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1813:AvoidUnsealedAttributes")]
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Property, AllowMultiple = true, Inherited = true)]
    public class RuleAttribute : Attribute
    {
        public Type RuleType { get; }

        private Rule Rule;

        public RuleAttribute(Type ruleType)
        {
            if (typeof(Rule).IsAssignableFrom(ruleType))
            {
                Rule = (Rule)Activator.CreateInstance(ruleType);
            }
        }

        public virtual IEnumerable<ValidationMessage> GetValidationMessages(object entity)
        {
            if (Rule != null)
            {
                foreach(var message in Rule.GetValidationMessages(entity))
                {
                    yield return message;
                }
            }
            yield break;
        }
    }
}
