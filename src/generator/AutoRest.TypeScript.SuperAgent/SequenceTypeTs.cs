using System;
using AutoRest.Core.Model;

namespace AutoRest.TypeScript.SuperAgent
{
    public class SequenceTypeTs : SequenceType, IImplementationNameAware
    {
        public SequenceTypeTs()
        {
            //Name.OnGet += v => ImplementationName;
        }

        public virtual string ImplementationName
        {
            get { return $"{XmlName}[]"; }
        }
    }
}
