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
            WriteLiteral("\r\n");
#line 8 "AzureMethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\'use strict\';\r\n");
#line 10 "AzureMethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nvar util = require(\'util\');\r\nvar msRest = require(\'ms-rest\');\r\nvar msRestAzure " +
"= require(\'ms-rest-azure\');\r\nvar ServiceClient = msRest.ServiceClient;\r\nvar WebR" +
"esource = msRest.WebResource;\r\n\r\n");
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

            WriteLiteral("var models = require(\'../models\');\r\n");
#line 21 "AzureMethodGroupTemplate.cshtml"
}

#line default
#line hidden

#line 22 "AzureMethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n/**\r\n * @class\r\n * ");
#line 25 "AzureMethodGroupTemplate.cshtml"
Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral("\r\n * __NOTE__: An instance of this class is automatically created for an\r\n * inst" +
"ance of the ");
#line 27 "AzureMethodGroupTemplate.cshtml"
              Write(Model.Name);

#line default
#line hidden
            WriteLiteral(".\r\n * Initializes a new instance of the ");
#line 28 "AzureMethodGroupTemplate.cshtml"
                                Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral(" class.\r\n * @constructor\r\n *\r\n * @param {");
#line 31 "AzureMethodGroupTemplate.cshtml"
       Write(Model.Name);

#line default
#line hidden
            WriteLiteral("} client Reference to the service client.\r\n */\r\nfunction ");
#line 33 "AzureMethodGroupTemplate.cshtml"
     Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral("(client) {\r\n  this.client = client;\r\n}\r\n\r\n");
#line 37 "AzureMethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 38 "AzureMethodGroupTemplate.cshtml"
 foreach (var method in Model.MethodTemplateModels)
{

#line default
#line hidden

#line 40 "AzureMethodGroupTemplate.cshtml"
Write(Include(new AzureMethodTemplate(), method as AzureMethodTemplateModel));

#line default
#line hidden
            WriteLiteral("\r\n");
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
            WriteLiteral("\r\nmodule.exports = ");
#line 44 "AzureMethodGroupTemplate.cshtml"
             Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral(";\r\n");
        }
        #pragma warning restore 1998
    }
}
