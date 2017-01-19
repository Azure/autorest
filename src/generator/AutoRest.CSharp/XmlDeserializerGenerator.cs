// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.CSharp.Model;
using AutoRest.Extensions;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.CSharp
{
    public static class XmlDeserializerGenerator
    {
        /// <summary>
        /// Generates code for an expression of type XmlDeserializer&ltT&gt.
        /// </summary>
        public static string Generate(CodeModel cm, IModelType modelType, string typeName = null)
        {
            var name = typeName ?? modelType.Name;
            if (modelType is CompositeType)
            {
                return $"(System.Xml.Linq.XElement parent, string propertyName, out {name} sresult) => {{ sresult = null; var element = parent.Element(propertyName); if (element == null) return false; sresult = {name}.XmlDeserialize(element); return true; }}";
                // honor user-def deserializer (problem: visibility of partial method)
                //return $"(System.Xml.Linq.XElement parent, string propertyName, out {name} sresult) => {{ sresult = null; var element = parent.Element(propertyName); if (element == null) return false; bool handled = false; {name}.TryDeserialize(\"application/xml\", element.ToString(), ref sresult, ref handled); if (handled) return true; sresult = {name}.XmlDeserialize(element); return true; }}";
            }
            if (modelType is DictionaryType)
                return $"{cm.Name}Extensions.CreateDictionaryXmlDeserializer({Generate(cm, (modelType as DictionaryType).ValueType)})";
            if (modelType is SequenceType)
                return $"{cm.Name}Extensions.CreateListXmlDeserializer({Generate(cm, (modelType as SequenceType).ElementType)}, \"{((modelType as SequenceType).XmlIsWrapped ? (modelType as SequenceType).ElementXmlName : "null")}\")";
            if ((modelType as EnumType)?.ModelAsString == false)
                return $"(System.Xml.Linq.XElement parent, string propertyName, out {name} sresult) => {{ sresult = default({name}); var element = parent.Element(propertyName); try {{ sresult = ({name})element.Value.Parse{modelType.Name}(); return true; }} catch {{ return false; }} }}";
            return $"(System.Xml.Linq.XElement parent, string propertyName, out {name} sresult) => {{ sresult = default({name}); var element = parent.Element(propertyName); if (element == null) return false; try {{ sresult = ({name})element; }} catch {{}} return true; }}";
        }
    }
}