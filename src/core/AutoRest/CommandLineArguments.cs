using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using AutoRest.Core.Logging;

namespace AutoRest
{
    internal class CommandLineArguments
    {
        public static CommandLineArguments Parse(string[] args)
        {
            var result = new CommandLineArguments();

            foreach (var arg in args)
            {
                var setting = Regex.Match(arg, @"--(?<key>.+?)=(?<value>.+)");
                var configurationFilePathMatch = Regex.Match(arg, @".+?\.md");
                if (setting.Success)
                {
                    var key = setting.Groups["key"].Value;
                    var value = setting.Groups["value"].Value;
                    if (result.Settings.ContainsKey(key))
                    {
                        Logger.Instance.Log(Category.Warning, $"Duplicate setting '{key}'");
                        return null;
                    }
                    result.Settings[key] = value;
                }
                else if(configurationFilePathMatch.Success)
                {
                    if (result.ConfigurationFilePath != null)
                    {
                        Logger.Instance.Log(Category.Warning, $"Multiple configuration files specified: '{result.ConfigurationFilePath}', '{configurationFilePathMatch.Value}'");
                        return null;
                    }
                    result.ConfigurationFilePath = configurationFilePathMatch.Value;
                }
                else if (arg == "help")
                {
                    if (result.Help)
                    {
                        Logger.Instance.Log(Category.Warning, "Multiple mentions of 'help'");
                        return null;
                    }
                    result.Help = true;
                }
                else
                {
                    Logger.Instance.Log(Category.Warning, $"Unrecognized argument '{arg}'");
                    return null;
                }
            }

            return result;
        }

        public bool Help { get; set; }

        public string ConfigurationFilePath { get; set; }

        public Dictionary<string, string> Settings { get; set; } = new Dictionary<string, string>();
    }
}
