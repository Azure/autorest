// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using AutoRest.Core.Utilities;
using AutoRest.Core.Utilities.Collections;

namespace AutoRest.Core.Validation
{
    /// <summary>
    ///     A validator that traverses an object graph, applies validation rules, and logs validation messages
    /// </summary>
    public class RecursiveObjectValidator
    {
        public IEnumerable<ValidationMessage> GetValidationExceptions(object entity)
        {
            return RecursiveValidate(entity, Enumerable.Empty<Rule>());
        }

        private IEnumerable<ValidationMessage> RecursiveValidate(object entity, IEnumerable<Rule> rules)
        {
            if (entity == null)
            {
                return Enumerable.Empty<ValidationMessage>();
            }

            // ensure that the rules can be re-enumerated without re-evaluating the enumeration.
            var collectionRules = rules.ReEnumerable();

            var list = entity as IList;
            if (list != null)
            {
                // Recursively validate each list item and add the 
                // item index to the location of each validation message
                return list.SelectMany((item, index)
                    => RecursiveValidate(item, collectionRules).Select(each
                        => each.AppendToPath($"[{index}]")));
            }

            var dictionary = entity as IDictionary;
            if (dictionary != null)
            {
                if (!dictionary.IsValidatableDictionary())
                {
                    return Enumerable.Empty<ValidationMessage>();
                }

                // Recursively validate each dictionary entry and add the entry 
                // key to the location of each validation message
                return dictionary.SelectMany((key, value)
                    => RecursiveValidate(value, collectionRules).Select(each
                        => each.AppendToPath((string)key)));
            }

            // if this is a class, validate it's value and it's properties.
            if (entity.GetType().IsClass && entity.GetType() != typeof(string))
            {
                // return the messages for both this value and its properties.
                return ValidateObjectValue(entity, collectionRules).Concat(ValidateObjectProperties(entity));
            }

            // validate just the value.
            return ValidateObjectValue(entity, collectionRules);
        }

        private IEnumerable<ValidationMessage> ValidateObjectValue(object entity,
            IEnumerable<Rule> collectionRules)
        {
            // Get any rules defined for the class of the entity
            var classRules = entity.GetType().GetValidationRules();

            // Combine the class rules with any rules that apply to the collection that the entity is part of
            classRules = collectionRules.Concat(classRules);

            // Apply each rule for the entity
            return classRules.SelectMany(rule => rule.GetValidationMessages(entity));
        }

        private IEnumerable<ValidationMessage> ValidateObjectProperties(object entity)
        {
            // Go through each validatable property
            foreach (var prop in entity.GetValidatableProperties())
            {
                // Get the value of the property from the entity
                var value = prop.GetValue(entity);

                // Get any rules defined on this property and apply them to the property value
                var propertyRules = prop.GetValidationRules().ReEnumerable();

                // if the property has no defined rules, let's supply some defaults
                if (propertyRules.IsNullOrEmpty())
                {
                    propertyRules = DefaultRules.ReEnumerable();
                }

                // add universal property rules
                propertyRules = propertyRules.Concat(UniversalRules).ReEnumerable();

                foreach (var rule in propertyRules)
                {
                    foreach (var exception in rule.GetValidationMessages(value))
                    {
                        exception.Path.Add(prop.Name);
                        yield return exception;
                    }
                }

                // Recursively validate the value of the property (passing any rules to inherit)
                var inheritableRules = prop.GetValidationColletionRules().Concat(UniversalRules).ReEnumerable();
                foreach (var exception in RecursiveValidate(value, inheritableRules))
                {
                    exception.Path.Add(prop.Name);
                    yield return exception;
                }
            }
        }

        /// <summary>
        ///     The collection of default rules applies to all properties that do not define rules
        ///     These can impose global conditions on any property that has not been otherwise validated.
        /// </summary>
        /// <returns></returns>
        public static IEnumerable<Rule> DefaultRules = new[] { new MissingValidator() };

        /// <summary>
        ///     The collection of rules that apply to all properties regardless of other rules.
        /// </summary>
        public static IEnumerable<Rule> UniversalRules = new[] { new NoControlCharacters() };


    }
}