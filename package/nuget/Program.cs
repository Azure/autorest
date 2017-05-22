using System;
using System.Diagnostics;
using Microsoft.DotNet.PlatformAbstractions;
using System.Linq;
using System.Text;
using System.Collections.Generic;

namespace autorest_nuget
{
    class Program
    {
        private static string Os
        {
            get
            {
                switch (RuntimeEnvironment.OperatingSystemPlatform)
                {
                    case Platform.Windows:
                        return "win";
                    case Platform.Linux:
                        return "linux";
                    case Platform.Darwin:
                        return "osx";
                    default:
                        return "unknown";
                }
            }
        }

        public static string EscapeAndConcatenateArgArrayForProcessStart(IEnumerable<string> args)
        {
            return string.Join(" ", EscapeArgArray(args));
        }
        private static IEnumerable<string> EscapeArgArray(IEnumerable<string> args)
        {
            var escapedArgs = new List<string>();

            foreach (var arg in args)
            {
                escapedArgs.Add(EscapeArg(arg));
            }

            return escapedArgs;
        }
        private static string EscapeArg(string arg)
        {
            var sb = new StringBuilder();

            var quoted = ShouldSurroundWithQuotes(arg);
            if (quoted) sb.Append("\"");

            for (int i = 0; i < arg.Length; ++i)
            {
                var backslashCount = 0;

                // Consume All Backslashes
                while (i < arg.Length && arg[i] == '\\')
                {
                    backslashCount++;
                    i++;
                }

                // Escape any backslashes at the end of the arg
                // This ensures the outside quote is interpreted as
                // an argument delimiter
                if (i == arg.Length)
                {
                    sb.Append('\\', 2 * backslashCount);
                }

                // Escape any preceding backslashes and the quote
                else if (arg[i] == '"')
                {
                    sb.Append('\\', (2 * backslashCount) + 1);
                    sb.Append('"');
                }

                // Output any consumed backslashes and the character
                else
                {
                    sb.Append('\\', backslashCount);
                    sb.Append(arg[i]);
                }
            }

            if (quoted) sb.Append("\"");

            return sb.ToString();
        }

        internal static bool ShouldSurroundWithQuotes(string argument)
        {
            // Don't quote already quoted strings
            if (argument.StartsWith("\"", StringComparison.Ordinal) &&
                    argument.EndsWith("\"", StringComparison.Ordinal))
            {
                return false;
            }

            // Only quote if whitespace exists in the string
            if (argument.Contains(" ") || argument.Contains("\t") || argument.Contains("\n"))
            {
                return true;
            }

            return false;
        }


        private static string AutoRestPath
        {
            get
            {
                var current = path;
                string newPath = string.Empty;

                while (!string.IsNullOrEmpty(current))
                {
                    if (System.IO.Directory.Exists(System.IO.Path.GetFullPath($"{current}/node_modules/autorest")))
                    {
                        return System.IO.Path.GetFullPath($"{current}/node_modules/autorest/app.js");
                    }
                    newPath = System.IO.Directory.GetParent(current)?.FullName;
                    if (newPath == current)
                    {
                        return null;
                    }
                    current = newPath;
                }
                return null;
            }
        }

        private static string NodePath
        {
            get
            {
                var current = path;
                string newPath = string.Empty;

                while (!string.IsNullOrEmpty(current))
                {
                    if (System.IO.Directory.Exists(System.IO.Path.GetFullPath($"{current}/tools/{Os}-{RuntimeEnvironment.RuntimeArchitecture}")))
                    {
                        return System.IO.Path.GetFullPath($"{current}/tools/{Os}-{RuntimeEnvironment.RuntimeArchitecture}/node");
                    }
                    newPath = System.IO.Directory.GetParent(current)?.FullName;
                    if (newPath == current)
                    {
                        return null;
                    }
                    current = newPath;
                }
                return null;
            }
        }

        private static string path =  new System.Uri(System.Reflection.Assembly.GetEntryAssembly().CodeBase).LocalPath;// Microsoft.DotNet.PlatformAbstractions.ApplicationEnvironment.ApplicationBasePath;
        static void Main(string[] args)
        {
            
            Process P = null;
            
            Console.CancelKeyPress += new ConsoleCancelEventHandler((sender, e) =>
            {
                if (P != null && !P.HasExited)
                {
                    P.Kill();
                }
                Environment.Exit(0);
            });

            var rgs = string.Empty;
            try
            {
                var nodePath = NodePath;
                if (string.IsNullOrEmpty(nodePath))
                {
                    Console.Error.WriteLine($"Unable to find node.js executable in the tools path (should contain `tools/{Os}-{RuntimeEnvironment.RuntimeArchitecture}`) ");
                    Environment.Exit(1);
                }

                var autorest = AutoRestPath;
                if (string.IsNullOrEmpty(autorest))
                {
                    Console.Error.WriteLine($"Unable to find autorest/app.js in the node_modules path");
                    Environment.Exit(2);
                }
                rgs = EscapeAndConcatenateArgArrayForProcessStart(new[] { autorest }.Concat(args));
                P = System.Diagnostics.Process.Start(new ProcessStartInfo(NodePath)
                {
                    Arguments = rgs
                });
                P.WaitForExit();
                Environment.Exit(P.ExitCode);
            }
            catch
            {
                // who cares what went wrong.
            }
            if (P != null && !P.HasExited)
            {
                P.Kill();
            }

            Console.Error.WriteLine($"Error attempting to run AutoRest.\n> {NodePath} {rgs}");
            Environment.Exit(3);
        }
    }
}
