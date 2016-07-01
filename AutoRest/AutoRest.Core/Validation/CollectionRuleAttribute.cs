using System;

namespace Microsoft.Rest.Generator
{
    /// <summary>
    /// A rule attribute that should be applied to all members of the collection that is annotated
    /// </summary>
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1813:AvoidUnsealedAttributes")]
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Property, AllowMultiple = true, Inherited = true)]
    public class CollectionRuleAttribute : RuleAttribute
    {
        public CollectionRuleAttribute(Type ruleType) : base(ruleType)
        {
        }
    }
}
