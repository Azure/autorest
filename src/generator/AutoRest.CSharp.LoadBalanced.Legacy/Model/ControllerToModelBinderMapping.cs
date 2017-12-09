using AutoRest.Core.Model;

namespace AutoRest.CSharp.LoadBalanced.Legacy.Model
{

    static class ControllerToModelBinderMapping
    {
        public static string GetModelBinder(ParameterLocation loc)
        {
            switch(loc)
            {
                case ParameterLocation.None:
                    return string.Empty;
                case ParameterLocation.Query:
                    return "FromQuery";
                case ParameterLocation.Header:
                    return "FromHeader";
                case ParameterLocation.Path:
                    return "FromRoute";
                case ParameterLocation.FormData:
                    return "FromForm";
                case ParameterLocation.Body:
                    return "FromBody";
                default:
                    return string.Empty;
            }
        }
    }
}