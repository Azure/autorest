// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

namespace AutoRest.Core {
    using Model;
    using Utilities;

    public interface IModelSerializer<out TCodeModel> {
        TCodeModel Load(string jsonText);
        TCodeModel Load(IFileSystem fileSystem, string path);
        TCodeModel Load(CodeModel codeModel);
    }
}