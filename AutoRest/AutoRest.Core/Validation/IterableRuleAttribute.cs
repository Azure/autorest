using System;

namespace Microsoft.Rest.Generator
{
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1813:AvoidUnsealedAttributes")]
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Property, AllowMultiple = true, Inherited = true)]
    public class IterableRuleAttribute : RuleAttribute
    {
        public IterableRuleAttribute(Type ruleType) : base(ruleType)
        {
        }
    }
}
