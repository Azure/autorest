// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Core {
    using System;
    using System.IO;
    using Model;
    using Newtonsoft.Json;
    using Utilities;

    public class ModelSerializer<TCodeModel> : IModelSerializer<TCodeModel> where TCodeModel : CodeModel {
        public virtual TCodeModel Load(string jsonText) {
            if (!Context.IsActive) {
                throw new Exception("Must be in an active context to load a model");
            }
            var result = JsonConvert.DeserializeObject<TCodeModel>(jsonText,
                CodeModelSettings.DeserializerSettings);
            return result;
        }

        public virtual TCodeModel Load(IFileSystem fileSystem, string path) {
            return Load(fileSystem.ReadFileAsText(path));
        }

        public virtual TCodeModel Load(CodeModel codeModel) {
            return codeModel as TCodeModel ?? Load(ToJson(codeModel));
        }

        public virtual string ToJson(CodeModel codeModel) {
            return JsonConvert.SerializeObject(codeModel, CodeModelSettings.SerializerSettings);
        }
    }
}