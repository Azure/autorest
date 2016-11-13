// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

namespace AutoRest.NodeJS.Model
{
    public class DictionaryTypeJs : Core.Model.DictionaryType
    {
        public DictionaryTypeJs()
        {
            Name.OnGet += v => $"Object";
        }
    }
}