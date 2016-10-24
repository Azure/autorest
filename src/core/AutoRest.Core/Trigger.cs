// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

namespace AutoRest.Core {
    public enum Trigger {
        AfterModelCreation,
        BeforeLoadingLanguageSpecificModel,
        AfterLoadingLanguageSpecificModel,
        AfterLanguageSpecificTransform,
        BeforeGeneratingCode
    }
}