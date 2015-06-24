// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.NodeJS.Templates
{
#line 1 "ModelIndexTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS

#line default
#line hidden
    ;
#line 2 "ModelIndexTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS.Templates

#line default
#line hidden
    ;
#line 3 "ModelIndexTemplate.cshtml"
using Microsoft.Rest.Generator.Utilities

#line default
#line hidden
    ;
#line 4 "ModelIndexTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ModelIndexTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.NodeJS.ServiceClientTemplateModel>
    {
        #line hidden
        public ModelIndexTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 6 "ModelIndexTemplate.cshtml"
Write(Header("/// "));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 7 "ModelIndexTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n/* jshint latedef:false */\r\n/* jshint forin:false */\r\n/* jshint noempty:false *" +
"/\r\n");
#line 11 "ModelIndexTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\'use strict\';\r\n");
#line 13 "ModelIndexTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 14 "ModelIndexTemplate.cshtml"
 foreach (var model in Model.ModelTemplateModels)
{

#line default
#line hidden

            WriteLiteral("exports.");
#line 16 "ModelIndexTemplate.cshtml"
     Write(model.Name);

#line default
#line hidden
            WriteLiteral(" = require(\'./");
#line 16 "ModelIndexTemplate.cshtml"
                              Write(model.Name);

#line default
#line hidden
            WriteLiteral("\');\r\n");
#line 17 "ModelIndexTemplate.cshtml"
}

#line default
#line hidden

#line 18 "ModelIndexTemplate.cshtml"
 if (!string.IsNullOrWhiteSpace(Model.PolymorphicDictionary))
{

#line default
#line hidden

            WriteLiteral("exports.discriminators = {\r\n  ");
#line 21 "ModelIndexTemplate.cshtml"
Write(Model.PolymorphicDictionary);

#line default
#line hidden
            WriteLiteral("\r\n};\r\n");
#line 23 "ModelIndexTemplate.cshtml"
}

#line default
#line hidden

        }
        #pragma warning restore 1998
    }
}
