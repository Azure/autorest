// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Ruby.Model
{
    /// <summary>
    /// The model for requirements template (the main file which contains list of autoloading files).
    /// </summary>
    public class RequirementsRb
    {
        /// <summary>
        /// Name of the generated sub-folder inside ourput directory.
        /// </summary>
        private const string GeneratedFolderName = "generated";

        /// <summary>
        /// Format for the autoload module.
        /// </summary>
        private const string AutoloadFormat = "autoload :{0},{1}'" + GeneratedFolderName + "/{2}/{3}'";

        /// <summary>
        /// Number of spaces between class name and file name required for better readability.
        /// </summary>
        private const int SpacingForAutoload = 50;

        /// <summary>
        /// Returns the ordered list of models. Ordered means that if some model has
        /// another model as a base then the base will be before the model in the list.
        /// </summary>
        /// <returns>The ordered list of models.</returns>
        private IEnumerable<CompositeType> GetOrderedModels()
        {
            return CodeModel.ModelTypes.OrderBy(each => each, CompositeType.Comparer);
        }

        /// <summary>
        /// Returns the formatted type and file name for 'autoload'ing it.
        /// </summary>
        /// <param name="typeName">The name of the type.</param>
        /// <param name="fileName">The name of the file.</param>
        /// <returns>File formatted for 'autoload'.</returns>
        private string GetAutoloadFormat(string typeName, string fileName)
        {
            string spacing;

            if (typeName.Length >= SpacingForAutoload)
            {
                spacing = " ";
            }
            else
            {
                var sb = new StringBuilder();
                for (var i = 0; i < SpacingForAutoload - typeName.Length + 1; i++)
                {
                    sb.Append(' ');
                }

                spacing = sb.ToString();
            }

            return string.Format(AutoloadFormat, typeName, spacing, GeneratorSettingsRb.Instance.packageName ?? GeneratorSettingsRb.Instance.sdkName, fileName);
        }

        /// <summary>
        /// Checks whether model should be excluded from producing.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>True if should be excluded, false otherwise.</returns>
        protected virtual bool ExcludeModel(CompositeType model)
        {
            return false;
        }

        protected CodeModelRb CodeModel { get; private set; }
        protected CodeGeneratorRb Generator { get; private set; }
        public CodeNamerRb CodeNamer => Singleton<CodeNamer>.Instance as CodeNamerRb;

        // public RequirementsTemplateModel(ServiceClient serviceClient, string sdkName, string implementationFileExtension, string ns)
        public RequirementsRb(CodeModelRb codeModel, CodeGeneratorRb generator)
        {
            CodeModel = codeModel;
            Generator = generator;
        }

        /// <summary>
        /// Returns the API client fils for 'autoloading'.
        /// </summary>
        /// <returns>The API client client name in form of string.</returns>
        public string GetClientRequiredFile()
        {
            return this.GetAutoloadFormat(CodeModel.Name, CodeNamer.UnderscoreCase(CodeModel.Name) + Generator.ImplementationFileExtension);
        }

        /// <summary>
        /// Returns a list of methods groups for 'autoloading' them.
        /// </summary>
        /// <returns>Method groups list in form of string.</returns>
        public string GetOperationsRequiredFiles()
        {
            var sb = new IndentedStringBuilder();

            CodeModel.MethodGroupNames.ForEach(method => sb.AppendLine("{0}",
                this.GetAutoloadFormat(method, CodeNamer.UnderscoreCase(method) + Generator.ImplementationFileExtension)));

            return sb.ToString();
        }

        /// <summary>
        /// Returns the list of model files for 'autoloading' them.
        /// </summary>
        /// <returns>Model files list in form of string.</returns>
        public string GetModelsRequiredFiles()
        {
            var sb = new IndentedStringBuilder();

            this.GetOrderedModels()
                .Where(m => !ExcludeModel(m))
                .ForEach(model => sb.AppendLine(this.GetAutoloadFormat(model.Name, "models/" + CodeNamer.UnderscoreCase(model.Name) + Generator.ImplementationFileExtension)));

            CodeModel.EnumTypes.Cast<EnumTypeRb>().ForEach(enumType => sb.AppendLine(this.GetAutoloadFormat(enumType.ModuleName, "models/" + CodeNamer.UnderscoreCase(enumType.Name) + Generator.ImplementationFileExtension)));

            return sb.ToString();
        }

        /// <summary>
        /// Returns a list of dependency gems.
        /// </summary>
        /// <returns>The list of 'required' gems in form of string.</returns>
        public virtual string GetDependencyGems()
        {
            var requirements = @"require 'uri'
require 'cgi'
require 'date'
require 'json'
require 'base64'
require 'erb'
require 'securerandom'
require 'time'
require 'timeliness'
require 'faraday'
require 'faraday-cookie_jar'
require 'concurrent'
require 'ms_rest'";

            if(!string.IsNullOrWhiteSpace(Settings.Instance.Namespace))
            {
                requirements = requirements 
                    + Environment.NewLine 
                    + string.Format(CultureInfo.InvariantCulture, "require '{0}/{1}/module_definition'", GeneratedFolderName, GeneratorSettingsRb.Instance.packageName ?? GeneratorSettingsRb.Instance.sdkName);
            }

            return requirements;
        }
    }
}
