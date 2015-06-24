// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.Test.Templates
{
    using System.Threading.Tasks;

    public class SampleModel : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.Test.Resource.SampleViewModel>
    {
        #line hidden
        public SampleModel()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
            WriteLiteral("using System;\r\nusing System.Collection;\r\n");
#line 4 "SampleModel.cshtml"
Write(Model.Imports);

#line default
#line hidden
            WriteLiteral("\r\nnamespace ");
#line 5 "SampleModel.cshtml"
     Write(Model.Namespace);

#line default
#line hidden
            WriteLiteral("\r\n{\r\n    public partial class ");
#line 7 "SampleModel.cshtml"
                    Write(Model.Name);

#line default
#line hidden
            WriteLiteral("\r\n    {\r\n");
#line 9 "SampleModel.cshtml"
        

#line default
#line hidden

#line 9 "SampleModel.cshtml"
         foreach(var property in Model.Properties)
        {

#line default
#line hidden

            WriteLiteral("        ");
#line 11 "SampleModel.cshtml"
     Write(property.Documentation);

#line default
#line hidden
            WriteLiteral("\r\n        public ");
#line 12 "SampleModel.cshtml"
            Write(property.Type);

#line default
#line hidden
            WriteLiteral(" ");
#line 12 "SampleModel.cshtml"
                           Write(property.Name);

#line default
#line hidden
            WriteLiteral(" { get; ");
#line 12 "SampleModel.cshtml"
                                                  Write(property.ReadOnly ? "private" : "");

#line default
#line hidden
            WriteLiteral(" set; }\r\n        \r\n");
#line 14 "SampleModel.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        /// Serialize the object\r\n        /// </summary>\r\n" +
"        /// <returns>\r\n        /// Returns the json model for the type ");
#line 19 "SampleModel.cshtml"
                                           Write(Model.Name);

#line default
#line hidden
            WriteLiteral("\r\n        /// </returns>\r\n        public virtual JToken SerializeJson(JToken outp" +
"utObject)\r\n        {\r\n            ");
#line 23 "SampleModel.cshtml"
       Write(Model.SerializationBlock);

#line default
#line hidden
            WriteLiteral("\r\n        }\r\n\r\n        /// <summary>\r\n        ");
#line 27 "SampleModel.cshtml"
   Write(WrapComment("/// ", "Deserialize current type to Json object because today is Friday and there is a sun outside the window."));

#line default
#line hidden
            WriteLiteral("\r\n        /// </summary>\r\n        public virtual void DeserializeJson(JToken inpu" +
"tObject)\r\n        {\r\n            ");
#line 31 "SampleModel.cshtml"
       Write(Model.DeserializationBlock);

#line default
#line hidden
            WriteLiteral("\r\n        }\r\n    }\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
