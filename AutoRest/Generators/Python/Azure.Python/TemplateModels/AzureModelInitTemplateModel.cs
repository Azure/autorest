// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Python.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Generator;
using Microsoft.Rest.Generator.Python;

namespace Microsoft.Rest.Generator.Azure.Python
{
    public class AzureModelInitTemplateModel : ModelInitTemplateModel
    {
        public AzureModelInitTemplateModel(ServiceClient serviceClient, ICollection<Tuple<string, string>> pageClass)
            : base(serviceClient)
        {
            this.PagedClasses = new List<string>();
            if (pageClass != null)
            {
                foreach (var pair in pageClass)
                {
                    this.PagedClasses.Add(pair.Item1);
                }
            }
        }

        public IList<string> PagedClasses { get; private set; }
    }
}