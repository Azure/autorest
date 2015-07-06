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
            WriteLiteral("\n/* jshint latedef:false */\n/* jshint forin:false */\n/* jshint noempty:false */\n");
#line 12 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n\'use strict\';\n");
#line 14 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\nvar util = require(\'util\');\nvar msRest = require(\'ms-rest\');\nvar msRestAzure = r" +
"equire(\'ms-rest-azure\');\nvar ServiceClient = msRestAzure.AzureServiceClient;\nvar" +
" WebResource = msRest.WebResource;\n\n");
#line 21 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n");
#line 22 "AzureServiceClientTemplate.cshtml"
 if (Model.ModelTypes.Any())
{

#line default
#line hidden

            WriteLiteral("var models = require(\'./models\');\n");
#line 25 "AzureServiceClientTemplate.cshtml"
}

#line default
#line hidden

#line 26 "AzureServiceClientTemplate.cshtml"
 if (Model.MethodGroups.Any())
{

#line default
#line hidden

            WriteLiteral("var operations = require(\'./operations\');\n");
#line 29 "AzureServiceClientTemplate.cshtml"
}

#line default
#line hidden

#line 30 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n/**\n * @class\n * Initializes a new instance of the ");
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
            WriteLiteral("(credentials, baseUri, options) {\n  if (!credentials) {\n    throw new Error(\'cred" +
"entials cannot be null.\');\n  }\n  ");
#line 54 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n  if (!options) options = {};\n  ");
#line 56 "AzureServiceClientTemplate.cshtml"
Write(Model.Name);

#line default
#line hidden
            WriteLiteral("[\'super_\'].call(this, credentials, options);\n  this.baseUri = baseUri;\n  this.cre" +
"dentials = credentials;\n  if (!this.baseUri) {\n    this.baseUri = \'");
#line 60 "AzureServiceClientTemplate.cshtml"
               Write(Model.BaseUrl);

#line default
#line hidden
            WriteLiteral("\';\n  }\n  ");
#line 62 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n");
#line 63 "AzureServiceClientTemplate.cshtml"
  

#line default
#line hidden

#line 63 "AzureServiceClientTemplate.cshtml"
   foreach (var property in Model.Properties.Where(p => p.DefaultValue != null))
  {

#line default
#line hidden

            WriteLiteral("  this.");
#line 65 "AzureServiceClientTemplate.cshtml"
     Write(property.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 65 "AzureServiceClientTemplate.cshtml"
                        Write(property.DefaultValue);

#line default
#line hidden
            WriteLiteral(";\n");
#line 66 "AzureServiceClientTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  \n");
#line 68 "AzureServiceClientTemplate.cshtml"
  

#line default
#line hidden

#line 68 "AzureServiceClientTemplate.cshtml"
   foreach (var methodGroup in Model.MethodGroupModels)
  {

#line default
#line hidden

            WriteLiteral("  this.");
#line 70 "AzureServiceClientTemplate.cshtml"
     Write(methodGroup.MethodGroupName);

#line default
#line hidden
            WriteLiteral(" = new operations.");
#line 70 "AzureServiceClientTemplate.cshtml"
                                                     Write(methodGroup.MethodGroupType);

#line default
#line hidden
            WriteLiteral("(this);\n");
#line 71 "AzureServiceClientTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("  \n");
#line 73 "AzureServiceClientTemplate.cshtml"
  

#line default
#line hidden

#line 73 "AzureServiceClientTemplate.cshtml"
   if (Model.ModelTypes.Any())
  {

#line default
#line hidden

            WriteLiteral("  this._models = models;\n");
#line 76 "AzureServiceClientTemplate.cshtml"
  }

#line default
#line hidden

            WriteLiteral("}\n\n");
#line 79 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\nutil.inherits(");
#line 80 "AzureServiceClientTemplate.cshtml"
         Write(Model.Name);

#line default
#line hidden
            WriteLiteral(", ServiceClient);\n");
#line 81 "AzureServiceClientTemplate.cshtml"
 foreach (var method in Model.MethodTemplateModels)
{

#line default
#line hidden

#line 83 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 83 "AzureServiceClientTemplate.cshtml"
          

#line default
#line hidden

#line 84 "AzureServiceClientTemplate.cshtml"
Write(Include(new AzureMethodTemplate(), method as AzureMethodTemplateModel));

#line default
#line hidden
            WriteLiteral("\n");
#line 85 "AzureServiceClientTemplate.cshtml"
}

#line default
#line hidden

#line 86 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\nmodule.exports = ");
#line 87 "AzureServiceClientTemplate.cshtml"
            Write(Model.Name);

#line default
#line hidden
            WriteLiteral(";");
        }
        #pragma warning restore 1998
    }
}
