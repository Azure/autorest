// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.Cli.Properties;
using Microsoft.Rest.Generator.Logging;

namespace Microsoft.Rest.Generator.Cli
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                BaseSettings settings = null;
                try
                {
                    settings = Settings.Create(args);
                    if (settings.ShowHelp)
                    {
                        //Console.WriteLine(HelpGenerator.Generate(Resources.HelpTextTemplate, settings));
                    }
                    else
                    {
                        AutoRest.Compare(settings);
                    }
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
                    if (settings != null && !settings.ShowHelp)
                    {
                        if (Logger.Entries.Any(e => e.Severity == LogEntrySeverity.Error || e.Severity == LogEntrySeverity.Fatal))
                        {
                            Console.ForegroundColor = ConsoleColor.Red;
                            Console.WriteLine(string.Format(CultureInfo.InvariantCulture, "{0} {1}",
                                typeof(Program).Assembly.ManifestModule.Name,
                                string.Join(" ", args)));
                        }
                    }

                    // Include LogEntrySeverity.Infos for verbose logging.
                    if (args.Any(a => "-Verbose".Equals(a, StringComparison.OrdinalIgnoreCase)))
                    {
                        Console.ForegroundColor = ConsoleColor.White;
                        Logger.WriteInfos(Console.Out);
                    }

                    if (Logger.Entries.Any(
                            e => e.Severity == LogEntrySeverity.Error || e.Severity == LogEntrySeverity.Fatal))
                    {
                        Console.ForegroundColor = ConsoleColor.Red;
                        Logger.WriteErrors(Console.Error,
                            args.Any(a => "-Verbose".Equals(a, StringComparison.OrdinalIgnoreCase)));
                    }

                    if (Logger.Entries.Any(e => e.Severity == LogEntrySeverity.Warning))
                    {
                        Console.ForegroundColor = ConsoleColor.Yellow;
                        Logger.WriteWarnings(Console.Out);
                    }

                    Console.ResetColor();
                }
            }
            catch (Exception exception)
            {
                Console.Error.WriteLine(Resources.ConsoleErrorMessage, exception.Message);
                Console.Error.WriteLine(Resources.ConsoleErrorStackTrace, exception.StackTrace);
            }
        }
    }
}
