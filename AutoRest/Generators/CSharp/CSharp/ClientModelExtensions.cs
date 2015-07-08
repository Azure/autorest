// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using System.Globalization;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.CSharp.TemplateModels
{
    public static class ClientModelExtensions
    {
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

        public static bool ShouldValidate(this IType model)
        {
            if (model == null)
            {
                return false;
            }

            var sequence = model as SequenceType;
            var dictionary = model as DictionaryType;
            var composite = model as CompositeType;
            if (sequence != null && sequence.ElementType  is CompositeType)
            {
                return true;
            }
            
            if (dictionary != null && dictionary.ValueType is CompositeType)
            {
                return true;
            }

            if (composite != null && composite.Properties.Any((p) => p.IsRequired || p.Type is CompositeType))
            {
                return true;
            }

            return false;
        }

        public static bool ShouldValidateChain(this IType model)
        {
            if (model == null)
            {
                return false;
            }

            var sequence = model as SequenceType;
            var dictionary = model as DictionaryType;
            var composite = model as CompositeType;
            if (sequence != null)
            {
                return sequence.ElementType.ShouldValidateChain();
            }
            
            if (dictionary != null)
            {
                return dictionary.ValueType.ShouldValidateChain();
            }

            if (composite != null)
            {
                return composite.BaseModelType.ShouldValidateChain() || 
                    composite.ShouldValidate();
            }

            return false;
        }

        /// <summary>
        /// Returns reference to self or global client.parameter
        /// </summary>
        /// <param name="parameter">The parameter to format</param>
        /// <param name="clientReference">The reference to the client</param>
        /// <returns>A reference to self or global parameter</returns>
        public static string GetSelfOrGlobalReference(this Parameter parameter, string clientReference)
        {
            if (parameter == null)
            {
                throw new ArgumentNullException("parameter");
            }
            if (clientReference == null)
            {
                throw new ArgumentNullException("clientReference");
            }

            string parameterName = parameter.Name;
            if (parameter.ClientProperty != null)
            {
                parameterName = string.Format("{0}.{1}", clientReference, parameter.ClientProperty.Name);
            }

            return parameterName;
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

            SequenceType sequence = parameter.Type as SequenceType;
            if (sequence == null)
            {
                return parameter.Type.ToString(clientReference, parameter.GetSelfOrGlobalReference(clientReference));
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
                                  "non-string List parameter {0}", parameter));
            }

            return string.Format(CultureInfo.InvariantCulture,
                "string.Join(\"{0}\", {1})", parameter.CollectionFormat.GetSeparator(), parameter.GetSelfOrGlobalReference(clientReference));
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
        /// Simple conversion of the type to string
        /// </summary>
        /// <param name="type">The type to convert</param>
        /// <param name="clientReference">The reference to the client</param>
        /// <param name="reference">a reference to an instance of the type</param>
        /// <returns></returns>
        public static string ToString(this IType type, string clientReference, string reference)
        {
            if (type == PrimaryType.String)
            {
                return reference;
            }

            var serializationSettings = (type == PrimaryType.Date) ?
                "new DateJsonConverter()"
                : string.Format(CultureInfo.InvariantCulture, 
                "{0}.SerializationSettings", clientReference);

            return string.Format(CultureInfo.InvariantCulture,
                    "JsonConvert.SerializeObject({0}, {1}).Trim('\"')",
                    reference,
                    serializationSettings);
        }

        /// <summary>
        /// Determines if the given IType is a value type in C#
        /// </summary>
        /// <param name="type">The type to check</param>
        /// <returns>True if the type maps to a C# value type, otherwise false</returns>
        public static bool IsValueType(this PrimaryType type)
        {
            return type == PrimaryType.Boolean || type == PrimaryType.DateTime || type == PrimaryType.Date
                || type == PrimaryType.Double || type == PrimaryType.Int || type == PrimaryType.Long;
        }

        public static string CheckNull(string valueReference, string executionBlock)
        {
            return string.Format(CultureInfo.InvariantCulture, 
                "if ({0} != null)\r\n{{\r\n    {1}\r\n}}", valueReference, executionBlock);
        }

        /// <summary>
        /// Generate code to perform required validation on a type
        /// </summary>
        /// <param name="type">The type to validate</param>
        /// <param name="scope">A scope provider for generating variable names as necessary</param>
        /// <param name="valueReference">A reference to the value being validated</param>
        /// <returns>The code to validate the reference of the given type</returns>
        public static string ValidateType(this IType type, IScopeProvider scope, string valueReference)
        {
            if (scope == null)
            {
                throw new ArgumentNullException("scope");
            }

            CompositeType model = type as CompositeType;
            SequenceType sequence = type as SequenceType;
            DictionaryType dictionary = type as DictionaryType;
            if (model != null && model.ShouldValidateChain())
            {
                return CheckNull(valueReference, string.Format(CultureInfo.InvariantCulture, 
                    "{0}.Validate();", valueReference));
            }
            if (sequence != null && sequence.ShouldValidateChain())
            {
                var elementVar = scope.GetVariableName("element");
                var innerValidation = sequence.ElementType.ValidateType(scope, elementVar);
                if (!string.IsNullOrEmpty(innerValidation))
                {
                    var sequenceBuilder = string.Format(CultureInfo.InvariantCulture, 
                        "foreach ( var {0} in {1})\r\n{{\r\n", elementVar,
                        valueReference);
                    sequenceBuilder += string.Format(CultureInfo.InvariantCulture, 
                        "    {0}\r\n}}", innerValidation);
                    return CheckNull(valueReference, sequenceBuilder);
                }
            }
            else if (dictionary != null && dictionary.ShouldValidateChain())
            {
                var valueVar = scope.GetVariableName("valueElement");
                var innerValidation = dictionary.ValueType.ValidateType(scope, valueVar);
                if (!string.IsNullOrEmpty(innerValidation))
                {
                    var sequenceBuilder = string.Format(CultureInfo.InvariantCulture, 
                        "if ( {0} != null)\r\n{{\r\n", valueReference);
                    sequenceBuilder += string.Format(CultureInfo.InvariantCulture, 
                        "    foreach ( var {0} in {1}.Values)\r\n    {{\r\n", valueVar,
                        valueReference);
                    sequenceBuilder += string.Format(CultureInfo.InvariantCulture, 
                        "        {0}\r\n    }}\r\n}}", innerValidation);
                    return CheckNull(valueReference, sequenceBuilder);
                }
            }

            return null;
        }
    }
}