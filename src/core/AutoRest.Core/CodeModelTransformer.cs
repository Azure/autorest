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

    public interface IModelSerializer<out TCodeModel>
    {
        TCodeModel Load(string jsonText);
        TCodeModel Load(IFileSystem fileSystem, string path);
        TCodeModel Load(CodeModel codeModel);
    }


    public class ModelSerializer<TCodeModel> :  IModelSerializer<TCodeModel> where TCodeModel : CodeModel
    {
        public virtual TCodeModel Load(string jsonText)
        {
            if (!Context.IsActive)
            {
                throw new Exception("Must be in an active context to load a model");
            }

            try { File.WriteAllText(@"c:\tmp\orig.json", jsonText); } catch { }
            var result = JsonConvert.DeserializeObject<TCodeModel>(jsonText,
                CodeModelSettings.DeserializerSettings);
            try { File.WriteAllText(@"c:\tmp\second.json", ToJson(result)); } catch { }
            return result;
        }

        public virtual TCodeModel Load(IFileSystem fileSystem, string path)
        {
            return Load(fileSystem.ReadFileAsText(path));
        }

        public virtual TCodeModel Load(CodeModel codeModel)
        {
            return codeModel as TCodeModel ?? Load(ToJson(codeModel));
        }
        
        protected virtual string ToJson(CodeModel codeModel)
        {
            return JsonConvert.SerializeObject(codeModel, CodeModelSettings.SerializerSettings);
        }
    }

    public interface ITransformer<out TResultCodeModel> where TResultCodeModel : CodeModel
    {
        Trigger Trigger { get; set; }
        int Priority { get; set; }
        TResultCodeModel TransformCodeModel(CodeModel codeModel); 
    }

#if unused
    /// <summary>
    ///     A CodeModelTransformer can take a Code Model in JSON format
    ///     and perform a transformation on it to customize it in some fashion.
    ///     The language-specific CodeModelTransformers will often
    /// </summary>
    public abstract class CodeModelTransformer
    {
        public virtual Trigger Trigger { get; set; } = Trigger.AfterModelCreation;
        public virtual int Priority { get; set; } = 0;

        /// <summary>
        /// This will call the type-specific Transform() on the code model and return the mutated model.
        /// </summary>
        /// <param name="codeModel">The codemodel to run the transformation on.</param>
        /// <returns>The transformed code model</returns>
        public abstract CodeModel TransformCodeModel(CodeModel codeModel);
    }
#endif 
    public class CodeModelTransformer<TCodeModel> : ITransformer<TCodeModel> where TCodeModel : CodeModel
    {
        public virtual Trigger Trigger { get; set; } = Trigger.AfterModelCreation;
        public virtual int Priority { get; set; } = 0;

        /// <summary>
        /// A type-specific method for code model tranformation.
        /// Note: This is the method you want to override.
        /// </summary>
        /// <param name="codeModel"></param>
        /// <returns></returns>
        public virtual TCodeModel TransformCodeModel(CodeModel codeModel)
        {
            return codeModel as TCodeModel;
        }
    }


#if integrated_loader_transformer

    /*
        /// <summary>
        /// This will call the type-specific Transform() on the code model and return the mutated model.
        /// </summary>
        /// <param name="codeModel">The codemodel to run the transformation on.</param>
        /// <returns>The transformed code model</returns>
        public CodeModel TransformCodeModel(CodeModel codeModel)
        {
            if (!Context.IsActive)
            {
                throw new Exception("Must be in an active context to transform a code model");
            }

            if (!(codeModel is TCodeModel))
            {
                throw new Exception($"CodeModel is not a {nameof(TCodeModel)}. Use the serializer to load the model first.");
            }

            return Transform((TCodeModel)codeModel);
        }
*/
        private readonly Context _context;

        public CodeModelTransformer()
        {
            // call our sub-class to setup the object factories.
            _context = InitializeContext();
        }
        public virtual string Transform(string jsonText)
        {
            return ToJson(TransformCodeModel(Load(jsonText)));
        }
        public virtual void Transform(IFileSystem fileSystem, string inputPath, string outputPath)
        {
            fileSystem.WriteFile(outputPath, ToJson(Load(fileSystem, inputPath)));
        }
        protected virtual string ToJson(CodeModel codeModel)
        {
            return JsonConvert.SerializeObject(codeModel, CodeModelSettings.SerializerSettings);
        }

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
#endif



}