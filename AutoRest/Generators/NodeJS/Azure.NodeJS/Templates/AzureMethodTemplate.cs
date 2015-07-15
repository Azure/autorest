// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.Azure.NodeJS.Templates
{
#line 1 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS

#line default
#line hidden
    ;
#line 2 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS.Templates

#line default
#line hidden
    ;
#line 3 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS.TemplateModels

#line default
#line hidden
    ;
#line 4 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.Azure.NodeJS

#line default
#line hidden
    ;
#line 5 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.Azure.NodeJS.Templates

#line default
#line hidden
    ;
#line 6 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.Utilities

#line default
#line hidden
    ;
#line 7 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.ClientModel

#line default
#line hidden
    ;
#line 8 "AzureMethodTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class AzureMethodTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.Azure.NodeJS.AzureMethodTemplateModel>
    {
        #line hidden
        public AzureMethodTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 11 "AzureMethodTemplate.cshtml"
 if (!Model.IsLongRunningOperation)
{

#line default
#line hidden

#line 13 "AzureMethodTemplate.cshtml"
Write(Include( new MethodTemplate(), Model as MethodTemplateModel));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 14 "AzureMethodTemplate.cshtml"
}
else if (Model.HttpMethod == HttpMethod.Post || Model.HttpMethod == HttpMethod.Delete)
{

#line default
#line hidden

            WriteLiteral("\r\n/**\r\n *\r\n");
#line 20 "AzureMethodTemplate.cshtml"
Write(WrapComment(" * ", Model.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 21 "AzureMethodTemplate.cshtml"
 foreach (var parameter in Model.DocumentationParameters)
{

#line default
#line hidden

            WriteLiteral(" * @param {");
#line 23 "AzureMethodTemplate.cshtml"
         Write(parameter.Type.Name);

#line default
#line hidden
            WriteLiteral("} [");
#line 23 "AzureMethodTemplate.cshtml"
                                Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("] ");
#line 23 "AzureMethodTemplate.cshtml"
                                                 Write(parameter.Documentation);

#line default
#line hidden
            WriteLiteral("\r\n *\r\n");
#line 25 "AzureMethodTemplate.cshtml"
}

#line default
#line hidden

#line 26 "AzureMethodTemplate.cshtml"
Write(WrapComment(" * ", " @param {object} [options]"));

#line default
#line hidden
            WriteLiteral("\r\n *\r\n");
#line 28 "AzureMethodTemplate.cshtml"
Write(WrapComment(" * ", " @param {object} [options.customHeaders] headers that will be added to request"));

#line default
#line hidden
            WriteLiteral("\r\n *\r\n");
#line 30 "AzureMethodTemplate.cshtml"
Write(WrapComment(" * ", " @param {function} callback"));

#line default
#line hidden
            WriteLiteral("\r\n *\r\n");
#line 32 "AzureMethodTemplate.cshtml"
Write(WrapComment(" * ", " @returns {Stream} The Response stream"));

#line default
#line hidden
            WriteLiteral("\r\n */\r\n");
#line 34 "AzureMethodTemplate.cshtml"
Write(Model.OperationName);

#line default
#line hidden
            WriteLiteral(".prototype.");
#line 34 "AzureMethodTemplate.cshtml"
                             Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" = function (");
#line 34 "AzureMethodTemplate.cshtml"
                                                       Write(Model.MethodParameterDeclarationWithCallback);

#line default
#line hidden
            WriteLiteral(") {\r\n  var self = ");
#line 35 "AzureMethodTemplate.cshtml"
         Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(";\r\n  if(!callback && typeof options === \'function\') {\r\n    callback = options;\r\n " +
"   options = null;\r\n  }\r\n  // Send request\r\n  this.begin");
#line 41 "AzureMethodTemplate.cshtml"
        Write(Model.Name.ToPascalCase());

#line default
#line hidden
            WriteLiteral("(");
#line 41 "AzureMethodTemplate.cshtml"
                                     Write(Model.MethodParameterDeclaration);

#line default
#line hidden
            WriteLiteral("function (err, result){\r\n    if (err) return callback(err);\r\n    self.getPostOrDe" +
"leteOperationResult(result, options, callback);\r\n  });\r\n};\r\n\r\n");
#line 47 "AzureMethodTemplate.cshtml"
}
else if (Model.HttpMethod == HttpMethod.Put)
{

#line default
#line hidden

            WriteLiteral("\r\n/**\r\n *\r\n");
#line 53 "AzureMethodTemplate.cshtml"
Write(WrapComment(" * ", Model.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 54 "AzureMethodTemplate.cshtml"
 foreach (var parameter in Model.DocumentationParameters)
{

#line default
#line hidden

            WriteLiteral(" * @param {");
#line 56 "AzureMethodTemplate.cshtml"
         Write(parameter.Type.Name);

#line default
#line hidden
            WriteLiteral("} [");
#line 56 "AzureMethodTemplate.cshtml"
                                Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("] ");
#line 56 "AzureMethodTemplate.cshtml"
                                                 Write(parameter.Documentation);

#line default
#line hidden
            WriteLiteral("\r\n *\r\n");
#line 58 "AzureMethodTemplate.cshtml"
}

#line default
#line hidden

#line 59 "AzureMethodTemplate.cshtml"
Write(WrapComment(" * ", " @param {object} [options]"));

#line default
#line hidden
            WriteLiteral("\r\n *\r\n");
#line 61 "AzureMethodTemplate.cshtml"
Write(WrapComment(" * ", " @param {object} [options.customHeaders] headers that will be added to request"));

#line default
#line hidden
            WriteLiteral("\r\n *\r\n");
#line 63 "AzureMethodTemplate.cshtml"
Write(WrapComment(" * ", " @param {function} callback"));

#line default
#line hidden
            WriteLiteral("\r\n *\r\n");
#line 65 "AzureMethodTemplate.cshtml"
Write(WrapComment(" * ", " @returns {Stream} The Response stream"));

#line default
#line hidden
            WriteLiteral("\r\n */\r\n");
#line 67 "AzureMethodTemplate.cshtml"
Write(Model.OperationName);

#line default
#line hidden
            WriteLiteral(".prototype.");
#line 67 "AzureMethodTemplate.cshtml"
                             Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" = function (");
#line 67 "AzureMethodTemplate.cshtml"
                                                       Write(Model.MethodParameterDeclarationWithCallback);

#line default
#line hidden
            WriteLiteral(") {\r\n  var client = ");
#line 68 "AzureMethodTemplate.cshtml"
           Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(@";
  if(!callback && typeof options === 'function') {
    callback = options;
    options = null;
  }
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  var self = this;
  function getMethod() {
    var cb = function (callback) {
      return self.");
#line 79 "AzureMethodTemplate.cshtml"
              Write(Model.GetMethod.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 79 "AzureMethodTemplate.cshtml"
                                      Write(Model.GetMethod.MethodParameterDeclaration);

#line default
#line hidden
            WriteLiteral("callback);\r\n    };\r\n    return cb;\r\n  }\r\n  // Send request\r\n  self.begin");
#line 84 "AzureMethodTemplate.cshtml"
        Write(Model.Name.ToPascalCase());

#line default
#line hidden
            WriteLiteral("(");
#line 84 "AzureMethodTemplate.cshtml"
                                     Write(Model.MethodParameterDeclaration);

#line default
#line hidden
            WriteLiteral("function (err, result){\r\n    if (err) return callback(err);\r\n    client.getPutOpe" +
"rationResult(result, getMethod(), options, callback);\r\n  });\r\n};\r\n\r\n");
#line 90 "AzureMethodTemplate.cshtml"
}

#line default
#line hidden

        }
        #pragma warning restore 1998
    }
}
