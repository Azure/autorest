using System;
using System.Collections.Generic;

namespace Microsoft.Rest.Generator
{
    /// <summary>
    /// An attribute that describes a rule to apply to the property or class that it decorates
    /// </summary>
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1813:AvoidUnsealedAttributes")]
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Property, AllowMultiple = true, Inherited = true)]
    public class RuleAttribute : Attribute
    {
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
