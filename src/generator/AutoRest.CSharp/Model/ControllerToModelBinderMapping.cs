using AutoRest.Core.Model;
using System.Collections.Generic;
namespace AutoRest.CSharp.Model
{

    static class ControllerToModelBinderMapping
    {
        static Dictionary<ParameterLocation, string> _dict = new Dictionary<ParameterLocation, string>
        {
            { ParameterLocation.None, "" },
            { ParameterLocation.Query, "FromQuery" },
            { ParameterLocation.Header, "FromHeader" },
            { ParameterLocation.Path, "FromRoute" },
            { ParameterLocation.FormData, "FromForm" },
            { ParameterLocation.Body, "FromBody" }
        };

        public static string GetModelBinder(ParameterLocation loc)
        {
            string result;
            if (_dict.TryGetValue(loc, out result))
            {
                return result;
            }
            else
            {
                return null;
            }
        }
    }
}