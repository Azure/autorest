namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public abstract class RequiredAttribute : RuleAttribute
    {
        public override bool IsSatisfiedBy(object obj, out object[] formatParams)
        {
            formatParams = null;
            return obj != null;
        }
    }
}
