using System;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Ruby;

namespace Microsoft.Rest.Generator.Azure.Ruby
{
    /// <summary>
    /// Model class which represents data for the rendering sdk_requirements file.
    /// </summary>
    class AzureRequirementsTemplateModel : RequirementsTemplateModel
    {
        /// <summary>
        /// Initializes a new instance of the AzureRequirementsTemplateModel class.
        /// </summary>
        /// <param name="serviceClient">The service client (main point of access to SDK).</param>
        public AzureRequirementsTemplateModel(ServiceClient serviceClient) : base(serviceClient)
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
