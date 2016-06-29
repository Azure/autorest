using System.Collections.Generic;

namespace Microsoft.Rest.Generator
{
    public interface IValidator<T>
    {
        bool IsValid(T entity);

        // TODO: change to from log entry
        IEnumerable<ValidationMessage> ValidationExceptions(T entity);
    }
}
