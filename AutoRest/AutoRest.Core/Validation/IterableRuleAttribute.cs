using System;

namespace Microsoft.Rest.Generator
{
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", MessageId = "Iterable")]
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1813:AvoidUnsealedAttributes")]
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Property, AllowMultiple = true, Inherited = true)]
    public class InheritableRuleAttribute : RuleAttribute
    {
        public InheritableRuleAttribute(Type ruleType) : base(ruleType)
        {
        }
    }
}
