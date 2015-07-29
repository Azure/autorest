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
using System.Collections.Generic

#line default
#line hidden
    ;
#line 3 "ModelTemplate.cshtml"
using Microsoft.Rest.Generator.ClientModel

#line default
#line hidden
    ;
#line 4 "ModelTemplate.cshtml"
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
#line 7 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nvar util = require(\'util\');\r\n");
#line 9 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nvar models = require(\'./index\');\r\n");
#line 11 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n/**\r\n * @class\r\n * Initializes a new instance of the ");
#line 14 "ModelTemplate.cshtml"
                                 Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\r\n * @constructor\r\n */\r\nfunction ");
#line 17 "ModelTemplate.cshtml"
     Write(Model.Name);

#line default
#line hidden
            WriteLiteral("() { }\r\n");
#line 18 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n/**\r\n * Validate the payload against the ");
#line 20 "ModelTemplate.cshtml"
                               Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" schema\r\n *\r\n * @param {JSON} payload\r\n *\r\n */\r\n");
#line 25 "ModelTemplate.cshtml"
Write(Model.Name);

#line default
#line hidden
            WriteLiteral(".prototype.validate = function (payload) {\r\n  if (!payload) {\r\n    throw new Erro" +
"r(\'");
#line 27 "ModelTemplate.cshtml"
                 Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" cannot be null.\');\r\n  }\r\n");
#line 29 "ModelTemplate.cshtml"
  

#line default
#line hidden

#line 29 "ModelTemplate.cshtml"
    
  var propertyList = new List<Property>(Model.ComposedProperties);
  for (int i = 0; i < propertyList.Count; i++)
  {

#line default
#line hidden

            WriteLiteral("  ");
#line 33 "ModelTemplate.cshtml"
Write(Model.ValidateProperty("payload", propertyList[i]));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 34 "ModelTemplate.cshtml"
  if (i != propertyList.Count-1)
  {
  

#line default
#line hidden

#line 36 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 36 "ModelTemplate.cshtml"
            
  }
  }

#line default
#line hidden

            WriteLiteral("\r\n};\r\n");
#line 41 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n/**\r\n * Deserialize the instance to ");
#line 43 "ModelTemplate.cshtml"
                          Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" schema\r\n *\r\n * @param {JSON} instance\r\n *\r\n */\r\n");
#line 48 "ModelTemplate.cshtml"
Write(Model.Name);

#line default
#line hidden
            WriteLiteral(".prototype.deserialize = function (instance) {\r\n");
#line 49 "ModelTemplate.cshtml"
  

#line default
#line hidden

#line 49 "ModelTemplate.cshtml"
    
  var specialProperties = Model.SpecialProperties;
  if (specialProperties.Count() > 0)
  {

#line default
#line hidden

            WriteLiteral("  if (instance) {\r\n");
#line 54 "ModelTemplate.cshtml"
    var specialPropertyList = new List<Property>(Model.ComposedProperties);
    for (int i = 0; i < specialPropertyList.Count; i++)
    {

#line default
#line hidden

            WriteLiteral("    ");
#line 57 "ModelTemplate.cshtml"
  Write(Model.DeserializeProperty("instance", specialPropertyList[i]));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 58 "ModelTemplate.cshtml"
    if (i != specialPropertyList.Count - 1)
    {
    

#line default
#line hidden

#line 60 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 60 "ModelTemplate.cshtml"
              
    }
    }

#line default
#line hidden

            WriteLiteral("  }\r\n");
#line 64 "ModelTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  return instance;\r\n");
#line 66 "ModelTemplate.cshtml"
  

#line default
#line hidden

            WriteLiteral("\r\n};\r\n");
#line 68 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nmodule.exports = new ");
#line 69 "ModelTemplate.cshtml"
                 Write(Model.Name);

#line default
#line hidden
            WriteLiteral("();");
        }
        #pragma warning restore 1998
    }
}
