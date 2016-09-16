// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.Core
{
#line 1 "FileTemplate.cshtml"

#line default
#line hidden
    using System.Threading.Tasks;

    public class FileTemplate : Template<string>
    {
        #line hidden
        public FileTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 3 "FileTemplate.cshtml"
Write(Model);

#line default
#line hidden
        }
        #pragma warning restore 1998
    }
}
