using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Sos.Negocio.Repositorio.Interface;
using System.Data.Objects.DataClasses;
using System.Linq.Expressions;

namespace Sos.Negocio.Repositorio.Implementacao
{
    public class Especificacao<E> : IEspecificacao<E> where E : EntityObject
    {
        #region Private Members

        private Func<E, bool> _evalFunc = null;
        private Expression<Func<E, bool>> _evalPredicate;

        #endregion

        #region Virtual Accessors

        public virtual Expression<Func<E, bool>> EvalPredicate
        {
            get { return _evalPredicate; }
        }

        public virtual Func<E, bool> EvalFunc
        {
            get { return _evalFunc; }
        }

        #endregion

        #region Constructors

        public Especificacao(Expression<Func<E, bool>> predicate)
        {
            _evalPredicate = predicate;
        }

        private Especificacao() { }

        #endregion
    }
}
