// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.Azure.NodeJS.Templates
{
#line 1 "AzureModelIndexTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS

#line default
#line hidden
    ;
#line 2 "AzureModelIndexTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS.Templates

#line default
#line hidden
    ;
#line 3 "AzureModelIndexTemplate.cshtml"
using Microsoft.Rest.Generator.Utilities

#line default
#line hidden
    ;
#line 4 "AzureModelIndexTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class AzureModelIndexTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.NodeJS.ServiceClientTemplateModel>
    {
        #line hidden
        public AzureModelIndexTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 6 "AzureModelIndexTemplate.cshtml"
Write(Header("/// "));

#line default
#line hidden
            WriteLiteral("\n");
#line 7 "AzureModelIndexTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n/* jshint latedef:false */\n/* jshint forin:false */\n/* jshint noempty:false */\n");
#line 11 "AzureModelIndexTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n\'use strict\';\n");
#line 13 "AzureModelIndexTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\nvar msRestAzure = require(\'ms-rest-azure\');\n");
#line 15 "AzureModelIndexTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\nexports.Resource = msRestAzure.Resource;\nexports.CloudError = msRestAzure.CloudE" +
"rror;\n");
#line 18 "AzureModelIndexTemplate.cshtml"
 foreach (var model in Model.ModelTemplateModels)
{

#line default
#line hidden

            WriteLiteral("exports.");
#line 20 "AzureModelIndexTemplate.cshtml"
     Write(model.Name);

#line default
#line hidden
            WriteLiteral(" = require(\'./");
#line 20 "AzureModelIndexTemplate.cshtml"
                              Write(model.Name);

#line default
#line hidden
            WriteLiteral("\');\n");
#line 21 "AzureModelIndexTemplate.cshtml"
}

#line default
#line hidden

#line 22 "AzureModelIndexTemplate.cshtml"
 if (!string.IsNullOrWhiteSpace(Model.PolymorphicDictionary))
{

#line default
#line hidden

            WriteLiteral("exports.discriminators = {\n  ");
#line 25 "AzureModelIndexTemplate.cshtml"
Write(Model.PolymorphicDictionary);

#line default
#line hidden
            WriteLiteral("\n};\n");
#line 27 "AzureModelIndexTemplate.cshtml"
}

#line default
#line hidden

        }
        #pragma warning restore 1998
    }
}
