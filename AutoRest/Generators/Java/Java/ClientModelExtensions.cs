// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Microsoft.Rest.Generator.Java.TemplateModels
{
    public static class ClientModelExtensions
    {
        public static bool NeedsSpecialSerialization(this IType type)
        {
            var known = type as PrimaryType;
            return (known != null && (known.Name == "LocalDate" || known.Name == "DateTime" || known == PrimaryType.ByteArray)) ||
                type is EnumType || type is CompositeType || type is SequenceType || type is DictionaryType;
        }

        /// <summary>
        /// Simple conversion of the type to string
        /// </summary>
        /// <param name="parameter">The parameter to convert</param>
        /// <param name="reference">a reference to an instance of the type</param>
        /// <returns></returns>
        public static string ToString(this Parameter parameter, string reference)
        {
            if (parameter == null)
            {
                return null;
            }
            var type = parameter.Type;
            var known = type as PrimaryType;
            var sequence = type as SequenceType;
            if (known != null && known.Name != "LocalDate" && known.Name != "DateTime")
            {
                if (known == PrimaryType.ByteArray)
                {
                    return "Base64.encodeBase64String(" + reference + ")";
                }
                else
                {
                    return reference;
                }
            }
            else if (sequence != null)
            {
                return "JacksonConverterBuilder.serializeList(" + reference + 
                    ", CollectionFormat." + parameter.CollectionFormat.ToString().ToUpper(CultureInfo.InvariantCulture) + ")";
            }
            else
            {
                return "JacksonConverterBuilder.serializeRaw(" + reference + ")";
            }
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

        private static string ConstructValidationCheck(string condition, string errorMessage, string valueReference, string typeName)
        {
            var builder = new IndentedStringBuilder("  ");
            var escapedValueReference = valueReference.EscapeSingleQuotes();
            var lowercaseTypeName = typeName.ToLower(CultureInfo.InvariantCulture);

            return builder.AppendLine(condition, valueReference, lowercaseTypeName)
                            .Indent()
                                .AppendLine(errorMessage, escapedValueReference, lowercaseTypeName)
                            .Outdent()
                          .AppendLine("}").ToString();
        }

        private static string ValidatePrimaryType(this PrimaryType primary, IScopeProvider scope, string valueReference, bool isRequired)
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            var builder = new IndentedStringBuilder("  ");
            var conditionBuilder = new IndentedStringBuilder("  ");
            var requiredTypeErrorMessage = "throw new Error('{0} cannot be null or undefined and it must be of type {1}.');";
            var typeErrorMessage = "throw new Error('{0} must be of type {1}.');";

            if (primary == PrimaryType.Boolean ||
                primary == PrimaryType.Double ||
                primary == PrimaryType.Int ||
                primary == PrimaryType.Long)
            {
                if (isRequired)
                {
                    return ConstructValidationCheck("if ({0} === null || {0} === undefined || typeof {0} !== '{1}') {{",
                                                    requiredTypeErrorMessage, valueReference, primary.Name);
                }

                return ConstructValidationCheck("if ({0} !== null && {0} !== undefined && typeof {0} !== '{1}') {{",
                                                typeErrorMessage, valueReference, primary.Name);
            }
            else if (primary == PrimaryType.String)
            {
                if (isRequired)
                {
                    //empty string can be a valid value hence we cannot implement the simple check if (!{0})
                    return ConstructValidationCheck("if ({0} === null || {0} === undefined || typeof {0}.valueOf() !== '{1}') {{",
                                                    requiredTypeErrorMessage, valueReference, primary.Name);
                }

                return ConstructValidationCheck("if ({0} !== null && {0} !== undefined && typeof {0}.valueOf() !== '{1}') {{",
                                                typeErrorMessage, valueReference, primary.Name);
            }
            else if (primary == PrimaryType.ByteArray)
            {
                if (isRequired)
                {
                    return ConstructValidationCheck("if (!Buffer.isBuffer({0})) {{", requiredTypeErrorMessage, valueReference, primary.Name);
                }

                return ConstructValidationCheck("if ({0} && !Buffer.isBuffer({0})) {{", typeErrorMessage, valueReference, primary.Name);
            }
            else if (primary == PrimaryType.DateTime || primary == PrimaryType.Date)
            {
                string condition = "";
                if (isRequired)
                {
                    condition = conditionBuilder.AppendLine("if(!{0} || !({0} instanceof Date || ")
                                                  .Indent()
                                                  .Indent()
                                                  .AppendLine("(typeof {0}.valueOf() === 'string' && !isNaN(Date.parse({0}))))) {{").ToString();
                    return ConstructValidationCheck(condition, requiredTypeErrorMessage, valueReference, primary.Name);
                }

                condition = conditionBuilder.AppendLine("if ({0} && !({0} instanceof Date || ")
                                              .Indent()
                                              .Indent()
                                              .AppendLine("(typeof {0}.valueOf() === 'string' && !isNaN(Date.parse({0}))))) {{").ToString();
                return ConstructValidationCheck(condition, typeErrorMessage, valueReference, primary.Name);
            }
            else if (primary == PrimaryType.Object)
            {
                if (isRequired)
                {
                    return ConstructValidationCheck("if ({0} !== null || {0} !== undefined || typeof {0} !== '{1}') {{",
                                                    requiredTypeErrorMessage, valueReference, primary.Name);
                }

                return builder.ToString();
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

            var builder = new IndentedStringBuilder("  ");
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
                        .AppendLine("throw new Error('{0} cannot be null or undefined.');", valueReference)
                    .Outdent()
                    .AppendLine("}");
            }

            return builder.ToString();
        }

        private static string ValidateCompositeType(this CompositeType composite, IScopeProvider scope, string valueReference, bool isRequired, string modelReference = "client._models")
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            var builder = new IndentedStringBuilder("  ");
            var escapedValueReference = valueReference.EscapeSingleQuotes();

            builder.AppendLine("if ({0}) {{", valueReference).Indent();

            if (!string.IsNullOrEmpty(composite.PolymorphicDiscriminator))
            {
                builder.AppendLine("if({0}['{1}'] !== null && {0}['{1}'] !== undefined && {2}.discriminators[{0}['{1}']]) {{",
                                    valueReference,
                                    composite.PolymorphicDiscriminator, modelReference)
                    .Indent()
                        .AppendLine("{2}.discriminators[{0}['{1}']].validate({0});",
                            valueReference,
                            composite.PolymorphicDiscriminator, modelReference)
                    .Outdent()
                    .AppendLine("}} else {{", valueReference)
                    .Indent()
                        .AppendLine("throw new Error('No discriminator field \"{0}\" was found in parameter \"{1}\".');",
                                    composite.PolymorphicDiscriminator,
                                    escapedValueReference)
                    .Outdent()
                    .AppendLine("}");
            }
            else
            {
                builder.AppendLine("{2}['{0}'].validate({1});", composite.Name, valueReference, modelReference);
            }
            builder.Outdent().AppendLine("}");

            if (isRequired)
            {
                builder.Append(" else {")
                    .Indent()
                        .AppendLine("throw new Error('{0} cannot be null or undefined.');", escapedValueReference)
                    .Outdent()
                    .AppendLine("}");
            }
            return builder.ToString();
        }

        private static string ValidateSequenceType(this SequenceType sequence, IScopeProvider scope, string valueReference, bool isRequired, string modelReference = "client._models")
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            var builder = new IndentedStringBuilder("  ");
            var escapedValueReference = valueReference.EscapeSingleQuotes();

            var indexVar = scope.GetVariableName("i");
            var innerValidation = sequence.ElementType.ValidateType(scope, valueReference + "[" + indexVar + "]", false, modelReference);
            if (!string.IsNullOrEmpty(innerValidation))
            {
                if (isRequired)
                {
                    return builder.AppendLine("if (!util.isArray({0})) {{", valueReference)
                        .Indent()
                          .AppendLine("throw new Error('{0} cannot be null or undefined and it must be of type {1}.');",
                          escapedValueReference, sequence.Name.ToLower(CultureInfo.InvariantCulture))
                        .Outdent()
                      .AppendLine("}")
                      .AppendLine("for (var {1} = 0; {1} < {0}.length; {1}++) {{", valueReference, indexVar)
                            .Indent()
                              .AppendLine(innerValidation)
                            .Outdent()
                          .AppendLine("}").ToString();
                }

                return builder.AppendLine("if (util.isArray({0})) {{", valueReference)
                        .Indent()
                          .AppendLine("for (var {1} = 0; {1} < {0}.length; {1}++) {{", valueReference, indexVar)
                            .Indent()
                              .AppendLine(innerValidation)
                            .Outdent()
                          .AppendLine("}")
                        .Outdent()
                      .AppendLine("}").ToString();
            }

            return null;
        }

        private static string ValidateDictionaryType(this DictionaryType dictionary, IScopeProvider scope, string valueReference, bool isRequired, string modelReference = "client._models")
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            var builder = new IndentedStringBuilder("  ");
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
                return composite.ValidateCompositeType(scope, valueReference, isRequired, modelReference);
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

        public static String GetJsonProperty(this Property property)
        {
            if (property == null)
            {
                return null;
            }

            List<string> settings = new List<string>();
            if (property.Name != property.SerializedName)
            {
                settings.Add(string.Format(CultureInfo.InvariantCulture, "value = \"{0}\"", property.SerializedName));
            }
            if (property.IsRequired)
            {
                settings.Add("required = true");
            }
            return string.Join(", ", settings);
        }
    }
}
