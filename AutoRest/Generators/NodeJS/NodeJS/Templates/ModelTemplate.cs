// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.NodeJS.Templates
{
#line 1 "ModelTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
#line 2 "ModelTemplate.cshtml"
using Microsoft.Rest.Generator.ClientModel

#line default
#line hidden
    ;
#line 3 "ModelTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS.TemplateModels

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ModelTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.NodeJS.ModelTemplateModel>
    {
        #line hidden
        public ModelTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
            WriteLiteral("\'use strict\';\r\n");
#line 6 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nvar util = require(\'util\');\r\n");
#line 8 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nvar models = require(\'./index\');\r\n");
#line 10 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n/**\r\n * @class\r\n * Initializes a new instance of the ");
#line 13 "ModelTemplate.cshtml"
                                 Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\r\n * @constructor\r\n */\r\nfunction ");
#line 16 "ModelTemplate.cshtml"
     Write(Model.Name);

#line default
#line hidden
            WriteLiteral("() { }\r\n");
#line 17 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n/**\r\n * Validate the payload against the ");
#line 19 "ModelTemplate.cshtml"
                               Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" schema\r\n *\r\n * @param {JSON} payload\r\n *\r\n */\r\n");
#line 24 "ModelTemplate.cshtml"
Write(Model.Name);

#line default
#line hidden
            WriteLiteral(".prototype.validate = function (payload) {\r\n  if (!payload) {\r\n    throw new Erro" +
"r(\'");
#line 26 "ModelTemplate.cshtml"
                 Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" cannot be null.\');\r\n  }\r\n");
#line 28 "ModelTemplate.cshtml"
  

#line default
#line hidden

#line 28 "ModelTemplate.cshtml"
   foreach (var property in Model.ComposedProperties)
  {

#line default
#line hidden

            WriteLiteral("  ");
#line 30 "ModelTemplate.cshtml"
Write(Model.ValidateProperty("payload", property));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 31 "ModelTemplate.cshtml"
  

#line default
#line hidden

#line 31 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 31 "ModelTemplate.cshtml"
            
  }

#line default
#line hidden

            WriteLiteral("};\r\n");
#line 34 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n/**\r\n * Deserialize the instance to ");
#line 36 "ModelTemplate.cshtml"
                          Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" schema\r\n *\r\n * @param {JSON} instance\r\n *\r\n */\r\n");
#line 41 "ModelTemplate.cshtml"
Write(Model.Name);

#line default
#line hidden
            WriteLiteral(".prototype.deserialize = function (instance) {\r\n");
#line 42 "ModelTemplate.cshtml"
  

#line default
#line hidden

#line 42 "ModelTemplate.cshtml"
    
  var specialProperties = Model.SpecialProperties;
  if (specialProperties.Count() > 0)
  {

#line default
#line hidden

            WriteLiteral("  if (instance) {\r\n");
#line 47 "ModelTemplate.cshtml"
    foreach (var property in Model.SpecialProperties)
    {

#line default
#line hidden

            WriteLiteral("    ");
#line 49 "ModelTemplate.cshtml"
  Write(Model.DeserializeProperty("instance", property));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 50 "ModelTemplate.cshtml"
    

#line default
#line hidden

#line 50 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 50 "ModelTemplate.cshtml"
              
    }

#line default
#line hidden

            WriteLiteral("  }\r\n");
#line 53 "ModelTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  return instance;\r\n");
#line 55 "ModelTemplate.cshtml"
  

#line default
#line hidden

            WriteLiteral("\r\n};\r\n");
#line 57 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nmodule.exports = new ");
#line 58 "ModelTemplate.cshtml"
                 Write(Model.Name);

#line default
#line hidden
            WriteLiteral("();");
        }
        #pragma warning restore 1998
    }
}
