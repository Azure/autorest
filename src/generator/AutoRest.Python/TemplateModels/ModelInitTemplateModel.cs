// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.ClientModel;

namespace AutoRest.Python.TemplateModels
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