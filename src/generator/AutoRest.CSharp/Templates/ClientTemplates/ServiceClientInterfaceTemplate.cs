// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.CSharp.Templates
{
#line 1 "ServiceClientInterfaceTemplate.cshtml"
using System

#line default
#line hidden
    ;
#line 2 "ServiceClientInterfaceTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
#line 3 "ServiceClientInterfaceTemplate.cshtml"
using AutoRest.Core.Utilities

#line default
#line hidden
    ;
#line 4 "ServiceClientInterfaceTemplate.cshtml"
using AutoRest.CSharp.Model

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ServiceClientInterfaceTemplate : AutoRest.Core.Template<CodeModelCs>
    {
        #line hidden
        public ServiceClientInterfaceTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 6 "ServiceClientInterfaceTemplate.cshtml"
Write(Header("// "));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 7 "ServiceClientInterfaceTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nnamespace ");
#line 8 "ServiceClientInterfaceTemplate.cshtml"
     Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral("\r\n{\r\n");
#line 10 "ServiceClientInterfaceTemplate.cshtml"
 foreach (var usingString in Model.Usings) {

#line default
#line hidden

            WriteLiteral("    using ");
#line 11 "ServiceClientInterfaceTemplate.cshtml"
       Write(usingString);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 12 "ServiceClientInterfaceTemplate.cshtml"
}

#line default
#line hidden

#line 13 "ServiceClientInterfaceTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    /// <summary>\r\n    ");
#line 15 "ServiceClientInterfaceTemplate.cshtml"
Write(WrapComment("/// ", Model.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n    /// </summary>\r\n    public partial interface I");
#line 17 "ServiceClientInterfaceTemplate.cshtml"
                          Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" : System.IDisposable\r\n    {\r\n        /// <summary>\r\n        /// The base URI of " +
"the service.\r\n        /// </summary>\r\n");
#line 22 "ServiceClientInterfaceTemplate.cshtml"
        

#line default
#line hidden

#line 22 "ServiceClientInterfaceTemplate.cshtml"
         if (!Model.IsCustomBaseUri)
        {

#line default
#line hidden

            WriteLiteral("        System.Uri BaseUri { get; set; }\r\n");
#line 25 "ServiceClientInterfaceTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        \r\n        ");
#line 27 "ServiceClientInterfaceTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n        /// <summary>\r\n        /// Gets or sets json serialization settings.\r" +
"\n        /// </summary>\r\n        Newtonsoft.Json.JsonSerializerSettings Serializ" +
"ationSettings { get; }\r\n        ");
#line 33 "ServiceClientInterfaceTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n        /// <summary>\r\n        /// Gets or sets json deserialization settings" +
".\r\n        /// </summary>\r\n        Newtonsoft.Json.JsonSerializerSettings Deseri" +
"alizationSettings { get; }\r\n        ");
#line 39 "ServiceClientInterfaceTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n");
#line 41 "ServiceClientInterfaceTemplate.cshtml"
        

#line default
#line hidden

#line 41 "ServiceClientInterfaceTemplate.cshtml"
         foreach (var property in Model.Properties)
        {

#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        ");
#line 44 "ServiceClientInterfaceTemplate.cshtml"
     Write(WrapComment("/// ", property.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n        /// </summary>\r\n        ");
#line 46 "ServiceClientInterfaceTemplate.cshtml"
     Write(property.ModelTypeName);

#line default
#line hidden
            WriteLiteral(" ");
#line 46 "ServiceClientInterfaceTemplate.cshtml"
                             Write(property.Name);

#line default
#line hidden
            WriteLiteral(" { get;");
#line 46 "ServiceClientInterfaceTemplate.cshtml"
                                                   Write(property.IsReadOnly || property.IsConstant ? "" : " set;");

#line default
#line hidden
            WriteLiteral(" }\r\n");
#line 47 "ServiceClientInterfaceTemplate.cshtml"
        

#line default
#line hidden

#line 47 "ServiceClientInterfaceTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 47 "ServiceClientInterfaceTemplate.cshtml"
                  
        }

#line default
#line hidden

            WriteLiteral("\r\n        ");
#line 50 "ServiceClientInterfaceTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 51 "ServiceClientInterfaceTemplate.cshtml"
    

#line default
#line hidden

#line 51 "ServiceClientInterfaceTemplate.cshtml"
     foreach(var operation in Model.AllOperations)
    {

#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        /// Gets the I");
#line 54 "ServiceClientInterfaceTemplate.cshtml"
                    Write(operation.TypeName);

#line default
#line hidden
            WriteLiteral(".\r\n        /// </summary>\r\n        I");
#line 56 "ServiceClientInterfaceTemplate.cshtml"
       Write(operation.TypeName);

#line default
#line hidden
            WriteLiteral(" ");
#line 56 "ServiceClientInterfaceTemplate.cshtml"
                             Write(operation.NameForProperty);

#line default
#line hidden
            WriteLiteral(" { get; }\r\n");
#line 57 "ServiceClientInterfaceTemplate.cshtml"
        

#line default
#line hidden

#line 57 "ServiceClientInterfaceTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 57 "ServiceClientInterfaceTemplate.cshtml"
                  

#line default
#line hidden

            WriteLiteral("        \r\n");
#line 59 "ServiceClientInterfaceTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("     \r\n");
#line 61 "ServiceClientInterfaceTemplate.cshtml"
    

#line default
#line hidden

#line 61 "ServiceClientInterfaceTemplate.cshtml"
     foreach(MethodCs method in Model.Methods.Where( each => each.Group.IsNullOrEmpty()) )
    {
        if (!String.IsNullOrEmpty(method.Description) || !String.IsNullOrEmpty(method.Summary))
        {

#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        ");
#line 66 "ServiceClientInterfaceTemplate.cshtml"
     Write(WrapComment("/// ", String.IsNullOrEmpty(method.Summary) ? method.Description.EscapeXmlComment() : method.Summary.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n        /// </summary>\r\n");
#line 68 "ServiceClientInterfaceTemplate.cshtml"
        }
        if (!String.IsNullOrEmpty(method.Description) && !String.IsNullOrEmpty(method.Summary))
        {

#line default
#line hidden

            WriteLiteral("        /// <remarks>\r\n        ");
#line 72 "ServiceClientInterfaceTemplate.cshtml"
     Write(WrapComment("/// ", method.Description.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n        /// </remarks>\r\n");
#line 74 "ServiceClientInterfaceTemplate.cshtml"
        }
        foreach (var parameter in method.LocalParameters)
        {

#line default
#line hidden

            WriteLiteral("        /// <param name=\'");
#line 77 "ServiceClientInterfaceTemplate.cshtml"
                      Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\'>\r\n        ");
#line 78 "ServiceClientInterfaceTemplate.cshtml"
     Write(WrapComment("/// ", parameter.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n        /// </param>\r\n");
#line 80 "ServiceClientInterfaceTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral(@"        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<");
#line 87 "ServiceClientInterfaceTemplate.cshtml"
                                  Write(method.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral("> ");
#line 87 "ServiceClientInterfaceTemplate.cshtml"
                                                                               Write(method.Name);

#line default
#line hidden
            WriteLiteral("WithHttpMessagesAsync(");
#line 87 "ServiceClientInterfaceTemplate.cshtml"
                                                                                                                   Write(method.GetAsyncMethodParameterDeclaration(true));

#line default
#line hidden
            WriteLiteral(");\r\n");
#line 88 "ServiceClientInterfaceTemplate.cshtml"
        

#line default
#line hidden

#line 88 "ServiceClientInterfaceTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 88 "ServiceClientInterfaceTemplate.cshtml"
                  

#line default
#line hidden

            WriteLiteral("        \r\n");
#line 90 "ServiceClientInterfaceTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("\r\n    }\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
