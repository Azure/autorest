// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using AutoRest.Core.Model;
using AutoRest.Extensions.Azure;
using AutoRest.Ruby.Model;

namespace AutoRest.Ruby.Azure.Model
{
    /// <summary>
    /// Model class which represents data for the rendering sdk_requirements file.
    /// </summary>
    class RequirementsRba : RequirementsRb
    {
        /// <summary>
        /// Checks whether model should be excluded from producing.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>True if should be excluded, false otherwise.</returns>
        protected override bool ExcludeModel(CompositeType model)
        {
            return (model.Extensions.ContainsKey(AzureExtensions.ExternalExtension) && 
                    (bool) model.Extensions[AzureExtensions.ExternalExtension]) 
                    || model.Name == "Resource" || model.Name == "SubResource";
        }

        /// <summary>
        /// Initializes a new instance of the AzureRequirementsTemplateModel class.
        /// </summary>
        /// <param name="serviceClient">The service client (main point of access to SDK).</param>
        /// <param name="sdkName">The name of the generated SDK, required for proper folder structuring.</param>
        /// <param name="filesExtension">The files extension.</param>
        /// <param name="ns">The namespace of the SDK.</param>
        public RequirementsRba(CodeModelRba codeModel, CodeGeneratorRba generator)
            : base(codeModel, generator)
        {
        }

        /// <summary>
        /// Returns a list of 'requires' to dependency gems but also includes azure related ones.
        /// </summary>
        /// <returns>List of all dependency gems in form of string.</returns>
        public override string GetDependencyGems()
        {
            return base.GetDependencyGems() + Environment.NewLine + "require 'ms_rest_azure'";
        }
    }
}
