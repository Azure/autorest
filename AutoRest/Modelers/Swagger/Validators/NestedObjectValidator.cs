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

        public IEnumerable<ValidationMessage> ValidationExceptions(object entity, SourceContext source = null)
        {
            if (entity != null)
            {
                var isList = entity is IList;
                bool isDictionary = entity is IDictionary;
                // If class, loop through properties
                if (!isList && !isDictionary && entity.GetType().IsClass && entity.GetType() != typeof(string))
                {
                    var ruleAttr = typeof(RuleAttribute);
                    // Go through each class rule
                    var classRules = entity.GetType().GetCustomAttributes(ruleAttr, true) as RuleAttribute[];
                    foreach (var rule in classRules)
                    {
                        if (!rule.IsSatisfiedBy(entity))
                        {
                            yield return CreateException(source, rule.Exception);
                        }
                    }

                    // Go through each prop rule
                    foreach (var prop in entity.GetType().GetProperties(BindingFlags.FlattenHierarchy
                        | BindingFlags.Public
                        | BindingFlags.Instance
                        ))
                    {
                        var value = prop.GetValue(entity);
                        var rules = prop.GetCustomAttributes(ruleAttr, true) as RuleAttribute[];
                        foreach (var rule in rules)
                        {
                            if (!rule.IsSatisfiedBy(value))
                            {
                                yield return CreateException(source, rule.Exception);
                            }
                        }

                        // If the property is a class, do validation on the property value
                        foreach (var exception in ValidationExceptions(value, source))
                        {
                            exception.Path.Add(prop.Name);
                            yield return exception;
                        }

                        //var iterableProp = value as IEnumerable<object>;
                        //if (iterableProp != null)
                        //{
                        //    foreach (var child in iterableProp)
                        //    {
                        //        var exceptions = ValidationExceptions(child, source);
                        //        foreach (var exception in exceptions)
                        //        {
                        //            exception.Path.Add(prop.Name);
                        //            yield return exception;
                        //        }
                        //    }
                        //}
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
                            var exceptions = ValidationExceptions(child, source);
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
                            var exceptions = ValidationExceptions(pair.Value, source);
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

        protected ValidationMessage CreateException(SourceContext source, ValidationException exceptionId, params object[] messageValues)
        {
            ValidationMessage validationMessage;
            ValidationException[] ignore = new ValidationException[] { };
            if (ignore.Any(id => id == exceptionId))
            {
                validationMessage = new ValidationMessage()
                {
                    Severity = LogEntrySeverity.Info,
                    Message = ""
                };
            }
            else if (ValidationExceptionConstants.Info.Messages.ContainsKey(exceptionId))
            {
                validationMessage = new ValidationMessage()
                {
                    Severity = LogEntrySeverity.Warning,
                    Message = string.Format(CultureInfo.InvariantCulture, ValidationExceptionConstants.Info.Messages[exceptionId], messageValues)
                };
            }
            else if (ValidationExceptionConstants.Warnings.Messages.ContainsKey(exceptionId))
            {
                validationMessage = new ValidationMessage()
                {
                    Severity = LogEntrySeverity.Warning,
                    Message = string.Format(CultureInfo.InvariantCulture, ValidationExceptionConstants.Warnings.Messages[exceptionId], messageValues)
                };
            }
            else if (ValidationExceptionConstants.Errors.Messages.ContainsKey(exceptionId))
            {
                validationMessage = new ValidationMessage()
                {
                    Severity = LogEntrySeverity.Warning,
                    Message = string.Format(CultureInfo.InvariantCulture, ValidationExceptionConstants.Errors.Messages[exceptionId], messageValues)
                };
            }
            else
            {
                throw new NotImplementedException();
            }

            validationMessage.Source = source;
            validationMessage.ValidationException = exceptionId;
            return validationMessage;
        }

    }
}
