namespace Fixtures.PetstoreV2AllSync
{
    using System.Collections;
    using System.Collections.Generic;
    using System.Xml;
    using System.Xml.Linq;
    internal static class XmlSerialization
    {
        internal delegate bool XmlRootDeserializer<T>( XElement root, out T result );
        internal delegate bool XmlDeserializer<T>( XElement parent, string propertyName, out T result );
        internal static XmlRootDeserializer<T> Root<T>( XmlDeserializer<T> deserializer ) =>
            (XElement root, out T result) => deserializer(new XElement("artificialRoot", root), root.Name.LocalName, out result);
        private static XmlDeserializer<T> Unroot<T>( XmlRootDeserializer<T> deserializer )
        {
            return (XElement parent, string propertyName, out T result) => {
                result = default(T);
                var element = parent.Element(propertyName);
                if (element == null)
                {
                    return false;
                }
                return deserializer(element, out result);
            };
        }
        private static XmlRootDeserializer<T> ToRootDeserializer<T>( System.Func<XElement, T> unsafeDeserializer )
            => (XElement root, out T result) => {
                try
                {
                    result = unsafeDeserializer(root);
                    return true;
                }
                catch
                {
                    result = default(T);
                    return false;
                }};
        internal static XmlDeserializer<T> ToDeserializer<T>( System.Func<XElement, T> unsafeDeserializer )
            => Unroot(ToRootDeserializer(unsafeDeserializer));
        internal static XmlDeserializer<IList<T>> CreateListXmlDeserializer<T>( XmlDeserializer<T> elementDeserializer, string elementTagName = null /*if isWrapped = false*/ )
        {
            if (elementTagName != null)
            {
                // create non-wrapped deserializer and forward
                var slave = CreateListXmlDeserializer( elementDeserializer );
                return (XElement parent, string propertyName, out IList<T> result) => {
                    result = null;
                    var wrapper = parent.Element(propertyName);
                    return wrapper != null && slave(wrapper, elementTagName, out result);
                };
            }
            var rootElementDeserializer = Root(elementDeserializer);
            return (XElement parent, string propertyName, out IList<T> result) => {
                result = new List<T>();
                foreach (var element in parent.Elements(propertyName))
                {
                    T elementResult;
                    if (!rootElementDeserializer(element, out elementResult))
                    {
                        return false;
                    }
                    result.Add(elementResult);
                }
                return true;
            };
        }
        internal static XmlDeserializer<IDictionary<string, T>> CreateDictionaryXmlDeserializer<T>( XmlDeserializer<T> elementDeserializer )
        {
            return (XElement parent, string propertyName, out IDictionary<string, T> result) => {
                result = null;
                var childElement = parent.Element(propertyName);
                if (childElement == null)
                {
                    return false;
                }
                result = new Dictionary<string, T>();
                foreach (var element in childElement.Elements())
                {
                    T elementResult;
                    if (!elementDeserializer(childElement, element.Name.LocalName, out elementResult))
                    {
                        return false;
                    }
                    result.Add(element.Name.LocalName, elementResult);
                }
                return true;
            };
        }
    }
}

