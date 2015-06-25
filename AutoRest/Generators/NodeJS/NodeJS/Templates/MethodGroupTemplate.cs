// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.NodeJS.Templates
{
#line 1 "MethodGroupTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS

#line default
#line hidden
    ;
#line 2 "MethodGroupTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS.Templates

#line default
#line hidden
    ;
#line 3 "MethodGroupTemplate.cshtml"
using System.Linq;

#line default
#line hidden
    using System.Threading.Tasks;

    public class MethodGroupTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.NodeJS.MethodGroupTemplateModel>
    {
        #line hidden
        public MethodGroupTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 5 "MethodGroupTemplate.cshtml"
Write(Header("/// "));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 6 "MethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\'use strict\';\r\n");
#line 8 "MethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nvar util = require(\'util\');\r\nvar msRest = require(\'ms-rest\');\r\nvar ServiceClien" +
"t = msRest.ServiceClient;\r\nvar WebResource = msRest.WebResource;\r\n\r\n");
#line 14 "MethodGroupTemplate.cshtml"
 if (Model.ModelTypes.Any())
{

#line default
#line hidden

#line 16 "MethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 16 "MethodGroupTemplate.cshtml"
          

#line default
#line hidden

            WriteLiteral("var models = require(\'../models\');\r\n");
#line 18 "MethodGroupTemplate.cshtml"
}

#line default
#line hidden

#line 19 "MethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n/**\r\n * @class\r\n * ");
#line 22 "MethodGroupTemplate.cshtml"
Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral("\r\n * __NOTE__: An instance of this class is automatically created for an\r\n * inst" +
"ance of the ");
#line 24 "MethodGroupTemplate.cshtml"
              Write(Model.Name);

#line default
#line hidden
            WriteLiteral(".\r\n * Initializes a new instance of the ");
#line 25 "MethodGroupTemplate.cshtml"
                                Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral(" class.\r\n * @constructor\r\n *\r\n * @param {");
#line 28 "MethodGroupTemplate.cshtml"
       Write(Model.Name);

#line default
#line hidden
            WriteLiteral("} client Reference to the service client.\r\n */\r\nfunction ");
#line 30 "MethodGroupTemplate.cshtml"
     Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral("(client) {\r\n  this.client = client;\r\n}\r\n\r\n");
#line 34 "MethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 35 "MethodGroupTemplate.cshtml"
 foreach (var method in Model.MethodTemplateModels)
{

#line default
#line hidden

#line 37 "MethodGroupTemplate.cshtml"
Write(Include(new MethodTemplate(), method));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 38 "MethodGroupTemplate.cshtml"

#line default
#line hidden

#line 38 "MethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 38 "MethodGroupTemplate.cshtml"
          
}

#line default
#line hidden

#line 40 "MethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nmodule.exports = ");
#line 41 "MethodGroupTemplate.cshtml"
             Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral(";\r\n");
        }
        #pragma warning restore 1998
    }
}
