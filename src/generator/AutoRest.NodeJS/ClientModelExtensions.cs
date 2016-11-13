// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Reflection;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;
using AutoRest.NodeJS.Properties;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.NodeJS
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
                return $"HttpMethod.{method}";
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
                throw new ArgumentNullException(nameof(parameter));
            }

            SequenceType sequence = parameter.ModelType as SequenceType;
            if (sequence == null)
            {
                return parameter.ModelType.ToString(parameter.Name);
            }

            PrimaryType primaryType = sequence.ElementType as PrimaryType;
            EnumType enumType = sequence.ElementType as EnumType;
            if (enumType != null && enumType.ModelAsString)
            {
                primaryType = New<PrimaryType>(KnownPrimaryType.String);
            }

            if (primaryType == null || primaryType.KnownPrimaryType != KnownPrimaryType.String)
            {
                throw new InvalidOperationException(
                    $"Cannot generate a formatted sequence from a non-string array parameter {parameter}");
            }

            return $"{parameter.Name}.join('{parameter.CollectionFormat.GetSeparator()}')";
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
                    throw new NotSupportedException($"Collection format {format} is not supported.");
            }
        }

        /// <summary>
        /// Simple conversion of the type to string
        /// </summary>
        /// <param name="type">The type to convert</param>
        /// <param name="reference">a reference to an instance of the type</param>
        /// <returns></returns>
        public static string ToString(this IModelType type, string reference)
        {
            var known = type as PrimaryType;
            var enumType = type as EnumType;
            if (enumType != null || known.IsPrimaryType(KnownPrimaryType.String))
            {
                return reference;
            }

            if (known != null)
            {
                switch (known.KnownPrimaryType)
                {
                    case KnownPrimaryType.Date:
                        return $"client.serializeObject({reference}).replace(/[Tt].*[Zz]/, '')";
                    case KnownPrimaryType.DateTimeRfc1123:
                        return $"{reference}.toUTCString()";
                    case KnownPrimaryType.DateTime:
                    case KnownPrimaryType.ByteArray:
                        return $"client.serializeObject({reference})";
                    case KnownPrimaryType.TimeSpan:
                        return $"{reference}.toISOString()";
                    case KnownPrimaryType.Base64Url:
                        return $"client.serialize({{required: true, serializedName: '{reference}', type: {{name: 'Base64Url'}}}}, {reference}, '{reference}')";
                    case KnownPrimaryType.UnixTime:
                        return $"client.serialize({{required: true, serializedName: '{reference}', type: {{name: 'UnixTime'}}}}, {reference}, '{reference}')";
                }
            }

            return $"{reference}.toString()";
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
                throw new ArgumentNullException(nameof(type));
            }

            return $"[ {string.Join(", ", type.Values.Select(p => $"'{p.Name}'"))} ]";
        }

        public static string EscapeSingleQuotes(this string valueReference)
        {
            if (valueReference == null)
            {
                throw new ArgumentNullException(nameof(valueReference));
            }

            return valueReference.Replace("'", "\\'");
        }

        private static IndentedStringBuilder ConstructValidationCheck(IndentedStringBuilder builder, string errorMessage, string valueReference, string typeName)
        {
            var escapedValueReference = valueReference.EscapeSingleQuotes();
            var lowercaseTypeName = typeName.ToLower(CultureInfo.InvariantCulture);

            return builder.Indent()
                            .AppendLine(errorMessage, escapedValueReference, lowercaseTypeName)
                          .Outdent()
                          .AppendLine("}");
        }

        private static string ValidatePrimaryType(this PrimaryType primary, IChild scope, string valueReference, bool isRequired)
        {
            if (scope == null)
            {
                throw new ArgumentNullException(nameof(scope));
            }

            if (primary == null)
            {
                throw new ArgumentNullException(nameof(primary));
            }

            var builder = new IndentedStringBuilder("  ");
            var requiredTypeErrorMessage = "throw new Error('{0} cannot be null or undefined and it must be of type {1}.');";
            var typeErrorMessage = "throw new Error('{0} must be of type {1}.');";
            var lowercaseTypeName = primary.Name.ToLower();
            if (primary.KnownPrimaryType == KnownPrimaryType.Boolean ||
                primary.KnownPrimaryType == KnownPrimaryType.Double ||
                primary.KnownPrimaryType == KnownPrimaryType.Decimal ||
                primary.KnownPrimaryType == KnownPrimaryType.Int ||
                primary.KnownPrimaryType == KnownPrimaryType.Long ||
                primary.KnownPrimaryType == KnownPrimaryType.Object)
            {
                if (isRequired)
                {
                    builder.AppendLine("if ({0} === null || {0} === undefined || typeof {0} !== '{1}') {{", valueReference, lowercaseTypeName);
                    return ConstructValidationCheck(builder, requiredTypeErrorMessage, valueReference, primary.Name).ToString();
                }

                builder.AppendLine("if ({0} !== null && {0} !== undefined && typeof {0} !== '{1}') {{", valueReference, lowercaseTypeName);
                return ConstructValidationCheck(builder, typeErrorMessage, valueReference, primary.Name).ToString();
            }
            else if (primary.KnownPrimaryType == KnownPrimaryType.Stream)
            {
                if (isRequired)
                {
                    builder.AppendLine("if ({0} === null || {0} === undefined) {{", valueReference, lowercaseTypeName);
                    return ConstructValidationCheck(builder, requiredTypeErrorMessage, valueReference, primary.Name).ToString();
                }

                builder.AppendLine("if ({0} !== null && {0} !== undefined && typeof {0}.valueOf() !== '{1}') {{", valueReference, lowercaseTypeName);
                return ConstructValidationCheck(builder, typeErrorMessage, valueReference, primary.Name).ToString();
            }
            else if (primary.KnownPrimaryType == KnownPrimaryType.String)
            {
                if (isRequired)
                {
                    //empty string can be a valid value hence we cannot implement the simple check if (!{0})
                    builder.AppendLine("if ({0} === null || {0} === undefined || typeof {0}.valueOf() !== '{1}') {{", valueReference, lowercaseTypeName);
                    return ConstructValidationCheck(builder, requiredTypeErrorMessage, valueReference, primary.Name).ToString();
                }

                builder.AppendLine("if ({0} !== null && {0} !== undefined && typeof {0}.valueOf() !== '{1}') {{", valueReference, lowercaseTypeName);
                return ConstructValidationCheck(builder, typeErrorMessage, valueReference, primary.Name).ToString();
            }
            else if (primary.KnownPrimaryType == KnownPrimaryType.Uuid)
            {
                if (isRequired)
                {
                    requiredTypeErrorMessage = "throw new Error('{0} cannot be null or undefined and it must be of type string and must be a valid {1}.');";
                    //empty string can be a valid value hence we cannot implement the simple check if (!{0})
                    builder.AppendLine("if ({0} === null || {0} === undefined || typeof {0}.valueOf() !== 'string' || !msRest.isValidUuid({0})) {{", valueReference);
                    return ConstructValidationCheck(builder, requiredTypeErrorMessage, valueReference, primary.Name).ToString();
                }
                typeErrorMessage = "throw new Error('{0} must be of type string and must be a valid {1}.');";
                builder.AppendLine("if ({0} !== null && {0} !== undefined && !(typeof {0}.valueOf() === 'string' && msRest.isValidUuid({0}))) {{", valueReference);
                return ConstructValidationCheck(builder, typeErrorMessage, valueReference, primary.Name).ToString();
            }
            else if (primary.KnownPrimaryType == KnownPrimaryType.ByteArray || primary.KnownPrimaryType == KnownPrimaryType.Base64Url)
            {
                if (isRequired)
                {
                    builder.AppendLine("if (!Buffer.isBuffer({0})) {{", valueReference, lowercaseTypeName);
                    return ConstructValidationCheck(builder, requiredTypeErrorMessage, valueReference, primary.Name).ToString();
                }

                builder.AppendLine("if ({0} && !Buffer.isBuffer({0})) {{", valueReference, lowercaseTypeName);
                return ConstructValidationCheck(builder, typeErrorMessage, valueReference, primary.Name).ToString();
            }
            else if (primary.KnownPrimaryType == KnownPrimaryType.DateTime || primary.KnownPrimaryType == KnownPrimaryType.Date || 
                primary.KnownPrimaryType == KnownPrimaryType.DateTimeRfc1123 || primary.KnownPrimaryType == KnownPrimaryType.UnixTime)
            {
                if (isRequired)
                {
                    builder.AppendLine("if(!{0} || !({0} instanceof Date || ", valueReference)
                                                  .Indent()
                                                  .Indent()
                                                  .AppendLine("(typeof {0}.valueOf() === 'string' && !isNaN(Date.parse({0}))))) {{", valueReference);
                    return ConstructValidationCheck(builder, requiredTypeErrorMessage, valueReference, primary.Name).ToString();
                }

                builder = builder.AppendLine("if ({0} && !({0} instanceof Date || ", valueReference)
                                              .Indent()
                                              .Indent()
                                              .AppendLine("(typeof {0}.valueOf() === 'string' && !isNaN(Date.parse({0}))))) {{", valueReference);
                return ConstructValidationCheck(builder, typeErrorMessage, valueReference, primary.Name).ToString();
            }
            else if (primary.KnownPrimaryType == KnownPrimaryType.TimeSpan)
            {
                if (isRequired)
                {
                    builder.AppendLine("if(!{0} || !moment.isDuration({0})) {{", valueReference);
                    return ConstructValidationCheck(builder, requiredTypeErrorMessage, valueReference, primary.Name).ToString();
                }

                builder.AppendLine("if({0} && !moment.isDuration({0})) {{", valueReference);
                return ConstructValidationCheck(builder, typeErrorMessage, valueReference, primary.Name).ToString();
            }
            else
            {
                throw new NotImplementedException($"'{valueReference}' not implemented");
            }
        }

        /// <summary>
        /// Returns the TypeScript type string for the specified primary.KnownPrimaryType
        /// </summary>
        /// <param name="primary">primary.KnownPrimaryType to query</param>
        /// <returns>The TypeScript type correspoinding to this model primary.KnownPrimaryType</returns>
        private static string PrimaryTSType(this PrimaryType primary) 
        {
            if (primary == null)
            {
                throw new ArgumentNullException(nameof(primary));
            }

            if (primary.KnownPrimaryType == KnownPrimaryType.Boolean)
                return "boolean";
            else if (primary.KnownPrimaryType == KnownPrimaryType.Double || primary.KnownPrimaryType == KnownPrimaryType.Decimal || 
                primary.KnownPrimaryType == KnownPrimaryType.Int || primary.KnownPrimaryType == KnownPrimaryType.Long)
                return "number";
            else if (primary.KnownPrimaryType == KnownPrimaryType.String || primary.KnownPrimaryType == KnownPrimaryType.Uuid)
                return "string";
            else if (primary.KnownPrimaryType == KnownPrimaryType.Date || primary.KnownPrimaryType == KnownPrimaryType.DateTime || 
                primary.KnownPrimaryType == KnownPrimaryType.DateTimeRfc1123 || primary.KnownPrimaryType == KnownPrimaryType.UnixTime)
                return "Date";
            else if (primary.KnownPrimaryType == KnownPrimaryType.Object)
                return "any";   // TODO: test this
            else if (primary.KnownPrimaryType == KnownPrimaryType.ByteArray || primary.KnownPrimaryType == KnownPrimaryType.Base64Url)  
                return "Buffer";  
            else if (primary.KnownPrimaryType == KnownPrimaryType.Stream)  
                return "stream.Readable";
            else if (primary.KnownPrimaryType == KnownPrimaryType.TimeSpan)
                return "moment.Duration"; //TODO: test this, add include for it
            else if (primary.KnownPrimaryType == KnownPrimaryType.Credentials)
                return "ServiceClientCredentials"; //TODO: test this, add include for it
            else {
                throw new NotImplementedException($"Type '{primary}' not implemented");
            }
        }

        private static string ValidateEnumType(this EnumType enumType, IChild scope, string valueReference, bool isRequired)
        {
            if (scope == null)
            {
                throw new ArgumentNullException(nameof(scope));
            }

            var builder = new IndentedStringBuilder("  ");
            var allowedValues = scope.GetUniqueName("allowedValues");

            builder.AppendLine("if ({0}) {{", valueReference)
                        .Indent()
                            .AppendLine("var {0} = {1};", allowedValues, enumType.GetEnumValuesArray())
                            .AppendLine("if (!{0}.some( function(item) {{ return item === {1}; }})) {{", allowedValues, valueReference)
                            .Indent()
                                .AppendLine("throw new Error({0} + ' is not a valid value. The valid values are: ' + {1});", valueReference, allowedValues)
                            .Outdent()
                            .AppendLine("}");
            if (isRequired)
            {
                var escapedValueReference = valueReference.EscapeSingleQuotes();
                builder.Outdent().AppendLine("} else {")
                    .Indent()
                        .AppendLine("throw new Error('{0} cannot be null or undefined.');", escapedValueReference)
                    .Outdent()
                    .AppendLine("}");
            }
            else
            {
                builder.Outdent().AppendLine("}");
            }
            
            return builder.ToString();
        }

        private static string ValidateCompositeType(IChild scope, string valueReference, bool isRequired)
        {
            if (scope == null)
            {
                throw new ArgumentNullException(nameof(scope));
            }

            var builder = new IndentedStringBuilder("  ");
            var escapedValueReference = valueReference.EscapeSingleQuotes();
            //Only validate whether the composite type is present, if it is required. Detailed validation happens in serialization.
            if (isRequired)
            {
                builder.AppendLine("if ({0} === null || {0} === undefined) {{", valueReference)
                         .Indent()
                         .AppendLine("throw new Error('{0} cannot be null or undefined.');", escapedValueReference)
                       .Outdent()
                       .AppendLine("}");
            }
            return builder.ToString();
        }

        private static string ValidateSequenceType(this SequenceType sequence, IChild scope, string valueReference, bool isRequired, string modelReference = "client.models")
        {
            if (scope == null)
            {
                throw new ArgumentNullException(nameof(scope));
            }

            var builder = new IndentedStringBuilder("  ");
            var escapedValueReference = valueReference.EscapeSingleQuotes();

            var indexVar = scope.GetUniqueName("i");
            var innerValidation = sequence.ElementType.ValidateType(scope, valueReference + "[" + indexVar + "]", false, modelReference);
            if (!string.IsNullOrEmpty(innerValidation))
            {
                if (isRequired)
                {
                    return builder.AppendLine("if (!util.isArray({0})) {{", valueReference)
                        .Indent()
                          .AppendLine("throw new Error('{0} cannot be null or undefined and it must be of type {1}.');",
                          escapedValueReference, sequence.Name.ToLower())
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

        private static string ValidateDictionaryType(this DictionaryType dictionary, IChild scope, string valueReference, bool isRequired, string modelReference = "client.models")
        {
            if (scope == null)
            {
                throw new ArgumentNullException(nameof(scope));
            }

            var builder = new IndentedStringBuilder("  ");
            var escapedValueReference = valueReference.EscapeSingleQuotes();
            var valueVar = scope.GetUniqueName("valueElement");
            var innerValidation = dictionary.ValueType.ValidateType(scope, valueReference + "[" + valueVar + "]", false, modelReference);
            if (!string.IsNullOrEmpty(innerValidation))
            {
                if (isRequired)
                {
                    return builder.AppendLine("if ({0} === null || {0} === undefined || typeof {0} !== 'object') {{", valueReference)
                        .Indent()
                          .AppendLine("throw new Error('{0} cannot be null or undefined and it must be of type {1}.');",
                            escapedValueReference, dictionary.Name.ToLower())
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
        public static string ValidateType(this IModelType type, IChild scope, string valueReference, bool isRequired, string modelReference = "client.models")
        {
            if (scope == null)
            {
                throw new ArgumentNullException(nameof(scope));
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
                if (enumType.ModelAsString)
                {
                    return New<PrimaryType>(KnownPrimaryType.String).ValidatePrimaryType(scope, valueReference, isRequired);
                }
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
		
        /// <summary>
        /// Return the TypeScript type (as a string) for specified type.
        /// </summary>
        /// <param name="type">IType to query</param>
        /// <param name="inModelsModule">Pass true if generating the code for the models module, thus model types don't need a "models." prefix</param>
        /// <returns>TypeScript type string for type</returns>
        public static string TSType(this IModelType type, bool inModelsModule) {
            CompositeType composite = type as CompositeType;
            SequenceType sequence = type as SequenceType;
            DictionaryType dictionary = type as DictionaryType;
            PrimaryType primary = type as PrimaryType;
            EnumType enumType = type as EnumType;

            string tsType;
            if (primary != null)
            {
                tsType = primary.PrimaryTSType();
            }
            else if (enumType != null)
            {
                tsType = "string";
            }
            else if (composite != null)
            {
                // ServiceClientCredentials starts with the "msRest." prefix, so strip msRest./msRestAzure. as we import those
                // types with no module prefix needed
                var compositeName = composite.Name;
                if (compositeName.StartsWith("msRest.") || compositeName.StartsWith("msRestAzure."))
                    tsType = compositeName.Substring(compositeName.IndexOf('.') + 1);
                else if (inModelsModule || compositeName.Contains('.'))
                    tsType = compositeName;
                else tsType = "models." + compositeName;
            }
            else if (sequence != null)
            {
                tsType = sequence.ElementType.TSType(inModelsModule) + "[]";
            }
            else if (dictionary != null)
            {
                // TODO: Confirm with Mark exactly what cases for additionalProperties AutoRest intends to handle (what about
                // additonalProperties combined with explicit properties?) and add support for those if needed to at least match
                // C# target level of functionality
                tsType = "{ [propertyName: string]: " + dictionary.ValueType.TSType(inModelsModule) + " }";
            }
            else throw new NotImplementedException($"Type '{type}' not implemented");

            return tsType;
        }

        public static IndentedStringBuilder AppendConstraintValidations(this IModelType type, string valueReference, Dictionary<Constraint, string> constraints, 
            IndentedStringBuilder builder)
        {
            if (valueReference == null)
            {
                throw new ArgumentNullException(nameof(valueReference));
            }

            if (constraints == null)
            {
                throw new ArgumentNullException(nameof(constraints));
            }

            if (builder == null)
            {
                throw new ArgumentNullException(nameof(builder));
            }

            foreach (var constraint in constraints.Keys)
            {
                string constraintCheck;
                string constraintValue = constraints[constraint];
                switch (constraint)
                {
                    case Constraint.ExclusiveMaximum:
                        constraintCheck = $"{valueReference} >= {constraints[constraint]}";
                        break;
                    case Constraint.ExclusiveMinimum:
                        constraintCheck = $"{valueReference} <= {constraints[constraint]}";
                        break;
                    case Constraint.InclusiveMaximum:
                        constraintCheck = $"{valueReference} > {constraints[constraint]}";
                        break;
                    case Constraint.InclusiveMinimum:
                        constraintCheck = $"{valueReference} < {constraints[constraint]}";
                        break;
                    case Constraint.MaxItems:
                        constraintCheck = $"{valueReference}.length > {constraints[constraint]}";
                        break;
                    case Constraint.MaxLength:
                        constraintCheck = $"{valueReference}.length > {constraints[constraint]}";
                        break;
                    case Constraint.MinItems:
                        constraintCheck = $"{valueReference}.length < {constraints[constraint]}";
                        break;
                    case Constraint.MinLength:
                        constraintCheck = $"{valueReference}.length < {constraints[constraint]}";
                        break;
                    case Constraint.MultipleOf:
                        constraintCheck = $"{valueReference} % {constraints[constraint]} !== 0";
                        break;
                    case Constraint.Pattern:

                        constraintValue = "/" + constraintValue.Replace("/", "\\/") + "/";
                        constraintCheck = $"{valueReference}.match({constraintValue}) === null";
                        break;
                    case Constraint.UniqueItems:
                        if ("true".EqualsIgnoreCase(constraints[constraint]))
                        {
                            constraintCheck = string.Format(
                                "{0}.length !== {0}.filter(function(item, i, ar) {{ return ar.indexOf(item) === i; }}).length", valueReference);
                        }
                        else
                        {
                            constraintCheck = null;
                        }
                        break;
                    default:
                        throw new NotSupportedException("Constraint '" + constraint + "' is not supported.");
                }
                if (constraintCheck != null)
                {
                    var escapedValueReference = valueReference.EscapeSingleQuotes();
                    if (constraint != Constraint.UniqueItems)
                    {
                        builder.AppendLine("if ({0})", constraintCheck)
                            .AppendLine("{").Indent()
                            .AppendLine("throw new Error('\"{0}\" should satisfy the constraint - \"{1}\": {2}');",
                                escapedValueReference, constraint, constraintValue).Outdent()
                            .AppendLine("}");
                    }
                    else
                    {
                        builder.AppendLine("if ({0})", constraintCheck)
                            .AppendLine("{").Indent()
                            .AppendLine("throw new Error('\"{0}\" should satisfy the constraint - \"{1}\"');",
                                escapedValueReference, constraint).Outdent()
                            .AppendLine("}");
                    }
                }
            }
            return builder;
        }

        public static string ConstructMapper(this IModelType type, string serializedName, IVariable parameter, bool isPageable, bool expandComposite)
        {
            var builder = new IndentedStringBuilder("  ");
            string defaultValue = null;
            bool isRequired = false;
            bool isConstant = false;
            bool isReadOnly = false;
            Dictionary<Constraint, string> constraints = null;
            var property = parameter as Property;
            if (parameter != null)
            {
                defaultValue = parameter.DefaultValue;
                isRequired = parameter.IsRequired;
                isConstant = parameter.IsConstant;
                constraints = parameter.Constraints;
            }
            if (property != null)
            {
                isReadOnly = property.IsReadOnly;
            }
            CompositeType composite = type as CompositeType;
            if (composite != null && composite.ContainsConstantProperties && (parameter != null && parameter.IsRequired))
            {
                defaultValue = "{}";
            }
            SequenceType sequence = type as SequenceType;
            DictionaryType dictionary = type as DictionaryType;
            PrimaryType primary = type as PrimaryType;
            EnumType enumType = type as EnumType;
            builder.AppendLine("").Indent();
            if (isRequired)
            {
                builder.AppendLine("required: true,");
            }
            else
            {
                builder.AppendLine("required: false,");
            }
            if (isReadOnly)
            {
                builder.AppendLine("readOnly: true,");
            }
            if (isConstant)
            {
                builder.AppendLine("isConstant: true,");
            }
            if (serializedName != null)
            {
                builder.AppendLine("serializedName: '{0}',", serializedName);
            }
            if (defaultValue != null)
            {
                builder.AppendLine("defaultValue: {0},", defaultValue);
            }
            if (constraints != null && constraints.Count > 0)
            {
                builder.AppendLine("constraints: {").Indent();
                var keys = constraints.Keys.ToList<Constraint>();
                for (int j = 0; j < keys.Count; j++)
                {
                    var constraintValue = constraints[keys[j]];
                    if (keys[j] == Constraint.Pattern)
                    {
                        constraintValue = $"'{constraintValue}'";
                    }
                    if (j != keys.Count - 1)
                    {
                        builder.AppendLine("{0}: {1},", keys[j], constraintValue);
                    }
                    else
                    {
                        builder.AppendLine("{0}: {1}", keys[j], constraintValue);
                    }
                }
                builder.Outdent().AppendLine("},");
            }
            // Add type information 
            if (primary != null)
            {
                switch (primary.KnownPrimaryType)
                {
                    case KnownPrimaryType.Boolean:
                        builder.AppendLine("type: {").Indent().AppendLine("name: 'Boolean'").Outdent().AppendLine("}");
                        break;
                    case KnownPrimaryType.Int:
                    case KnownPrimaryType.Long:
                    case KnownPrimaryType.Decimal:
                    case KnownPrimaryType.Double:
                        builder.AppendLine("type: {").Indent().AppendLine("name: 'Number'").Outdent().AppendLine("}");
                        break;
                    case KnownPrimaryType.String:
                        builder.AppendLine("type: {").Indent().AppendLine("name: 'String'").Outdent().AppendLine("}");
                        break;

                    case KnownPrimaryType.Uuid:
                       builder.AppendLine("type: {").Indent().AppendLine("name: 'String'").Outdent().AppendLine("}");
                        break;
                  
                    // case KnownPrimaryType.Uuid:
                       //  builder.AppendLine("type: {").Indent().AppendLine("name: 'Uuid'").Outdent().AppendLine("}");
                        //break;
                    case KnownPrimaryType.ByteArray:
                        builder.AppendLine("type: {").Indent().AppendLine("name: 'ByteArray'").Outdent().AppendLine("}");
                        break;
                    case KnownPrimaryType.Base64Url:
                        builder.AppendLine("type: {").Indent().AppendLine("name: 'Base64Url'").Outdent().AppendLine("}");
                        break;
                    case KnownPrimaryType.Date:
                        builder.AppendLine("type: {").Indent().AppendLine("name: 'Date'").Outdent().AppendLine("}");
                        break;
                    case KnownPrimaryType.DateTime:
                        builder.AppendLine("type: {").Indent().AppendLine("name: 'DateTime'").Outdent().AppendLine("}");
                        break;
                    case KnownPrimaryType.DateTimeRfc1123:
                        builder.AppendLine("type: {").Indent().AppendLine("name: 'DateTimeRfc1123'").Outdent().AppendLine("}");
                        break;
                    case KnownPrimaryType.TimeSpan:
                        builder.AppendLine("type: {").Indent().AppendLine("name: 'TimeSpan'").Outdent().AppendLine("}");
                        break;
                    case KnownPrimaryType.UnixTime:
                        builder.AppendLine("type: {").Indent().AppendLine("name: 'UnixTime'").Outdent().AppendLine("}");
                        break;
                    case KnownPrimaryType.Object:
                        builder.AppendLine("type: {").Indent().AppendLine("name: 'Object'").Outdent().AppendLine("}");
                        break;
                    case KnownPrimaryType.Stream:
                        builder.AppendLine("type: {").Indent().AppendLine("name: 'Stream'").Outdent().AppendLine("}");
                        break;
                    default:
                        throw new NotImplementedException(string.Format( Resources.InvalidType, primary));
                }
            }
            else if (enumType != null)
            {
                if (enumType.ModelAsString)
                {
                    builder.AppendLine("type: {").Indent().AppendLine("name: 'String'").Outdent().AppendLine("}");
                }
                else
                {
                    builder.AppendLine("type: {")
                        .Indent()
                        .AppendLine("name: 'Enum',")
                        .AppendLine("allowedValues: {0}", enumType.GetEnumValuesArray())
                        .Outdent()
                        .AppendLine("}");
                }
            }
            else if (sequence != null)
            {
                builder.AppendLine("type: {")
                         .Indent()
                         .AppendLine("name: 'Sequence',")
                         .AppendLine("element: {")
                           .Indent()
                           .AppendLine("{0}", sequence.ElementType.ConstructMapper(sequence.ElementType.DeclarationName + "ElementType", null, false, false))
                         .Outdent().AppendLine("}").Outdent().AppendLine("}");
            }
            else if (dictionary != null)
            {
                builder.AppendLine("type: {")
                         .Indent()
                         .AppendLine("name: 'Dictionary',")
                         .AppendLine("value: {")
                           .Indent()
                           .AppendLine("{0}", dictionary.ValueType.ConstructMapper(dictionary.ValueType.DeclarationName + "ElementType", null, false, false))
                         .Outdent().AppendLine("}").Outdent().AppendLine("}");
            }
            else if (composite != null)
            {
                builder.AppendLine("type: {")
                         .Indent()
                         .AppendLine("name: 'Composite',");
                if (composite.IsPolymorphic)
                {
                    builder = ConstructPolymorphicDiscriminator(composite, builder);
                }
                if (!expandComposite)
                {
                    builder.AppendLine("className: '{0}'", composite.Name).Outdent().AppendLine("}");
                }
                else
                {
                    builder.AppendLine("className: '{0}',", composite.Name)
                           .AppendLine("modelProperties: {").Indent();
                    var composedPropertyList = new List<Property>(composite.ComposedProperties);
                    for (var i = 0; i < composedPropertyList.Count; i++)
                    {
                        var prop = composedPropertyList[i];
                        var serializedPropertyName = prop.SerializedName;
                        PropertyInfo nextLinkName = null;
                        string nextLinkNameValue = null;
                        if (isPageable)
                        {
                            var itemName = composite.GetType().GetProperty("ItemName");
                            nextLinkName = composite.GetType().GetProperty("NextLinkName");
                            nextLinkNameValue = (string)nextLinkName.GetValue(composite);
                            if (itemName != null && ((string)itemName.GetValue(composite) == prop.Name))
                            {
                                serializedPropertyName = "";
                            }

                            if (prop.Name.Contains("nextLink") && nextLinkName != null && nextLinkNameValue == null)
                            {
                                continue;
                            }
                        }

                        if (i != composedPropertyList.Count - 1)
                        {
                            if (!isPageable)
                            {
                                builder.AppendLine("{0}: {{{1}}},", prop.Name, prop.ModelType.ConstructMapper(serializedPropertyName, prop, false, false));
                            }
                            else
                            {
                                // if pageable and nextlink is also present then we need a comma as nextLink would be the next one to be added
                                if (nextLinkNameValue != null)
                                {
                                    builder.AppendLine("{0}: {{{1}}},", prop.Name, prop.ModelType.ConstructMapper(serializedPropertyName, prop, false, false));
                                }
                                else
                                {
                                    builder.AppendLine("{0}: {{{1}}}", prop.Name, prop.ModelType.ConstructMapper(serializedPropertyName, prop, false, false));
                                }
                                    
                            }   
                        }
                        else
                        {
                            builder.AppendLine("{0}: {{{1}}}", prop.Name, prop.ModelType.ConstructMapper(serializedPropertyName, prop, false, false));
                        }
                    }
                    // end of modelProperties and type
                    builder.Outdent().AppendLine("}").Outdent().AppendLine("}");
                }
            }
            else
            {
                throw new NotImplementedException(string.Format( Resources.InvalidType, type));
            }
            return builder.ToString();
        }

        public static IndentedStringBuilder ConstructPolymorphicDiscriminator(CompositeType composite, IndentedStringBuilder builder)
        {
            if (composite == null)
            {
                throw new ArgumentNullException("composite");
            }
            if (builder == null)
            {
                throw new ArgumentNullException("builder");
            }
            // Note: If the polymorphicDiscriminator has a dot in it's name then do not escape that dot for 
            // it's serializedName, the way it is done for other properties. This makes it easy to find the 
            // discriminator property from the responseBody during deserialization. Please, do not get confused  
            // between the definition of the discriminator and the definition of the property that is  
            // marked as the discriminator. 
            builder.AppendLine("polymorphicDiscriminator: {")
                     .Indent()
                     .AppendLine("serializedName: '{0}',", composite.PolymorphicDiscriminator)
                     .AppendLine("clientName: '{0}'", Singleton<CodeNamerJs>.Instance.GetPropertyName(composite.PolymorphicDiscriminator))
                   .Outdent()
                   .AppendLine("},");
            var polymorphicType = composite;
            while (polymorphicType.BaseModelType != null)
            {
                polymorphicType = polymorphicType.BaseModelType;
            }
            builder.AppendLine("uberParent: '{0}',", polymorphicType.Name);
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

            return parameter.Extensions.ContainsKey(SwaggerExtensions.SkipUrlEncodingExtension) &&
                   (bool)parameter.Extensions[SwaggerExtensions.SkipUrlEncodingExtension];
        }

        public static bool ContainsTimeSpan(this CompositeType type)
        {
            if (type == null)
            {
                throw new ArgumentNullException(nameof(type));
            }

            Property prop = type.Properties.FirstOrDefault(p =>
                p.ModelType.IsPrimaryType(KnownPrimaryType.TimeSpan) ||
                (p.ModelType is SequenceType && (p.ModelType as SequenceType).ElementType.IsPrimaryType(KnownPrimaryType.TimeSpan)) ||
                (p.ModelType is DictionaryType && (p.ModelType as DictionaryType).ValueType.IsPrimaryType(KnownPrimaryType.TimeSpan)));

            return prop != null;
        }
    }
}
