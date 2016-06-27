namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public abstract class RequiredAttribute : RuleAttribute
    {
        public override bool IsSatisfiedBy(object obj)
        {
            return obj != null;
        }
    }
}
