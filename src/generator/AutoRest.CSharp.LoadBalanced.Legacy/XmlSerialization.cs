// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Model;
using AutoRest.CSharp.LoadBalanced.Legacy.Model;

namespace AutoRest.CSharp.LoadBalanced.Legacy
{
    public static class XmlSerialization
    {
        public static readonly string XmlDeserializationClass = "XmlSerialization";

        /// <summary>
        /// Generates code for an expression of type XmlDeserializer&ltT&gt.
        /// </summary>
        public static string GenerateDeserializer(CodeModel cm, IModelType modelType, string typeName = null)
        {
            var name = typeName ?? modelType.Name;
            if (modelType is CompositeType)
                return $"{XmlDeserializationClass}.ToDeserializer(e => {name}.XmlDeserialize(e))";
            if (modelType is DictionaryType)
                return $"{XmlDeserializationClass}.CreateDictionaryXmlDeserializer({GenerateDeserializer(cm, (modelType as DictionaryType).ValueType, (modelType as DictionaryType).ValueType.AsNullableType((modelType as DictionaryTypeCs).IsNullable))})";
            if (modelType is SequenceType)
                return $"{XmlDeserializationClass}.CreateListXmlDeserializer({GenerateDeserializer(cm, (modelType as SequenceType).ElementType)}, {((modelType as SequenceType).XmlIsWrapped ? $"\"{(modelType as SequenceType).ElementXmlName}\"" : "null")})";
            if ((modelType as EnumType)?.ModelAsString == false)
                return $"{XmlDeserializationClass}.ToDeserializer(e => ({name})e.Value.Parse{modelType.Name}())";
            if ((modelType as PrimaryType)?.KnownPrimaryType == KnownPrimaryType.ByteArray)
                return $"{XmlDeserializationClass}.ToDeserializer(e => System.Convert.FromBase64String(e.Value))";
            return $"{XmlDeserializationClass}.ToDeserializer(e => ({name})e)";
        }
    }
}