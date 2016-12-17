using AutoRest.Core.Model;
using AutoRest.Java.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Java.Azure.Model
{
    public class SequenceTypeJva : SequenceTypeJv
    {
        protected string _azureRuntimePackage = "com.microsoft.azure";

        public string PageImplType { get; set; }
    }
}
