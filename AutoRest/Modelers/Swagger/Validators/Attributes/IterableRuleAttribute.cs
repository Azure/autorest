using Microsoft.Rest.Generator;
using Microsoft.Rest.Generator.Logging;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Microsoft.Rest.Modeler.Swagger.Validators
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
