// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.Ruby.Templates
{
#line 1 "ServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.Ruby

#line default
#line hidden
    ;
#line 2 "ServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.Ruby.Templates

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
#line 5 "ServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.Ruby.TemplateModels

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ServiceClientTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.Ruby.ServiceClientTemplateModel>
    {
        #line hidden
        public ServiceClientTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 7 "ServiceClientTemplate.cshtml"
Write(Header("# "));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 8 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nmodule ");
#line 9 "ServiceClientTemplate.cshtml"
  Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral("\r\n  #\r\n  ");
#line 11 "ServiceClientTemplate.cshtml"
Write(WrapComment("# ", Model.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n  #\r\n  class ");
#line 13 "ServiceClientTemplate.cshtml"
   Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" < ");
#line 13 "ServiceClientTemplate.cshtml"
                 Write(Model.BaseType);

#line default
#line hidden
            WriteLiteral("\r\n    # @return [String] the base URI of the service.\r\n    attr_accessor :base_ur" +
"l\r\n");
#line 16 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n");
#line 18 "ServiceClientTemplate.cshtml"
 foreach (var property in Model.Properties)
{

#line default
#line hidden

            WriteLiteral("    ");
#line 20 "ServiceClientTemplate.cshtml"
 Write(WrapComment("# ", string.Format("@return {0}{1}", property.Type.GetYardDocumentation(), property.Documentation)));

#line default
#line hidden
            WriteLiteral("\r\n    ");
#line 21 "ServiceClientTemplate.cshtml"
  Write(property.IsReadOnly ? "attr_reader" : "attr_accessor");

#line default
#line hidden
            WriteLiteral(" :");
#line 21 "ServiceClientTemplate.cshtml"
                                                           Write(property.Name);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 22 "ServiceClientTemplate.cshtml"

#line default
#line hidden

#line 22 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 22 "ServiceClientTemplate.cshtml"
          
}

#line default
#line hidden

            WriteLiteral("\r\n");
#line 25 "ServiceClientTemplate.cshtml"
 foreach (var operation in Model.MethodGroups) 
{

#line default
#line hidden

            WriteLiteral("    ");
#line 27 "ServiceClientTemplate.cshtml"
 Write(WrapComment("# ", string.Format("@return {0}", RubyCodeNamer.UnderscoreCase(operation))));

#line default
#line hidden
            WriteLiteral("\r\n    attr_reader :");
#line 28 "ServiceClientTemplate.cshtml"
               Write(RubyCodeNamer.UnderscoreCase(operation));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 29 "ServiceClientTemplate.cshtml"

#line default
#line hidden

#line 29 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 29 "ServiceClientTemplate.cshtml"
          
}

#line default
#line hidden

            WriteLiteral("\r\n");
#line 32 "ServiceClientTemplate.cshtml"
  var parameters = Model.Properties.Where(p => p.IsRequired);

#line default
#line hidden

            WriteLiteral("\r\n\r\n    #\r\n    # Creates and initializes a new instance of the ");
#line 35 "ServiceClientTemplate.cshtml"
                                               Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\r\n    # @param base_url [String] base url for accessing current service.\r\n" +
"");
#line 37 "ServiceClientTemplate.cshtml"
    

#line default
#line hidden

#line 37 "ServiceClientTemplate.cshtml"
     foreach (var param in parameters)
    {
    

#line default
#line hidden

#line 39 "ServiceClientTemplate.cshtml"
Write(WrapComment("# ", string.Format("@param {0} {1}{2}", param.Name, param.Type.GetYardDocumentation(), param.Documentation)));

#line default
#line hidden
#line 39 "ServiceClientTemplate.cshtml"
                                                                                                                              

#line default
#line hidden

            WriteLiteral("    \r\n");
#line 41 "ServiceClientTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    #\r\n    def initialize(base_url = nil");
#line 43 "ServiceClientTemplate.cshtml"
                             Write(Model.RequiredContructorParametersWithSeparator);

#line default
#line hidden
            WriteLiteral(")\r\n      super(");
#line 44 "ServiceClientTemplate.cshtml"
        Write(Model.BaseClassParams);

#line default
#line hidden
            WriteLiteral(")\r\n      @base_url = base_url || \'");
#line 45 "ServiceClientTemplate.cshtml"
                           Write(Model.BaseUrl);

#line default
#line hidden
            WriteLiteral("\'\r\n");
#line 46 "ServiceClientTemplate.cshtml"
      

#line default
#line hidden

#line 46 "ServiceClientTemplate.cshtml"
       foreach (var operation in Model.MethodGroups) 
      {

#line default
#line hidden

            WriteLiteral("      @");
#line 48 "ServiceClientTemplate.cshtml"
      Write(RubyCodeNamer.UnderscoreCase(operation));

#line default
#line hidden
            WriteLiteral(" = ");
#line 48 "ServiceClientTemplate.cshtml"
                                                   Write(operation);

#line default
#line hidden
            WriteLiteral(".new(self)\r\n");
#line 49 "ServiceClientTemplate.cshtml"
      }

#line default
#line hidden

            WriteLiteral("      ");
#line 50 "ServiceClientTemplate.cshtml"
       foreach (var param in parameters)
      {

#line default
#line hidden

            WriteLiteral("      fail ArgumentError, \'");
#line 52 "ServiceClientTemplate.cshtml"
                        Write(param.Name);

#line default
#line hidden
            WriteLiteral(" is nil\' if ");
#line 52 "ServiceClientTemplate.cshtml"
                                                Write(param.Name);

#line default
#line hidden
            WriteLiteral(".nil?\r\n");
#line 53 "ServiceClientTemplate.cshtml"
      }

#line default
#line hidden

            WriteLiteral("      ");
#line 54 "ServiceClientTemplate.cshtml"
       foreach (var param in parameters)
      {

#line default
#line hidden

            WriteLiteral("      @");
#line 56 "ServiceClientTemplate.cshtml"
     Write(param.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 56 "ServiceClientTemplate.cshtml"
                   Write(param.Name);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 57 "ServiceClientTemplate.cshtml"
      }

#line default
#line hidden

            WriteLiteral("\r\n    end\r\n\r\n    ");
#line 61 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 62 "ServiceClientTemplate.cshtml"
    

#line default
#line hidden

#line 62 "ServiceClientTemplate.cshtml"
     foreach (var method in Model.MethodTemplateModels)
    {

#line default
#line hidden

            WriteLiteral("    ");
#line 64 "ServiceClientTemplate.cshtml"
  Write(Include(new MethodTemplate(), method));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 65 "ServiceClientTemplate.cshtml"
    

#line default
#line hidden

#line 65 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 65 "ServiceClientTemplate.cshtml"
              

#line default
#line hidden

            WriteLiteral("    \r\n");
#line 67 "ServiceClientTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("  end\r\nend\r\n");
        }
        #pragma warning restore 1998
    }
}
