// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.CSharp.Templates
{
#line 1 "MethodGroupInterfaceTemplate.cshtml"
using System

#line default
#line hidden
    ;
#line 2 "MethodGroupInterfaceTemplate.cshtml"
using System.Linq;

#line default
#line hidden
#line 3 "MethodGroupInterfaceTemplate.cshtml"
using AutoRest.Core.Utilities

#line default
#line hidden
    ;
#line 4 "MethodGroupInterfaceTemplate.cshtml"
using AutoRest.CSharp

#line default
#line hidden
    ;
#line 5 "MethodGroupInterfaceTemplate.cshtml"
using AutoRest.CSharp.Model

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class MethodGroupInterfaceTemplate : AutoRest.Core.Template<AutoRest.CSharp.Model.MethodGroupCs>
    {
        #line hidden
        public MethodGroupInterfaceTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 7 "MethodGroupInterfaceTemplate.cshtml"
Write(Header("// "));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 8 "MethodGroupInterfaceTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nnamespace ");
#line 9 "MethodGroupInterfaceTemplate.cshtml"
     Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral("\r\n{\r\n");
#line 11 "MethodGroupInterfaceTemplate.cshtml"
 foreach (var usingString in Model.Usings) {

#line default
#line hidden

            WriteLiteral("    using ");
#line 12 "MethodGroupInterfaceTemplate.cshtml"
       Write(usingString);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 13 "MethodGroupInterfaceTemplate.cshtml"
}

#line default
#line hidden

#line 14 "MethodGroupInterfaceTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    /// <summary>\r\n    /// ");
#line 16 "MethodGroupInterfaceTemplate.cshtml"
    Write(Model.TypeName);

#line default
#line hidden
            WriteLiteral(" operations.\r\n    /// </summary>\r\n    public partial interface I");
#line 18 "MethodGroupInterfaceTemplate.cshtml"
                          Write(Model.TypeName);

#line default
#line hidden
            WriteLiteral("\r\n    {\r\n");
#line 20 "MethodGroupInterfaceTemplate.cshtml"
    

#line default
#line hidden

#line 20 "MethodGroupInterfaceTemplate.cshtml"
     foreach(MethodCs method in Model.Methods)
    {
        if (!String.IsNullOrEmpty(method.Description) || !String.IsNullOrEmpty(method.Summary))
        {

#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        ");
#line 25 "MethodGroupInterfaceTemplate.cshtml"
     Write(WrapComment("/// ", String.IsNullOrEmpty(method.Summary) ? method.Description.EscapeXmlComment() : method.Summary.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 26 "MethodGroupInterfaceTemplate.cshtml"
            if (!String.IsNullOrEmpty(method.ExternalDocsUrl))
            {

#line default
#line hidden

            WriteLiteral("        /// <see href=\"");
#line 28 "MethodGroupInterfaceTemplate.cshtml"
                    Write(method.ExternalDocsUrl);

#line default
#line hidden
            WriteLiteral("\" />\r\n");
#line 29 "MethodGroupInterfaceTemplate.cshtml"
            }

#line default
#line hidden

            WriteLiteral("        /// </summary>\r\n");
#line 31 "MethodGroupInterfaceTemplate.cshtml"
        }
        if (!String.IsNullOrEmpty(method.Description) && !String.IsNullOrEmpty(method.Summary))
        {

#line default
#line hidden

            WriteLiteral("        /// <remarks>\r\n        ");
#line 35 "MethodGroupInterfaceTemplate.cshtml"
     Write(WrapComment("/// ", method.Description.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n        /// </remarks>\r\n");
#line 37 "MethodGroupInterfaceTemplate.cshtml"
        }
        foreach (ParameterCs parameter in method.LocalParameters)
        {

#line default
#line hidden

            WriteLiteral("        /// <param name=\'");
#line 40 "MethodGroupInterfaceTemplate.cshtml"
                      Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\'>\r\n        ");
#line 41 "MethodGroupInterfaceTemplate.cshtml"
     Write(WrapComment("/// ", parameter.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n        /// </param>\r\n");
#line 43 "MethodGroupInterfaceTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        /// <param name=\'customHeaders\'>\r\n        /// The headers that will be ad" +
"ded to request.\r\n        /// </param>\r\n        /// <param name=\'cancellationToke" +
"n\'>\r\n        /// The cancellation token.\r\n        /// </param>\r\n        /// <exc" +
"eption cref=\"");
#line 50 "MethodGroupInterfaceTemplate.cshtml"
                           Write(method.OperationExceptionTypeString);

#line default
#line hidden
            WriteLiteral("\">\r\n        /// Thrown when the operation returned an invalid status code\r\n      " +
"  /// </exception>\r\n");
#line 53 "MethodGroupInterfaceTemplate.cshtml"
        

#line default
#line hidden

#line 53 "MethodGroupInterfaceTemplate.cshtml"
         if (method.Responses.Where(r => r.Value.Body != null).Any())
        {

#line default
#line hidden

            WriteLiteral("        /// <exception cref=\"Microsoft.Rest.SerializationException\">\r\n        ///" +
" Thrown when unable to deserialize the response\r\n        /// </exception>\r\n");
#line 58 "MethodGroupInterfaceTemplate.cshtml"
        }

#line default
#line hidden

#line 58 "MethodGroupInterfaceTemplate.cshtml"
         
        

#line default
#line hidden

#line 59 "MethodGroupInterfaceTemplate.cshtml"
         if (method.Parameters.Any(p => p.IsRequired && p.IsNullable()))
        {

#line default
#line hidden

            WriteLiteral("        /// <exception cref=\"Microsoft.Rest.ValidationException\">\r\n        /// Th" +
"rown when a required parameter is null\r\n        /// </exception>\r\n");
#line 64 "MethodGroupInterfaceTemplate.cshtml"
        }

#line default
#line hidden

#line 64 "MethodGroupInterfaceTemplate.cshtml"
         
        

#line default
#line hidden

#line 65 "MethodGroupInterfaceTemplate.cshtml"
         if (method.Deprecated)
        {

#line default
#line hidden

            WriteLiteral("        [System.Obsolete()]\r\n");
#line 68 "MethodGroupInterfaceTemplate.cshtml"
        }

#line default
#line hidden

#line 68 "MethodGroupInterfaceTemplate.cshtml"
         

#line default
#line hidden

            WriteLiteral("        System.Threading.Tasks.Task<");
#line 69 "MethodGroupInterfaceTemplate.cshtml"
                                 Write(method.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral("> ");
#line 69 "MethodGroupInterfaceTemplate.cshtml"
                                                                             Write(method.Name);

#line default
#line hidden
            WriteLiteral("WithHttpMessagesAsync(");
#line 69 "MethodGroupInterfaceTemplate.cshtml"
                                                                                                                 Write(method.GetAsyncMethodParameterDeclaration(true));

#line default
#line hidden
            WriteLiteral(");\r\n");
#line 70 "MethodGroupInterfaceTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    }\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
