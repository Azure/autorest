using System.Collections.Generic;

namespace AutoRest.CSharp.LoadBalanced.Legacy.Model
{
    public class ClientCodeModelCs
    {
        public string Name { get; set; }
        public MethodCs[] Methods { get; set; }
        public IEnumerable<string> Usings { get; set; }
        public string Documentation { get; set; }
        public bool IsCustomBaseUri { get; set; }
        public IEnumerable<PropertyCs> Properties { get; set; }
        public IEnumerable<MethodGroupCs> AllOperations { get; set; }
    }
}
