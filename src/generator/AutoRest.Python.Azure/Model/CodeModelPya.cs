// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Extensions.Azure;
using AutoRest.Python.Model;

namespace AutoRest.Python.Azure.Model
{
    public class CodeModelPya : CodeModelPy
    {
        internal IList<PagePya> PageModels { get; } = new List<PagePya>();

        internal IDictionary<string, IDictionary<int, string>> PageClasses { get; } =
            new Dictionary<string, IDictionary<int, string>>();

        public IEnumerable<string> PagedClasses => PageModels.Select(t => t.TypeDefinitionName);

        public override bool HasAnyModel =>
            ModelTypes.Any(model =>
                !model.Extensions.ContainsKey(AzureExtensions.ExternalExtension) ||
                !(bool) model.Extensions[AzureExtensions.ExternalExtension]);

        public bool HasAnyLongRunOperation =>
            MethodTemplateModels.Any(m =>
                    m.Extensions.ContainsKey(AzureExtensions.LongRunningExtension) &&
                    (bool) m.Extensions[AzureExtensions.LongRunningExtension]);

        public bool HasAnyCloudErrors =>
            MethodTemplateModels.Any(item => 
                (item.DefaultResponse.Body == null) || (item.DefaultResponse.Body.Name == "CloudError"));

        public override string RequiredConstructorParameters
        {
            get
            {
                var requireParams = new List<string>();
                var optionalParams = new List<string>();
                foreach (var property in Properties)
                {
                    if (property.IsConstant)
                    {
                        continue;
                    }
                    if (property.IsRequired)
                    {
                        requireParams.Add(property.Name.ToPythonCase());
                    }
                    else
                    {
                        var defaultValue = PythonConstants.None;
                        if (!string.IsNullOrWhiteSpace(property.DefaultValue) && property.ModelType is PrimaryType)
                        {
                            defaultValue = property.DefaultValue;
                        }
                        optionalParams.Add(string.Format(CultureInfo.InvariantCulture, "{0}={1}",
                            property.Name.ToPythonCase(), defaultValue));
                    }
                }

                // The parameter without default value has to be in front of the parameters with default value
                requireParams.AddRange(optionalParams);
                var param = string.Join(", ", requireParams);
                if (!string.IsNullOrEmpty(param))
                {
                    param = ", " + param;
                }
                return param;
            }
        }

        public override string SetupRequires => "\"msrestazure>=0.4.7\"";

        public override bool NeedsExtraImport => true;

        
    }
}