using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using AutoRest.Core.Logging;
using AutoRest.Core.Parsing;
using YamlDotNet.Core;
using YamlDotNet.Core.Events;
using YamlDotNet.Serialization;
using YamlDotNet.Serialization.NodeDeserializers;
using YamlDotNet.Serialization.ValueDeserializers;

namespace AutoRest.Core.Configuration
{
    class YamlScalarAsArrayDeserializer : INodeDeserializer
    {
        public bool Deserialize(EventReader reader, Type expectedType, Func<EventReader, Type, object> nestedObjectDeserializer, out object value)
        {
            Type innerType = null;
            if (expectedType.IsArray)
            {
                innerType = expectedType.GetElementType();
            }

            if (innerType == null)
            {
                value = null;
                return false;
            }

            INodeDeserializer innerDeserializer = new ScalarNodeDeserializer();
            if (!innerDeserializer.Deserialize(reader, innerType, nestedObjectDeserializer, out value))
            {
                return false;
            }

            value = new[] {value};
            return true;
        }
    }

    public class AutoRestConfigurationParser
    {
        public static AutoRestConfiguration Parse(string configurationText, Dictionary<string, string> settings = null)
        {
            // deliteralize
            if (!configurationText.IsYaml())
            {
                Logger.Instance.Log(Category.Info, "Parsing literate configuration");
                Func<string, string> variableEvaluator = name =>
                {
                    if (settings?.ContainsKey(name) == true)
                    {
                        return settings[name];
                    }
                    // TODO: more stuff? environment variables? simple evaluation logic (and, or, not, ...)?
                    // https://github.com/Azure/autorest/blob/master/docs/proposals/generator-specific-settings/literate-configuration.md
                    return null;
                };
                configurationText = LiterateYamlParser.Parse(configurationText, variableEvaluator);
            }

            configurationText = YamlExtensions.MergeYamlObjects(
                configurationText.ParseYaml(), 
                File.ReadAllText(Path.Combine(Path.GetDirectoryName(Assembly.GetAssembly(typeof(Settings)).Location), "AutoRest.json")).ParseYaml()).Serialize();

            // load
            var d = new Deserializer(ignoreUnmatched: true);
            d.NodeDeserializers.Add(new YamlScalarAsArrayDeserializer());
            return d.Deserialize<AutoRestConfiguration>(new StringReader(configurationText));
        }
    }
}
