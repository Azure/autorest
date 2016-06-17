using Microsoft.Rest.Generator.Logging;
using System.Collections.Generic;

namespace Microsoft.Rest.Modeler.Swagger
{
    public interface IValidator<T>
    {
        bool IsValid(T entity);

        // TODO: change to from log entry
        IEnumerable<ValidationMessage> ValidationExceptions(T entity);
    }
}
