using System;
using AutoRest.Core.Model;

namespace AutoRest.TypeScript.SuperAgent
{
    public class CompositeTypeTs : CompositeType, IImplementationNameAware
    {
        public CompositeTypeTs()
        {

        }

        public CompositeTypeTs(string name) : base(name)
        {

        }

        public string ImplementationName => ((IModelType)this).Name.Value; /*
            .Replace("Response", "")
            .Replace("Request", "")
            .Replace("Message", "")
            .Replace("ViewModel", "")
            .Replace("Model", "");*/
    }
}
