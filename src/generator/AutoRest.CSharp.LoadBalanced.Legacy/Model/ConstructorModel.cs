using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;

namespace AutoRest.CSharp.LoadBalanced.Legacy.Model
{
    internal class ConstructorModel
    {
        private readonly CompositeTypeCs _model;
        public ConstructorModel(CompositeTypeCs model)
        {
            _model = model;
        }

        // TODO: this could just be the "required" parameters instead of required and all the optional ones
        // with defaults if we wanted a bit cleaner constructors
        public IEnumerable<ConstructorParameterModel> Parameters
        {
            get
            {

                return _model.AllPropertyTemplateModels.OrderBy(p => !p.Property.IsRequired).ThenBy(p => p.Depth)
                    .Select(p => new ConstructorParameterModel(p.Property));

            }
        }

        public IEnumerable<string> SignatureDocumentation => CreateSignatureDocumentation(Parameters);

        public string Signature => CreateSignature(Parameters);

        public string BaseCall => CreateBaseCall(_model);

        private  string CreateSignature(IEnumerable<ConstructorParameterModel> parameters)
        {
            var declarations = new List<string>();
            foreach (var argument in GetConstructorArguments(parameters))
            {
                string format = argument.IsRequired ? "{0} {1}" : "{0} {1} = default({0})";

                var typeName = _model.PropertyTypeSelectionStrategy?.GetPropertyTypeName(argument) ?? argument.ModelTypeName;
                var argumentName = CodeNamer.Instance.CamelCase(argument.Name);

                declarations.Add(string.Format(CultureInfo.InvariantCulture, format, typeName, argumentName));
            }

            return string.Join(", ", declarations);
        }

        private IEnumerable<Property> GetConstructorArguments(IEnumerable<ConstructorParameterModel> parameters)
        {
            foreach (var property in parameters.Where(p => !p.UnderlyingProperty.IsConstant).Select(p => p.UnderlyingProperty))
            {
                yield return property;
            }
        }

        private static IEnumerable<string> CreateSignatureDocumentation(IEnumerable<ConstructorParameterModel> parameters)
        {
            var declarations = new List<string>();

            IEnumerable<Property> parametersWithDocumentation =
               parameters.Where(p => !(string.IsNullOrEmpty(p.UnderlyingProperty.Summary) &&
               string.IsNullOrEmpty(p.UnderlyingProperty.Documentation)) &&
               !p.UnderlyingProperty.IsConstant).Select(p => p.UnderlyingProperty);

            foreach (var property in parametersWithDocumentation)
            {
                var documentationInnerText = string.IsNullOrEmpty(property.Summary) ? property.Documentation.EscapeXmlComment() : property.Summary.EscapeXmlComment();

                var documentation = string.Format(
                    CultureInfo.InvariantCulture,
                    "<param name=\"{0}\">{1}</param>",
                    char.ToLower(property.Name.CharAt(0), CultureInfo.InvariantCulture) + property.Name.Substring(1),
                    documentationInnerText);

                declarations.Add(documentation);
            }

            return declarations;
        }

        private static string CreateBaseCall(CompositeTypeCs model)
        {
            if (model.BaseModelType != null)
            {
                IEnumerable<ConstructorParameterModel> parameters = (model.BaseModelType as CompositeTypeCs)?._constructorModel.Parameters;
                if (parameters.Any())
                {
                    return $": base({string.Join(", ", parameters.Select(p => p.Name))})";
                }
            }

            return string.Empty;
        }
    }
}
