// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using Microsoft.Rest.Generator.ClientModel;
using System.Linq;

namespace Microsoft.Rest.Generator.Ruby.TemplateModels
{
    using Utilities;

    /// <summary>
    /// Keeps a few aux method used across all templates/models.
    /// </summary>
    public static class ClientModelExtensions
    {
        /// <summary>
        /// Determines if a type can be assigned the value null
        /// </summary>
        /// <param name="type">The type to check</param>
        /// <returns>true if null can be assigned, otherwise false</returns>
        public static bool IsNullable(this IType type)
        {
            return true;
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
            return (known != null && known == PrimaryType.String)
                ? reference
                : string.Format("{0}.to_s", reference);
        }

        /// <summary>
        /// Internal method for generating Yard-compatible representation of given type.
        /// </summary>
        /// <param name="type">The type doc needs to be generated for.</param>
        /// <returns>Doc in form of string.</returns>
        private static string PrepareTypeForDocRecursively(IType type)
        {
            // TODO: add more primitive types, also dictionary and composite ones.
            var sequenceType = type as SequenceType;
            var compositeType = type as CompositeType;

            if (type == PrimaryType.String)
            {
                return "String";
            }

            if (type == PrimaryType.Int || type == PrimaryType.Long)
            {
                return "Integer";
            }

            if (type == PrimaryType.Boolean)
            {
                return "Boolean";
            }

            if (type == PrimaryType.Double)
            {
                return "Float";
            }

            if (compositeType != null)
            {
                return compositeType.Name;
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

            return string.Empty;
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
                    throw new NotSupportedException(string.Format("Collection format {0} is not supported.", format));
            }
        }

        /// <summary>
        /// Format the value of a sequence given the modeled element format.  Note that only sequences of strings are supported
        /// </summary>
        /// <param name="parameter">The parameter to format</param>
        /// <returns>A reference to the formatted parameter value</returns>
        public static string GetFormattedReferenceValue(this Parameter parameter)
        {
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
        /// Esnures that required and optional are correctly set on parameters based on their location
        /// </summary>
        /// <param name="parameter">The parameter to check</param>
        /// <returns>The updated parameter</returns>
        public static Parameter SetRequiredOptional(this Parameter parameter)
        {
            parameter.IsRequired = parameter.IsRequired ||
                                   (parameter.Location == ParameterLocation.Path ||
                                    parameter.Location == ParameterLocation.Body);
            return parameter;
        }

        /// <summary>
        /// Generats null check instruction.
        /// </summary>
        /// <param name="valueReference">Object for null check.</param>
        /// <param name="executionBlock">Code to execute if given object isn't null.</param>
        /// <returns>Generated Ruby code for null check.</returns>
        public static string CheckNull(string valueReference, string executionBlock)
        {
            return string.Format("{1} unless {0}.nil?", valueReference, executionBlock);
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
            CompositeType model = type as CompositeType;
            SequenceType sequence = type as SequenceType;
            DictionaryType dictionary = type as DictionaryType;

            if (model != null && model.Properties.Any())
            {
                return string.Format("{0}.validate unless {0}.nil?", valueReference);
            }
            
            if (sequence != null || dictionary != null)
            {
                return string.Format("{0}.each{{ |e| e.validate if e.respond_to?(:validate) }} unless {0}.nil?\r\n", valueReference);
            }

            return null;
        }

        /// <summary>
        /// Determine whether a model should be serializable
        /// </summary>
        /// <param name="type">The type to check</param>
        public static bool IsSerializable(this IType type)
        {
            var known = type as PrimaryType;
            return (known != PrimaryType.Object);
        }

        /// <summary>
        /// Verifies whether client includes Model types.
        /// </summary>
        /// <param name="client">The client.</param>
        /// <returns>True if client contain Model types, false otherwise.</returns>
        public static bool HasModelTypes(this ServiceClient client)
        {
            return client.ModelTypes.Any() || client.Properties.Any(p => p.Type is CompositeType) ||
                   client.Methods.Any(m => m.HasModelTypes());
        }

        /// <summary>
        /// Verifies whether method includes Model types.
        /// </summary>
        /// <param name="method">The method.</param>
        /// <returns>True if method contain Model types, false otherwise.</returns>
        public static bool HasModelTypes(this Method method)
        {
            return method.Parameters.Any(p => p.Type is CompositeType) ||
                   method.Responses.Any(r => r.Value is CompositeType) || method.ReturnType is CompositeType ||
                   method.DefaultResponse is CompositeType;
        }

        /// <summary>
        /// Generates Ruby code in form of string for deserializing object of given type.
        /// </summary>
        /// <param name="type">Type of object needs to be deserialized.</param>
        /// <param name="scope">Current scope.</param>
        /// <param name="valueReference">Reference to object which needs to be deserialized.</param>
        /// <param name="defaultNamespace">Current namespace.</param>
        /// <returns>Generated Ruby code in form of string.</returns>
        public static string DeserializeType(
            this IType type,
            IScopeProvider scope,
            string valueReference,
            string defaultNamespace)
        {
            var composite = type as CompositeType;
            var sequence = type as SequenceType;
            var dictionary = type as DictionaryType;
            var primary = type as PrimaryType;
            var enumType = type as EnumType;

            var builder = new IndentedStringBuilder("  ");

            if (primary != null)
            {
                if (primary == PrimaryType.Int || primary == PrimaryType.Long)
                {
                    return builder.AppendLine("{0} = Integer({0}) unless {0}.to_s.empty?", valueReference).ToString();
                }

                if (primary == PrimaryType.Double)
                {
                    return builder.AppendLine("{0} = Float({0}) unless {0}.to_s.empty?", valueReference).ToString();
                }

                if (primary == PrimaryType.ByteArray)
                {
                    return builder.AppendLine("{0} = Base64.strict_decode64({0}).unpack('C*') unless {0}.to_s.empty?", valueReference).ToString();
                }

                if (primary == PrimaryType.Date)
                {
                    return builder.AppendLine("{0} = ClientRuntime::Serialization.deserialize_date({0}) unless {0}.to_s.empty?", valueReference).ToString();
                }

                if (primary == PrimaryType.DateTime)
                {
                    return builder.AppendLine("{0} = DateTime.parse({0}) unless {0}.to_s.empty?", valueReference).ToString();
                }
            }
            else if (enumType != null && !string.IsNullOrEmpty(enumType.Name))
            {
                return builder.AppendLine(
                    "fail ClientRuntime::DeserializationError.new('Error occured in deserializing the enum', nil, nil, nil) if (!{2}.nil? && !{2}.empty? && !{0}::{1}.constants.any? {{ |enum| enum.to_s == {2} }})",
                    defaultNamespace, enumType.Name, valueReference).ToString();
            }
            else if (sequence != null)
            {
                var elementVar = scope.GetVariableName("element");
                var innerSerialization = sequence.ElementType.DeserializeType(scope, elementVar, defaultNamespace);

                if (!string.IsNullOrEmpty(innerSerialization))
                {
                    return
                        builder
                            .AppendLine("if ({0})", valueReference)
                                .Indent()
                                    .AppendLine("deserialized{0} = [];", sequence.Name)
                                    .AppendLine("{0}.each do |{1}|", valueReference, elementVar)
                                    .Indent()
                                        .AppendLine(innerSerialization)
                                        .AppendLine("deserialized{0}.push({1});", sequence.Name.ToPascalCase(), elementVar)
                                    .Outdent()
                                    .AppendLine("end")
                                    .AppendLine("{0} = deserialized{1};", valueReference, sequence.Name.ToPascalCase())
                                .Outdent()
                            .AppendLine("end")
                            .ToString();
                }
            }
            else if (dictionary != null)
            {
                var valueVar = scope.GetVariableName("valueElement");
                var innerSerialization = dictionary.ValueType.DeserializeType(scope, valueVar, defaultNamespace);
                if (!string.IsNullOrEmpty(innerSerialization))
                {
                    return builder.AppendLine("if ({0})", valueReference)
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
                return builder.AppendLine("if ({0})", valueReference)
                    .Indent()
                        .AppendLine("{0} = {1}::Models::{2}.deserialize_object({0})", valueReference, defaultNamespace, composite.Name)
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
        /// <param name="defaultNamespace">Current namespace.</param>
        /// <returns>Generated Ruby code in form of string.</returns>
        public static string SerializeType(
            this IType type,
            IScopeProvider scope,
            string valueReference,
            string defaultNamespace)
        {
            var composite = type as CompositeType;
            var sequence = type as SequenceType;
            var dictionary = type as DictionaryType;
            var primary = type as PrimaryType;

            var builder = new IndentedStringBuilder("  ");

            if (primary != null)
            {
                if (primary == PrimaryType.ByteArray)
                {
                    return builder.AppendLine("{0} = Base64.strict_encode64({0}.pack('c*'))", valueReference).ToString();
                }

                if (primary == PrimaryType.DateTime)
                {
                    return builder.AppendLine("{0} = {0}.new_offset(0).strftime('%FT%TZ')", valueReference).ToString();
                }
            }
            else if (sequence != null)
            {
                var elementVar = scope.GetVariableName("element");
                var innerSerialization = sequence.ElementType.SerializeType(scope, elementVar, defaultNamespace);

                if (!string.IsNullOrEmpty(innerSerialization))
                {
                    return
                        builder
                            .AppendLine("if ({0})", valueReference)
                                .Indent()
                                    .AppendLine("serialized{0} = [];", sequence.Name)
                                    .AppendLine("{0}.each do |{1}|", valueReference, elementVar)
                                    .Indent()
                                        .AppendLine(innerSerialization)
                                        .AppendLine("serialized{0}.push({1});", sequence.Name.ToPascalCase(), elementVar)
                                    .Outdent()
                                    .AppendLine("end")
                                    .AppendLine("{0} = serialized{1};", valueReference, sequence.Name.ToPascalCase())
                                .Outdent()
                            .AppendLine("end")
                            .ToString();
                }
            }
            else if (dictionary != null)
            {
                var valueVar = scope.GetVariableName("valueElement");
                var innerSerialization = dictionary.ValueType.SerializeType(scope, valueVar, defaultNamespace);
                if (!string.IsNullOrEmpty(innerSerialization))
                {
                    return builder.AppendLine("if ({0})", valueReference)
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
                return builder.AppendLine("if ({0})", valueReference)
                    .Indent()
                        .AppendLine("{0} = {1}::Models::{2}.serialize_object({0})", valueReference, defaultNamespace, composite.Name)
                    .Outdent()
                    .AppendLine("end").ToString();
            }

            return string.Empty;
        }
    }
}
