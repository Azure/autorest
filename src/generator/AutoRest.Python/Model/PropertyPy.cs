// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Model;
using AutoRest.Core.Utilities;

namespace AutoRest.Python.Model
{
    public class PropertyPy : Property
    {
        public PropertyPy()
        {
            Name.OnGet += value =>
            {
                if (!(Parent is CodeModel))
                {
                    if (IsSpecialConstant && IsConstant && !value.StartsWith("self."))
                    {
                        return $"self.{value.ToPythonCase()}";
                    }
                }
                return value.ToPythonCase();
            };
            DefaultValue.OnGet += value => value.Else(PythonConstants.None);

            SerializedName.OnGet += value =>
            {
                if (value != null)
                {
                    if (value.IndexOf(".") > -1 && value.IndexOf("\\\\") == -1 &&
                        !Extensions.ContainsKey("x-ms-client-flatten-original-type-name"))
                    {
                        return value.Replace(".", "\\\\.");
                    }
                }
                return value;
            };
        }

        public bool IsSpecialConstant { get; set; }
    }
}