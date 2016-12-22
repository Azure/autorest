// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.CSharp.Templates
{
#line 1 "ExceptionTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ExceptionTemplate : AutoRest.Core.Template<AutoRest.CSharp.Model.CompositeTypeCs>
    {
        #line hidden
        public ExceptionTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 3 "ExceptionTemplate.cshtml"
Write(Header("// "));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 4 "ExceptionTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nnamespace ");
#line 5 "ExceptionTemplate.cshtml"
      Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral(".");
#line 5 "ExceptionTemplate.cshtml"
                            Write(Settings.ModelsName);

#line default
#line hidden
            WriteLiteral("\r\n{\r\n");
#line 7 "ExceptionTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    /// <summary>\r\n    ");
#line 9 "ExceptionTemplate.cshtml"
Write(WrapComment("/// ", "Exception thrown for an invalid response with " + Model.Name + " information."));

#line default
#line hidden
            WriteLiteral("\r\n    /// </summary>\r\n#if !PORTABLE \r\n    [System.Serializable]\r\n#endif\r\n    publ" +
"ic class ");
#line 14 "ExceptionTemplate.cshtml"
            Write(Model.ExceptionTypeDefinitionName);

#line default
#line hidden
            WriteLiteral(" : Microsoft.Rest.RestException\r\n    {\r\n        /// <summary>\r\n        /// Gets i" +
"nformation about the associated HTTP request.\r\n        /// </summary>\r\n        p" +
"ublic Microsoft.Rest.HttpRequestMessageWrapper Request { get; set; }\r\n");
#line 20 "ExceptionTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n        /// <summary>\r\n        /// Gets information about the associated HTTP r" +
"esponse.\r\n        /// </summary>\r\n        public Microsoft.Rest.HttpResponseMess" +
"ageWrapper Response { get; set; }\r\n");
#line 25 "ExceptionTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n        /// <summary>\r\n        /// Gets or sets the body object.\r\n        /// <" +
"/summary>\r\n        public ");
#line 29 "ExceptionTemplate.cshtml"
          Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" Body { get; set; }\r\n");
#line 30 "ExceptionTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 32 "ExceptionTemplate.cshtml"
                                         Write(Model.ExceptionTypeDefinitionName);

#line default
#line hidden
            WriteLiteral(" class.\r\n        /// </summary>\r\n        public ");
#line 34 "ExceptionTemplate.cshtml"
           Write(@Model.ExceptionTypeDefinitionName);

#line default
#line hidden
            WriteLiteral("()\r\n        {\r\n        }\r\n");
#line 37 "ExceptionTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 39 "ExceptionTemplate.cshtml"
                                         Write(Model.ExceptionTypeDefinitionName);

#line default
#line hidden
            WriteLiteral(" class.\r\n        /// </summary>\r\n        /// <param name=\"message\">The exception " +
"message.</param>\r\n        public ");
#line 42 "ExceptionTemplate.cshtml"
           Write(Model.ExceptionTypeDefinitionName);

#line default
#line hidden
            WriteLiteral("(string message)\r\n            : this(message, null)\r\n        {\r\n        }\r\n");
#line 46 "ExceptionTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 48 "ExceptionTemplate.cshtml"
                                         Write(Model.ExceptionTypeDefinitionName);

#line default
#line hidden
            WriteLiteral(" class.\r\n        /// </summary>\r\n        /// <param name=\"message\">The exception " +
"message.</param>\r\n        /// <param name=\"innerException\">Inner exception.</par" +
"am>\r\n        public ");
#line 52 "ExceptionTemplate.cshtml"
           Write(Model.ExceptionTypeDefinitionName);

#line default
#line hidden
            WriteLiteral("(string message, System.Exception innerException)\r\n            : base(message, in" +
"nerException)\r\n        {\r\n        }\r\n");
#line 56 "ExceptionTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n#if !PORTABLE \r\n        /// <summary>\r\n        /// Initializes a new instance o" +
"f the ");
#line 59 "ExceptionTemplate.cshtml"
                                         Write(Model.ExceptionTypeDefinitionName);

#line default
#line hidden
            WriteLiteral(" class.\r\n        /// </summary>\r\n        /// <param name=\"info\">Serialization inf" +
"o.</param>\r\n        /// <param name=\"context\">Streaming context.</param>\r\n      " +
"  protected ");
#line 63 "ExceptionTemplate.cshtml"
              Write(Model.ExceptionTypeDefinitionName);

#line default
#line hidden
            WriteLiteral("(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serializatio" +
"n.StreamingContext context)\r\n            : base(info, context)\r\n        {\r\n     " +
"   }\r\n");
#line 67 "ExceptionTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral(@"
        /// <summary>
        /// Serializes content of the exception.
        /// </summary>
        /// <param name=""info"">Serialization info.</param>
        /// <param name=""context"">Streaming context.</param>
        /// <exception cref=""System.ArgumentNullException"">
        /// Thrown when a required parameter is null
        /// </exception>
        [System.Security.Permissions.SecurityPermission(System.Security.Permissions.SecurityAction.Demand, SerializationFormatter = true)]
        public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context)
        {
            base.GetObjectData(info, context);
            if (info == null)
            {
                throw new System.ArgumentNullException(""info"");
            }
");
#line 84 "ExceptionTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n            info.AddValue(\"Request\", Request);\r\n            info.AddValue(\"Resp" +
"onse\", Response);\r\n            info.AddValue(\"Body\", Body);\r\n        }\r\n#endif\r\n" +
"    }\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
