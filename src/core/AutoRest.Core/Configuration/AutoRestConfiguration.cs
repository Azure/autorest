using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using YamlDotNet.Serialization;

namespace AutoRest.Core.Configuration
{
    public class AutoRestConfiguration
    {
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
