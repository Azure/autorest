// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using Microsoft.Rest.Generator.Cli.Properties;
using Microsoft.Rest.Generator.Extensibility;
using Microsoft.Rest.Generator.Logging;

namespace Microsoft.Rest.Generator.Cli
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            try
            {
                if (IsShowMarkdownHelpIncluded(args))
                {
                    Console.WriteLine(HelpGenerator.Generate(Resources.HelpMarkdownTemplate));
                }
                else if (IsShowHelpIncluded(args))
                {
                    Console.WriteLine(HelpGenerator.Generate(Resources.HelpTextTemplate));
                }
                else
                {
                    Settings settings = null;
                    try
                    {
                        settings = Settings.Create(args);
                        AutoRest.Generate(settings);
                        var codeGenerator = ExtensionsLoader.GetCodeGenerator(settings);
                        Console.WriteLine(codeGenerator.UsageInstructions);
                    }
                    catch (CodeGenerationException)
                    {
                        // Do not add the CodeGenerationException again. Will be written in finally block
                    }
                    catch (Exception exception)
                    {
                        Logger.LogError(exception, exception.Message);
                    }
                    finally
                    {
                        if (
                            Logger.Entries.Any(
                                e => e.Severity == LogEntrySeverity.Error || e.Severity == LogEntrySeverity.Fatal))
                        {
                            Console.ForegroundColor = ConsoleColor.Red;
                        }
                        else if (Logger.Entries.Any(e => e.Severity == LogEntrySeverity.Warning))
                        {
                            Console.ForegroundColor = ConsoleColor.Yellow;
                        }

                        Logger.WriteErrors(Console.Error,
                            args.Any(a => "-Verbose".Equals(a, StringComparison.OrdinalIgnoreCase)));

                        Logger.WriteWarnings(Console.Out);

                        // Include LogEntrySeverity.Infos for verbose logging.
                        if (args.Any(a => "-Verbose".Equals(a, StringComparison.OrdinalIgnoreCase)))
                        {
                            Logger.WriteInfos(Console.Out);
                        }

                        if (settings != null)
                        {
                            Console.WriteLine(Resources.GenerationComplete,
                                settings.CodeGenerator, settings.Input);
                        }

                        Console.ResetColor();
                    }
                }
            }
            catch (Exception exception)
            {
                Console.Error.WriteLine(Resources.ConsoleErrorMessage, exception.Message);
                Console.Error.WriteLine(Resources.ConsoleErrorStackTrace, exception.StackTrace);
            }
        }

        /// <summary>
        /// Returns true if one of the help flags are specified among the command line arguments.
        /// Supported help flags are: '-?' '/?' '-help' and no argument at all.
        /// </summary>
        /// <param name="args">Command line arguments.</param>
        /// <returns>True if help should be shown, otherwise false.</returns>
        private static bool IsShowHelpIncluded(string[] args)
        {
            if (args == null || args.Length == 0 ||
                args.Any(a => a == "-?" || a == "/?" || "-help".Equals(a, StringComparison.OrdinalIgnoreCase)))
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// Returns true if show markdown flag is specified among the command line arguments.
        /// </summary>
        /// <param name="args">Command line arguments.</param>
        /// <returns>True if markdown formatted help should be shown, otherwise false.</returns>
        private static bool IsShowMarkdownHelpIncluded(string[] args)
        {
            if (IsShowHelpIncluded(args) &&
                args.Any(a => a == "-md" || "-markdown".Equals(a, StringComparison.OrdinalIgnoreCase)))
            {
                return true;
            }
            return false;
        }
    }
}