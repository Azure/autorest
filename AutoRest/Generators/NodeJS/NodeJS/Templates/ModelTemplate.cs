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
            WriteLiteral("\'use strict\';\n");
#line 6 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\nvar util = require(\'util\');\n");
#line 8 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\nvar models = require(\'./index\');\n");
#line 10 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n/**\n * @class\n * Initializes a new instance of the ");
#line 13 "ModelTemplate.cshtml"
                                 Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\n * @constructor\n */\nfunction ");
#line 16 "ModelTemplate.cshtml"
     Write(Model.Name);

#line default
#line hidden
            WriteLiteral("() { }\n");
#line 17 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n/**\n * Validate the payload against the ");
#line 19 "ModelTemplate.cshtml"
                               Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" schema\n *\n * @param {JSON} payload\n *\n */\n");
#line 24 "ModelTemplate.cshtml"
Write(Model.Name);

#line default
#line hidden
            WriteLiteral(".prototype.validate = function (payload) {\n  if (!payload) {\n    throw new Error(" +
"\'");
#line 26 "ModelTemplate.cshtml"
                 Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" cannot be null.\');\n  }\n");
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
            WriteLiteral("\n");
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

            WriteLiteral("};\n");
#line 34 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n/**\n * Deserialize the instance to ");
#line 36 "ModelTemplate.cshtml"
                          Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" schema\n *\n * @param {JSON} instance\n *\n */\n");
#line 41 "ModelTemplate.cshtml"
Write(Model.Name);

#line default
#line hidden
            WriteLiteral(".prototype.deserialize = function (instance) {\n");
#line 42 "ModelTemplate.cshtml"
  

#line default
#line hidden

#line 42 "ModelTemplate.cshtml"
    
  var specialProperties = Model.SpecialProperties;
  if (specialProperties.Count() > 0)
  {

#line default
#line hidden

            WriteLiteral("  if (instance) {\n");
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
            WriteLiteral("\n");
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

            WriteLiteral("  }\n");
#line 53 "ModelTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  return instance;\n");
#line 55 "ModelTemplate.cshtml"
  

#line default
#line hidden

            WriteLiteral("\n};\n");
#line 57 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\nmodule.exports = new ");
#line 58 "ModelTemplate.cshtml"
                 Write(Model.Name);

#line default
#line hidden
            WriteLiteral("();");
        }
        #pragma warning restore 1998
    }
}
