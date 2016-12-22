// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.CSharp.Templates
{
#line 1 "ServerMethodTemplate.cshtml"
using System.Globalization

#line default
#line hidden
    ;
#line 2 "ServerMethodTemplate.cshtml"
using System.Linq;

#line default
#line hidden
#line 3 "ServerMethodTemplate.cshtml"
using System

#line default
#line hidden
    ;
#line 4 "ServerMethodTemplate.cshtml"
using AutoRest.Core.Model

#line default
#line hidden
    ;
#line 5 "ServerMethodTemplate.cshtml"
using AutoRest.Core.Utilities

#line default
#line hidden
    ;
#line 6 "ServerMethodTemplate.cshtml"
using AutoRest.CSharp

#line default
#line hidden
    ;
#line 7 "ServerMethodTemplate.cshtml"
using AutoRest.CSharp.Model

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ServerMethodTemplate : AutoRest.Core.Template<AutoRest.CSharp.Model.MethodCs>
    {
        #line hidden
        public ServerMethodTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 10 "ServerMethodTemplate.cshtml"
 if (!string.IsNullOrWhiteSpace(Model.Description) || !string.IsNullOrEmpty(Model.Summary))
{

#line default
#line hidden

            WriteLiteral("/// <summary>\r\n    ");
#line 13 "ServerMethodTemplate.cshtml"
 Write(WrapComment("/// ", String.IsNullOrEmpty(Model.Summary) ? Model.Description.EscapeXmlComment() : Model.Summary.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 14 "ServerMethodTemplate.cshtml"
    if (!string.IsNullOrEmpty(Model.ExternalDocsUrl))
    {

#line default
#line hidden

            WriteLiteral("    /// <see href=\"");
#line 16 "ServerMethodTemplate.cshtml"
                Write(Model.ExternalDocsUrl);

#line default
#line hidden
            WriteLiteral("\" />\r\n");
#line 17 "ServerMethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("/// </summary>\r\n");
#line 19 "ServerMethodTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral("\r\n");
#line 21 "ServerMethodTemplate.cshtml"
 if (!String.IsNullOrEmpty(Model.Description) && !String.IsNullOrEmpty(Model.Summary))
{

#line default
#line hidden

            WriteLiteral("    /// <remarks>\r\n        ");
#line 24 "ServerMethodTemplate.cshtml"
     Write(WrapComment("/// ", Model.Description.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n        ///\r\n    ///</remarks>\r\n");
#line 27 "ServerMethodTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral("\r\n[");
#line 29 "ServerMethodTemplate.cshtml"
Write("Http" + @Model.HttpMethod);

#line default
#line hidden
            WriteLiteral("(\"");
#line 29 "ServerMethodTemplate.cshtml"
                           Write(Model.Url);

#line default
#line hidden
            WriteLiteral("\")]\r\n");
#line 30 "ServerMethodTemplate.cshtml"
   var methodSignature = "public " + Model.ReturnTypeString + " " + @Model.HttpMethod + "("; 

#line default
#line hidden

            WriteLiteral("\r\n\r\n");
#line 32 "ServerMethodTemplate.cshtml"
 foreach (var param in @Model.LocalParameters)
{
    

#line default
#line hidden

#line 34 "ServerMethodTemplate.cshtml"
     if (param.Location != ParameterLocation.None)
    {
        methodSignature += "[" + ControllerToModelBinderMapping.GetModelBinder(param.Location) + "]";

    }

#line default
#line hidden

#line 38 "ServerMethodTemplate.cshtml"
     
    methodSignature += param.ModelTypeName + " ";
    methodSignature += param.Name;
}

#line default
#line hidden

#line 42 "ServerMethodTemplate.cshtml"
   methodSignature += ")"; 

#line default
#line hidden

            WriteLiteral("\r\n");
#line 43 "ServerMethodTemplate.cshtml"
Write(methodSignature);

#line default
#line hidden
            WriteLiteral("\r\n{\r\n");
#line 45 "ServerMethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 46 "ServerMethodTemplate.cshtml"
 foreach (ParameterCs parameter in Model.Parameters.Where(p => !p.IsConstant))
{
    if (parameter.IsRequired && parameter.IsNullable())
    {

#line default
#line hidden

            WriteLiteral("    if (");
#line 50 "ServerMethodTemplate.cshtml"
      Write(parameter.Name);

#line default
#line hidden
            WriteLiteral(" == null)\r\n    {\r\n        throw new System.ArgumentNullException();\r\n    }\r\n    \r" +
"\n");
#line 55 "ServerMethodTemplate.cshtml"
}
    if (parameter.CanBeValidated && (Model.HttpMethod != HttpMethod.Patch || parameter.Location != ParameterLocation.Body))
    {

#line default
#line hidden

            WriteLiteral("    ");
#line 58 "ServerMethodTemplate.cshtml"
  Write(parameter.ModelType.ValidateType(Model, parameter.Name, parameter.Constraints));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 59 "ServerMethodTemplate.cshtml"
}
}

#line default
#line hidden

#line 61 "ServerMethodTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 62 "ServerMethodTemplate.cshtml"
 if (Model.HttpMethod == HttpMethod.Get)
{

#line default
#line hidden

            WriteLiteral("    return new ");
#line 64 "ServerMethodTemplate.cshtml"
                   

#line default
#line hidden

#line 64 "ServerMethodTemplate.cshtml"
              Write(Model.ReturnTypeString);

#line default
#line hidden
#line 64 "ServerMethodTemplate.cshtml"
                                          

#line default
#line hidden

            WriteLiteral("();\r\n");
#line 65 "ServerMethodTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral("\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
