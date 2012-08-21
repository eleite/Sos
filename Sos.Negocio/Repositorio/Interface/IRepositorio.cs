using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;
using System.Data.Objects.DataClasses;
using System.Data.Objects;
using System.Collections.ObjectModel;
using System.Linq.Expressions;

namespace Sos.Negocio.Repositorio.Interface
{
    public interface IRepositorio : IDisposable
    {
        DbTransaction BeginTransaction();
        void Add<E>(E entity) where E : EntityObject;
        void AddOrAttach<E>(E entity) where E : EntityObject;
        void DeleteRelatedEntries<E>(E entity) where E : EntityObject;
        void DeleteRelatedEntries<E>(E entity, ObservableCollection<string> keyListOfIgnoreEntites) where E : EntityObject;
        void Delete<E>(E entity) where E : EntityObject;
        int Save();

        ObjectQuery<E> DoQuery<E>() where E : EntityObject;
        ObjectQuery<E> DoQuery<E>(string entitySetName) where E : EntityObject;
        ObjectQuery<E> DoQuery<E>(string entitySetName, IEspecificacao<E> where) where E : EntityObject;
        ObjectQuery<E> DoQuery<E>(IEspecificacao<E> where) where E : EntityObject;
        ObjectQuery<E> DoQuery<E>(int maximumRows, int startRowIndex) where E : EntityObject;
        ObjectQuery<E> DoQuery<E>(Expression<Func<E, object>> sortExpression) where E : EntityObject;
        ObjectQuery<E> DoQuery<E>(Expression<Func<E, object>> sortExpression, int maximumRows, int startRowIndex) where E : EntityObject;

        IList<E> SelectAll<E>(string entitySetName) where E : EntityObject;
        IList<E> SelectAll<E>() where E : EntityObject;
        IList<E> SelectAll<E>(string entitySetName, IEspecificacao<E> where) where E : EntityObject;
        IList<E> SelectAll<E>(IEspecificacao<E> where) where E : EntityObject;
        IList<E> SelectAll<E>(int maximumRows, int startRowIndex) where E : EntityObject;
        IList<E> SelectAll<E>(Expression<Func<E, object>> sortExpression) where E : EntityObject;
        IList<E> SelectAll<E>(Expression<Func<E, object>> sortExpression, int maximumRows, int startRowIndex) where E : EntityObject;

        E SelectByKey<E>(int Key, params string[] Includes) where E : EntityObject;

        bool TrySameValueExist<E>(string fieldName, object fieldValue, string key) where E : EntityObject;
        bool TryEntity<E>(IEspecificacao<E> selectSpec) where E : EntityObject;

        int GetCount<E>() where E : EntityObject;
        int GetCount<E>(IEspecificacao<E> selectSpec) where E : EntityObject;
    }
}
