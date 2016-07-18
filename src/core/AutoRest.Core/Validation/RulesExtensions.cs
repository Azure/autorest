using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using AutoRest.Core.Utilities.Collections;
using Newtonsoft.Json;

namespace AutoRest.Core.Validation
{
    internal static class RulesExtensions
    {
        private static readonly Type JsonExtensionDataType = typeof(JsonExtensionDataAttribute);

        /// <summary>
        ///     Gets an enumerable of properties for <paramref name="entity" /> that can be validated
        /// </summary>
        /// <param name="entity">The object to get properties for</param>
        /// <returns></returns>
        internal static IEnumerable<PropertyInfo> GetValidatableProperties(this object entity)
        {
            if (entity == null)
            {
                return Enumerable.Empty<PropertyInfo>();
            }
            return entity.GetType()
                .GetProperties(BindingFlags.FlattenHierarchy | BindingFlags.Public | BindingFlags.Instance)
                .Where(prop => !Attribute.IsDefined(prop, JsonExtensionDataType))
                .Where(prop => prop.PropertyType != typeof(object));
        }

        /// <summary>
        ///     Determines if a dictionary can be validated by running rules
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

        public static IEnumerable<Rule> GetValidationRules(this PropertyInfo property)
        {
            return property.GetCustomAttributes<RuleAttribute>(true).Select(each => each.Rule).ReEnumerable();
        }

        public static IEnumerable<Rule> GetValidationColletionRules(this PropertyInfo property)
        {
            return property.GetCustomAttributes<CollectionRuleAttribute>(true).Select(each => each.Rule).ReEnumerable();
        }
        public static IEnumerable<Rule> GetValidationRules(this Type type)
        {
            return type.GetCustomAttributes<RuleAttribute>(true).Select(each => each.Rule).ReEnumerable();
        }
       
    }
}