using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using AutoRest.Core.Utilities.Collections;
using Newtonsoft.Json;
using AutoRest.Core.Utilities;

namespace AutoRest.Core.Validation
{
    internal static class RulesExtensions
    {
        private static readonly Type JsonExtensionDataType = typeof(JsonExtensionDataAttribute);

        /// <summary>
        /// Gets an enumerable of properties for <paramref name="entity" /> that can be validated
        /// </summary>
        /// <param name="entity">The object to get properties for</param>
        /// <returns></returns>
        internal static IEnumerable<PropertyInfo> GetValidatableProperties(this object entity)
            => entity.GetType().GetProperties(BindingFlags.FlattenHierarchy | BindingFlags.Public | BindingFlags.Instance)
                ?? Enumerable.Empty<PropertyInfo>();

        /// <summary>
        /// Properties of type object can cause infinite iteration if recursively traversed
        /// </summary>
        /// <param name="prop"></param>
        /// <returns></returns>
        internal static bool IsTraversableProperty(this PropertyInfo prop) => prop.PropertyType != typeof(object);

        /// <summary>
        /// Determines if a dictionary's elements should be recursively traversed
        /// Dictionaries where there isn't type information for the value type should not be
        /// traversed, since there isn't enough information to prevent infinite traversal
        /// </summary>
        /// <param name="entity">The object to check</param>
        /// <returns></returns>
        internal static bool IsTraversableDictionary(this object entity)
        {
            if (entity == null)
            {
                return false;
            }
            // Dictionaries of type <string, object> cannot be traversed, because the object could be infinitely deep.
            // We only want to validate objects that have strong typing for the value type
            var dictType = entity.GetType();
            return dictType.IsGenericType &&
                   dictType.GenericTypeArguments.Count() >= 2 &&
                   dictType.GenericTypeArguments[1] != typeof(object);
        }

        public static IEnumerable<Rule> GetValidationRules(this PropertyInfo property)
        {
            var propertyRules = property.GetCustomAttributes<RuleAttribute>(true).Select(each => each.Rule).ReEnumerable();
            if (propertyRules.IsNullOrEmpty())
            {
                propertyRules = DefaultRules.ReEnumerable();
            }
            return propertyRules.Concat(UniversalRules).ReEnumerable();
        }

        public static IEnumerable<Rule> GetValidationCollectionRules(this PropertyInfo property)
        {
            var collectionRules = property.GetCustomAttributes<CollectionRuleAttribute>(true).Select(each => each.Rule).ReEnumerable();
            return collectionRules.Concat(UniversalRules).ReEnumerable();
        }

        public static IEnumerable<Rule> GetValidationRules(this Type type)
            => type.GetCustomAttributes<RuleAttribute>(true).Select(each => each.Rule).ReEnumerable();

        /// <summary>
        /// The collection of default rules applies to all properties that do not define rules
        /// These can impose global conditions on any property that has not been otherwise validated.
        /// </summary>
        /// <returns></returns>
        public static IEnumerable<Rule> DefaultRules = new[] { new MissingValidator() };

        /// <summary>
        /// The collection of rules that apply to all properties regardless of other rules.
        /// </summary>
        public static IEnumerable<Rule> UniversalRules = new[] { new NoControlCharacters() };
    }
}