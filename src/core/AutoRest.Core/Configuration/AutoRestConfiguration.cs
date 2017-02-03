using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using YamlDotNet.Serialization;

namespace AutoRest.Core.Configuration
{
    public class AutoRestConfiguration
    {
        public static AutoRestConfiguration Create()
        {
            return AutoRestConfigurationParser.Parse("{}");
        }

        [Obsolete]
        public static AutoRestConfiguration CreateForPlugin(string codeGen)
        {
            var res = Create();
            res.CodeGenerator = codeGen;
            return res;
        }

        [YamlMember(Alias = "autorest")]
        public object AutoRest { get; set; }

        [YamlMember(Alias = "namespace")]
        public string Namespace { get; set; }

        [YamlMember(Alias = "input-file")]
        public string[] InputFiles { get; set; }

        [YamlMember(Alias = "output-folder")]
        public string OutputFolder { get; set; }

        [YamlMember(Alias = "log-file")]
        public string LogFile { get; set; }

        public string ModelsName { get; set; }
        public string ClientName { get; set; }
        public bool ValidationLinter { get; set; }
        [YamlMember(Alias = "plugins")]
        public IDictionary<string, AutoRestProviderConfiguration> Plugins { get; set; }
        public string CodeGenerator { get; set; }
        public bool AddCredentials { get; set; }

        [Obsolete("gen specific")]
        public bool DisableSimplifier { get; set; }

        public string OutputFile { get; set; }
        public string PackageName { get; set; }
        public string PackageVersion { get; set; }

        public bool Validate()
        {
            // TODO
            if (InputFiles.Length == 0)
            {
                Logger.Instance.Log(Category.Error, "Must specify at least one input file.");
                return false;
            }
            return true;
        }
    }
}
