using System;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using YamlDotNet.RepresentationModel;

namespace AutoRest.Core.Parsing
{
    public static class LiterateYamlParser
    {
        // http://spec.commonmark.org/0.12/#fenced-code-blocks
        private class CodeFence
        {
            public string Fence { get; set; }
            public string InfoString { get; set; }
        }
        // search code blocks
        private static CodeFence TryParseCodeFence(string line)
        {
            line = line.Trim();
            var fenceChar = line.FirstOrDefault();
            var fenceLength = line.TakeWhile(c => c == fenceChar).Count();

            if ((fenceChar != '`' && fenceChar != '~') || fenceLength < 3)
            {
                return null;
            }

            return new CodeFence
            {
                Fence = line.Substring(0, fenceLength),
                InfoString = line.Substring(fenceLength).Trim()
            };
        }

        private static bool IsCodeFencePair(CodeFence open, CodeFence close)
            => open.Fence.Length <= close.Fence.Length
            && open.Fence[0] == close.Fence[0];

        public static string ResolveVariables(this string s, Func<string, string> variableEvaluator)
        {
            if (variableEvaluator == null)
            {
                variableEvaluator = v => null; // TODO: sane default?
            }

            return Regex.Replace(s, @"\$\{(?<varname>[^}]*)\}", match => variableEvaluator(match.Groups["varname"].Value));
        }

        public static string Parse(string markdown, Func<string, string> variableEvaluator = null, bool requireCodeBlocks = true)
        {
            var lines = markdown.Split(new[] { "\r\n", "\r", "\n" }, StringSplitOptions.None);

            // parse and merge code blocks into single syntax tree
            var mergedYaml = new YamlMappingNode();
            bool foundCodeBlock = false;

            for (int i = 0; i < lines.Length; i++)
            {
                CodeFence fenceOpen = TryParseCodeFence(lines[i]);
                CodeFence fenceClose;
                // get code block
                if (fenceOpen != null)
                {
                    foundCodeBlock = true;
                    var codeBlock = new StringBuilder();

                    // parse code block
                    i++;
                    while (i < lines.Length &&
                        ((fenceClose = TryParseCodeFence(lines[i])) == null || !IsCodeFencePair(fenceOpen, fenceClose)))
                    {
                        codeBlock.AppendLine(lines[i]);
                        i++;
                    }

                    // deserialize and merge
                    var guard = Regex.Match(fenceOpen.InfoString.ResolveVariables(variableEvaluator), @"enabled=(?<guard>\S+)").Groups["guard"]; // TODO: logical ops?
                    var active = !guard.Success || guard.Value == "true"; // TODO: that all? TRUE? 1? wat?

                    if (active)
                    {
                        // deserialize and merge
                        var codeBlockYaml = codeBlock.ToString().ResolveVariables(variableEvaluator).ParseYaml() as YamlMappingNode;
                        if (codeBlockYaml == null)
                        {
                            throw new FormatException("A given code block was not a valid YAML object.");
                        }
                        mergedYaml = mergedYaml.MergeWith(codeBlockYaml);
                    }
                }
            }

            if (requireCodeBlocks && !foundCodeBlock)
            {
                throw new FormatException("Require at least one code block in provided markdown.");
            }

            // return resulting YAML
            return mergedYaml.Serialize();
        }
    }
}
