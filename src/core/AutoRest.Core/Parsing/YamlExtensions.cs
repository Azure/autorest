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

        public static T ParseYaml<T>(this string yaml)
        {
            try
            {
                using (var reader = new StringReader(yaml))
                {
                    return new Deserializer().Deserialize<T>(reader);
                }
            }
            catch (Exception e)
            {
                Logger.Instance.Log(Category.Warning, "Parsed document is not valid YAML/JSON.");
                Logger.Instance.Log(Category.Warning, e.ToString());
            }
            return default(T);
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
            catch (Exception e)
            {
                Logger.Instance.Log(Category.Debug, "Parsed document is not valid YAML/JSON.");
                Logger.Instance.Log(Category.Debug, e.ToString());
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
                new YamlStream(new YamlDocument(node)).Save(writer, false);
                return writer.ToString();
            }
        }
    }
}
