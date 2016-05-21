// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using Microsoft.Rest.Generator.ClientModel;
using System.Linq;

namespace Microsoft.Rest.Generator.Ruby.TemplateModels
{
    using Utilities;
    using System.Collections.Generic;

    /// <summary>
    /// Keeps a few aux method used across all templates/models.
    /// </summary>
    public static class ClientModelExtensions
    {
        /// <summary>
        /// Determines if a type can be assigned the value null.
        /// </summary>
        /// <param name="type">The type to check.</param>
        /// <returns>True if null can be assigned, otherwise false.</returns>
        public static bool IsNullable(this IType type)
        {
            return true;
        }

        /// <summary>
        /// Simple conversion of the type to string.
        /// </summary>
        /// <param name="type">The type to convert</param>
        /// <param name="reference">a reference to an instance of the type</param>
        /// <returns></returns>
        public static string ToString(this IType type, string reference)
        {
            var known = type as PrimaryType;
            string result = string.Format("{0}.to_s", reference);
            if (known != null)
            {
                if (known.Type == KnownPrimaryType.String || known.Type == KnownPrimaryType.DateTime)
                {
                    result = reference;
                }
                else if (known.Type == KnownPrimaryType.DateTimeRfc1123)
                {
                    result = string.Format("{0}.strftime('%a, %d %b %Y %H:%M:%S GMT')", reference);
                }
            }

            return result;
        }

        /// <summary>
        /// Internal method for generating Yard-compatible representation of given type.
        /// </summary>
        /// <param name="type">The type doc needs to be generated for.</param>
        /// <returns>Doc in form of string.</returns>
        private static string PrepareTypeForDocRecursively(IType type)
        {
            var sequenceType = type as SequenceType;
            var compositeType = type as CompositeType;
            var enumType = type as EnumType;
            var dictionaryType = type as DictionaryType;
            var primaryType = type as PrimaryType;

            if (primaryType != null)
            {
                if (primaryType.Type == KnownPrimaryType.String)
                {
                    return "String";
                }

                if (primaryType.Type == KnownPrimaryType.Int || primaryType.Type == KnownPrimaryType.Long)
                {
                    return "Integer";
                }

                if (primaryType.Type == KnownPrimaryType.Boolean)
                {
                    return "Boolean";
                }

                if (primaryType.Type == KnownPrimaryType.Double)
                {
                    return "Float";
                }

                if (primaryType.Type == KnownPrimaryType.Date)
                {
                    return "Date";
                }

                if (primaryType.Type == KnownPrimaryType.DateTime)
                {
                    return "DateTime";
                }

                if (primaryType.Type == KnownPrimaryType.DateTimeRfc1123)
                {
                    return "DateTime";
                }

                if (primaryType.Type == KnownPrimaryType.ByteArray)
                {
                    return "Array<Integer>";
                }

                if (primaryType.Type == KnownPrimaryType.TimeSpan)
                {
                    return "Duration"; //TODO: Is this a real Ruby type...?
                }
            }

            if (compositeType != null)
            {
                return compositeType.Name;
            }

            if (enumType != null)
            {
                return enumType.Name;
            }

            if (sequenceType != null)
            {
                string internalString = PrepareTypeForDocRecursively(sequenceType.ElementType);

                if (!string.IsNullOrEmpty(internalString))
                {
                    return string.Format("Array<{0}>", internalString);
                }

                return string.Empty;
            }

            if (dictionaryType != null)
            {
                string internalString = PrepareTypeForDocRecursively(dictionaryType.ValueType);

                if (!string.IsNullOrEmpty(internalString))
                {
                    return string.Format("Hash{{String => {0}}}", internalString);
                }

                return string.Empty;
            }

            return string.Empty;
        }

        /// <summary>
        /// Return the separator associated with a given collectionFormat.
        /// </summary>
        /// <param name="format">The collection format.</param>
        /// <returns>The separator.</returns>
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
                    throw new NotSupportedException(string.Format("Collection format {0} is not supported.", format));
            }
        }

        /// <summary>
        /// Format the value of a sequence given the modeled element format. Note that only sequences of strings are supported.
        /// </summary>
        /// <param name="parameter">The parameter to format.</param>
        /// <returns>A reference to the formatted parameter value.</returns>
        public static string GetFormattedReferenceValue(this Parameter parameter)
        {
            SequenceType sequence = parameter.Type as SequenceType;
            if (sequence == null)
            {
                return parameter.Name;
            }

            PrimaryType primaryType = sequence.ElementType as PrimaryType;
            EnumType enumType = sequence.ElementType as EnumType;
            if (enumType != null && enumType.ModelAsString)
            {
                primaryType = new PrimaryType(KnownPrimaryType.String);
            }

            if (primaryType == null || primaryType.Type != KnownPrimaryType.String)
            {
                throw new InvalidOperationException(
                    string.Format("Cannot generate a formatted sequence from a " +
                                  "non-string array parameter {0}", parameter));
            }

            return string.Format("{0}.join('{1}')", parameter.Name, parameter.CollectionFormat.GetSeparator());
        }

        /// <summary>
        /// Generates Yard-compatible representation of given type.
        /// </summary>
        /// <param name="type">The type doc needs to be generated for.</param>
        /// <returns>Doc in form of string.</returns>
        public static string GetYardDocumentation(this IType type)
        {
            string typeForDoc = PrepareTypeForDocRecursively(type);

            if (string.IsNullOrEmpty(typeForDoc))
            {
                return string.Empty;
            }

            return string.Format("[{0}] ", typeForDoc);
        }

        /// <summary>
        /// Generate code to perform required validation on a type.
        /// </summary>
        /// <param name="type">The type to validate.</param>
        /// <param name="scope">A scope provider for generating variable names as necessary.</param>
        /// <param name="valueReference">A reference to the value being validated.</param>
        /// <returns>The code to validate the reference of the given type.</returns>
        public static string ValidateType(this IType type, IScopeProvider scope, string valueReference)
        {
            CompositeType model = type as CompositeType;
            SequenceType sequence = type as SequenceType;
            DictionaryType dictionary = type as DictionaryType;

            if (model != null && model.Properties.Any())
            {
                return string.Format("{0}.validate unless {0}.nil?", valueReference);
            }

            if (sequence != null || dictionary != null)
            {
                return string.Format("{0}.each{{ |e| e.validate if e.respond_to?(:validate) }} unless {0}.nil?" + Environment.NewLine, valueReference);
            }

            return null;
        }

        /// <summary>
        /// Determine whether a model should be serializable.
        /// </summary>
        /// <param name="type">The type to check.</param>
        public static bool IsSerializable(this IType type)
        {
            return !type.IsPrimaryType(KnownPrimaryType.Object);
        }

        /// <summary>
        /// Verifies whether client includes model types.
        /// </summary>
        /// <param name="client">The client.</param>
        /// <returns>True if client contain model types, false otherwise.</returns>
        public static bool HasModelTypes(this ServiceClient client)
        {
            return client.ModelTypes.Any(mt => mt.Extensions.Count == 0);
        }

        /// <summary>
        /// Generates Ruby code in form of string for deserializing object of given type.
        /// </summary>
        /// <param name="type">Type of object needs to be deserialized.</param>
        /// <param name="scope">Current scope.</param>
        /// <param name="valueReference">Reference to object which needs to be deserialized.</param>
        /// <returns>Generated Ruby code in form of string.</returns>
        public static string DeserializeType(
            this IType type,
            IScopeProvider scope,
            string valueReference)
        {
            var composite = type as CompositeType;
            var sequence = type as SequenceType;
            var dictionary = type as DictionaryType;
            var primary = type as PrimaryType;
            var enumType = type as EnumType;

            var builder = new IndentedStringBuilder("  ");

            if (primary != null)
            {
                if (primary.Type == KnownPrimaryType.Int || primary.Type == KnownPrimaryType.Long)
                {
                    return builder.AppendLine("{0} = Integer({0}) unless {0}.to_s.empty?", valueReference).ToString();
                }

                if (primary.Type == KnownPrimaryType.Double)
                {
                    return builder.AppendLine("{0} = Float({0}) unless {0}.to_s.empty?", valueReference).ToString();
                }

                if (primary.Type == KnownPrimaryType.ByteArray)
                {
                    return builder.AppendLine("{0} = Base64.strict_decode64({0}).unpack('C*') unless {0}.to_s.empty?", valueReference).ToString();
                }

                if (primary.Type == KnownPrimaryType.Date)
                {
                    return builder.AppendLine("{0} = MsRest::Serialization.deserialize_date({0}) unless {0}.to_s.empty?", valueReference).ToString();
                }

                if (primary.Type == KnownPrimaryType.DateTime)
                {
                    return builder.AppendLine("{0} = DateTime.parse({0}) unless {0}.to_s.empty?", valueReference).ToString();
                }

                if (primary.Type == KnownPrimaryType.DateTimeRfc1123)
                {
                    return builder.AppendLine("{0} = DateTime.parse({0}) unless {0}.to_s.empty?", valueReference).ToString();
                }

                if (primary.Type == KnownPrimaryType.UnixTime)
                {
                    return builder.AppendLine("{0} = DateTime.strptime({0}.to_s, '%s') unless {0}.to_s.empty?", valueReference).ToString();
                }
            }
            else if (enumType != null && !string.IsNullOrEmpty(enumType.Name))
            {
                return builder
                    .AppendLine("if (!{0}.nil? && !{0}.empty?)", valueReference)
                    .AppendLine(
                        "  enum_is_valid = {0}.constants.any? {{ |e| {0}.const_get(e).to_s.downcase == {1}.downcase }}",
                        enumType.Name, valueReference)
                    .AppendLine(
                        "  warn 'Enum {0} does not contain ' + {1}.downcase + ', but was received from the server.' unless enum_is_valid", enumType.Name, valueReference)
                    .AppendLine("end")
                    .ToString();
            }
            else if (sequence != null)
            {
                var elementVar = scope.GetUniqueName("element");
                var innerSerialization = sequence.ElementType.DeserializeType(scope, elementVar);

                if (!string.IsNullOrEmpty(innerSerialization))
                {
                    return
                        builder
                            .AppendLine("unless {0}.nil?", valueReference)
                                .Indent()
                                    .AppendLine("deserialized_{0} = []", sequence.Name.ToLower())
                                    .AppendLine("{0}.each do |{1}|", valueReference, elementVar)
                                    .Indent()
                                        .AppendLine(innerSerialization)
                                        .AppendLine("deserialized_{0}.push({1})", sequence.Name.ToLower(), elementVar)
                                    .Outdent()
                                    .AppendLine("end")
                                    .AppendLine("{0} = deserialized_{1}", valueReference, sequence.Name.ToLower())
                                .Outdent()
                            .AppendLine("end")
                            .ToString();
                }
            }
            else if (dictionary != null)
            {
                var valueVar = scope.GetUniqueName("valueElement");
                var innerSerialization = dictionary.ValueType.DeserializeType(scope, valueVar);
                if (!string.IsNullOrEmpty(innerSerialization))
                {
                    return builder.AppendLine("unless {0}.nil?", valueReference)
                            .Indent()
                              .AppendLine("{0}.each do |key, {1}|", valueReference, valueVar)
                                .Indent()
                                  .AppendLine(innerSerialization)
                                  .AppendLine("{0}[key] = {1}", valueReference, valueVar)
                               .Outdent()
                             .AppendLine("end")
                           .Outdent()
                         .AppendLine("end").ToString();
                }
            }
            else if (composite != null)
            {
                return builder.AppendLine("unless {0}.nil?", valueReference)
                    .Indent()
                        .AppendLine("{0} = {1}.deserialize_object({0})", valueReference, composite.Name)
                    .Outdent()
                    .AppendLine("end").ToString();
            }

            return string.Empty;
        }

        /// <summary>
        /// Generates Ruby code in form of string for serializing object of given type.
        /// </summary>
        /// <param name="type">Type of object needs to be serialized.</param>
        /// <param name="scope">Current scope.</param>
        /// <param name="valueReference">Reference to object which needs to serialized.</param>
        /// <returns>Generated Ruby code in form of string.</returns>
        public static string SerializeType(
            this IType type,
            IScopeProvider scope,
            string valueReference)
        {
            var composite = type as CompositeType;
            var sequence = type as SequenceType;
            var dictionary = type as DictionaryType;
            var primary = type as PrimaryType;

            var builder = new IndentedStringBuilder("  ");

            if (primary != null)
            {
                if (primary.Type == KnownPrimaryType.ByteArray)
                {
                    return builder.AppendLine("{0} = Base64.strict_encode64({0}.pack('c*'))", valueReference).ToString();
                }

                if (primary.Type == KnownPrimaryType.DateTime)
                {
                    return builder.AppendLine("{0} = {0}.new_offset(0).strftime('%FT%TZ')", valueReference).ToString();
                }

                if (primary.Type == KnownPrimaryType.DateTimeRfc1123)
                {
                    return builder.AppendLine("{0} = {0}.new_offset(0).strftime('%a, %d %b %Y %H:%M:%S GMT')", valueReference).ToString();
                }

                if (primary.Type == KnownPrimaryType.UnixTime)
                {
                    return builder.AppendLine("{0} = {0}.new_offset(0).strftime('%s')", valueReference).ToString();
                }
            }
            else if (sequence != null)
            {
                var elementVar = scope.GetUniqueName("element");
                var innerSerialization = sequence.ElementType.SerializeType(scope, elementVar);

                if (!string.IsNullOrEmpty(innerSerialization))
                {
                    return
                        builder
                            .AppendLine("unless {0}.nil?", valueReference)
                                .Indent()
                                    .AppendLine("serialized{0} = []", sequence.Name)
                                    .AppendLine("{0}.each do |{1}|", valueReference, elementVar)
                                    .Indent()
                                        .AppendLine(innerSerialization)
                                        .AppendLine("serialized{0}.push({1})", sequence.Name.ToPascalCase(), elementVar)
                                    .Outdent()
                                    .AppendLine("end")
                                    .AppendLine("{0} = serialized{1}", valueReference, sequence.Name.ToPascalCase())
                                .Outdent()
                            .AppendLine("end")
                            .ToString();
                }
            }
            else if (dictionary != null)
            {
                var valueVar = scope.GetUniqueName("valueElement");
                var innerSerialization = dictionary.ValueType.SerializeType(scope, valueVar);
                if (!string.IsNullOrEmpty(innerSerialization))
                {
                    return builder.AppendLine("unless {0}.nil?", valueReference)
                            .Indent()
                              .AppendLine("{0}.each {{ |key, {1}|", valueReference, valueVar)
                                .Indent()
                                  .AppendLine(innerSerialization)
                                  .AppendLine("{0}[key] = {1}", valueReference, valueVar)
                               .Outdent()
                             .AppendLine("}")
                           .Outdent()
                         .AppendLine("end").ToString();
                }
            }
            else if (composite != null)
            {
                return builder.AppendLine("unless {0}.nil?", valueReference)
                    .Indent()
                        .AppendLine("{0} = {1}.serialize_object({0})", valueReference, composite.Name)
                    .Outdent()
                    .AppendLine("end").ToString();
            }

            return string.Empty;
        }

        /// <summary>
        /// Determines whether one composite type derives directly or indirectly from another.
        /// </summary>
        /// <param name="type">Type to test.</param>
        /// <param name="possibleAncestorType">Type that may be an ancestor of this type.</param>
        /// <returns>true if the type is an ancestor, false otherwise.</returns>
        public static bool DerivesFrom(this CompositeType type, CompositeType possibleAncestorType)
        {
            return
                type.BaseModelType != null &&
                (type.BaseModelType.Equals(possibleAncestorType) ||
                 type.BaseModelType.DerivesFrom(possibleAncestorType));
        }
    }
}
