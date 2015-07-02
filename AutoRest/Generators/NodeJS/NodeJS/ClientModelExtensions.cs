// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Microsoft.Rest.Generator.NodeJS.TemplateModels
{
    public static class ClientModelExtensions
    {
        public static string GetHttpMethod(this HttpMethod method)
        {
            if (method == HttpMethod.Patch)
            {
                return "new HttpMethod(\"Patch\")";
            }
            else
            {
                return string.Format(CultureInfo.InvariantCulture, "HttpMethod.{0}", method);
            }
        }
        
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
            if (enumType != null && enumType.IsExpandable)
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

        /// <summary>
        /// Simple conversion of the type to string
        /// </summary>
        /// <param name="type">The type to convert</param>
        /// <param name="reference">a reference to an instance of the type</param>
        /// <returns></returns>
        public static string ToString(this IType type, string reference)
        {
            var known = type as PrimaryType;
            if (known == PrimaryType.String)
            {
                return reference;
            }
            else if (known == PrimaryType.Date)
            {
                return string.Format(CultureInfo.InvariantCulture, 
                    "msRest.serializeObject({0}).replace(/[Tt].*[Zz]/, '')", reference);
            }
            else if (known == PrimaryType.DateTime
                || known == PrimaryType.ByteArray)
            {
                return string.Format(CultureInfo.InvariantCulture, 
                    "msRest.serializeObject({0})", reference);
            }
            else
            {
                return string.Format(CultureInfo.InvariantCulture, "{0}.toString()", reference);
            }
        }
        
        /// <summary>
        /// Generate code to perform validation on a required parameter or property
        /// </summary>
        /// <param name="type">The type to validate</param>
        /// <param name="scope">A scope provider for generating variable names as necessary</param>
        /// <param name="valueReference">A reference to the value being validated</param>
        /// <param name="modelReference">A reference to the models classes</param>
        /// <returns>The code to validate the reference of the given type</returns>
        public static string ValidateRequiredType(this IType type, IScopeProvider scope, string valueReference, string modelReference)
        {
            var builder = new IndentedStringBuilder("  ");
            return builder.AppendLine("if ({0} === null || {0} === undefined) {{", valueReference)
                   .Indent()
                     .AppendLine("throw new Error('{0} cannot be null or undefined.');", valueReference.EscapeSingleQuotes())
                   .Outdent()
                   .AppendLine("}")
                   .AppendLine(ValidateType(type, scope, valueReference, modelReference)).ToString();
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

        /// <summary>
        /// Generate code to perform validation on a parameter or property
        /// </summary>
        /// <param name="type">The type to validate</param>
        /// <param name="scope">A scope provider for generating variable names as necessary</param>
        /// <param name="valueReference">A reference to the value being validated</param>
        /// <param name="modelReference">A reference to the models array</param>
        /// <returns>The code to validate the reference of the given type</returns>
        public static string ValidateType(this IType type, IScopeProvider scope, string valueReference, string modelReference = "client._models")
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
            var builder = new IndentedStringBuilder("  ");
            var escapedValueReference = valueReference.EscapeSingleQuotes();
            if(primary != null)
            {
                if (primary == PrimaryType.String ||
                    primary == PrimaryType.Boolean ||
                    primary == PrimaryType.Double ||
                    primary == PrimaryType.Int ||
                    primary == PrimaryType.Long)
                {
                    return builder.AppendLine("if ({0} !== null && {0} !== undefined && typeof {0} !== '{1}') {{", valueReference, primary.Name.ToLower(CultureInfo.InvariantCulture))
                            .Indent()
                                .AppendLine("throw new Error('{0} must be of type {1}.');", escapedValueReference, primary.Name.ToLower(CultureInfo.InvariantCulture))
                            .Outdent()
                          .AppendLine("}").ToString();
                }
                else if (primary == PrimaryType.ByteArray)
                {
                    return builder.AppendLine("if ({0} !== null && {0} !== undefined && !Buffer.isBuffer({0})) {{", valueReference)
                            .Indent()
                                .AppendLine("throw new Error('{0} must be of type {1}.');", escapedValueReference, primary.Name.ToLower(CultureInfo.InvariantCulture))
                            .Outdent()
                          .AppendLine("}").ToString();
                }
                else if (primary == PrimaryType.DateTime || primary == PrimaryType.Date)
                {
                    return builder.AppendLine("if ({0} !== null && {0} !== undefined && ", valueReference)
                    .Indent()
                    .Indent()
                        .AppendLine("!({0} instanceof Date || ", valueReference)
                            .Indent()
                                .AppendLine("(typeof {0} === 'string' && !isNaN(Date.parse({0}))))) {{", valueReference)
                           .Outdent()
                           .Outdent()
                    .AppendLine("throw new Error('{0} must be of type {1}.');", escapedValueReference, primary.Name.ToLower(CultureInfo.InvariantCulture))
                           .Outdent()
                           .AppendLine("}").ToString();
                }
                else if (primary == PrimaryType.Object)
                {
                    return builder.ToString();
                }
                else
                {
                    throw new NotImplementedException(string.Format(CultureInfo.InvariantCulture, 
                        "'{0}' not implemented", valueReference));
                }
            }
            else if (enumType != null && enumType.Values.Any()) {
                var allowedValues = scope.GetVariableName("allowedValues");
                return builder.AppendLine("if ({0} !== null && {0} !== undefined) {{", valueReference)
                           .Indent()
                                .AppendLine("var {0} = {1};", allowedValues, enumType.GetEnumValuesArray())
                                .AppendLine("if (!{0}.some( function(item) {{ return item === {1}; }})) {{", allowedValues, valueReference)
                                .Indent()
                                   .AppendLine("throw new Error({0} + ' is not a valid value. The valid values are: ' + {1});", escapedValueReference, allowedValues)
                                .Outdent()
                                .AppendLine("}")
                           .Outdent()
                           .AppendLine("}").ToString();
            }
            else if (composite != null && composite.Properties.Any())
            {
                builder.AppendLine("if ({0} !== null && {0} !== undefined) {{", valueReference).Indent();

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
                                        valueReference)
                        .Outdent()
                        .AppendLine("}");
                }
                else
                {
                    builder.AppendLine("{2}['{0}'].validate({1});", composite.Name, valueReference, modelReference);
                }
                builder.Outdent().AppendLine("}");

                return builder.ToString();
            }
            else if (sequence != null)
            {
                var elementVar = scope.GetVariableName("element");
                var innerValidation = sequence.ElementType.ValidateType(scope, elementVar, modelReference);
                if (!string.IsNullOrEmpty(innerValidation))
                {
                    return builder.AppendLine("if ({0} !== null && {0} !== undefined && util.isArray({0})) {{", valueReference)
                            .Indent()
                              .AppendLine("{0}.forEach(function({1}) {{", valueReference, elementVar)
                                .Indent()
                                  .AppendLine(innerValidation)
                                .Outdent()
                              .AppendLine("});")
                            .Outdent()
                          .AppendLine("}").ToString();
                }
            }
            else if (dictionary != null)
            {
                var valueVar = scope.GetVariableName("valueElement");
                var innerValidation = dictionary.ValueType.ValidateType(scope, 
                    valueReference + "[" + valueVar + "]", modelReference);
                if (!string.IsNullOrEmpty(innerValidation))
                {
                    return builder.AppendLine("if ({0} !== null && {0} !== undefined && typeof {0} === 'object') {{", valueReference)
                            .Indent()
                              .AppendLine("for(var {0} in {1}) {{", valueVar, valueReference)
                                .Indent()
                                  .AppendLine(innerValidation)
                                .Outdent()
                              .AppendLine("}")
                            .Outdent()
                          .AppendLine("}").ToString();
                }
            }

            return null;
        }

        /// <summary>
        /// Generate code to perform deserialization on a parameter or property
        /// </summary>
        /// <param name="type">The type to deserialize</param>
        /// <param name="scope">A scope provider for generating variable names as necessary</param>
        /// <param name="valueReference">A reference to the value being deserialized</param>
        /// <param name="modelReference">A reference to the models</param>
        /// <returns>The code to deserialize the given type</returns>
        public static string DeserializeType(this IType type, IScopeProvider scope, string valueReference, string modelReference = "self._models")
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            CompositeType composite = type as CompositeType;
            SequenceType sequence = type as SequenceType;
            DictionaryType dictionary = type as DictionaryType;
            PrimaryType primary = type as PrimaryType;
            var builder = new IndentedStringBuilder("  ");
            if (primary != null)
            {
                if (primary == PrimaryType.ByteArray)
                {
                    return builder.AppendLine("if ({0} !== null && {0} !== undefined && typeof {0} === 'string') {{", valueReference)
                            .Indent()
                                .AppendLine("{0} = new Buffer({0}, 'base64');", valueReference)
                            .Outdent()
                            .AppendLine("}").ToString();
                }
                else if (primary == PrimaryType.DateTime || primary == PrimaryType.Date)
                {
                    return builder.AppendLine("if ({0} !== null && {0} !== undefined) {{", valueReference)
                            .Indent()
                              .AppendLine("{0} = new Date({0});", valueReference)
                            .Outdent()
                          .AppendLine("}").ToString();
                }
            }
            else if (composite != null && composite.Properties.Any())
            {
                builder.AppendLine("if ({0} !== null && {0} !== undefined) {{", valueReference).Indent();

                if (!string.IsNullOrEmpty(composite.PolymorphicDiscriminator))
                {
                    builder.AppendLine("if({0}['{1}'] !== null && {0}['{1}'] !== undefined && {2}.discriminators[{0}['{1}']]) {{",
                                        valueReference,
                                        composite.PolymorphicDiscriminator, modelReference)
                        .Indent()
                            .AppendLine("{0} = {2}.discriminators[{0}['{1}']].deserialize({0});",
                                valueReference,
                                composite.PolymorphicDiscriminator, modelReference) 
                        .Outdent()
                        .AppendLine("}} else {{", valueReference)
                        .Indent()
                            .AppendLine("throw new Error('No discriminator field \"{0}\" was found in parameter \"{1}\".');",
                                        composite.PolymorphicDiscriminator,
                                        valueReference)
                        .Outdent()
                        .AppendLine("}");
                }
                else
                {
                    builder.AppendLine("{0} = {2}['{1}'].deserialize({0});", valueReference, composite.Name, modelReference);
                }
                builder.Outdent().AppendLine("}");

                return builder.ToString();
            }
            else if (sequence != null)
            {
                var elementVar = scope.GetVariableName("element");
                var innerSerialization = sequence.ElementType.DeserializeType(scope, elementVar, modelReference);
                if (!string.IsNullOrEmpty(innerSerialization))
                {
                    return builder.AppendLine("if ({0} !== null && {0} !== undefined) {{", valueReference)
                            .Indent()
                              .AppendLine("var deserialized{0} = [];", sequence.Name.ToPascalCase())
                              .AppendLine("{0}.forEach(function({1}) {{", valueReference, elementVar)
                                .Indent()
                                  .AppendLine(innerSerialization)
                                  .AppendLine("deserialized{0}.push({1});", sequence.Name.ToPascalCase(), elementVar)
                                .Outdent()
                              .AppendLine("});")
                              .AppendLine("{0} = deserialized{1};", valueReference, sequence.Name.ToPascalCase())
                            .Outdent()
                          .AppendLine("}").ToString();
                }
            }
            else if (dictionary != null)
            {
                var valueVar = scope.GetVariableName("valueElement");
                var innerSerialization = dictionary.ValueType.DeserializeType(scope, valueReference + "[" + valueVar + "]", modelReference);
                if (!string.IsNullOrEmpty(innerSerialization))
                {
                    return builder.AppendLine("if ({0} !== null && {0} !== undefined) {{", valueReference)
                            .Indent()
                              .AppendLine("for(var {0} in {1}) {{", valueVar, valueReference)
                                .Indent()
                                  .AppendLine(innerSerialization)
                                .Outdent()
                              .AppendLine("}")
                            .Outdent()
                          .AppendLine("}").ToString();
                }
            }

            return null;
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
                   (bool) parameter.Extensions[CodeGenerator.SkipUrlEncodingExtension];
        }
    }
}
