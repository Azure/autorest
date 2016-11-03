// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using AutoRest.Core;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Utilities;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Ruby
{
    public class GeneratorSettingsRb : IsSingleton<GeneratorSettingsRb>, IGeneratorSettings
    {
        private string _sdkName;

        /// <summary>
        ///     Relative path to produced SDK model files.
        /// </summary>
        public string modelsPath => Path.Combine(sdkPath, Settings.Instance.ModelsName.ToLowerInvariant());

        /// <summary>
        ///     Get the module declarations for the entire depth of modules generated.
        /// </summary>
        public string ModuleDeclarations
        {
            get
            {
                var modules = Regex.Split(Settings.Instance.Namespace, "::");
                var sb = new StringBuilder(modules.Length);
                for (var i = 0; i < modules.Length; i++)
                {
                    var joined = string.Join("::", modules.Take(i + 1));
                    sb.Append($"module {joined} end{Environment.NewLine}");
                }
                return sb.ToString();
            }
        }

        /// <summary>
        ///     The name of the package name to be used in creating a version.rb file
        /// </summary>
        public string packageName => Settings.Instance.PackageName;

        /// <summary>
        ///     The name of the package version to be used in creating a version.rb file
        /// </summary>
        public string packageVersion => Settings.Instance.PackageVersion;

        /// <summary>
        ///     The name of the SDK. Determined in the following way:
        ///     if the parameter 'Name' is provided that it becomes the
        ///     name of the SDK, otherwise the name of input swagger is converted
        ///     into Ruby style and taken as name.
        /// </summary>
        [SettingsInfo("SDK Name.")]
        [SettingsAlias("Name")]
        public string sdkName
        {
            get
            {
                return
                    Singleton<CodeNamerRb>.Instance.UnderscoreCase(
                        Singleton<CodeNamerRb>.Instance.RubyRemoveInvalidCharacters(
                            _sdkName.Else(
                                Path.GetFileNameWithoutExtension(Settings.Instance.Input).Else("client"))));
            }
            set { _sdkName = value; }
        }


        /// <summary>
        ///     Relative path to produced SDK files.
        /// </summary>
        public string sdkPath => packageName ?? sdkName;

        /// <summary>
        ///     Gets the brief description of the code generator.
        /// </summary>
        public virtual string Description => "Generic Ruby code generator.";

        /// <summary>
        ///     Gets the name of code generator.
        /// </summary>
        public virtual string Name => "Ruby";
    }
}