using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Objects.DataClasses;
using System.Linq.Expressions;

namespace Sos.Negocio.Repositorio.Interface
{
    public interface IEspecificacao<E> where E : EntityObject
    {
        /// <summary>
        /// Select/Where Expression
        /// </summary>
        Expression<Func<E, bool>> EvalPredicate { get; }
        /// <summary>
        /// Function to evaluate where Expression
        /// </summary>
        Func<E, bool> EvalFunc { get; }
    }
}
