// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.Azure.NodeJS.Templates
{
#line 1 "AzureServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS

#line default
#line hidden
    ;
#line 2 "AzureServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.Azure.NodeJS

#line default
#line hidden
    ;
#line 3 "AzureServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS.Templates

#line default
#line hidden
    ;
#line 4 "AzureServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.Azure.NodeJS.Templates

#line default
#line hidden
    ;
#line 5 "AzureServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.Utilities

#line default
#line hidden
    ;
#line 6 "AzureServiceClientTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class AzureServiceClientTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.Azure.NodeJS.AzureServiceClientTemplateModel>
    {
        #line hidden
        public AzureServiceClientTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 8 "AzureServiceClientTemplate.cshtml"
Write(Header("// "));

#line default
#line hidden
            WriteLiteral("\r\n/* jshint latedef:false */\r\n/* jshint forin:false */\r\n/* jshint noempty:false *" +
"/\r\n");
#line 12 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\'use strict\';\r\n");
#line 14 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nvar util = require(\'util\');\r\nvar msRest = require(\'ms-rest\');\r\nvar msRestAzure " +
"= require(\'ms-rest-azure\');\r\nvar ServiceClient = msRestAzure.AzureServiceClient;" +
"\r\nvar WebResource = msRest.WebResource;\r\n\r\n");
#line 21 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 22 "AzureServiceClientTemplate.cshtml"
 if (Model.ModelTypes.Any())
{

#line default
#line hidden

            WriteLiteral("var models = require(\'./models\');\r\n");
#line 25 "AzureServiceClientTemplate.cshtml"
}

#line default
#line hidden

#line 26 "AzureServiceClientTemplate.cshtml"
 if (Model.MethodGroups.Any())
{

#line default
#line hidden

            WriteLiteral("var operations = require(\'./operations\');\r\n");
#line 29 "AzureServiceClientTemplate.cshtml"
}

#line default
#line hidden

#line 30 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 31 "AzureServiceClientTemplate.cshtml"
  var parameters = Model.Properties.Where(p => p.IsRequired);

#line default
#line hidden

            WriteLiteral("\r\n/**\r\n * @class\r\n * Initializes a new instance of the ");
#line 34 "AzureServiceClientTemplate.cshtml"
                                Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\r\n * @constructor\r\n *\r\n");
#line 37 "AzureServiceClientTemplate.cshtml"
 foreach (var param in parameters)
{

#line default
#line hidden

            WriteLiteral(" * @param {");
#line 39 "AzureServiceClientTemplate.cshtml"
         Write(param.Type.Name);

#line default
#line hidden
            WriteLiteral("} [");
#line 39 "AzureServiceClientTemplate.cshtml"
                            Write(param.Name);

#line default
#line hidden
            WriteLiteral("] ");
#line 39 "AzureServiceClientTemplate.cshtml"
                                         Write(param.Documentation);

#line default
#line hidden
            WriteLiteral("\r\n *\r\n");
#line 41 "AzureServiceClientTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral(@" * @param {string} [baseUri] - The base URI of the service.
 *
 * @param {object} [options] - The parameter options
 *
 * @param {Array} [options.filters] - Filters to be added to the request pipeline
 *
 * @param {object} [options.requestOptions] - Options for the underlying request object
 * {@link https://github.com/request/request#requestoptions-callback Options doc}
 *
 * @param {bool} [options.noRetryPolicy] - If set to true, turn off default retry policy
 */
function ");
#line 53 "AzureServiceClientTemplate.cshtml"
     Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 53 "AzureServiceClientTemplate.cshtml"
                   Write(Model.RequiredConstructorParameters);

#line default
#line hidden
            WriteLiteral(", options) {\r\n");
#line 54 "AzureServiceClientTemplate.cshtml"
 foreach (var param in parameters)
{

#line default
#line hidden

            WriteLiteral("  if (");
#line 56 "AzureServiceClientTemplate.cshtml"
    Write(param.Name);

#line default
#line hidden
            WriteLiteral(" === null || ");
#line 56 "AzureServiceClientTemplate.cshtml"
                              Write(param.Name);

#line default
#line hidden
            WriteLiteral(" === undefined) {\r\n    throw new Error(\'\\\'");
#line 57 "AzureServiceClientTemplate.cshtml"
                     Write(param.Name);

#line default
#line hidden
            WriteLiteral("\\\' cannot be null.\');\r\n  }\r\n");
#line 59 "AzureServiceClientTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral("  ");
#line 60 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n  if (!options) options = {};\r\n  ");
#line 62 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n  ");
#line 63 "AzureServiceClientTemplate.cshtml"
Write(Model.Name);

#line default
#line hidden
            WriteLiteral("[\'super_\'].call(this, ");
#line 63 "AzureServiceClientTemplate.cshtml"
                                 Write(parameters.Any(p => p.Name == "credentials") ? "credentials" : "null");

#line default
#line hidden
            WriteLiteral(", options);\r\n  this.baseUri = baseUri;\r\n  if (!this.baseUri) {\r\n    this.baseUri " +
"= \'");
#line 66 "AzureServiceClientTemplate.cshtml"
               Write(Model.BaseUrl);

#line default
#line hidden
            WriteLiteral("\';\r\n  }\r\n");
#line 68 "AzureServiceClientTemplate.cshtml"
 foreach (var param in parameters)
{

#line default
#line hidden

            WriteLiteral("  this.");
#line 70 "AzureServiceClientTemplate.cshtml"
     Write(param.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 70 "AzureServiceClientTemplate.cshtml"
                     Write(param.Name);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 71 "AzureServiceClientTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral("  ");
#line 72 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 73 "AzureServiceClientTemplate.cshtml"
  

#line default
#line hidden

#line 73 "AzureServiceClientTemplate.cshtml"
   foreach (var property in Model.Properties.Where(p => p.DefaultValue != null))
  {

#line default
#line hidden

            WriteLiteral("  if(!this.");
#line 75 "AzureServiceClientTemplate.cshtml"
         Write(property.Name);

#line default
#line hidden
            WriteLiteral(") {\r\n    this.");
#line 76 "AzureServiceClientTemplate.cshtml"
       Write(property.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 76 "AzureServiceClientTemplate.cshtml"
                          Write(property.DefaultValue);

#line default
#line hidden
            WriteLiteral(";\r\n  }\r\n");
#line 78 "AzureServiceClientTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  \r\n");
#line 80 "AzureServiceClientTemplate.cshtml"
  

#line default
#line hidden

#line 80 "AzureServiceClientTemplate.cshtml"
   foreach (var methodGroup in Model.MethodGroupModels)
  {

#line default
#line hidden

            WriteLiteral("  this.");
#line 82 "AzureServiceClientTemplate.cshtml"
     Write(methodGroup.MethodGroupName);

#line default
#line hidden
            WriteLiteral(" = new operations.");
#line 82 "AzureServiceClientTemplate.cshtml"
                                                     Write(methodGroup.MethodGroupType);

#line default
#line hidden
            WriteLiteral("(this);\r\n");
#line 83 "AzureServiceClientTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  \r\n");
#line 85 "AzureServiceClientTemplate.cshtml"
  

#line default
#line hidden

#line 85 "AzureServiceClientTemplate.cshtml"
   if (Model.ModelTypes.Any())
  {

#line default
#line hidden

            WriteLiteral("  this._models = models;\r\n");
#line 88 "AzureServiceClientTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("}\r\n\r\n");
#line 91 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nutil.inherits(");
#line 92 "AzureServiceClientTemplate.cshtml"
         Write(Model.Name);

#line default
#line hidden
            WriteLiteral(", ServiceClient);\r\n");
#line 93 "AzureServiceClientTemplate.cshtml"
 foreach (var method in Model.MethodTemplateModels)
{

#line default
#line hidden

#line 95 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 95 "AzureServiceClientTemplate.cshtml"
          

#line default
#line hidden

#line 96 "AzureServiceClientTemplate.cshtml"
Write(Include(new AzureMethodTemplate(), method as AzureMethodTemplateModel));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 97 "AzureServiceClientTemplate.cshtml"
}

#line default
#line hidden

#line 98 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nmodule.exports = ");
#line 99 "AzureServiceClientTemplate.cshtml"
            Write(Model.Name);

#line default
#line hidden
            WriteLiteral(";");
        }
        #pragma warning restore 1998
    }
}
