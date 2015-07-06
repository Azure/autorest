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
            WriteLiteral("\n");
#line 6 "MethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n\'use strict\';\n");
#line 8 "MethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\nvar util = require(\'util\');\nvar msRest = require(\'ms-rest\');\nvar ServiceClient =" +
" msRest.ServiceClient;\nvar WebResource = msRest.WebResource;\n\n");
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

            WriteLiteral("var models = require(\'../models\');\n");
#line 18 "MethodGroupTemplate.cshtml"
}

#line default
#line hidden

#line 19 "MethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n/**\n * @class\n * ");
#line 22 "MethodGroupTemplate.cshtml"
Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral("\n * __NOTE__: An instance of this class is automatically created for an\n * instan" +
"ce of the ");
#line 24 "MethodGroupTemplate.cshtml"
              Write(Model.Name);

#line default
#line hidden
            WriteLiteral(".\n * Initializes a new instance of the ");
#line 25 "MethodGroupTemplate.cshtml"
                                Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral(" class.\n * @constructor\n *\n * @param {");
#line 28 "MethodGroupTemplate.cshtml"
       Write(Model.Name);

#line default
#line hidden
            WriteLiteral("} client Reference to the service client.\n */\nfunction ");
#line 30 "MethodGroupTemplate.cshtml"
     Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral("(client) {\n  this.client = client;\n}\n\n");
#line 34 "MethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n");
#line 35 "MethodGroupTemplate.cshtml"
 foreach (var method in Model.MethodTemplateModels)
{

#line default
#line hidden

#line 37 "MethodGroupTemplate.cshtml"
Write(Include(new MethodTemplate(), method));

#line default
#line hidden
            WriteLiteral("\n");
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
            WriteLiteral("\nmodule.exports = ");
#line 41 "MethodGroupTemplate.cshtml"
             Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral(";\n");
        }
        #pragma warning restore 1998
    }
}
