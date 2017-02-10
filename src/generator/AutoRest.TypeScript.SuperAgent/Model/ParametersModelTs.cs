using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Model;

namespace AutoRest.TypeScript.SuperAgent.Model
{
    public class ParametersModelTs
    {
        private readonly IEnumerableWithIndex<Parameter> _parameters;

        public ParametersModelTs(IEnumerableWithIndex<Parameter> parameters)
        {
            _parameters = parameters;
        }

        public IEnumerable<string> ParamNamesInPath => _parameters.Where(p => p.Location == ParameterLocation.Path).Select(p => p.Name.Value);
        public IEnumerable<string> ParamNamesInQuery => _parameters.Where(p => p.Location == ParameterLocation.Query).Select(p => p.Name.Value);
        public IEnumerable<string> ParamNamesInBody => _parameters.Where(p => p.Location == ParameterLocation.Body).Select(p => p.Name.Value);
        public IEnumerable<string> ParamNamesInHeader => _parameters.Where(p => p.Location == ParameterLocation.Header).Select(p => p.Name.Value);

    }
}
