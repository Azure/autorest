// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Python.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Generator;

namespace Microsoft.Rest.Generator.Python
{
    public class ModelInitTemplateModel
    {
        public ModelInitTemplateModel(ServiceClient serviceClient)
        {
            ServiceClient = serviceClient;
        }

        public ServiceClient ServiceClient { get; set; }

        public virtual string GetExceptionNameIfExist(IType type, bool needsQuote)
        {
            CompositeType compType = type as CompositeType;
            if (compType != null)
            {
                if (ServiceClient.ErrorTypes.Contains(compType))
                {
                    if (needsQuote)
                    {
                        return ", '" + compType.GetExceptionDefineType() + "'";
                    }
                    return ", " + compType.GetExceptionDefineType();
                }
            }

            return string.Empty;
        }
    }
}