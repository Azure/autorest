// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

namespace AutoRest.NodeJS.Model
{
    public class SequenceTypeJs : Core.Model.SequenceType
    {
        public SequenceTypeJs()
        {
            Name.OnGet += v => $"Array";
        }
    }
}