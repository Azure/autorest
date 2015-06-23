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
Write(Header("/// "));

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
            WriteLiteral("\r\n/**\r\n * @class\r\n * Initializes a new instance of the ");
#line 33 "AzureServiceClientTemplate.cshtml"
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
#line 50 "AzureServiceClientTemplate.cshtml"
     Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(credentials, baseUri, options) {\r\n  if (!credentials) {\r\n    throw new Error(\'cr" +
"edentials cannot be null.\');\r\n  }\r\n  ");
#line 54 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n  if (!options) options = {};\r\n  ");
#line 56 "AzureServiceClientTemplate.cshtml"
Write(Model.Name);

#line default
#line hidden
            WriteLiteral("[\'super_\'].call(this, credentials, options);\r\n  this.baseUri = baseUri;\r\n  this.c" +
"redentials = credentials;\r\n  if (!this.baseUri) {\r\n    this.baseUri = \'");
#line 60 "AzureServiceClientTemplate.cshtml"
               Write(Model.BaseUrl);

#line default
#line hidden
            WriteLiteral("\';\r\n  }\r\n  ");
#line 62 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 63 "AzureServiceClientTemplate.cshtml"
  

#line default
#line hidden

#line 63 "AzureServiceClientTemplate.cshtml"
   foreach (var property in Model.Properties.Where(p => p.DefaultValue != null))
  {

#line default
#line hidden

            WriteLiteral("  if (!this.");
#line 65 "AzureServiceClientTemplate.cshtml"
          Write(property.Name);

#line default
#line hidden
            WriteLiteral(") {\r\n    this.");
#line 66 "AzureServiceClientTemplate.cshtml"
       Write(property.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 66 "AzureServiceClientTemplate.cshtml"
                          Write(property.DefaultValue);

#line default
#line hidden
            WriteLiteral(";\r\n  }\r\n");
#line 68 "AzureServiceClientTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  \r\n");
#line 70 "AzureServiceClientTemplate.cshtml"
  

#line default
#line hidden

#line 70 "AzureServiceClientTemplate.cshtml"
   foreach (var methodGroup in Model.MethodGroupModels)
  {

#line default
#line hidden

            WriteLiteral("  this.");
#line 72 "AzureServiceClientTemplate.cshtml"
     Write(methodGroup.MethodGroupName);

#line default
#line hidden
            WriteLiteral(" = new operations.");
#line 72 "AzureServiceClientTemplate.cshtml"
                                                     Write(methodGroup.MethodGroupType);

#line default
#line hidden
            WriteLiteral("(this);\r\n");
#line 73 "AzureServiceClientTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  \r\n");
#line 75 "AzureServiceClientTemplate.cshtml"
  

#line default
#line hidden

#line 75 "AzureServiceClientTemplate.cshtml"
   if (Model.ModelTypes.Any())
  {

#line default
#line hidden

            WriteLiteral("    this._models = models;\r\n");
#line 78 "AzureServiceClientTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("}\r\n\r\n");
#line 81 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nutil.inherits(");
#line 82 "AzureServiceClientTemplate.cshtml"
         Write(Model.Name);

#line default
#line hidden
            WriteLiteral(", ServiceClient);\r\n");
#line 83 "AzureServiceClientTemplate.cshtml"
 foreach (var method in Model.MethodTemplateModels)
{

#line default
#line hidden

#line 85 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 85 "AzureServiceClientTemplate.cshtml"
          

#line default
#line hidden

#line 86 "AzureServiceClientTemplate.cshtml"
Write(Include<AzureMethodTemplate, AzureMethodTemplateModel>(method as AzureMethodTemplateModel));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 87 "AzureServiceClientTemplate.cshtml"
}

#line default
#line hidden

#line 88 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nmodule.exports = ");
#line 89 "AzureServiceClientTemplate.cshtml"
            Write(Model.Name);

#line default
#line hidden
            WriteLiteral(";");
        }
        #pragma warning restore 1998
    }
}
