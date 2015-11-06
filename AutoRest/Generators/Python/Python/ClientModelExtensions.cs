// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using System.Text.RegularExpressions;
using System.Collections.Generic;
namespace Microsoft.Rest.Generator.Python.TemplateModels
{
    public static class ClientModelExtensions
    {
        /// <summary>
        /// The set contain the primary types which require datetime module
        /// </summary>
        public static HashSet<PrimaryType> PythonDatetimeModuleType = new HashSet<PrimaryType>() { PrimaryType.Date, PrimaryType.DateTime, PrimaryType.DateTimeRfc1123, PrimaryType.TimeSpan };

        /// <summary>
        /// Format the value of a sequence given the modeled element format.  Note that only sequences of strings are supported
        /// </summary>
        /// <param name="parameter">The parameter to format</param>
        /// <returns>A reference to the formatted parameter value</returns>
        public static string GetFormattedReferenceValue(this Parameter parameter)
        {
            if (parameter == null)
            {
                throw new ArgumentNullException("parameter");
            }

            SequenceType sequence = parameter.Type as SequenceType;
            if (sequence == null)
            {
                return parameter.Type.ToString(parameter.Name);
            }

            PrimaryType primaryType = sequence.ElementType as PrimaryType;
            EnumType enumType = sequence.ElementType as EnumType;
            if (enumType != null && enumType.ModelAsString)
            {
                primaryType = PrimaryType.String;
            }

            if (primaryType != PrimaryType.String)
            {
                throw new InvalidOperationException(
                    string.Format(CultureInfo.InvariantCulture,
                    "Cannot generate a formatted sequence from a " +
                                  "non-string array parameter {0}", parameter));
            }

            return string.Format(CultureInfo.InvariantCulture,
                "{0}.join('{1}')", parameter.Name, parameter.CollectionFormat.GetSeparator());
        }

        /// <summary>
        /// Return the separator associated with a given collectionFormat
        /// </summary>
        /// <param name="format">The collection format</param>
        /// <returns>The separator</returns>
        private static string GetSeparator(this CollectionFormat format)
        {
            switch (format)
            {
                case CollectionFormat.Csv:
                    return ",";
                case CollectionFormat.Pipes:
                    return "|";
                case CollectionFormat.Ssv:
                    return " ";
                case CollectionFormat.Tsv:
                    return "\t";
                default:
                    throw new NotSupportedException(string.Format(CultureInfo.InvariantCulture,
                        "Collection format {0} is not supported.", format));
            }
        }

        private static string NormalizeValueReference(this string valueReference)
        {
            Regex pattern = new Regex("['.\\[\\]]");
            return pattern.Replace(valueReference, "");
        }

        private static string GetBasePropertyFromUnflattenedProperty(this string property)
        {
            string result = null;
            if (property.Contains("]["))
            {
                result = property.Substring(0, property.IndexOf("][", StringComparison.OrdinalIgnoreCase) + 1);
            }
            
            return result;
        }

        /// <summary>
        /// Simple conversion of the type to string
        /// </summary>
        /// <param name="type">The type to convert</param>
        /// <param name="reference">a reference to an instance of the type</param>
        /// <returns></returns>
        public static string ToString(this IType type, string reference)
        {
            var known = type as PrimaryType;

            if (known == PrimaryType.Date)
            {
                return string.Format(CultureInfo.InvariantCulture,
                    "Serialized.serializeObject({0}, \'date\')", reference);
            }

            if (known == PrimaryType.DateTimeRfc1123)
            {
                return string.Format(CultureInfo.InvariantCulture,
                    "Serialized.serializeObject({0}, \'rfc-date\')", reference);
            }

            if (known == PrimaryType.DateTime)
            {
                return string.Format(CultureInfo.InvariantCulture,
                    "Serialized.serializeObject({0}, \'iso-date\')", reference);
            }

            if (known == PrimaryType.TimeSpan)
            {
                return string.Format(CultureInfo.InvariantCulture,
                    "Serialized.serializeObject({0}, \'duration\')", reference);
            }

            return reference;
        }

        /// <summary>
        /// Simple conversion of the type to string
        /// </summary>
        /// <param name="type">The type to convert</param>
        /// <returns></returns>
        public static string ToPythonRuntimeTypeString(this IType type)
        {
            var known = type as PrimaryType;

            if (known == PrimaryType.Date)
            {
                return "date";
            }

            if (known == PrimaryType.DateTimeRfc1123)
            {
                return "rfc-date";
            }

            if (known == PrimaryType.DateTime)
            {
                return "iso-date"; 
            }

            if (known == PrimaryType.TimeSpan)
            {
                return "duration";
            }

            if (type is SequenceType)
            {
                var sequenceType = type as SequenceType;
                return "[" + sequenceType.ElementType.ToPythonRuntimeTypeString() + "]";
            }

            if (type is DictionaryType)
            {
                var dictionaryType = type as DictionaryType;
                return "{{" + dictionaryType.ValueType.ToPythonRuntimeTypeString() + "}}";
            }

            return type.Name;
        }
        /// <summary>
        /// Returns a Javascript Array containing the values in a string enum type
        /// </summary>
        /// <param name="type">EnumType to model as Javascript Array</param>
        /// <returns>The Javascript Array as a string</returns>
        public static string GetEnumValuesArray(this EnumType type)
        {
            if (type == null)
            {
                throw new ArgumentNullException("type");
            }

            return string.Format(CultureInfo.InvariantCulture,
                "[ {0} ]", string.Join(", ",
                type.Values.Select(p => string.Format(CultureInfo.InvariantCulture, "'{0}'", p.Name))));
        }

        public static string EscapeSingleQuotes(this string valueReference)
        {
            if (valueReference == null)
            {
                throw new ArgumentNullException("valueReference");
            }

            return valueReference.Replace("'", "\\'");
        }

        private static IndentedStringBuilder ConstructValidationCheck(IndentedStringBuilder builder, string errorMessage, string valueReference, string typeName)
        {
            var escapedValueReference = valueReference.EscapeSingleQuotes();
            var lowercaseTypeName = typeName.ToLower(CultureInfo.InvariantCulture);

            return builder.Indent()
                            .AppendLine(errorMessage, escapedValueReference, lowercaseTypeName);
        }

        private static string ValidatePrimaryType(this PrimaryType primary, IScopeProvider scope, string valueReference, bool isRequired)
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            var builder = new IndentedStringBuilder("    ");
            var requiredTypeErrorMessage = "raise Exception('{0} cannot be null and it must be of type {1}.')";
            var typeErrorMessage = "raise Exception('{0} must be of type {1}.')";
            var lowercaseTypeName = primary.Name;
            if (primary == PrimaryType.Boolean ||
                primary == PrimaryType.Double ||
                primary == PrimaryType.Int ||
                primary == PrimaryType.Long ||
                primary == PrimaryType.String ||
                primary == PrimaryType.ByteArray ||
                primary == PrimaryType.DateTime ||
                primary == PrimaryType.Date ||
                primary == PrimaryType.DateTimeRfc1123 ||
                primary == PrimaryType.TimeSpan ||
                primary == PrimaryType.Decimal ||
                primary == PrimaryType.Object)
            {
                if (isRequired)
                {
                    builder.AppendLine("if {0} or isinstance({0}, {1}):", valueReference, lowercaseTypeName);
                    return ConstructValidationCheck(builder, requiredTypeErrorMessage, valueReference, primary.Name).ToString();
                }

                builder.AppendLine("if {0} and type({0}) is not {1}:", valueReference, lowercaseTypeName);
                return ConstructValidationCheck(builder, typeErrorMessage, valueReference, primary.Name).ToString();
            }
            else
            {
                throw new NotImplementedException(string.Format(CultureInfo.InvariantCulture,
                    "'{0}' not implemented", valueReference));
            }
        }

        private static string ValidateEnumType(this EnumType enumType, IScopeProvider scope, string valueReference, bool isRequired)
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            var builder = new IndentedStringBuilder("    ");
            var allowedValues = scope.GetVariableName("allowedValues");

            builder.AppendLine("if ({0}) {{", valueReference)
                        .Indent()
                            .AppendLine("var {0} = {1};", allowedValues, enumType.GetEnumValuesArray())
                            .AppendLine("if (!{0}.some( function(item) {{ return item === {1}; }})) {{", allowedValues, valueReference)
                            .Indent()
                                .AppendLine("throw new Error({0} + ' is not a valid value. The valid values are: ' + {1});", valueReference, allowedValues)
                            .Outdent()
                            .AppendLine("}")
                        .Outdent()
                        .AppendLine("}");
            if (isRequired)
            {
                builder.Append(" else {")
                    .Indent()
                        .AppendLine("throw new Error('{0} cannot be null or undefined.')", valueReference)
                    .Outdent()
                    .AppendLine("}");
            }

            return builder.ToString();
        }

        private static string ValidateCompositeType(IScopeProvider scope, string valueReference, bool isRequired)
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            var builder = new IndentedStringBuilder("    ");
            var escapedValueReference = valueReference.EscapeSingleQuotes();
            //Only validate whether the composite type is present, if it is required. Detailed validation happens in serialization.
            if (isRequired)
            {
                builder.AppendLine("if {0} is None:", valueReference)
                         .Indent()
                         .AppendLine("raise Exception('{0} cannot be null.')", escapedValueReference);
            }
            return builder.ToString();
        }

        private static string ValidateSequenceType(this SequenceType sequence, IScopeProvider scope, string valueReference, bool isRequired, string modelReference = "client._models")
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            var builder = new IndentedStringBuilder("    ");
            var escapedValueReference = valueReference.EscapeSingleQuotes();

            var indexVar = scope.GetVariableName("i");
            var innerValidation = sequence.ElementType.ValidateType(scope, valueReference + "[" + indexVar + "]", false, modelReference);
            if (!string.IsNullOrEmpty(innerValidation))
            {
                if (isRequired)
                {
                    return builder.AppendLine("if {0} is None or type({0}) is not list:", valueReference)
                        .Indent()
                          .AppendLine("raise Exception('{0} cannot be null and it must be of type {1}.')",
                          escapedValueReference, sequence.Name.ToLower(CultureInfo.InvariantCulture))
                        .Outdent()
                      .AppendLine("else:")
                        .Indent()
                        .AppendLine("for {1} in range(len({0})):", valueReference, indexVar)
                            .Indent()
                              .AppendLine(innerValidation).ToString();
                }

                return builder.AppendLine("if {0} is not None and type({0}) is list:", valueReference)
                        .Indent()
                        .AppendLine("for {1} in range(len({0})):", valueReference, indexVar)
                            .Indent()
                              .AppendLine(innerValidation).ToString();
            }

            return null;
        }

        private static string ValidateDictionaryType(this DictionaryType dictionary, IScopeProvider scope, string valueReference, bool isRequired, string modelReference = "client._models")
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            var builder = new IndentedStringBuilder("    ");
            var escapedValueReference = valueReference.EscapeSingleQuotes();
            var valueVar = scope.GetVariableName("valueElement");
            var innerValidation = dictionary.ValueType.ValidateType(scope, valueReference + "[" + valueVar + "]", false, modelReference);
            if (!string.IsNullOrEmpty(innerValidation))
            {
                if (isRequired)
                {
                    return builder.AppendLine("if ({0} === null || {0} === undefined || typeof {0} !== 'object') {{", valueReference)
                        .Indent()
                          .AppendLine("throw new Error('{0} cannot be null or undefined and it must be of type {1}.');",
                            escapedValueReference, dictionary.Name.ToLower(CultureInfo.InvariantCulture))
                        .Outdent()
                      .AppendLine("}")
                      .AppendLine("for(var {0} in {1}) {{", valueVar, valueReference)
                        .Indent()
                          .AppendLine(innerValidation)
                        .Outdent()
                      .AppendLine("}").ToString();
                }

                return builder.AppendLine("if ({0} && typeof {0} === 'object') {{", valueReference)
                        .Indent()
                          .AppendLine("for(var {0} in {1}) {{", valueVar, valueReference)
                            .Indent()
                              .AppendLine(innerValidation)
                            .Outdent()
                          .AppendLine("}")
                        .Outdent()
                      .AppendLine("}").ToString();
            }

            return null;
        }

        /// <summary>
        /// Generate code to perform validation on a parameter or property
        /// </summary>
        /// <param name="type">The type to validate</param>
        /// <param name="scope">A scope provider for generating variable names as necessary</param>
        /// <param name="valueReference">A reference to the value being validated</param>
        /// <param name="isRequired">True if the parameter is required.</param>
        /// <param name="modelReference">A reference to the models array</param>
        /// <returns>The code to validate the reference of the given type</returns>
        public static string ValidateType(this IType type, IScopeProvider scope, string valueReference, bool isRequired, string modelReference = "client._models")
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            CompositeType composite = type as CompositeType;
            SequenceType sequence = type as SequenceType;
            DictionaryType dictionary = type as DictionaryType;
            PrimaryType primary = type as PrimaryType;
            EnumType enumType = type as EnumType;
            if (primary != null)
            {
                return primary.ValidatePrimaryType(scope, valueReference, isRequired);
            }
            else if (enumType != null && enumType.Values.Any())
            {
                return enumType.ValidateEnumType(scope, valueReference, isRequired);
            }
            else if (composite != null && composite.Properties.Any())
            {
                return ValidateCompositeType(scope, valueReference, isRequired);
            }
            else if (sequence != null)
            {
                return sequence.ValidateSequenceType(scope, valueReference, isRequired, modelReference);
            }
            else if (dictionary != null)
            {
                return dictionary.ValidateDictionaryType(scope, valueReference, isRequired, modelReference);
            }

            return null;
        }

        private static string SerializePrimaryType(this PrimaryType primary, IScopeProvider scope, string objectReference, string valueReference, bool isRequired)
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            var builder = new IndentedStringBuilder("    ");
            var requiredTypeErrorMessage = "throw new Error('{0} cannot be null or undefined and it must be of type {1}.');";
            var typeErrorMessage = "throw new Error('{0} must be of type {1}.');";
            var typeName = primary.Name.ToLower(CultureInfo.InvariantCulture);

            if (primary == PrimaryType.Boolean ||
                primary == PrimaryType.Double ||
                primary == PrimaryType.Int ||
                primary == PrimaryType.Long ||
                primary == PrimaryType.Object)
            {
                if (isRequired)
                {
                    builder.AppendLine("if ({0} === null || {0} === undefined || typeof {0} !== '{1}') {{", 
                        objectReference, typeName);
                    builder = ConstructValidationCheck(builder, requiredTypeErrorMessage, objectReference, primary.Name);
                    builder = ConstructBasePropertyCheck(builder, valueReference);
                    return builder.AppendLine("{0} = {1};", valueReference, objectReference).ToString();
                }
                builder.AppendLine("if ({0} !== null && {0} !== undefined) {{", objectReference)
                         .Indent()
                         .AppendLine("if (typeof {0} !== '{1}') {{", objectReference, typeName);
                builder = ConstructValidationCheck(builder, typeErrorMessage, objectReference, primary.Name);
                builder = ConstructBasePropertyCheck(builder, valueReference);
                return builder.AppendLine("{0} = {1};", valueReference, objectReference)
                            .Outdent()
                            .AppendLine("}").ToString();
            }
            else if (primary == PrimaryType.String)
            {
                if (isRequired)
                {
                    //empty string can be a valid value hence we cannot implement the simple check if (!{0})
                    builder.AppendLine("if ({0} === null || {0} === undefined || typeof {0}.valueOf() !== '{1}') {{",
                        objectReference, typeName);
                    builder = ConstructValidationCheck(builder, requiredTypeErrorMessage, objectReference, primary.Name);
                    builder = ConstructBasePropertyCheck(builder, valueReference);
                    return builder.AppendLine("{0} = {1};", valueReference, objectReference).ToString();
                }
                builder.AppendLine("if ({0} !== null && {0} !== undefined) {{", objectReference)
                         .Indent()
                         .AppendLine("if (typeof {0}.valueOf() !== '{1}') {{", objectReference, typeName);
                builder = ConstructValidationCheck(builder, typeErrorMessage, objectReference, primary.Name);
                builder = ConstructBasePropertyCheck(builder, valueReference);
                return builder.AppendLine("{0} = {1};", valueReference, objectReference)
                            .Outdent()
                            .AppendLine("}").ToString();
            }
            else if (primary == PrimaryType.ByteArray)
            {
                if (isRequired)
                {
                    builder.AppendLine("if (!Buffer.isBuffer({0})) {{", objectReference);
                    builder = ConstructValidationCheck(builder, requiredTypeErrorMessage, objectReference, primary.Name);
                    builder = ConstructBasePropertyCheck(builder, valueReference);
                    return builder.AppendLine("{0} = {1}.toString('base64');", valueReference, objectReference).ToString();
                }
                builder.AppendLine("if ({0}) {{", objectReference)
                         .Indent()
                         .AppendLine("if (!Buffer.isBuffer({0})) {{", objectReference);
                builder = ConstructValidationCheck(builder, typeErrorMessage, objectReference, primary.Name);
                builder = ConstructBasePropertyCheck(builder, valueReference);
                return builder.AppendLine("{0} = {1}.toString('base64');", valueReference, objectReference)
                            .Outdent()
                            .AppendLine("}").ToString();
            }
            else if (primary == PrimaryType.Date)
            {
                if (isRequired)
                {
                    builder.AppendLine("if(!{0} || !({0} instanceof Date || (typeof {0}.valueOf() === 'string' && !isNaN(Date.parse({0}))))) {{", 
                        objectReference);
                    builder = ConstructValidationCheck(builder, requiredTypeErrorMessage, objectReference, primary.Name);
                    builder = ConstructBasePropertyCheck(builder, valueReference);
                    return builder.AppendLine("{0} = ({1} instanceof Date) ? {1}.toISOString().substring(0,10) : {1};", 
                        valueReference, objectReference).ToString();
                }

                builder.AppendLine("if ({0}) {{", objectReference)
                         .Indent()
                         .AppendLine("if (!({0} instanceof Date || typeof {0}.valueOf() === 'string' && !isNaN(Date.parse({0})))) {{", 
                         objectReference);
                builder = ConstructValidationCheck(builder, typeErrorMessage, objectReference, primary.Name);
                builder = ConstructBasePropertyCheck(builder, valueReference);
                return builder.AppendLine("{0} = ({1} instanceof Date) ? {1}.toISOString().substring(0,10) : {1};", valueReference, objectReference)
                                .Outdent()
                                .AppendLine("}").ToString();
            }
            else if (primary == PrimaryType.DateTime)
            {
                if (isRequired)
                {
                    builder.AppendLine("if(!{0} || !({0} instanceof Date || (typeof {0}.valueOf() === 'string' && !isNaN(Date.parse({0}))))) {{",
                        objectReference);
                    builder = ConstructValidationCheck(builder, requiredTypeErrorMessage, objectReference, primary.Name);
                    builder = ConstructBasePropertyCheck(builder, valueReference);
                    return builder.AppendLine("{0} = ({1} instanceof Date) ? {1}.toISOString() : {1};",
                        valueReference, objectReference).ToString();
                }

                builder.AppendLine("if ({0}) {{", objectReference)
                         .Indent()
                         .AppendLine("if (!({0} instanceof Date || typeof {0}.valueOf() === 'string' && !isNaN(Date.parse({0})))) {{",
                         objectReference);
                builder = ConstructValidationCheck(builder, typeErrorMessage, objectReference, primary.Name);
                builder = ConstructBasePropertyCheck(builder, valueReference);
                return builder.AppendLine("{0} = ({1} instanceof Date) ? {1}.toISOString() : {1};", valueReference, objectReference)
                                .Outdent()
                                .AppendLine("}").ToString();
            }
            else if (primary == PrimaryType.DateTimeRfc1123)
            {
                if (isRequired)
                {
                    builder.AppendLine("if(!{0} || !({0} instanceof Date || (typeof {0}.valueOf() === 'string' && !isNaN(Date.parse({0}))))) {{",
                        objectReference);
                    builder = ConstructValidationCheck(builder, requiredTypeErrorMessage, objectReference, primary.Name);
                    builder = ConstructBasePropertyCheck(builder, valueReference);
                    return builder.AppendLine("{0} = ({1} instanceof Date) ? {1}.toUTCString() : {1};",
                        valueReference, objectReference).ToString();
                }

                builder.AppendLine("if ({0}) {{", objectReference)
                         .Indent()
                         .AppendLine("if (!({0} instanceof Date || typeof {0}.valueOf() === 'string' && !isNaN(Date.parse({0})))) {{",
                         objectReference);
                builder = ConstructValidationCheck(builder, typeErrorMessage, objectReference, primary.Name);
                builder = ConstructBasePropertyCheck(builder, valueReference);
                return builder.AppendLine("{0} = ({1} instanceof Date) ? {1}.toUTCString() : {1};", valueReference, objectReference)
                                .Outdent()
                                .AppendLine("}").ToString();
            }
            else if (primary == PrimaryType.TimeSpan)
            {
                if (isRequired)
                {
                    builder.AppendLine("if(!{0} || !moment.isDuration({0})) {{", objectReference);
                    builder = ConstructValidationCheck(builder, requiredTypeErrorMessage, objectReference, primary.Name);
                    builder = ConstructBasePropertyCheck(builder, valueReference);
                    return builder.AppendLine("{0} = {1}.toISOString();", valueReference, objectReference).ToString();
                }

                builder.AppendLine("if ({0}) {{", objectReference)
                         .Indent()
                         .AppendLine("if (!moment.isDuration({0})) {{",
                         objectReference);
                builder = ConstructValidationCheck(builder, typeErrorMessage, objectReference, primary.Name);
                builder = ConstructBasePropertyCheck(builder, valueReference);
                return builder.AppendLine("{0} = {1}.toISOString();", valueReference, objectReference)
                                .Outdent()
                                .AppendLine("}").ToString();
            }
            else
            {
                throw new NotImplementedException(string.Format(CultureInfo.InvariantCulture,
                    "'{0}' not implemented", valueReference));
            }
        }

        private static IndentedStringBuilder ConstructBasePropertyCheck(IndentedStringBuilder builder, string valueReference)
        {
            string baseProperty = valueReference.GetBasePropertyFromUnflattenedProperty();
            if (baseProperty != null)
            {
                builder.AppendLine("if ({0} === null || {0} === undefined) {{", baseProperty)
                         .Indent()
                         .AppendLine("{0} = {{}};", baseProperty)
                       .Outdent()
                       .AppendLine("}");
            }

            return builder;
        }

        private static string SerializeEnumType(this EnumType enumType, IScopeProvider scope, string objectReference, string valueReference, bool isRequired)
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            var builder = new IndentedStringBuilder("    ");
            var allowedValues = scope.GetVariableName("allowedValues");
            string tempReference = objectReference;
            builder.AppendLine("if ({0} !== null && {0} !== undefined) {{", objectReference)
                        .Indent()
                        .AppendLine("var {0} = {1};", allowedValues, enumType.GetEnumValuesArray());
                        if (objectReference.IndexOfAny(new char[] { '.', '[', ']'}) >= 0)
                        {
                            tempReference = tempReference.NormalizeValueReference();
                            builder.AppendLine("var {0} = {1};", tempReference, objectReference);
                        }
                        builder.AppendLine("if (!{0}.some( function(item) {{ return item === {1}; }})) {{", allowedValues, tempReference)
                                    .Indent()
                                    .AppendLine("throw new Error({0} + ' is not a valid value. The valid values are: ' + {1});", objectReference, allowedValues)
                                .Outdent()
                                .AppendLine("}");
                        builder = ConstructBasePropertyCheck(builder, valueReference);
                        builder.AppendLine("{0} = {1};", valueReference, objectReference)
                              .Outdent()
                              .AppendLine("}");
            if (isRequired)
            {
                builder.Append(" else {")
                    .Indent()
                        .AppendLine("throw new Error('{0} cannot be null or undefined.');", objectReference)
                    .Outdent()
                    .AppendLine("}");
            }

            return builder.ToString();
        }

        private static string SerializeCompositeType(this CompositeType composite, IScopeProvider scope, string objectReference, 
            string valueReference, bool isRequired, string modelReference = "client._models")
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            var builder = new IndentedStringBuilder("    ");
            var escapedObjectReference = objectReference.EscapeSingleQuotes();

            builder.AppendLine("if ({0}) {{", objectReference).Indent();

            if (!string.IsNullOrEmpty(composite.PolymorphicDiscriminator))
            {
                builder.AppendLine("if({0}['{1}'] !== null && {0}['{1}'] !== undefined && {2}.discriminators[{0}['{1}']]) {{",
                                    objectReference,
                                    composite.PolymorphicDiscriminator, modelReference)
                    .Indent();
                builder = ConstructBasePropertyCheck(builder, valueReference);
                builder.AppendLine("{0} = {1}.serialize();", valueReference, objectReference)
                    .Outdent()
                    .AppendLine("}} else {{", valueReference)
                    .Indent()
                        .AppendLine("throw new Error('No discriminator field \"{0}\" was found in parameter \"{1}\".');",
                                    composite.PolymorphicDiscriminator,
                                    escapedObjectReference)
                    .Outdent()
                    .AppendLine("}");
            }
            else
            {
                builder = ConstructBasePropertyCheck(builder, valueReference);
                builder.AppendLine("{0} = {1}.serialize();", valueReference, objectReference);
            }
            builder.Outdent().AppendLine("}");

            if (isRequired)
            {
                builder.Append(" else {")
                    .Indent()
                        .AppendLine("throw new Error('{0} cannot be null or undefined.');", escapedObjectReference)
                    .Outdent()
                    .AppendLine("}");
            }
            return builder.ToString();
        }

        private static string SerializeSequenceType(this SequenceType sequence, IScopeProvider scope, string objectReference, 
            string valueReference, bool isRequired, string modelReference = "client._models")
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            var builder = new IndentedStringBuilder("    ");
            var escapedObjectReference = objectReference.EscapeSingleQuotes();

            var indexVar = scope.GetVariableName("i");
            var innerSerialization = sequence.ElementType.SerializeType(scope, objectReference + "[" + indexVar + "]", valueReference + "[" + indexVar + "]", false, modelReference);
            if (!string.IsNullOrEmpty(innerSerialization))
            {
                if (isRequired)
                {
                    return builder.AppendLine("if (!util.isArray({0})) {{", objectReference)
                        .Indent()
                          .AppendLine("throw new Error('{0} cannot be null or undefined and it must be of type {1}.');",
                          escapedObjectReference, sequence.Name.ToLower(CultureInfo.InvariantCulture))
                        .Outdent()
                      .AppendLine("}")
                      .AppendLine("{0} = [];", valueReference)
                      .AppendLine("for (var {1} = 0; {1} < {0}.length; {1}++) {{", objectReference, indexVar)
                            .Indent()
                              .AppendLine(innerSerialization)
                            .Outdent()
                          .AppendLine("}").ToString();
                }

                return builder.AppendLine("if (util.isArray({0})) {{", objectReference)
                        .Indent()
                          .AppendLine("{0} = [];", valueReference)
                          .AppendLine("for (var {1} = 0; {1} < {0}.length; {1}++) {{", objectReference, indexVar)
                            .Indent()
                              .AppendLine(innerSerialization)
                            .Outdent()
                          .AppendLine("}")
                        .Outdent()
                      .AppendLine("}").ToString();
            }

            return null;
        }

        private static string SerializeDictionaryType(this DictionaryType dictionary, IScopeProvider scope, string objectReference, string valueReference, 
            bool isRequired, string modelReference = "client._models")
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            var builder = new IndentedStringBuilder("    ");
            var escapedObjectReference = objectReference.EscapeSingleQuotes();
            var valueVar = scope.GetVariableName("valueElement");
            var innerSerialization = dictionary.ValueType.SerializeType(scope, objectReference + "[" + valueVar + "]", valueReference + "[" + valueVar + "]", false, modelReference);
            if (!string.IsNullOrEmpty(innerSerialization))
            {
                if (isRequired)
                {
                    return builder.AppendLine("if ({0} === null || {0} === undefined || typeof {0} !== 'object') {{", objectReference)
                        .Indent()
                          .AppendLine("throw new Error('{0} cannot be null or undefined and it must be of type {1}.');",
                            escapedObjectReference, dictionary.Name.ToLower(CultureInfo.InvariantCulture))
                        .Outdent()
                      .AppendLine("}")
                      .AppendLine("{0} = {{}};", valueReference)
                      .AppendLine("for(var {0} in {1}) {{", valueVar, objectReference)
                        .Indent()
                          .AppendLine(innerSerialization)
                        .Outdent()
                      .AppendLine("}").ToString();
                }

                return builder.AppendLine("if ({0} && typeof {0} === 'object') {{", objectReference)
                        .Indent()
                          .AppendLine("{0} = {{}};", valueReference)
                          .AppendLine("for(var {0} in {1}) {{", valueVar, objectReference)
                            .Indent()
                              .AppendLine(innerSerialization)
                              .AppendLine("else {")
                                .Indent()
                                .AppendLine("{0} = {1};", valueReference + "[" + valueVar + "]", objectReference + "[" + valueVar + "]")
                              .Outdent()
                              .AppendLine("}")
                            .Outdent()
                          .AppendLine("}")
                        .Outdent()
                      .AppendLine("}").ToString();
            }

            return null;
        }

        /// <summary>
        /// Generate code to perform serialization on a parameter or property
        /// </summary>
        /// <param name="type">The type to validate</param>
        /// <param name="scope">A scope provider for generating variable names as necessary</param>
        /// <param name="objectReference">A reference to the object being serialized</param>
        /// <param name="valueReference">A reference to the value that will be assigned the serialized object</param>
        /// <param name="isRequired">True if the parameter or property is required.</param>
        /// <param name="modelReference">A reference to the models</param>
        /// <returns>The code to serialize the given type</returns>
        public static string SerializeType(this IType type, IScopeProvider scope, string objectReference, string valueReference, bool isRequired, string modelReference = "client._models")
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            CompositeType composite = type as CompositeType;
            SequenceType sequence = type as SequenceType;
            DictionaryType dictionary = type as DictionaryType;
            PrimaryType primary = type as PrimaryType;
            EnumType enumType = type as EnumType;
            if (primary != null)
            {
                return primary.SerializePrimaryType(scope, objectReference, valueReference, isRequired);
            }
            else if (enumType != null && enumType.Values.Any())
            {
                return enumType.SerializeEnumType(scope, objectReference, valueReference, isRequired);
            }
            else if (composite != null && composite.Properties.Any())
            {
                return composite.SerializeCompositeType(scope, objectReference, valueReference, isRequired, modelReference);
            }
            else if (sequence != null)
            {
                return sequence.SerializeSequenceType(scope, objectReference, valueReference, isRequired, modelReference);
            }
            else if (dictionary != null)
            {
                return dictionary.SerializeDictionaryType(scope, objectReference, valueReference, isRequired, modelReference);
            }

            return null;
        }

        /// <summary>
        /// Generate code to perform deserialization on a parameter or property
        /// </summary>
        /// <param name="type">The type to deserialize</param>
        /// <param name="scope">A scope provider for generating variable names as necessary</param>
        /// <param name="objectReference">A reference to the object that will be assigned the deserialized value</param>
        /// <param name="valueReference">A reference to the value being deserialized</param>
        /// <param name="modelReference">A reference to the models</param>
        /// <returns>The code to deserialize the given type</returns>
        public static string DeserializeType(this IType type, IScopeProvider scope, string objectReference, string valueReference, string modelReference = "self._models")
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            EnumType enumType = type as EnumType;
            CompositeType composite = type as CompositeType;
            SequenceType sequence = type as SequenceType;
            DictionaryType dictionary = type as DictionaryType;
            PrimaryType primary = type as PrimaryType;
            var builder = new IndentedStringBuilder("    ");
            string baseProperty = valueReference.GetBasePropertyFromUnflattenedProperty();
            if (baseProperty != null)
            {
                builder.AppendLine("if ({0} !== null && {0} !== undefined) {{", baseProperty).Indent();
            }
            if (enumType != null)
            {
                builder = ProcessBasicType(objectReference, valueReference, builder);
            }
            else if (primary != null)
            {
                if (primary == PrimaryType.ByteArray)
                {
                    builder.AppendLine("if ({0}) {{", valueReference)
                             .Indent()
                             .AppendLine("{1} = new Buffer({0}, 'base64');", valueReference, objectReference)
                           .Outdent().AppendLine("}")
                           .AppendLine("else if ({0} !== undefined) {{", valueReference)
                             .Indent()
                             .AppendLine("{1} = {0};", valueReference, objectReference)
                           .Outdent()
                           .AppendLine("}");
                }
                else if (primary == PrimaryType.DateTime || primary == PrimaryType.Date || primary == PrimaryType.DateTimeRfc1123)
                {
                    builder.AppendLine("if ({0}) {{", valueReference)
                             .Indent()
                             .AppendLine("{1} = new Date({0});", valueReference, objectReference)
                           .Outdent()
                           .AppendLine("}")
                           .AppendLine("else if ({0} !== undefined) {{", valueReference)
                             .Indent()
                             .AppendLine("{1} = {0};", valueReference, objectReference)
                           .Outdent()
                           .AppendLine("}");
                }
                else if (primary == PrimaryType.TimeSpan)
                {
                    builder.AppendLine("if ({0}) {{", valueReference)
                             .Indent()
                             .AppendLine("{1} = moment.duration({0});", valueReference, objectReference)
                           .Outdent()
                           .AppendLine("}")
                           .AppendLine("else if ({0} !== undefined) {{", valueReference)
                             .Indent()
                             .AppendLine("{1} = {0};", valueReference, objectReference)
                           .Outdent()
                           .AppendLine("}");
                }
                else
                {
                    builder.AppendLine("if ({0} !== undefined) {{", valueReference)
                             .Indent()
                             .AppendLine("{1} = {0};", valueReference, objectReference)
                           .Outdent()
                           .AppendLine("}");
                }
            }
            else if (composite != null && composite.Properties.Any())
            {
                builder = composite.ProcessCompositeType(objectReference, valueReference, modelReference, builder, "DeserializeType");
            }
            else if (sequence != null)
            {
                builder = sequence.ProcessSequenceType(scope, objectReference, valueReference, modelReference, builder, "DeserializeType");
            }
            else if (dictionary != null)
            {
                builder = dictionary.ProcessDictionaryType(scope, objectReference, valueReference, modelReference, builder, "DeserializeType");
            }

            if (baseProperty != null)
            {
                builder.Outdent().AppendLine("}");
            }

            return builder.ToString();
        }

        public static string NullInitializeType(this IType type, IScopeProvider scope, string objectReference, string modelReference = "models")
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            SequenceType sequence = type as SequenceType;
            DictionaryType dictionary = type as DictionaryType;
            string nullValue = "None";
            if (sequence != null)
            {
                nullValue = "[]";
            }
            else if (dictionary != null)
            {
                nullValue = "{}";
            }

            return string.Format(CultureInfo.InvariantCulture, "{0} = {1}", objectReference, nullValue);
        }

        public static string InitializeType(this IType type, IScopeProvider scope, string objectReference, string valueReference, string modelReference = "models")
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            EnumType enumType = type as EnumType;
            CompositeType composite = type as CompositeType;
            SequenceType sequence = type as SequenceType;
            DictionaryType dictionary = type as DictionaryType;
            PrimaryType primary = type as PrimaryType;
            var builder = new IndentedStringBuilder("    ");
            if (enumType != null || primary != null)
            {
                builder = ProcessBasicType(objectReference, valueReference, builder);
            }
            else if (composite != null && composite.Properties.Any())
            {
                builder = composite.ProcessCompositeType(objectReference, valueReference, modelReference, builder, "InitializeType");
            }
            else if (sequence != null)
            {
                builder = sequence.ProcessSequenceType(scope, objectReference, valueReference, modelReference, builder, "InitializeType");
            }
            else if (dictionary != null)
            {
                builder = dictionary.ProcessDictionaryType(scope, objectReference, valueReference, modelReference, builder, "InitializeType");
            }

            return builder.ToString();
        }


        public static string InitializeSerializationType(this IType type, IScopeProvider scope, string objectReference, string valueReference, string modelReference = "models")
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            CompositeType composite = type as CompositeType;
            SequenceType sequence = type as SequenceType;
            DictionaryType dictionary = type as DictionaryType;
            var builder = new IndentedStringBuilder("    ");
            if (composite != null && composite.Properties.Any())
            {
                builder = composite.ProcessCompositeType(objectReference, valueReference, modelReference, builder, "InitializeSerializationType");
            }
            else if (sequence != null)
            {
                builder = sequence.ProcessSequenceType(scope, objectReference, valueReference, modelReference, builder, "InitializeSerializationType");
            }
            else if (dictionary != null)
            {
                builder = dictionary.ProcessDictionaryType(scope, objectReference, valueReference, modelReference, builder, "InitializeSerializationType");
            }

            return builder.ToString();
        }

        private static IndentedStringBuilder ProcessBasicType(string objectReference, string valueReference, IndentedStringBuilder builder)
        {
            return builder.AppendLine("if ({0} !== undefined) {{", valueReference)
                            .Indent()
                            .AppendLine("{0} = {1};", objectReference, valueReference)
                          .Outdent()
                          .AppendLine("}");
        }

        private static IndentedStringBuilder ProcessCompositeType(this CompositeType composite, string objectReference,
            string valueReference, string modelReference, IndentedStringBuilder builder, string processType)
        {
            builder.AppendLine("if ({0}) {{", valueReference).Indent();
            string discriminator = "{3} = new {2}.discriminators[{0}['{1}']]({0});";
            string objectCreation = "{3} = new {2}['{1}']({0});";

            if (processType == "DeserializeType")
            {
                discriminator = "{3} = new {2}.discriminators[{0}['{1}']]().deserialize({0});";
                objectCreation = "{3} = new {2}['{1}']().deserialize({0});";
            }

            if (!string.IsNullOrEmpty(composite.PolymorphicDiscriminator))
            {
                builder.AppendLine(discriminator, valueReference, composite.PolymorphicDiscriminator, modelReference, objectReference);
            }
            else
            {
                builder.AppendLine(objectCreation, valueReference, composite.Name, modelReference, objectReference);
            }
            builder.Outdent().AppendLine("}");

            return builder;
        }

        private static IndentedStringBuilder ProcessSequenceType(this SequenceType sequence, IScopeProvider scope, string objectReference, 
            string valueReference, string modelReference, IndentedStringBuilder builder, string processType)
        {
            var elementVar = scope.GetVariableName("element");
            string innerInitialization = null;
            if (processType == null)
            {
                throw new ArgumentNullException("processType");
            }

            if (processType == "InitializeType")
            {
                innerInitialization = sequence.ElementType.InitializeType(scope, elementVar, elementVar, modelReference);
            }
            else if (processType == "DeserializeType")
            {
                innerInitialization = sequence.ElementType.DeserializeType(scope, elementVar, elementVar, modelReference);
            }
            else if (processType == "InitializeSerializationType")
            {
                innerInitialization = sequence.ElementType.InitializeSerializationType(scope, elementVar, elementVar, modelReference);
            }

            if (!string.IsNullOrEmpty(innerInitialization))
            {
                var arrayName = valueReference.ToPascalCase().NormalizeValueReference();
                builder.AppendLine("if ({0}) {{", valueReference)
                         .Indent()
                         .AppendLine("var temp{0} = [];", arrayName)
                         .AppendLine("{0}.forEach(function({1}) {{", valueReference, elementVar)
                           .Indent()
                             .AppendLine(innerInitialization)
                             .AppendLine("temp{0}.push({1});", arrayName, elementVar)
                           .Outdent()
                           .AppendLine("});")
                           .AppendLine("{0} = temp{1};", objectReference, arrayName)
                         .Outdent()
                         .AppendLine("}");
            }

            return builder;
        }

        private static IndentedStringBuilder ProcessDictionaryType(this DictionaryType dictionary, IScopeProvider scope, string objectReference, 
            string valueReference, string modelReference, IndentedStringBuilder builder, string processType)
        {
            var valueVar = scope.GetVariableName("valueElement");
            string innerInitialization = null;
            if (processType == null)
            {
                throw new ArgumentNullException("processType");
            }

            string elementObjectReference = objectReference + "[" + valueVar + "]";
            string elementValueReference = valueReference + "[" + valueVar + "]";

            if (processType == "InitializeType")
            {
                innerInitialization = dictionary.ValueType.InitializeType(scope, elementObjectReference, elementValueReference, modelReference);
            }
            else if (processType == "DeserializeType")
            {
                innerInitialization = dictionary.ValueType.DeserializeType(scope, elementObjectReference, elementValueReference, modelReference);
            }
            else if (processType == "InitializeSerializationType")
            {
                innerInitialization = dictionary.ValueType.InitializeSerializationType(scope, elementObjectReference, elementValueReference, modelReference);
            }

            if (!string.IsNullOrEmpty(innerInitialization))
            {
                builder.AppendLine("if ({0}) {{", valueReference).Indent();
                if (processType == "DeserializeType" || processType == "InitializeType")
                {
                    builder.AppendLine("{0} = {{}};", objectReference);
                }
                         
                builder.AppendLine("for(var {0} in {1}) {{", valueVar, valueReference)
                         .Indent()
                         .AppendLine(innerInitialization)
                       .Outdent()
                       .AppendLine("}")
                     .Outdent()
                     .AppendLine("}");
            }

            return builder;
        }

        /// <summary>
        /// Determine whether URL encoding should be skipped for this parameter
        /// </summary>
        /// <param name="parameter">The parameter to check</param>
        /// <returns>true if url encoding should be skipped for the parameter, otherwise false</returns>
        public static bool SkipUrlEncoding(this Parameter parameter)
        {
            if (parameter == null)
            {
                return false;
            }

            return parameter.Extensions.ContainsKey(CodeGenerator.SkipUrlEncodingExtension) &&
                   (bool)parameter.Extensions[CodeGenerator.SkipUrlEncodingExtension];
        }

        public static bool ContainsDecimal(this CompositeType type)
        {
            if (type == null)
            {
                throw new ArgumentNullException("type");
            }

            Property prop = type.Properties.FirstOrDefault(p =>
                p.Type == PrimaryType.Decimal ||
                (p.Type is SequenceType && (p.Type as SequenceType).ElementType == PrimaryType.Decimal) ||
                (p.Type is DictionaryType && (p.Type as DictionaryType).ValueType == PrimaryType.Decimal));

            return prop != null;
        }

        public static bool ContainsDatetime(this CompositeType type)
        {
            if (type == null)
            {
                throw new ArgumentNullException("type");
            }

            Property prop = type.Properties.FirstOrDefault(p =>
                PythonDatetimeModuleType.Contains(p.Type) ||
                (p.Type is SequenceType && PythonDatetimeModuleType.Contains((p.Type as SequenceType).ElementType)) ||
                (p.Type is DictionaryType && PythonDatetimeModuleType.Contains((p.Type as DictionaryType).ValueType)));

            return prop != null;
        }
    }
}
