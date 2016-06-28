using Microsoft.Rest.Generator;
using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Generator.Validation;
using Microsoft.Rest.Generators.Validation;
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

        public override IEnumerable<ValidationMessage> GetValidationMessages(object obj)
        {
            if (Rule != null)
            {
                var enumerable = obj as IEnumerable;
                if (enumerable != null)
                {
                    foreach (var entity in enumerable)
                    {
                        object[] outParams;
                        if (!Rule.IsValid(entity, out outParams))
                        {
                            yield return CreateException(null, Rule.Exception, outParams);
                        }
                    }
                }
            }
            yield break;
        }
    }
}
