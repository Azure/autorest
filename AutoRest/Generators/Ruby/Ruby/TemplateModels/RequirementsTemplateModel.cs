// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Ruby
{
    /// <summary>
    /// The model for requirements template (the main file which contains list of autoloading files).
    /// </summary>
    public class RequirementsTemplateModel : ServiceClient
    {
        /// <summary>
        /// Number of spaces between class name and file name required for better readability.
        /// </summary>
        private const int SpacingForAutoload = 50;

        /// <summary>
        /// The name of the SDK.
        /// </summary>
        private readonly string sdkName;

        /// <summary>
        /// Files extensions.
        /// </summary>
        private readonly string implementationFileExtension;

        /// <summary>
        /// Returns the ordered list of models. Ordered means that if some model has
        /// another model as a base then the base will be before the model in the list.
        /// </summary>
        /// <returns>The ordered list of models.</returns>
        private IEnumerable<CompositeType> GetOrderedModels()
        {
            List<CompositeType> resultModels = new List<CompositeType>();
            List<CompositeType> models = new List<CompositeType>(this.ModelTypes);

            // Doing iteratively the following step:
            // selecting independent models from the current models list
            // and pushing them into result list until initial models list
            // become empty.
            while (models.Any())
            {
                var independentModels = models.Where(t => !models.Contains(t.BaseModelType)).ToArray();

                resultModels.AddRange(independentModels);
                models = models.Except(independentModels).ToList();
            }

            return resultModels;
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

            return string.Format("autoload :{0},{1}'{2}/{3}'", typeName, spacing, this.sdkName, fileName);
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

        /// <summary>
        /// Initializes a new instance of RequirementsTemplateModel class.
        /// </summary>
        /// <param name="serviceClient">The service client.</param>
        /// <param name="sdkName">The name of the SDK.</param>
        /// <param name="implementationFileExtension">The files extension.</param>
        public RequirementsTemplateModel(ServiceClient serviceClient, string sdkName, string implementationFileExtension)
        {
            this.LoadFrom(serviceClient);
            this.sdkName = sdkName;
            this.implementationFileExtension = implementationFileExtension;
        }

        /// <summary>
        /// Returns the API client fils for 'autoloading'.
        /// </summary>
        /// <returns>The API client client name in form of string.</returns>
        public string GetClientRequiredFile()
        {
            return this.GetAutoloadFormat(this.Name, RubyCodeNamer.UnderscoreCase(this.Name) + this.implementationFileExtension);
        }

        /// <summary>
        /// Returns a list of methods groups for 'autoloading' them.
        /// </summary>
        /// <returns>Method groups list in form of string.</returns>
        public string GetOperationsRequiredFiles()
        {
            var sb = new IndentedStringBuilder();

            this.MethodGroups.ForEach(method => sb.AppendLine("{0}",
                this.GetAutoloadFormat(method, RubyCodeNamer.UnderscoreCase(method) + this.implementationFileExtension)));

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
                .ForEach(model => sb.AppendLine(this.GetAutoloadFormat(model.Name, "models/" + RubyCodeNamer.UnderscoreCase(model.Name) + this.implementationFileExtension)));

            this.EnumTypes.ForEach(enumType => sb.AppendLine(this.GetAutoloadFormat(enumType.Name, "models/" + RubyCodeNamer.UnderscoreCase(enumType.Name) + this.implementationFileExtension)));

            return sb.ToString();
        }

        /// <summary>
        /// Returns a list of dependency gems.
        /// </summary>
        /// <returns>The list of 'required' gems in form of string.</returns>
        public virtual string GetDependencyGems()
        {
            return @"require 'uri'
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
        }
    }
}
