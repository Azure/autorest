using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.TypeScript.SuperAgent.Model;

namespace AutoRest.TypeScript.SuperAgent
{
    public class TransformerTs : CodeModelTransformer<CodeModelTs>
    {
        /// <summary>
        /// A type-specific method for code model tranformation.
        /// Note: This is the method you want to override.
        /// </summary>
        /// <param name="codeModel"></param>
        /// <returns></returns>
        public override CodeModelTs TransformCodeModel(CodeModel codeModel)
        {
            var newCodeModel = base.TransformCodeModel(codeModel);
            return newCodeModel;
        }
    }
}
