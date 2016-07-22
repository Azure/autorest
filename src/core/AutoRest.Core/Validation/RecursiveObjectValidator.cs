// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using AutoRest.Core.Utilities.Collections;
using System;

namespace AutoRest.Core.Validation
{
    /// <summary>
    ///     A validator that traverses an object graph, applies validation rules, and logs validation messages
    /// </summary>
    public class RecursiveObjectValidator
    {
        private const string ROOT_PATH_INDICATOR = "#";

        private Func<PropertyInfo, string> resolver;

        /// <summary>
        /// Initializes the object validator. By default, it will use the property name when
        /// returning the location of messages
        /// </summary>
        public RecursiveObjectValidator() : this(PropertyNameResolver.PropertyName) { }

        /// <summary>
        /// Initializes the object validator with a custom <paramref name="resolver"/>
        /// that returns the name for a property when setting the location of messages
        /// </summary>
        /// <param name="resolver">A function that resolves the name of a property</param>
        public RecursiveObjectValidator(Func<PropertyInfo, string> resolver)
        {
            this.resolver = resolver;
        }

        /// <summary>
        /// Recursively validates <paramref name="entity"/> by traversing all of its properties
        /// </summary>
        /// <param name="entity">The object to validate</param>
        public IEnumerable<ValidationMessage> GetValidationExceptions(object entity)
        {
            return RecursiveValidate(entity, new RuleContext(entity), Enumerable.Empty<Rule>())
                .Select(m => m.AppendToPath(ROOT_PATH_INDICATOR));
        }

        /// <summary>
        /// Recursively validates <paramref name="entity"/> by traversing all of its properties
        /// </summary>
        /// <param name="entity">The object to validate</param>
        /// <param name="parentContext">The rule context of the object that <paramref name="entity"/> belongs to</param>
        /// <param name="rules">The set of rules from the parent object to apply to <paramref name="entity"/></param>
        /// <param name="traverseProperties">Whether or not to traverse this <paramref name="entity"/>'s properties</param>
        /// <returns></returns>
        private IEnumerable<ValidationMessage> RecursiveValidate(object entity, RuleContext parentContext, IEnumerable<Rule> rules, bool traverseProperties = true)
        {
            var messages = Enumerable.Empty<ValidationMessage>();
            if (entity == null)
            {
                return messages;
            }

            // Ensure that the rules can be re-enumerated without re-evaluating the enumeration.
            var collectionRules = rules.ReEnumerable();

            var list = entity as IList;
            var dictionary = entity as IDictionary;
            if (traverseProperties && list != null)
            {
                // Recursively validate each list item and add the 
                // item index to the location of each validation message
                var listMessages = list.SelectMany((item, index)
                    => RecursiveValidate(item, parentContext.CreateChild(item, index), collectionRules).Select(each
                        => each.AppendToPath($"[{index}]")));
                messages = messages.Concat(listMessages);
            }

            else if (traverseProperties && dictionary != null)
            {
                // Dictionaries that don't provide any type info cannot be traversed, since it result in infinite iteration
                var shouldTraverseEntries = dictionary.IsTraversableDictionary();

                // Recursively validate each dictionary entry and add the entry 
                // key to the location of each validation message
                var dictMessages = dictionary.SelectMany((key, value)
                    => RecursiveValidate(value, parentContext.CreateChild(value, (string)key), collectionRules, shouldTraverseEntries).Select(each
                        => each.AppendToPath((string)key)));
                messages = messages.Concat(dictMessages);
            }

            // If this is a class, validate its value and its properties.
            else if (traverseProperties && entity.GetType().IsClass && entity.GetType() != typeof(string))
            {
                // Validate each property of the object
                var propertyMessages = entity.GetValidatableProperties()
                    .SelectMany(p => ValidateProperty(p, p.GetValue(entity), parentContext));
                messages = messages.Concat(propertyMessages);
            }

            // Validate the value of the object itself
            var valueMessages = ValidateObjectValue(entity, collectionRules, parentContext);
            return messages.Concat(valueMessages);
        }

        /// <summary>
        /// Validates an object value 
        /// </summary>
        /// <param name="entity"></param>
        /// <param name="collectionRules"></param>
        /// <param name="parentContext"></param>
        /// <returns></returns>
        private IEnumerable<ValidationMessage> ValidateObjectValue(object entity,
            IEnumerable<Rule> collectionRules, RuleContext parentContext)
        {
            // Get any rules defined for the class of the entity
            var classRules = entity.GetType().GetValidationRules();

            // Combine the class rules with any rules that apply to the collection that the entity is part of
            classRules = collectionRules.Concat(classRules);

            // Apply each rule for the entity
            return classRules.SelectMany(rule => rule.GetValidationMessages(entity, parentContext));
        }

        private IEnumerable<ValidationMessage> ValidateProperty(PropertyInfo prop, object value, RuleContext parentContext)
        {
            // Uses the property name resolver to get the name to use in the path of messages
            var propName = resolver(prop);
            // Determine if anything about this property indicates that it shouldn't be traversed further 
            var shouldTraverseObject = prop.IsTraversableProperty();
            // Create the context that's available to rules that validate this value
            var ruleContext = parentContext.CreateChild(value, propName);

            // Get any rules defined on this property and any defined as applying to the collection
            var propertyRules = prop.GetValidationRules();
            var collectionRules = prop.GetValidationCollectionRules();

            // Validate the value of this property against any rules for it
            var propertyMessages = propertyRules.SelectMany(r => r.GetValidationMessages(value, ruleContext));

            // Recursively validate the property (e.g. its properties or any list/dictionary entries),
            // passing any rules that apply to this collection)
            var childrenMessages = RecursiveValidate(value, ruleContext, collectionRules, shouldTraverseObject);

            return propertyMessages.Concat(childrenMessages)
                .Select(e => e.AppendToPath(propName));
        }
    }
}