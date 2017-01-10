// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Logging;
using AutoRest.Core.Utilities;
using AutoRest.Properties;
using AutoRest.Simplify;
using static AutoRest.Core.Utilities.DependencyInjection;
using System.IO;
using AutoRest.Core.Parsing;
using YamlDotNet.RepresentationModel;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace AutoRest
{
    internal class Program
    {
        private static int Main(string[] args)
        {
            int exitCode = (int)ExitCode.Error;

            try
            {
                using (NewContext)
                {
                    bool generationFailed = false;
                    Settings settings = null;
                    try
                    {
                        settings = Settings.Create(args);

                        // set up logging
                        Logger.Instance.AddListener(new ConsoleLogListener(
                            settings.Debug ? Category.Debug : Category.Warning,
                            settings.ValidationLevel,
                            settings.Verbose));
                        Logger.Instance.AddListener(new SignalingLogListener(Category.Error, _ => generationFailed = true));

                        // internal preprocesor
                        if (settings.Preprocessor)
                        {
                            Console.Write(InternalPreprocessor(settings.FileSystem.ReadFileAsText(settings.Input)));
                            return 0;
                        }

                        // determine some reasonable default namespace
                        if (settings.Namespace == null)
                        {
                            if (settings.Input != null)
                            {
                                settings.Namespace = Path.GetFileNameWithoutExtension(settings.Input);
                            }
                            else if (settings.InputFolder != null)
                            {
                                settings.Namespace = Path.GetFileNameWithoutExtension(settings.InputFolder.Segments.Last().Trim('/'));
                            }
                            else
                            {
                                settings.Namespace = "default";
                            }
                        }

                        string defCodeGen = (args.Where(arg => arg.ToLowerInvariant().Contains("codegenerator")).IsNullOrEmpty()) ? "" : settings.CodeGenerator;
                        if (settings.ShowHelp && IsShowMarkdownHelpIncluded(args))
                        {
                            settings.CodeGenerator = defCodeGen;
                            Console.WriteLine(HelpGenerator.Generate(Resources.HelpMarkdownTemplate, settings));
                        }
                        else if (settings.ShowHelp)
                        {
                            settings.CodeGenerator = defCodeGen;
                            Console.WriteLine(HelpGenerator.Generate(Resources.HelpTextTemplate, settings));
                        }
                        else if (!string.IsNullOrEmpty(settings.Previous))
                        {
                            Core.AutoRestController.Compare();
                        }
                        else
                        {
                            Core.AutoRestController.Generate();
                            if (!Settings.Instance.DisableSimplifier && Settings.Instance.CodeGenerator.IndexOf("csharp", StringComparison.OrdinalIgnoreCase) > -1)
                            {
                                new CSharpSimplifier().Run().ConfigureAwait(false).GetAwaiter().GetResult();
                            }
                        }
                    }
                    catch (Exception exception)
                    {
                        Logger.Instance.Log(Category.Error, exception.Message);
                    }
                    finally
                    {
                        if (settings != null && !settings.ShowHelp)
                        {
                            if (generationFailed)
                            {
                                if (!"None".EqualsIgnoreCase(settings.CodeGenerator))
                                {
                                    Logger.Instance.Log(Category.Error, Resources.GenerationFailed);
                                    Logger.Instance.Log(Category.Error, "{0} {1}",
                                        typeof(Program).Assembly.ManifestModule.Name, string.Join(" ", args));
                                }
                            }
                            else
                            {
                                if (!"None".EqualsIgnoreCase(settings.CodeGenerator))
                                {
                                    Logger.Instance.Log(Category.Info, Resources.GenerationComplete,
                                        settings.CodeGenerator, settings.Input);
                                }
                                exitCode = (int)ExitCode.Success;
                            }
                        }
                    }
                }
            }
            catch (Exception exception)
            {
                Console.Error.WriteLine(Resources.ConsoleErrorMessage, exception.Message);
                Console.Error.WriteLine(Resources.ConsoleErrorStackTrace, exception.StackTrace);
            }
            return exitCode;
        }

        /// <summary>
        /// Returns true if show markdown flag is specified among the command line arguments.
        /// </summary>
        /// <param name="args">Command line arguments.</param>
        /// <returns>True if markdown formatted help should be shown, otherwise false.</returns>
        private static bool IsShowMarkdownHelpIncluded(string[] args)
        {
            if (args.Any(a => a == "-md" || "-markdown".EqualsIgnoreCase(a)))
            {
                return true;
            }
            return false;
        }

        private static string InternalPreprocessor(string preSwagger)
        {
            var yaml = preSwagger.ParseYaml() as YamlMappingNode;

            Func<string, string> getNameFromRefPath = refPath =>
            {
                var match = Regex.Match(refPath, $@"\#\/[^/]*/(?<name>.*)");
                return match.Success
                    ? match.Groups["name"].Value
                    : null;
            };
            Func<string, string> getSectionFromRefPath = refPath =>
            {
                var match = Regex.Match(refPath, $@"\#\/(?<section>[^/]*)/.*");
                return match.Success
                    ? match.Groups["section"].Value
                    : null;
            };

            string incKey = "$inc";

            // resolve sequence-style headers (special case, you don't want to end up with a sequence of resolved stuff here)
            var headersSection = yaml?.Get("headers") as YamlMappingNode;
            if (headersSection != null)
            {
                // find response headers
                var paths1 = (yaml.Get("paths") as YamlMappingNode)?.Select(x => x.Value) ?? new YamlNode[0];
                var paths2 = (yaml.Get("x-ms-paths") as YamlMappingNode)?.Select(x => x.Value) ?? new YamlNode[0];
                var operations = paths1.Concat(paths2).OfType<YamlMappingNode>().SelectMany(x => x.Children).Select(x => x.Value).OfType<YamlMappingNode>();
                var responses = operations.Select(x => x.Get("responses")).OfType<YamlMappingNode>();
                var statusCodes = responses.SelectMany(x => x.Children).Select(x => x.Value).OfType<YamlMappingNode>();
                foreach (var statusCode in statusCodes.ToList())
                {
                    var headersNodeSequence = statusCode.Get("headers") as YamlSequenceNode;
                    if (headersNodeSequence != null)
                    {
                        var headersNodeMapping = new YamlMappingNode();
                        foreach (var refPath in headersNodeSequence.Children.OfType<YamlMappingNode>().Select(x => x.Get(incKey)).OfType<YamlScalarNode>().Select(x => x.Value))
                        {
                            var refName = getNameFromRefPath(refPath);
                            headersNodeMapping.Add(refName, headersSection.Get(refName));
                        }
                        statusCode.Set("headers", headersNodeMapping);
                    }
                }

                yaml.Remove("headers");
            }

            // handle all includes
            YamlMappingNode incable;
            while (null != (incable = yaml.AllNodes.OfType<YamlMappingNode>().FirstOrDefault(x => x.Get(incKey) != null)))
            {
                var refPath = (incable.Get(incKey) as YamlScalarNode)?.Value;
                var refName = getNameFromRefPath(refPath);
                var refSection = getSectionFromRefPath(refPath);
                var refedNode = (yaml.Get(refSection) as YamlMappingNode).Get(refName) as YamlMappingNode;
                if (refedNode == null)
                {
                    throw new Exception($"Cannot include {refPath} because it does not exist.");
                }
                var incableNew = incable.MergeWith(refedNode);
                incableNew.Remove(incKey);
                incable.Children.Clear();
                foreach (var child in incableNew.Children)
                {
                    incable.Children.Add(child.Key, child.Value);
                }
            }

            return yaml.Serialize();
        }
    }
}