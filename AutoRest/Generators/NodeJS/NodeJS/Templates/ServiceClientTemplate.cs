// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.NodeJS.Templates
{
#line 1 "ServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS

#line default
#line hidden
    ;
#line 2 "ServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS.Templates

#line default
#line hidden
    ;
#line 3 "ServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.Utilities

#line default
#line hidden
    ;
#line 4 "ServiceClientTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ServiceClientTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.NodeJS.ServiceClientTemplateModel>
    {
        #line hidden
        public ServiceClientTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 6 "ServiceClientTemplate.cshtml"
Write(Header("/// "));

#line default
#line hidden
            WriteLiteral("\r\n/* jshint latedef:false */\r\n/* jshint forin:false */\r\n/* jshint noempty:false *" +
"/\r\n");
#line 10 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\'use strict\';\r\n");
#line 12 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nvar util = require(\'util\');\r\nvar msRest = require(\'ms-rest\');\r\nvar ServiceClien" +
"t = msRest.ServiceClient;\r\nvar WebResource = msRest.WebResource;\r\n\r\n");
#line 18 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 19 "ServiceClientTemplate.cshtml"
 if (Model.ModelTypes.Any())
{

#line default
#line hidden

            WriteLiteral("var models = require(\'./models\');\r\n");
#line 22 "ServiceClientTemplate.cshtml"
}

#line default
#line hidden

#line 23 "ServiceClientTemplate.cshtml"
 if (Model.MethodGroups.Any())
{

#line default
#line hidden

            WriteLiteral("var operations = require(\'./operations\');\r\n");
#line 26 "ServiceClientTemplate.cshtml"
}

#line default
#line hidden

#line 27 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 28 "ServiceClientTemplate.cshtml"
  var parameters = Model.Properties.Where(p => p.IsRequired);

#line default
#line hidden

            WriteLiteral("\r\n/**\r\n * @class\r\n * Initializes a new instance of the ");
#line 31 "ServiceClientTemplate.cshtml"
                                Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\r\n * @constructor\r\n *\r\n");
#line 34 "ServiceClientTemplate.cshtml"
 foreach (var param in parameters)
{

#line default
#line hidden

            WriteLiteral(" * @param {");
#line 36 "ServiceClientTemplate.cshtml"
         Write(param.Type.Name);

#line default
#line hidden
            WriteLiteral("} [");
#line 36 "ServiceClientTemplate.cshtml"
                            Write(param.Name);

#line default
#line hidden
            WriteLiteral("] ");
#line 36 "ServiceClientTemplate.cshtml"
                                         Write(param.Documentation);

#line default
#line hidden
            WriteLiteral("\r\n *\r\n");
#line 38 "ServiceClientTemplate.cshtml"
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
#line 50 "ServiceClientTemplate.cshtml"
     Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 50 "ServiceClientTemplate.cshtml"
                   Write(Model.RequiredConstructorParameters);

#line default
#line hidden
            WriteLiteral(", options) {\r\n");
#line 51 "ServiceClientTemplate.cshtml"
 foreach (var param in parameters)
{

#line default
#line hidden

            WriteLiteral("  if (");
#line 53 "ServiceClientTemplate.cshtml"
    Write(param.Name);

#line default
#line hidden
            WriteLiteral(" === null || ");
#line 53 "ServiceClientTemplate.cshtml"
                              Write(param.Name);

#line default
#line hidden
            WriteLiteral(" === undefined) {\r\n    throw new Error(\'\\\'");
#line 54 "ServiceClientTemplate.cshtml"
                     Write(param.Name);

#line default
#line hidden
            WriteLiteral("\\\' cannot be null.\');\r\n  }\r\n");
#line 56 "ServiceClientTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral("  ");
#line 57 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n  if (!options) options = {};\r\n  ");
#line 59 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n  ");
#line 60 "ServiceClientTemplate.cshtml"
Write(Model.Name);

#line default
#line hidden
            WriteLiteral("[\'super_\'].call(this, ");
#line 60 "ServiceClientTemplate.cshtml"
                                 Write(parameters.Any(p => p.Name == "credentials") ? "credentials" : "null");

#line default
#line hidden
            WriteLiteral(", options);\r\n  this.baseUri = baseUri;\r\n  if (!this.baseUri) {\r\n    this.baseUri " +
"= \'");
#line 63 "ServiceClientTemplate.cshtml"
               Write(Model.BaseUrl);

#line default
#line hidden
            WriteLiteral("\';\r\n  }\r\n");
#line 65 "ServiceClientTemplate.cshtml"
 foreach (var param in parameters)
{

#line default
#line hidden

            WriteLiteral("  this.");
#line 67 "ServiceClientTemplate.cshtml"
     Write(param.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 67 "ServiceClientTemplate.cshtml"
                     Write(param.Name);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 68 "ServiceClientTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral("  ");
#line 69 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 70 "ServiceClientTemplate.cshtml"
  

#line default
#line hidden

#line 70 "ServiceClientTemplate.cshtml"
   foreach (var property in Model.Properties.Where(p => p.DefaultValue != null))
  {

#line default
#line hidden

            WriteLiteral("  if(!this.");
#line 72 "ServiceClientTemplate.cshtml"
         Write(property.Name);

#line default
#line hidden
            WriteLiteral(") { \r\n    this.");
#line 73 "ServiceClientTemplate.cshtml"
       Write(property.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 73 "ServiceClientTemplate.cshtml"
                          Write(property.DefaultValue);

#line default
#line hidden
            WriteLiteral(";\r\n  }\r\n");
#line 75 "ServiceClientTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  \r\n");
#line 77 "ServiceClientTemplate.cshtml"
  

#line default
#line hidden

#line 77 "ServiceClientTemplate.cshtml"
   foreach (var methodGroup in Model.MethodGroupModels)
  {

#line default
#line hidden

            WriteLiteral("  this.");
#line 79 "ServiceClientTemplate.cshtml"
     Write(methodGroup.MethodGroupName);

#line default
#line hidden
            WriteLiteral(" = new operations.");
#line 79 "ServiceClientTemplate.cshtml"
                                                     Write(methodGroup.MethodGroupType);

#line default
#line hidden
            WriteLiteral("(this);\r\n");
#line 80 "ServiceClientTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  \r\n");
#line 82 "ServiceClientTemplate.cshtml"
  

#line default
#line hidden

#line 82 "ServiceClientTemplate.cshtml"
   if (Model.ModelTypes.Any())
  {

#line default
#line hidden

            WriteLiteral("  this._models = models;\r\n");
#line 85 "ServiceClientTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("}\r\n");
#line 87 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nutil.inherits(");
#line 88 "ServiceClientTemplate.cshtml"
         Write(Model.Name);

#line default
#line hidden
            WriteLiteral(", ServiceClient);\r\n");
#line 89 "ServiceClientTemplate.cshtml"
 foreach (var method in Model.MethodTemplateModels)
{

#line default
#line hidden

#line 91 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 91 "ServiceClientTemplate.cshtml"
          

#line default
#line hidden

#line 92 "ServiceClientTemplate.cshtml"
Write(Include(new MethodTemplate(), method));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 93 "ServiceClientTemplate.cshtml"
}

#line default
#line hidden

#line 94 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nmodule.exports = ");
#line 95 "ServiceClientTemplate.cshtml"
            Write(Model.Name);

#line default
#line hidden
            WriteLiteral(";\r\n");
        }
        #pragma warning restore 1998
    }
}
