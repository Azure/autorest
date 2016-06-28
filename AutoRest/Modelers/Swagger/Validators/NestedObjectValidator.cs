using Microsoft.Rest.Generator;
using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Generator.Validation;
using Microsoft.Rest.Generators.Validation;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public class NestedObjectValidator : IValidator<object>
    {
        public bool IsValid(object entity)
        {
            return !ValidationExceptions(entity).Any();
        }

        public IEnumerable<ValidationMessage> ValidationExceptions(object entity)
        {
            return ValidationExceptions(entity, null);
        }

        public IEnumerable<ValidationMessage> ValidationExceptions(object entity, SourceContext source = null, RuleAttribute[] inheritedRules = null)
        {
            var ruleAttr = typeof(RuleAttribute);
            var iterableRuleAttr = typeof(IterableRuleAttribute);
            if (entity != null)
            {
                var isList = entity is IList;
                bool isDictionary = entity is IDictionary;
                // If class, loop through properties
                if (!isList && !isDictionary && entity.GetType().IsClass && entity.GetType() != typeof(string))
                {
                    // Go through each class rule
                    var classRules = entity.GetType().GetCustomAttributes(ruleAttr, true) as RuleAttribute[];
                    if (inheritedRules != null)
                    {
                        classRules = inheritedRules.Concat(classRules).ToArray();
                    }
                    foreach (var rule in classRules)
                    {
                        foreach (var message in rule.GetValidationMessages(entity))
                        {
                            yield return message;
                        }
                    }

                    // Go through each prop rule
                    foreach (var prop in entity.GetType().GetProperties(BindingFlags.FlattenHierarchy
                        | BindingFlags.Public
                        | BindingFlags.Instance
                        ))
                    {
                        // TODO: figure out way to iterate through lists and dictionaries and apply rules. Or pass rules to the next nested iteration of validation
                        var value = prop.GetValue(entity);
                        var rules = prop.GetCustomAttributes(ruleAttr, true) as RuleAttribute[];
                        foreach (var rule in rules)
                        {
                            foreach (var message in rule.GetValidationMessages(value))
                            {
                                yield return message;
                            }
                        }

                        // If the property is a class, do validation on the property value
                        var inheritableRules = prop.GetCustomAttributes(iterableRuleAttr, true) as IterableRuleAttribute[];
                        foreach (var exception in ValidationExceptions(value, source, inheritableRules))
                        {
                            exception.Path.Add(prop.Name);
                            yield return exception;
                        }
                    }
                }
                else if (isList)
                {
                    var list = ((IList)entity).Cast<dynamic>().ToList();
                    if (list != null)
                    {
                        var index = 0;
                        foreach (var child in list)
                        {
                            var exceptions = ValidationExceptions(child, source, inheritedRules);
                            foreach (var exception in exceptions)
                            {
                                exception.Path.Add($"[{index}]");
                                yield return exception;
                            }
                        }
                    }
                }
                else if (isDictionary)
                {
                    var dict = ((IDictionary)entity).Cast<dynamic>().ToDictionary(entry => (string)entry.Key, entry => entry.Value);
                    if (dict != null)
                    {
                        foreach (var pair in dict)
                        {
                            var exceptions = ValidationExceptions(pair.Value, source, inheritedRules);
                            foreach (var exception in exceptions)
                            {
                                exception.Path.Add(pair.Key);
                                yield return exception;
                            }
                        }
                    }
                }
            }
            yield break;
        }
    }
}
