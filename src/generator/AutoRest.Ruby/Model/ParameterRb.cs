// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Model;

namespace AutoRest.Ruby.Model
{
    /// <summary>
    /// The model for parameter template.
    /// </summary>
    public class ParameterRb : Parameter
    {
        public ParameterRb()
        {
            Name.OnGet += value =>
            {
                if (IsClientProperty)
                {
                    if (true == Method?.MethodGroup?.IsCodeModelMethodGroup)
                    {
                        return ClientProperty.Name;
                    }
                    return $"{((MethodRb)Method)?.ClientReference}.{value}";
                }
                return value;
            };
        }
    }
}