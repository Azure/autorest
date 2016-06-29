using Microsoft.Rest.Generator;
using Microsoft.Rest.Generator.Logging;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Property, AllowMultiple = true, Inherited = true)]
    public class IterableRuleAttribute : RuleAttribute
    {
        public IterableRuleAttribute(Type type) : base(type)
        {
        }
    }
}
