// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.CodeDom;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.CSharp.LoadBalanced.Legacy.Model;
using AutoRest.Extensions;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.CSharp.LoadBalanced.Legacy
{
    public static class ClientModelExtensions
    {
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

        /// <summary>
        /// Generate code for the string representation for http method
        /// </summary>
        /// <param name="method">The http method</param>
        /// <returns>The code to generate the http method, as a string</returns>
        public static string GetHttpMethod(this HttpMethod method)
        {
            if (method == HttpMethod.Patch)
            {
                return "new HttpMethod(\"Patch\")";
            }
            return string.Format(CultureInfo.InvariantCulture, "HttpMethod.{0}", method);
        }

        public static bool ShouldValidateChain(this IModelType model)
        {
            if (model == null)
            {
                return false;
            }

            var typesToValidate = new Stack<IModelType>();
            typesToValidate.Push(model);
            var validatedTypes = new HashSet<IModelType>();
            while (typesToValidate.Count > 0)
            {
                IModelType modelToValidate = typesToValidate.Pop();
                if (validatedTypes.Contains(modelToValidate))
                {
                    continue;
                }
                validatedTypes.Add(modelToValidate);

                var sequence = modelToValidate as SequenceType;
                var dictionary = modelToValidate as DictionaryType;
                var composite = modelToValidate as CompositeType;
                if (sequence != null)
                {
                    typesToValidate.Push(sequence.ElementType);
                }
                else if (dictionary != null)
                {
                    typesToValidate.Push(dictionary.ValueType);
                } 
                else if (composite != null)
                {
                    if (composite.ShouldValidate())
                    {
                        return true;
                    }
                    typesToValidate.Push(composite.BaseModelType);
                }
            }

            return false;
        }

        private static bool ShouldValidate(this IModelType model)
        {
            if (model == null)
            {
                return false;
            }

            var typesToValidate = new Stack<IModelType>();
            typesToValidate.Push(model);
            var validatedTypes = new HashSet<IModelType>();
            while (typesToValidate.Count > 0)
            {
                IModelType modelToValidate = typesToValidate.Pop();
                if (validatedTypes.Contains(modelToValidate))
                {
                    continue;
                }
                validatedTypes.Add(modelToValidate);

                var sequence = modelToValidate as SequenceType;
                var dictionary = modelToValidate as DictionaryType;
                var composite = modelToValidate as CompositeType;
                if (sequence != null)
                {
                    typesToValidate.Push(sequence.ElementType);
                } 
                else if (dictionary != null)
                {
                    typesToValidate.Push(dictionary.ValueType);
                } 
                else if (composite != null)
                {
                    composite.Properties
                        .Where(p => p.ModelType is CompositeType)
                        .ForEach(cp => typesToValidate.Push(cp.ModelType));

                    if (composite.Properties.Any(p => (p.IsRequired && !p.IsConstant) || p.Constraints.Any()))
                    {
                        return true;
                    }
                }
            }

            return false;
        }

        /// <summary>
        /// Format the documentation of a property properly with the correct getters and setters. Note that this validation will
        /// checks for special cases such as acronyms and article words.
        /// </summary>
        /// <param name="property">The given property documentation to format</param>
        /// <returns>A reference to the property documentation</returns>
        public static string GetFormattedPropertySummary(this Property property)
        {
            if (property == null)
            {
                throw new ArgumentNullException("property");
            }

            if (string.IsNullOrEmpty(property.Summary) && string.IsNullOrEmpty(property.Documentation))
            {
                return null;
            }

            string documentation = String.Empty;
            string summary = string.IsNullOrEmpty(property.Summary) ? property.Documentation.EscapeXmlComment() : property.Summary.EscapeXmlComment();

            if (summary.TrimStart().StartsWith("Gets ", StringComparison.OrdinalIgnoreCase))
            {
                documentation = summary;
            }
            else
            {
                documentation = property.IsReadOnly ? "Gets " : "Gets or sets ";
                string firstWord = summary.TrimStart().Split(' ').First();
                if (firstWord.Length <= 1)
                {
                    documentation += char.ToLower(summary[0], CultureInfo.InvariantCulture) + summary.Substring(1);
                }
                else
                {
                    documentation += firstWord.ToUpper(CultureInfo.InvariantCulture) == firstWord
                        ? summary
                        : char.ToLower(summary[0], CultureInfo.InvariantCulture) + summary.Substring(1);
                }
            }
            return documentation.EscapeXmlComment();
        }

        /// <summary>
        /// Format the value of a sequence given the modeled element format.  Note that only sequences of strings are supported
        /// </summary>
        /// <param name="parameter">The parameter to format</param>
        /// <param name="clientReference">The reference to the client</param>
        /// <returns>A reference to the formatted parameter value</returns>
        public static string GetFormattedReferenceValue(this Parameter parameter, string clientReference)
        {
            if (parameter == null)
            {
                throw new ArgumentNullException("parameter");
            }

            SequenceType sequence = parameter.ModelType as SequenceType;
            if (sequence == null)
            {
                return parameter.ModelType.ToString(clientReference, parameter.Name);
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
                    string.Format(CultureInfo.InvariantCulture, 
                    "Cannot generate a formatted sequence from a " +
                                  "non-string List parameter {0}", parameter));
            }

            return string.Format(CultureInfo.InvariantCulture,
                "string.Join(\"{0}\", {1})", parameter.CollectionFormat.GetSeparator(), parameter.Name);
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
                    throw new NotSupportedException(
                        string.Format(CultureInfo.InvariantCulture, 
                        "Collection format {0} is not supported.", format));
            }
        }

        /// <summary>
        /// Returns true if the IModelType is a kind of string (ie, string PrimaryType or an Enum that is modeled as a string)
        /// </summary>
        /// <param name="t">ModelType to check</param>
        /// <returns>true if the IModelType is a kind of string</returns>
        public static bool IsKindOfString(this IModelType t) => 
            t is PrimaryType && 
                ((PrimaryType) t).KnownPrimaryType == KnownPrimaryType.String && 
                ((PrimaryType) t).KnownFormat != KnownFormat.@char ||
            t is EnumType && 
                ((EnumType) t).ModelAsString;

        /// <summary>
        /// Simple conversion of the type to string
        /// </summary>
        /// <param name="type">The type to convert</param>
        /// <param name="clientReference">The reference to the client</param>
        /// <param name="reference">a reference to an instance of the type</param>
        /// <returns></returns>
        public static string ToString(this IModelType type, string clientReference, string reference)
        {
            if (type == null || type.IsKindOfString() )
            {
                return reference;
            }

            PrimaryType primaryType = type as PrimaryType;
            string serializationSettings = string.Format(CultureInfo.InvariantCulture, "{0}.SerializationSettings", clientReference);
            if (primaryType != null)
            {
                if (primaryType.KnownPrimaryType == KnownPrimaryType.Date)
                {
                    serializationSettings = "new Microsoft.Rest.Serialization.DateJsonConverter()";
                }
                else if (primaryType.KnownPrimaryType == KnownPrimaryType.DateTimeRfc1123)
                {
                    serializationSettings = "new Microsoft.Rest.Serialization.DateTimeRfc1123JsonConverter()";
                }
                else if (primaryType.KnownPrimaryType == KnownPrimaryType.Base64Url)
                {
                    serializationSettings = "new Microsoft.Rest.Serialization.Base64UrlJsonConverter()";
                }
                else if (primaryType.KnownPrimaryType == KnownPrimaryType.UnixTime)
                {
                    serializationSettings = "new Microsoft.Rest.Serialization.UnixTimeJsonConverter()";
                }
            }

            return string.Format(CultureInfo.InvariantCulture,
                    "Microsoft.Rest.Serialization.SafeJsonConvert.SerializeObject({0}, {1}).Trim('\"')",
                    reference,
                    serializationSettings);
        }

        /// <summary>
        /// Determines if the given IModelType is a value type in C#
        /// </summary>
        /// <param name="modelType">The type to check</param>
        /// <returns>True if the type maps to a C# value type, otherwise false</returns>
        public static bool IsValueType(this IModelType modelType) => true == (modelType as IExtendedModelType)?.IsValueType;
        
        public static string CheckNull(string valueReference, string executionBlock)
        {
            var sb = new IndentedStringBuilder();
            sb.AppendLine("if ({0} != null)", valueReference)
                .AppendLine("{").Indent()
                    .AppendLine(executionBlock).Outdent()
                .AppendLine("}");
            return sb.ToString();
        }

        /// <summary>
        /// Generate code to perform required validation on a type
        /// </summary>
        /// <param name="type">The type to validate</param>
        /// <param name="scope">A scope provider for generating variable names as necessary</param>
        /// <param name="valueReference">A reference to the value being validated</param>
        /// <param name="constraints">Constraints</param>
        /// <returns>The code to validate the reference of the given type</returns>
        public static string ValidateType(this IModelType type, IChild scope, string valueReference,
            Dictionary<Constraint, string> constraints)
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            var model = type as CompositeTypeCs;
            var sequence = type as SequenceTypeCs;
            var dictionary = type as DictionaryTypeCs;

            var sb = new IndentedStringBuilder();

            if (model != null && model.ShouldValidateChain())
            {
                sb.AppendLine("{0}.Validate();", valueReference);
            }

            if (constraints != null && constraints.Any())
            {
                AppendConstraintValidations(valueReference, constraints, sb, type);
            }

            if (sequence != null && sequence.ShouldValidateChain())
            {
                var elementVar = scope.GetUniqueName("element");
                var innerValidation = sequence.ElementType.ValidateType(scope, elementVar, null);
                if (!string.IsNullOrEmpty(innerValidation))
                {
                    sb.AppendLine("foreach (var {0} in {1})", elementVar, valueReference)
                       .AppendLine("{").Indent()
                           .AppendLine(innerValidation).Outdent()
                       .AppendLine("}");
                }
            }
            else if (dictionary != null && dictionary.ShouldValidateChain())
            {
                var valueVar = scope.GetUniqueName("valueElement");
                var innerValidation = dictionary.ValueType.ValidateType(scope, valueVar, null);
                if (!string.IsNullOrEmpty(innerValidation))
                {
                    sb.AppendLine("foreach (var {0} in {1}.Values)", valueVar, valueReference)
                      .AppendLine("{").Indent()
                          .AppendLine(innerValidation).Outdent()
                      .AppendLine("}").Outdent();
                }
            }

            if (sb.ToString().Trim().Length > 0)
            {
                if (type.IsValueType())
                {
                    return sb.ToString();
                }
                else
                {
                    return CheckNull(valueReference, sb.ToString());
                }
            }

            return null;
        }

        /// <summary>
        /// Generates a C# string literal for given string, fully escaped and such.
        /// </summary>
        private static string ToLiteral(string input)
        {
            using (var writer = new StringWriter())
            {
                using (var provider = CodeDomProvider.CreateProvider("CSharp"))
                {
                    provider.GenerateCodeFromExpression(new CodePrimitiveExpression(input), writer, null);
                    return writer.ToString();
                }
            }
        }

        private static void AppendConstraintValidations(string valueReference, Dictionary<Constraint, string> constraints, IndentedStringBuilder sb, IModelType type)
        {
            foreach (var constraint in constraints.Keys)
            {
                string constraintCheck;
                string constraintValue = ((type as PrimaryType)?.KnownFormat == KnownFormat.@char) ?$"'{constraints[constraint]}'" : constraints[constraint];
                switch (constraint)
                {
                    case Constraint.ExclusiveMaximum:
                        constraintCheck = $"{valueReference} >= {constraintValue}";
                        break;
                    case Constraint.ExclusiveMinimum:
                        constraintCheck = $"{valueReference} <= {constraintValue}";
                        break;
                    case Constraint.InclusiveMaximum:
                        constraintCheck = $"{valueReference} > {constraintValue}";
                        break;
                    case Constraint.InclusiveMinimum:
                        constraintCheck = $"{valueReference} < {constraintValue}";
                        break;
                    case Constraint.MaxItems:
                        constraintCheck = $"{valueReference}.Count > {constraintValue}";
                        break;
                    case Constraint.MaxLength:
                        constraintCheck = $"{valueReference}.Length > {constraintValue}";
                        break;
                    case Constraint.MinItems:
                        constraintCheck = $"{valueReference}.Count < {constraintValue}";
                        break;
                    case Constraint.MinLength:
                        constraintCheck = $"{valueReference}.Length < {constraintValue}";
                        break;
                    case Constraint.MultipleOf:
                        constraintCheck = $"{valueReference} % {constraintValue} != 0";
                        break;
                    case Constraint.Pattern:
                        constraintValue = ToLiteral(constraintValue);
                        if (type is DictionaryType)
                        {
                            constraintCheck = $"!System.Linq.Enumerable.All({valueReference}.Values, value => System.Text.RegularExpressions.Regex.IsMatch(value, {constraintValue}))";
                        }
                        else
                        {
                            constraintCheck = $"!System.Text.RegularExpressions.Regex.IsMatch({valueReference}, {constraintValue})";
                        }
                        break;
                    case Constraint.UniqueItems:
                        if ("true".EqualsIgnoreCase(constraints[constraint]))
                        {
                            constraintCheck = $"{valueReference}.Count != {valueReference}.Distinct().Count()";
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
                    if (constraint != Constraint.UniqueItems)
                    {
                        sb.AppendLine("if ({0})", constraintCheck)
                            .AppendLine("{").Indent()
                            .AppendLine("throw new Microsoft.Rest.ValidationException(Microsoft.Rest.ValidationRules.{0}, \"{1}\", {2});",
                                constraint, valueReference.Replace("this.", ""), constraintValue).Outdent()
                            .AppendLine("}");
                    }
                    else
                    {
                        sb.AppendLine("if ({0})", constraintCheck)
                            .AppendLine("{").Indent()
                            .AppendLine("throw new Microsoft.Rest.ValidationException(Microsoft.Rest.ValidationRules.{0}, \"{1}\");",
                                constraint, valueReference.Replace("this.", "")).Outdent()
                            .AppendLine("}");
                    }
                }
            }
        }

        /// <summary>
        /// Returns the ModelType name expressed as a nullable type (for classes, nothing different, for value types, append a '?'
        /// </summary>
        /// <param name="modelType">The ModelType to return as nullable</param>
        /// <returns>The ModelType name expressed as a nullable type</returns>
        public static string AsNullableType(this IModelType modelType) => modelType.IsValueType() ? $"{modelType.Name}" : modelType.DeclarationName;

        /// <summary>
        /// Conditiallaly returns the ModelType name expressed as a nullable type (for classes, nothing different, for value types, append a '?'
        /// </summary>
        /// <param name="modelType">The ModelType to return as nullable</param>
        /// <param name="predicate">An expression indicating whether to make the type nullable</param>
        /// <returns>The ModelType name expressed as a nullable type</returns>
        public static string AsNullableType(this IModelType modelType, Func<bool> predicate ) => predicate() && modelType.IsValueType() ? $"{modelType.Name}" : modelType.DeclarationName;
        /// <summary>
        /// Conditionally returns the ModelType name expressed as a nullable type (for classes, nothing different, for value types, append a '?'
        /// </summary>
        /// <param name="modelType">The ModelType to return as nullable</param>
        /// <param name="predicate">An boolean indicating whether to make the type nullable</param>
        /// <returns>The ModelType name expressed as a nullable type</returns>
        public static string AsNullableType(this IModelType modelType, bool predicate) => predicate && modelType.IsValueType() ? $"{modelType.Name}" : modelType.DeclarationName;

        /// <summary>
        /// This returns true if the parameter or property should be expressed as a nullable type.
        /// 
        /// Note: do not confuse this with "Can this be null" or "Can this be made nullable" 
        /// </summary>
        /// <param name="variable">The property or parameter to check </param>
        /// <returns>True when the property or parameter can be assigned to null.</returns>
        public static bool IsNullable(this IVariable variable) => !variable.ModelType.IsValueType() || (variable.IsXNullable ?? !variable.IsRequired);
    }
}