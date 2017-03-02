using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using AutoRest.Core.Model;

namespace AutoRest.TypeScript.SuperAgent.ModelBinder
{
    public class ModelBinderBaseTs
    {
        protected bool TryGetResponseName(Method method, out IModelType modelType, out string responseName, out string requestName)
        {
            responseName = null;
            requestName = null;
            modelType = null;

            Response okResponse = method.Responses.ContainsKey(HttpStatusCode.OK) ? 
                method.Responses[HttpStatusCode.OK] : 
                method.Responses.Values.FirstOrDefault(r => r.Body != null);

            if (okResponse == null)
            {
                return false;
            }

            modelType = okResponse.Body;

            var doNotWrap = modelType.IsPrimaryType() || modelType.IsSequenceType() || modelType.IsEnumType();

            if (doNotWrap)
            {
                var serializedName = method.SerializedName.Value;
                var parts = serializedName.Split('_');
                if (parts.Length > 1)
                {
                    requestName = parts[0];
                }
            }

            responseName = GetTypeText(modelType);

            if (requestName == null)
            {
                requestName = GetTypeText(modelType);
            }
         
            if (requestName.Contains("[]"))
            {
                requestName = requestName.Replace("[]", "List");
            }

            requestName = $"{requestName}Request".TrimStart('I');

            return true;
        }

        protected string GetTypeText(IModelType modelType)
        {
            var seqType = modelType as SequenceTypeTs;

            string name = "";

            if (seqType == null)
            {
                name = modelType.GetImplementationName();

                if (modelType.IsEnumType())
                {
                    return name;
                }

                return modelType.IsPrimaryType() ? name : $"I{name}";
            }

            var elementType = seqType.ElementType;
            name = elementType.GetImplementationName();

            return SequenceTypeTs.CreateSeqTypeText(elementType.IsPrimaryType() ? name : $"I{name}");
        }


    }
}
