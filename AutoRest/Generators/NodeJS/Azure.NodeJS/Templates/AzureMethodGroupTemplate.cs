// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.Azure.NodeJS.Templates
{
#line 1 "AzureMethodGroupTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS

#line default
#line hidden
    ;
#line 2 "AzureMethodGroupTemplate.cshtml"
using Microsoft.Rest.Generator.Azure.NodeJS

#line default
#line hidden
    ;
#line 3 "AzureMethodGroupTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS.Templates

#line default
#line hidden
    ;
#line 4 "AzureMethodGroupTemplate.cshtml"
using Microsoft.Rest.Generator.Azure.NodeJS.Templates

#line default
#line hidden
    ;
#line 5 "AzureMethodGroupTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class AzureMethodGroupTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.Azure.NodeJS.AzureMethodGroupTemplateModel>
    {
        #line hidden
        public AzureMethodGroupTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 7 "AzureMethodGroupTemplate.cshtml"
Write(Header("/// "));

#line default
#line hidden
            WriteLiteral("\n");
#line 8 "AzureMethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n\'use strict\';\n");
#line 10 "AzureMethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\nvar util = require(\'util\');\nvar msRest = require(\'ms-rest\');\nvar msRestAzure = r" +
"equire(\'ms-rest-azure\');\nvar ServiceClient = msRest.ServiceClient;\nvar WebResour" +
"ce = msRest.WebResource;\n\n");
#line 17 "AzureMethodGroupTemplate.cshtml"
 if (Model.ModelTypes.Any())
{

#line default
#line hidden

#line 19 "AzureMethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 19 "AzureMethodGroupTemplate.cshtml"
          

#line default
#line hidden

            WriteLiteral("var models = require(\'../models\');\n");
#line 21 "AzureMethodGroupTemplate.cshtml"
}

#line default
#line hidden

#line 22 "AzureMethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n/**\n * @class\n * ");
#line 25 "AzureMethodGroupTemplate.cshtml"
Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral("\n * __NOTE__: An instance of this class is automatically created for an\n * instan" +
"ce of the ");
#line 27 "AzureMethodGroupTemplate.cshtml"
              Write(Model.Name);

#line default
#line hidden
            WriteLiteral(".\n * Initializes a new instance of the ");
#line 28 "AzureMethodGroupTemplate.cshtml"
                                Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral(" class.\n * @constructor\n *\n * @param {");
#line 31 "AzureMethodGroupTemplate.cshtml"
       Write(Model.Name);

#line default
#line hidden
            WriteLiteral("} client Reference to the service client.\n */\nfunction ");
#line 33 "AzureMethodGroupTemplate.cshtml"
     Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral("(client) {\n  this.client = client;\n}\n\n");
#line 37 "AzureMethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n");
#line 38 "AzureMethodGroupTemplate.cshtml"
 foreach (var method in Model.MethodTemplateModels)
{

#line default
#line hidden

#line 40 "AzureMethodGroupTemplate.cshtml"
Write(Include(new AzureMethodTemplate(), method as AzureMethodTemplateModel));

#line default
#line hidden
            WriteLiteral("\n");
#line 41 "AzureMethodGroupTemplate.cshtml"

#line default
#line hidden

#line 41 "AzureMethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 41 "AzureMethodGroupTemplate.cshtml"
          
}

#line default
#line hidden

#line 43 "AzureMethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\nmodule.exports = ");
#line 44 "AzureMethodGroupTemplate.cshtml"
             Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral(";\n");
        }
        #pragma warning restore 1998
    }
}
