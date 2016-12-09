using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using YamlDotNet.RepresentationModel;

namespace AutoRest.Core.Logging
{
    /// <summary>
    /// Represents a path into an object.
    /// </summary>
    public class ObjectPath
    {
        public static ObjectPath Empty => new ObjectPath(Enumerable.Empty<ObjectPathPart>());

        private ObjectPath(IEnumerable<ObjectPathPart> path)
        {
            Path = path;
        }

        private ObjectPath Append(ObjectPathPart part)
        {
            return new ObjectPath(Path.Concat(new[] { part }));
        }

        public ObjectPath AppendIndex(int index)
        {
            return Append(new ObjectPathPartIndex(index));
        }

        public ObjectPath AppendProperty(string property)
        {
            return Append(new ObjectPathPartProperty(property));
        }

        public IEnumerable<ObjectPathPart> Path { get; }
        
        public string XPath => "#" + string.Concat(Path.Select(p => p.XPath));

        public YamlNode SelectNode(YamlNode node)
        {
            YamlNode result = node;
            foreach (var part in Path)
            {
                result = part.SelectNode(ref node) ?? result;
            }
            return result;
        }
    }

    public abstract class ObjectPathPart
    {
        public abstract string XPath { get; }

        /// <summary>
        /// Selects the child node according to this path part.
        /// Returns null if such node was not found.
        /// </summary>
        public abstract YamlNode SelectNode(ref YamlNode node);
    }

    public class ObjectPathPartIndex : ObjectPathPart
    {
        public ObjectPathPartIndex(int index)
        {
            Index = index;
        }

        public int Index { get; }

        public override string XPath => $"[{Index + 1}]";

        public override YamlNode SelectNode(ref YamlNode node)
        {
            var snode = node as YamlSequenceNode;
            node = snode != null && 0 <= Index && Index < snode.Children.Count
                ? snode.Children[Index]
                : null;
            return node;
        }
    }

    public class ObjectPathPartProperty : ObjectPathPart
    {
        private static string SanitizeXPathProperty(string property) => property.Replace("/", "~1");

        public ObjectPathPartProperty(string property)
        {
            Property = property;
        }

        public string Property { get; }

        public override string XPath => $"/{SanitizeXPathProperty(Property)}";

        public override YamlNode SelectNode(ref YamlNode node)
        {
            var child = (node as YamlMappingNode)?.
                Children?.FirstOrDefault(pair => pair.Key.ToString().Equals(Property, StringComparison.InvariantCultureIgnoreCase));
            node = child?.Value;
            return child?.Key;
        }
    }
}
