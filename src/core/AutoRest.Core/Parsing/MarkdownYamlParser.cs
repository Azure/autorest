using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using YamlDotNet.Core;
using YamlDotNet.RepresentationModel;
using YamlDotNet.Serialization;

namespace AutoRest.Core.Parsing
{
    public class MarkdownYamlParser
    {
        public string ParseMarkdown(string markdown)
        {
            // search code blocks
            var lines = markdown.Split(new[] {"\r\n", "\r", "\n"}, StringSplitOptions.None);
            var splitLines =
                Enumerable.Range(0, lines.Length).Where(lineNo => lines[lineNo].Trim().StartsWith("```")).ToList();
            if (splitLines.Count%2 != 0)
            {
                throw new FormatException("Could not determine code blocks in provided markdown.");
            }

            // parse and merge code blocks into single syntax tree
            var mergedYaml = new YamlMappingNode();
            var d = new Deserializer();
            d.NodeDeserializers.Insert(0, new YamlBoolDeserializer());

            for (int i = 0; i < splitLines.Count; i += 2)
            {
                // get code block
                var codeBlock = new StringBuilder();
                var lineNoFrom = splitLines[i];
                var lineNoTo = splitLines[i + 1];
                for (int lineNo = lineNoFrom + 1; lineNo < lineNoTo; ++lineNo)
                {
                    codeBlock.AppendLine(lines[lineNo]);
                }

                // deserialize and merge
                var codeBlockYaml = codeBlock.ToString().ParseYaml() as YamlMappingNode;
                if (codeBlockYaml == null)
                {
                    throw new FormatException("A given code block was not a valid YAML object.");
                }
                mergedYaml = mergedYaml.MergeWith(codeBlockYaml);
            }

            // return resulting YAML
            return mergedYaml.Serialize();
        }
    }
}
