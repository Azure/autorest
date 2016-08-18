// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;

using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;


namespace AutoRest.Go.TemplateModels
{
    public class VersionTemplateModel : ServiceClient
    {
        public static readonly List<string> StandardImports = new List<string> { "fmt" };

        public readonly string PackageName;

        public VersionTemplateModel(ServiceClient serviceClient, string packageName)
        {
            this.LoadFrom(serviceClient);

            PackageName = packageName;
        }

        public virtual IEnumerable<string> Imports
        {
            get
            {
                var imports = new HashSet<string>();
                imports.UnionWith(StandardImports);
                return imports.OrderBy(i => i);
            }
        }
    }
}
