using AutoRest.Core.Logging;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using YamlDotNet.RepresentationModel;
using YamlDotNet.Serialization;

namespace AutoRest.Core.Parsing
{
    public static class YamlExtensions
    {
        private static Deserializer YamlDeserializer
        {
            get
            {
                var d = new Deserializer();
                d.NodeDeserializers.Insert(0, new YamlBoolDeserializer());
                return d;
            }
        }
        private static JsonSerializer JsonSerializer => new JsonSerializer();

        /// <summary>
        /// Checks whether given text is a YAML document.
        /// </summary>
        public static bool IsYaml(this string text) => text.ParseYaml() != null;

        /// <summary>
        /// Converts the YAML document to JSON.
        /// </summary>
        public static string EnsureYamlIsJson(this string text)
        {
            using (var reader = new StringReader(text))
            {
                using (var writer = new StringWriter(CultureInfo.CurrentCulture))
                {
                    var obj = YamlDeserializer.Deserialize(reader);
                    JsonSerializer.Serialize(writer, obj);
                    return writer.ToString();
                }
            }
        }

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
                Logger.Instance.Log(Category.Warning, "Parsed document is not valid YAML");
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

        public static YamlMappingNode MergeYamlObjects(YamlMappingNode a, YamlMappingNode b, ObjectPath path)
        {
            if (a == null)
            {
                throw new ArgumentNullException(nameof(a));
            }
            if (b == null)
            {
                throw new ArgumentNullException(nameof(b));
            }

            // iterate all members
            var result = new YamlMappingNode();
            var keys = a.Children.Keys.Concat(b.Children.Keys).Distinct();
            foreach (var key in keys)
            {
                var subpath = path.AppendProperty(key.ToString());

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
                var aMember = a.Children[key];
                var bMember = b.Children[key];
                if (aMember.Equals(bMember))
                {
                    // objects identical
                    result.Children.Add(key, aMember);
                }
                else
                {
                    var aMemberMapping = a.Children[key] as YamlMappingNode;
                    var bMemberMapping = b.Children[key] as YamlMappingNode;
                    if (aMember == null || bMember == null)
                    {
                        throw new FormatException($"{subpath} has incomaptible types.");
                    }
                    result.Children.Add(key, MergeYamlObjects(aMemberMapping, bMemberMapping, subpath));
                }
            }
            return result;
        }

        public static YamlMappingNode MergeWith(this YamlMappingNode self, YamlMappingNode other)
            => MergeYamlObjects(self, other, ObjectPath.Empty);

        public static void Set(this YamlMappingNode self, string key, YamlNode value)
            => self.Children[new YamlScalarNode(key)] = value;

        public static YamlNode Get(this YamlMappingNode self, string key)
            => self.Children[new YamlScalarNode(key)];

        public static void Remove(this YamlMappingNode self, string key)
            => self.Children.Remove(new YamlScalarNode(key));
    }
}
