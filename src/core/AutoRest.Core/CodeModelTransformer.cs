// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.IO;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using Newtonsoft.Json;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Core
{
    public enum Trigger
    {
        AfterModelCreation,
        BeforeLoadingLanguageSpecificModel,
        AfterLoadingLanguageSpecificModel,
        AfterLanguageSpecificTransform,
        BeforeGeneratingCode
    }

    /// <summary>
    ///     A CodeModelTransformer can take a Code Model in JSON format
    ///     and perform a transformation on it to customize it in some fashion.
    ///     The language-specific CodeModelTransformers will often
    /// </summary>
    public class CodeModelTransformer
    {
        private readonly Context _context;

        public CodeModelTransformer()
        {
            // call our sub-class to setup the object factories.
            _context = InitializeContext();
        }

        public virtual Trigger Trigger { get; set; } = Trigger.AfterModelCreation;
        public virtual int Priority { get; set; } = 0;

        /// <summary>
        ///     This method should be overriden to setup the object factories for any
        ///     overrides for any of the Code Model classes.
        /// </summary>
        protected virtual Context InitializeContext()
        {
            // create any appropriate factories:
            return new Context();
        }

        public IDisposable Activate() => _context.Activate();

        public virtual CodeModel Load(string jsonText)
        {
            using (_context.Activate())
            {
                try { File.WriteAllText(@"c:\tmp\orig.json",jsonText); } catch { }
                var result = JsonConvert.DeserializeObject<CodeModel>(jsonText,
                    CodeModelSettings.DeserializerSettings);
                try { File.WriteAllText(@"c:\tmp\second.json", ToJson(result)); } catch { }
                return result;
            }
        }

        public virtual CodeModel Load(IFileSystem fileSystem, string path)
        {
            return Load(fileSystem.ReadFileAsText(path));
        }

        public virtual CodeModel Load(CodeModel codeModel)
        {
            return Load(ToJson(codeModel));
        }

        public virtual string Transform(string jsonText)
        {
            return ToJson(TransformCodeModel(Load(jsonText)));
        }

        public CodeModel TransformCodeModel(CodeModel codeModel)
        {
            using (_context.Activate())
            {
                var result = Transform(codeModel);
                try { File.WriteAllText(@"c:\tmp\third.json", ToJson(result));} catch { }
                return result;
            }
        }

        protected virtual CodeModel Transform(CodeModel codeModel)
        {
            return codeModel;
        }

        protected virtual string ToJson(CodeModel codeModel)
        {
            return JsonConvert.SerializeObject(codeModel, CodeModelSettings.SerializerSettings);
        }

        public virtual void Transform(IFileSystem fileSystem, string inputPath, string outputPath)
        {
            fileSystem.WriteFile(outputPath, ToJson(Load(fileSystem, inputPath)));
        }
    }
}