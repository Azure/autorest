// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Globalization;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.Ruby.Azure
{
    /// <summary>
    /// Keeps a few aux method used across all templates/models.
    /// </summary>
    public static class AzureClientModelExtensions
    {

        /// <summary>
        /// Generates Ruby code in form of string for deserializing object of given type.
        /// </summary>
        /// <param name="type">Type of object needs to be deserialized.</param>
        /// <param name="scope">Current scope.</param>
        /// <param name="valueReference">Reference to object which needs to be deserialized.</param>
        /// <returns>Generated Ruby code in form of string.</returns>
        public static string AzureDeserializeType(
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
                var innerSerialization = sequence.ElementType.AzureDeserializeType(scope, elementVar);

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
                var innerSerialization = dictionary.ValueType.AzureDeserializeType(scope, valueVar);
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
                var compositeName = composite.Name;
                if(compositeName == "Resource" || compositeName == "SubResource")
                {
                    compositeName = string.Format(CultureInfo.InvariantCulture, "{0}::{1}", "MsRestAzure", compositeName);
                }
                return builder.AppendLine("unless {0}.nil?", valueReference)
                    .Indent()
                        .AppendLine("{0} = {1}.deserialize_object({0})", valueReference, compositeName)
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
        public static string AzureSerializeType(
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
                var innerSerialization = sequence.ElementType.AzureSerializeType(scope, elementVar);

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
                var innerSerialization = dictionary.ValueType.AzureSerializeType(scope, valueVar);
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
                var compositeName = composite.Name;
                if(compositeName == "Resource" || compositeName == "SubResource")
                {
                    compositeName = string.Format(CultureInfo.InvariantCulture, "{0}::{1}", "MsRestAzure", compositeName);
                }
                return builder.AppendLine("unless {0}.nil?", valueReference)
                    .Indent()
                        .AppendLine("{0} = {1}.serialize_object({0})", valueReference, compositeName)
                    .Outdent()
                    .AppendLine("end").ToString();
            }

            return string.Empty;
        }
    }
}
