using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using YamlDotNet.RepresentationModel;

namespace AutoRest.Core.Parsing
{
    public static class YamlExtensions
    {
        /// <summary>
        /// Gets the YAML syntax tree from given string. Returns null on failure.
        /// </summary>
        public static YamlNode ParseYaml(this string yaml)
        {
            YamlNode doc = null;
            try
            {
                var yamlStream = new YamlStream();
                using (var reader = new StringReader(yaml))
                {
                    yamlStream.Load(reader);
                }
                doc = yamlStream.Documents[0].RootNode;
            }
            catch
            {
                // parsing failed, return null
            }
            return doc;
        }

        /// <summary>
        /// Gets the YAML syntax tree from given string. Returns null on failure.
        /// </summary>
        public static string Serialize(this YamlNode node)
        {
            using (var writer = new StringWriter())
            {
                new YamlStream(new YamlDocument(node)).Save(writer);
                return writer.ToString();
            }
        }

        public static YamlNode ResolvePath(this YamlNode node, IEnumerable<string> path)
        {
            if (!path.Any())
                return node;

            var next = path.First();
            path = path.Skip(1);

            var mnode = node as YamlMappingNode;
            if (mnode != null)
            {
                var child = mnode.Children.FirstOrDefault(pair => pair.Key.ToString().Equals(next, StringComparison.InvariantCultureIgnoreCase));
                if (child.Value != null)
                {
                    return path.Any()
                        ? ResolvePath(child.Value, path)
                        : child.Key;
                }
            }

            var snode = node as YamlSequenceNode;
            if (snode != null)
            {
                var indexStr = next.TrimStart('[').TrimEnd(']');
                int index;
                if (int.TryParse(indexStr, out index))
                {
                    if (0 <= index && index < snode.Children.Count)
                    {
                        return snode.Children[index];
                    }
                }
            }

            return node;
        }

        public static YamlMappingNode MergeYamlObjects(YamlMappingNode a, YamlMappingNode b, string path)
        { // TODO: unify path type
            if (a == null)
            {
                throw new ArgumentNullException(nameof(a));
            }
            if (b == null)
            {
                throw new ArgumentNullException(nameof(b));
            }

            // iterate over all members
            var result = new YamlMappingNode();
            var keys = a.Children.Keys.Concat(b.Children.Keys).Distinct();
            foreach (var key in keys)
            {
                var subpath = path + "/" + key;

                // forward if only present in one of the nodes
                if (!a.Children.ContainsKey(key))
                {
                    result.Children.Add(key, b.Children[key]);
                    continue;
                }
                if (!b.Children.ContainsKey(key))
                {
                    result.Children.Add(key, a.Children[key]);
                    continue;
                }

                // try merge objects otherwise
                var aMember = a.Children[key] as YamlMappingNode;
                var bMember = b.Children[key] as YamlMappingNode;
                if (aMember == null || bMember == null)
                {
                    throw new FormatException($"{subpath} has incomaptible types.");
                }
                result.Children.Add(key, MergeYamlObjects(aMember, bMember, subpath));
            }
            return result;
        }

        public static YamlMappingNode MergeWith(this YamlMappingNode self, YamlMappingNode other)
        {
            return MergeYamlObjects(self, other, "");
        }
    }
}
