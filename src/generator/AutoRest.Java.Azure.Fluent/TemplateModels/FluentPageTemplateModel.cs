// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Java.Azure.Fluent
{
    public class FluentPageTemplateModel : PageTemplateModel
    {
        public FluentPageTemplateModel(string typeDefinitionName, string nextLinkName, string itemName)
            : base(typeDefinitionName, nextLinkName, itemName) {
        }

        public override string ModelsPackage
        {
            get
            {
                return "implementation";
            }
        }
    }
}
