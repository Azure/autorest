// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

namespace AutoRest.Core.Validation
{
    /// <summary>
    /// A validator that traverses an object graph, applies validation rules, and logs validation messages
    /// </summary>
    public class RecursiveObjectValidator
    {
        public RecursiveObjectValidator()
        {
        }

        public IEnumerable<ValidationMessage> GetValidationExceptions(object entity)
        {
            return RecursiveValidate(entity, new List<RuleAttribute>());
        }

        private IEnumerable<ValidationMessage> RecursiveValidate(object entity, IEnumerable<RuleAttribute> collectionRules)
        {
            if (entity != null)
            {
                if (entity is IList)
                {
                    // Recursively validate each list item and add the item index to the location of each validation message
                    IList<dynamic> list = ((IList)entity).Cast<dynamic>().ToList();
                    if (list != null)
                    {
                        for (int i = 0; i < list.Count; i++)
                        {
                            foreach (ValidationMessage exception in RecursiveValidate(list[i], collectionRules))
                            {
                                exception.Path.Add($"[{i}]");
                                yield return exception;
                            }
                        }
                    }
                }
                else if (entity is IDictionary)
                {
                    // Recursively validate each dictionary entry and add the entry key to the location of each validation message
                    IDictionary<string, dynamic> dict = ((IDictionary)entity).Cast<dynamic>().ToDictionary(entry => (string)entry.Key, entry => entry.Value);
                    if (dict != null && entity.IsValidatableDictionary())
                    {
                        foreach (var pair in dict)
                        {
                            foreach (ValidationMessage exception in RecursiveValidate(pair.Value, collectionRules))
                            {
                                exception.Path.Add(pair.Key);
                                yield return exception;
                            }
                        }
                    }
                }
                else if (entity.GetType().IsClass && entity.GetType() != typeof(string))
                {
                    // Validate objects by running class rules against the object and recursively against properties
                    foreach(var exception in ValidateObjectValue(entity, collectionRules))
                    {
                        yield return exception;
                    }
                    foreach(var exception in ValidateObjectProperties(entity))
                    {
                        yield return exception;
                    }
                }
            }
            yield break;
        }

        private IEnumerable<ValidationMessage> ValidateObjectValue(object entity, IEnumerable<RuleAttribute> collectionRules)
        {
            // Get any rules defined for the class of the entity
            var classRules = entity.GetType().GetCustomAttributes<RuleAttribute>(true);

            // Combine the class rules with any rules that apply to the collection that the entity is part of
            classRules = collectionRules.Concat(classRules);

            // Apply each rule for the entity
            foreach (var rule in classRules)
            {
                foreach (var exception in rule.GetValidationMessages(entity))
                {
                    yield return exception;
                }
            }
            yield break;
        }

        private IEnumerable<ValidationMessage> ValidateObjectProperties(object entity)
        {
            // Go through each validatable property
            foreach (var prop in entity.GetValidatableProperties())
            {
                // Get the value of the property from the entity
                var value = prop.GetValue(entity);

                // Get any rules defined on this property and apply them to the property value
                var propertyRules = prop.GetCustomAttributes<RuleAttribute>(true);
                foreach (var rule in propertyRules)
                {
                    foreach (var exception in rule.GetValidationMessages(value))
                    {
                        exception.Path.Add(prop.Name);
                        yield return exception;
                    }
                }

                // Recursively validate the value of the property (passing any rules to inherit)
                var inheritableRules = prop.GetCustomAttributes<CollectionRuleAttribute>(true);
                foreach (var exception in RecursiveValidate(value, inheritableRules))
                {
                    exception.Path.Add(prop.Name);
                    yield return exception;
                }
            }
            yield break;
        }
    }

    internal static class RulesExtensions
    {
        private static readonly Type JsonExtensionDataType = typeof(JsonExtensionDataAttribute);

        /// <summary>
        /// Gets an enumerable of properties for <paramref name="entity"/> that can be validated
        /// </summary>
        /// <param name="entity">The object to get properties for</param>
        /// <returns></returns>
        internal static IEnumerable<PropertyInfo> GetValidatableProperties(this object entity)
        {
            if (entity == null)
            {
                return new List<PropertyInfo>();
            }
            return entity.GetType().GetProperties(BindingFlags.FlattenHierarchy | BindingFlags.Public | BindingFlags.Instance)
                         .Where(prop => !Attribute.IsDefined(prop, JsonExtensionDataType))
                         .Where(prop => prop.PropertyType != typeof(object));
        }

        /// <summary>
        /// Determines if a dictionary can be validated by running rules
        /// </summary>
        /// <param name="entity">The object to check</param>
        /// <returns></returns>
        internal static bool IsValidatableDictionary(this object entity)
        {
            if (entity == null)
            {
                return false;
            }
            // Dictionaries of type <string, object> cannot be validated, because the object could be infinitely deep.
            // We only want to validate objects that have strong typing for the value type
            var dictType = entity.GetType();
            return dictType.IsGenericType &&
                   dictType.GenericTypeArguments.Count() >= 2 &&
                   dictType.GenericTypeArguments[1] != typeof(object);
        }
    }

}
