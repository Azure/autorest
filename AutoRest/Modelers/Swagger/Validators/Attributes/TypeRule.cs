using Microsoft.Rest.Generator.Validation;
using Microsoft.Rest.Generators.Validation;
using System;
using System.Collections.Generic;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public abstract class TypeRule<T> : Rule where T : class
    {
        public TypeRule()
        {
        }

        public sealed override IEnumerable<ValidationMessage> GetValidationMessages(object obj)
        {
            var entity = obj as T;
            if (entity != null)
            {
                foreach (var exception in GetValidationMessages(entity))
                {
                    yield return exception;
                }
            }
            yield break;
        }

        /// <summary>
        /// Overridable method that lets a child rule return objects to be passed to string.Format
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public virtual IEnumerable<ValidationMessage> GetValidationMessages(T entity)
        {
            object[] formatParams;
            if (!IsValid(entity, out formatParams))
            {
                yield return CreateException(null, Exception, formatParams);
            }
            yield break;
        }

        /// <summary>
        /// Overridable method that lets a child rule return objects to be passed to string.Format
        /// </summary>
        /// <param name="entity"></param>
        /// <param name="formatParams"></param>
        /// <returns></returns>
        public virtual bool IsValid(T entity, out object[] formatParams)
        {
            formatParams = new object[0];
            return IsValid(entity);
        }

        /// <summary>
        /// Overridable method that lets a child rule specify if <paramref name="entity"/> passes validation
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public virtual bool IsValid(T entity)
        {
            return true;
        }
    }
}
