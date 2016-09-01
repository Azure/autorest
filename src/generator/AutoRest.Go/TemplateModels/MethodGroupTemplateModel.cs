// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.Go.TemplateModels
{
    public class MethodGroupTemplateModel : ServiceClientTemplateModel
    {
        public MethodGroupTemplateModel(ServiceClient serviceClient, string packageName, string methodGroupName)
            : base(serviceClient, packageName, methodGroupName)
        {
            this.LoadFrom(serviceClient);

            Documentation = string.Format("{0} is the {1} ", ClientName,
                                    string.IsNullOrEmpty(Documentation)
                                        ? string.Format("client for the {0} methods of the {1} service.", MethodGroupName, ServiceName)
                                        : Documentation.ToSentence());
        }
    }
}