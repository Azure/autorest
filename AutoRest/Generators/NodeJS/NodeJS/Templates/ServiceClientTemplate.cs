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
            WriteLiteral("\r\n/**\r\n * @class\r\n * Initializes a new instance of the ");
#line 30 "ServiceClientTemplate.cshtml"
                                Write(Model.Name);

#line default
#line hidden
            WriteLiteral(@" class.
 * @constructor
 *
 * @param {ServiceClientCredentials} credentials - Credentials for
 * authenticating with the service.
 *
 * @param {string} [baseUri] - The base URI of the service.
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
#line 47 "ServiceClientTemplate.cshtml"
     Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(credentials, baseUri, options) {\r\n  if (!credentials) {\r\n    throw new Error(\'cr" +
"edentials cannot be null.\');\r\n  }\r\n  ");
#line 51 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n  if (!options) options = {};\r\n  ");
#line 53 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n  ");
#line 54 "ServiceClientTemplate.cshtml"
Write(Model.Name);

#line default
#line hidden
            WriteLiteral("[\'super_\'].call(this, credentials, options);\r\n  this.baseUri = baseUri;\r\n  this.c" +
"redentials = credentials;\r\n  if (!this.baseUri) {\r\n    this.baseUri = \'");
#line 58 "ServiceClientTemplate.cshtml"
               Write(Model.BaseUrl);

#line default
#line hidden
            WriteLiteral("\';\r\n  }\r\n  ");
#line 60 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 61 "ServiceClientTemplate.cshtml"
  

#line default
#line hidden

#line 61 "ServiceClientTemplate.cshtml"
   foreach (var property in Model.Properties.Where(p => p.DefaultValue != null))
  {

#line default
#line hidden

            WriteLiteral("  this.");
#line 63 "ServiceClientTemplate.cshtml"
     Write(property.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 63 "ServiceClientTemplate.cshtml"
                        Write(property.DefaultValue);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 64 "ServiceClientTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  \r\n");
#line 66 "ServiceClientTemplate.cshtml"
  

#line default
#line hidden

#line 66 "ServiceClientTemplate.cshtml"
   foreach (var methodGroup in Model.MethodGroupModels)
  {

#line default
#line hidden

            WriteLiteral("  this.");
#line 68 "ServiceClientTemplate.cshtml"
     Write(methodGroup.MethodGroupName);

#line default
#line hidden
            WriteLiteral(" = new operations.");
#line 68 "ServiceClientTemplate.cshtml"
                                                     Write(methodGroup.MethodGroupType);

#line default
#line hidden
            WriteLiteral("(this);\r\n");
#line 69 "ServiceClientTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  \r\n");
#line 71 "ServiceClientTemplate.cshtml"
  

#line default
#line hidden

#line 71 "ServiceClientTemplate.cshtml"
   if (Model.ModelTypes.Any())
  {

#line default
#line hidden

            WriteLiteral("  this._models = models;\r\n");
#line 74 "ServiceClientTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("}\r\n");
#line 76 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nutil.inherits(");
#line 77 "ServiceClientTemplate.cshtml"
         Write(Model.Name);

#line default
#line hidden
            WriteLiteral(", ServiceClient);\r\n");
#line 78 "ServiceClientTemplate.cshtml"
 foreach (var method in Model.MethodTemplateModels)
{

#line default
#line hidden

#line 80 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 80 "ServiceClientTemplate.cshtml"
          

#line default
#line hidden

#line 81 "ServiceClientTemplate.cshtml"
Write(Include(new MethodTemplate(), method));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 82 "ServiceClientTemplate.cshtml"
}

#line default
#line hidden

#line 83 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nmodule.exports = ");
#line 84 "ServiceClientTemplate.cshtml"
            Write(Model.Name);

#line default
#line hidden
            WriteLiteral(";\r\n");
        }
        #pragma warning restore 1998
    }
}
