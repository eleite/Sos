using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Sos.Negocio.Repositorio.Interface;
using System.Data.Objects;
using System.Data.Objects.DataClasses;
using Sos.Negocio.Repositorio.Util;
using System.Linq.Expressions;
using System.Data;
using System.Data.Metadata.Edm;
using System.Data.Common;
using System.Collections.ObjectModel;
using System.Reflection;

namespace Sos.Negocio.Repositorio.Implementacao
{
    public class RepositorioBase<C> : IRepositorio, IDisposable
    where C : ObjectContext
    {
        #region Private Members
        private readonly C _ctx;

        public C Session
        {
            get { return _ctx; }
        }

        public RepositorioBase(C session)
        {
            _ctx = session;
        }
        #endregion

        #region IRepositorio<E,C> Members

        public int Save()
        {
            return _ctx.SaveChanges();
        }
        /// <summary>
        /// A generic method to return ALL the entities
        /// </summary>
        /// <param name=”entitySetName”>
        /// The EntitySet name of the entity in the model.
        /// </param>
        /// <typeparam name=”TEntity”>
        /// The Entity to load from the database.
        /// </typeparam>
        /// <returns>Returns a set of TEntity.</returns>
        public virtual ObjectQuery<E> DoQuery<E>(string entitySetName) where E : EntityObject
        {
            return _ctx.CreateQuery<E>("[" + entitySetName + "]");
        }
        /// <summary>
        /// A generic method to return ALL the entities
        /// </summary>
        /// <typeparam name=”TEntity”>
        /// The Entity to load from the database.
        /// </typeparam>
        /// <returns>Returns a set of TEntity.</returns>
        public virtual ObjectQuery<E> DoQuery<E>() where E : EntityObject
        {
            return _ctx.CreateQuery<E>(_ctx.GetEntitySet<E>().Name);
        }
        /*
        public virtual string EntitySetName<E>()
        {
            return String.Format( "{0}.{1}", _ctx.DefaultContainerName, _ctx.MetadataWorkspace.GetEntityContainer( _ctx.DefaultContainerName, DataSpace.CSpace ).BaseEntitySets.Where( bes => bes.ElementType.Name == typeof( E ).Name ).First().Name );
        }
        */
        /// <summary>
        /// </summary>
        /// <param name=”entitySetName”>
        /// The EntitySet name of the entity in the model.
        /// </param>
        /// <typeparam name=”TEntity”>
        /// The Entity to load from the database.
        /// </typeparam>
        /// <returns>Returns a set of TEntity.</returns>
        public virtual ObjectQuery<E> DoQuery<E>(string entitySetName, IEspecificacao<E> where) where E : EntityObject
        {
            return
                (ObjectQuery<E>)_ctx.CreateQuery<E>("[" + entitySetName + "]").Where(where.EvalPredicate);
        }

        /// <summary>
        /// </summary>
        /// <typeparam name=”TEntity”>
        /// The Entity to load from the database.
        /// </typeparam>
        /// <returns>Returns a set of TEntity.</returns>
        public virtual ObjectQuery<E> DoQuery<E>(IEspecificacao<E> where) where E : EntityObject
        {
            return (ObjectQuery<E>)_ctx.CreateQuery<E>(_ctx.GetEntitySet<E>().Name).Where(where.EvalPredicate);
        }
        /// <summary>
        /// Query Entity with Paging 
        /// </summary>
        /// <param name="maximumRows">Max no of row to Fetch</param>
        /// <param name="startRowIndex">Start Index</param>
        /// <returns>Collection of Entities</returns>
        public virtual ObjectQuery<E> DoQuery<E>(int maximumRows, int startRowIndex) where E : EntityObject
        {
            return (ObjectQuery<E>)_ctx.CreateQuery<E>(_ctx.GetEntitySet<E>().Name).Skip<E>(startRowIndex).Take(maximumRows);
        }
        /// <summary>
        /// Query Entity in sorted Order
        /// </summary>
        /// <param name="sortExpression">Sort Expression/condition</param>
        /// <param name="ErrorCode">custom Error Message</param> 
        /// <returns>Collection of Entities</returns>
        public virtual ObjectQuery<E> DoQuery<E>(Expression<Func<E, object>> sortExpression) where E : EntityObject
        {
            if (null == sortExpression)
            {
                return ((IRepositorio)this).DoQuery<E>();
            }
            return (ObjectQuery<E>)((IRepositorio)this).DoQuery<E>().OrderBy<E, object>(sortExpression);
        }
        /// <summary>
        /// Query All Entity in sorted Order with Paging support
        /// </summary>
        /// <param name="sortExpression">Sort Expression/condition</param>
        /// <param name="maximumRows">Max no of row to Fetch</param>
        /// <param name="startRowIndex">Start Index</param>
        /// <returns>Collection Of entities</returns>
        public virtual ObjectQuery<E> DoQuery<E>(Expression<Func<E, object>> sortExpression, int maximumRows, int startRowIndex) where E : EntityObject
        {
            if (sortExpression == null)
            {
                return ((IRepositorio)this).DoQuery<E>(maximumRows, startRowIndex);
            }
            return (ObjectQuery<E>)((IRepositorio)this).DoQuery(sortExpression).Skip<E>(startRowIndex).Take(maximumRows);
        }
        /// <summary>
        /// A generic method to return ALL the entities
        /// </summary>
        /// <param name=”entitySetName”>
        /// The EntitySet name of the entity in the model.
        /// </param>
        /// <typeparam name=”TEntity”>
        /// The Entity to load from the database.
        /// </typeparam>
        /// <returns>Returns a set of TEntity.</returns>
        public virtual IList<E> SelectAll<E>(string entitySetName) where E : EntityObject
        {
            return DoQuery<E>(entitySetName).ToList();
        }
        /// <summary>
        /// A generic method to return ALL the entities
        /// </summary>
        /// <typeparam name=”TEntity”>
        /// The Entity to load from the database.
        /// </typeparam>
        /// <returns>Returns a set of TEntity.</returns>
        public virtual IList<E> SelectAll<E>() where E : EntityObject
        {
            try
            {
                return DoQuery<E>().ToList(); //_ctx.CreateQuery<E>
                //(EntitySetName<E>());
            }
            catch (Exception)
            {
                throw;
            }
        }

        /// <summary>
        /// A generic method to return ALL the entities
        /// </summary>
        /// <param name=”entitySetName”>
        /// The EntitySet name of the entity in the model.
        /// </param>
        /// <typeparam name=”TEntity”>
        /// The Entity to load from the database.
        /// </typeparam>
        /// <returns>Returns a set of TEntity.</returns>
        public virtual IList<E> SelectAll<E>(string entitySetName, IEspecificacao<E> where) where E : EntityObject
        {
            return DoQuery<E>(entitySetName, where).ToList();
        }

        /// <summary>
        /// A generic method to return ALL the entities
        /// </summary>
        /// <typeparam name=”TEntity”>
        /// The Entity to load from the database.
        /// </typeparam>
        /// <returns>Returns a set of TEntity.</returns>
        public virtual IList<E> SelectAll<E>(IEspecificacao<E> where) where E : EntityObject
        {
            return DoQuery<E>(where).ToList();
        }
        /// <summary>
        /// Select All Entity with Paging 
        /// </summary>
        /// <param name="maximumRows">Max no of row to Fetch</param>
        /// <param name="startRowIndex">Start Index</param>
        /// <returns>Collection of Entities</returns>
        public virtual IList<E> SelectAll<E>(int maximumRows, int startRowIndex) where E : EntityObject
        {
            return DoQuery<E>(maximumRows, startRowIndex).ToList();
        }
        /// <summary>
        /// Select All Entity in sorted Order
        /// </summary>
        /// <param name="sortExpression">Sort Expression/condition</param>
        /// <param name="ErrorCode">custom Error Message</param> 
        /// <returns>Collection of Entities</returns>
        public virtual IList<E> SelectAll<E>(Expression<Func<E, object>> sortExpression) where E : EntityObject
        {
            if (null == sortExpression)
            {
                return DoQuery<E>(sortExpression).ToList();
            }
            return DoQuery<E>(sortExpression).ToList();
        }
        /// <summary>
        /// Select All Entity in sorted Order with Paging support
        /// </summary>
        /// <param name="sortExpression">Sort Expression/condition</param>
        /// <param name="maximumRows">Max no of row to Fetch</param>
        /// <param name="startRowIndex">Start Index</param>
        /// <returns>Collection Of entities</returns>
        public virtual IList<E> SelectAll<E>(Expression<Func<E, object>> sortExpression, int maximumRows, int startRowIndex) where E : EntityObject
        {
            if (sortExpression == null)
            {
                return DoQuery<E>(maximumRows, startRowIndex).ToList();
            }
            return DoQuery<E>(sortExpression, maximumRows, startRowIndex).ToList();
        }
        /// <summary>
        /// Get Entity By Primary Key
        /// </summary>
        /// <typeparam name="E">Entity Type</typeparam>
        /// <param name="Key">Primary Key Value</param>
        /// <returns>return entity</returns>
        public virtual E SelectByKey<E>(int Key, params string[] Includes) where E : EntityObject
        {
            // First we define the parameter that we are going to use the clause. 
            var xParam = Expression.Parameter(typeof(E), typeof(E).Name);

            string KeyProperty = "Id";

            MemberExpression leftExpr = MemberExpression.Property(xParam, KeyProperty);
            Expression rightExpr = Expression.Constant(Key);
            BinaryExpression binaryExpr = MemberExpression.Equal(leftExpr, rightExpr);
            //Create Lambda Expression for the selection 
            Expression<Func<E, bool>> lambdaExpr = Expression.Lambda<Func<E, bool>>(binaryExpr, new ParameterExpression[] { xParam });
            //Searching ....
            //IList<E> resultCollection = ( (IRepositorio)this ).SelectAll( new Especificacao<E>( lambdaExpr ) );

            var collection = ((IRepositorio)this).DoQuery<E>(new Especificacao<E>(lambdaExpr));
            foreach (var Include in Includes)
                collection = collection.Include(Include);

            IList<E> resultCollection = collection.ToList();

            if (null != resultCollection && resultCollection.Count() > 0)
            {
                //return valid single result
                return resultCollection.First<E>();
            }//end if 
            return null;
        }
        /// <summary>
        /// Check if value of specific field is already exist
        /// </summary>
        /// <typeparam name="E"></typeparam>
        /// <param name="fieldName">name of the Field</param>
        /// <param name="fieldValue">Field value</param>
        /// <param name="key">Primary key value</param>
        /// <returns>True or False</returns>
        public virtual bool TrySameValueExist<E>(string fieldName, object fieldValue, string key) where E : EntityObject
        {
            // First we define the parameter that we are going to use the clause. 
            var xParam = Expression.Parameter(typeof(E), typeof(E).Name);
            MemberExpression leftExprFieldCheck =
            MemberExpression.Property(xParam, fieldName);
            Expression rightExprFieldCheck = Expression.Constant(fieldValue);
            BinaryExpression binaryExprFieldCheck =
            MemberExpression.Equal(leftExprFieldCheck, rightExprFieldCheck);

            string KeyProperty = "ID";

            MemberExpression leftExprKeyCheck =
            MemberExpression.Property(xParam, KeyProperty);
            Expression rightExprKeyCheck = Expression.Constant(key);
            BinaryExpression binaryExprKeyCheck =
            MemberExpression.NotEqual(leftExprKeyCheck, rightExprKeyCheck);
            BinaryExpression finalBinaryExpr =
            Expression.And(binaryExprFieldCheck, binaryExprKeyCheck);

            //Create Lambda Expression for the selection 
            Expression<Func<E, bool>> lambdaExpr =
            Expression.Lambda<Func<E, bool>>(finalBinaryExpr,
            new ParameterExpression[] { xParam });
            //Searching ....            
            return ((IRepositorio)this).TryEntity(new Especificacao<E>(lambdaExpr));
        }
        /// <summary>
        /// Check if Entities exist with Condition
        /// </summary>
        /// <param name="selectExpression">Selection Condition</param>
        /// <returns>True or False</returns>
        public virtual bool TryEntity<E>(IEspecificacao<E> selectSpec) where E : EntityObject
        {
            return _ctx.CreateQuery<E>(_ctx.GetEntitySet<E>().Name).Any<E>(selectSpec.EvalPredicate);
        }

        /// <summary>
        /// Get Count of all records
        /// </summary>
        /// <typeparam name="E"></typeparam>
        /// <returns>count of all records</returns>
        public virtual int GetCount<E>() where E : EntityObject
        {
            return _ctx.CreateQuery<E>(_ctx.GetEntitySet<E>().Name).Count();
        }
        /// <summary>
        /// Get count of selection
        /// </summary>
        /// <typeparam name="E">Selection Condition</typeparam>
        /// <returns>count of selection</returns>
        public virtual int GetCount<E>(IEspecificacao<E> selectSpec) where E : EntityObject
        {
            return _ctx.CreateQuery<E>(_ctx.GetEntitySet<E>().Name).Where(selectSpec.EvalPredicate).Count();
        }
        /// <summary>
        /// Delete data from context
        /// </summary>
        /// <typeparam name="E"></typeparam>
        /// <param name="entity"></param>
        public virtual void Delete<E>(E entity) where E : EntityObject
        {
            _ctx.DeleteObject(entity);
        }
        /// <summary>
        /// Delete data from context
        /// </summary>
        /// <typeparam name="E"></typeparam>
        /// <param name="entity"></param>
        public virtual void Delete(object entity)
        {
            _ctx.DeleteObject(entity);
        }
        /// <summary>
        /// Insert new data into context
        /// </summary>
        /// <typeparam name="E"></typeparam>
        /// <param name="entity"></param>
        public virtual void Add<E>(E entity) where E : EntityObject
        {
            _ctx.AddObject(_ctx.GetEntitySet<E>().Name, entity);
        }
        /// <summary>
        /// Insert if new otherwise attach data into context
        /// </summary>
        /// <param name="entity"></param>
        public virtual void AddOrAttach<E>(E entity) where E : EntityObject
        {
            // Define an ObjectStateEntry and EntityKey for the current object.
            EntityKey key;
            object originalItem;
            // Get the detached object's entity key.
            if (entity.EntityKey == null)
            {
                // Get the entity key of the updated object.
                key = _ctx.CreateEntityKey(_ctx.GetEntitySet<E>().Name, entity);
            }
            else
            {
                key = entity.EntityKey;
            }
            try
            {
                // Get the original item based on the entity key from the context
                // or from the database.
                if (_ctx.TryGetObjectByKey(key, out originalItem))
                {//accept the changed property
                    if (originalItem is EntityObject &&
                        ((EntityObject)originalItem).EntityState != EntityState.Added)
                    {
                        // Call the ApplyPropertyChanges method to apply changes
                        // from the updated item to the original version.
                        _ctx.ApplyCurrentValues(key.EntitySetName, entity);
                    }
                }
                else
                {//add the new entity
                    Add(entity);
                }//end else
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private EntitySetBase GetEntitySet1<E>() where E : EntityObject
        {
            EntityContainer container = _ctx.MetadataWorkspace.GetEntityContainer(_ctx.DefaultContainerName, DataSpace.CSpace);
            Type baseType = GetBaseType(typeof(E));
            return container.BaseEntitySets.Where(item => item.ElementType.Name.Equals(baseType.Name)).FirstOrDefault(); ;
        }

        private Type GetBaseType(Type type)
        {
            var baseType = type.BaseType;
            if (baseType != null && baseType != typeof(EntityObject))
            {
                return GetBaseType(type.BaseType);
            }
            return type;
        }

        /// <summary>
        /// Start Transaction
        /// </summary>
        /// <returns></returns>
        public virtual DbTransaction BeginTransaction()
        {
            if (_ctx.Connection.State != ConnectionState.Open)
            {
                _ctx.Connection.Open();
            }
            return _ctx.Connection.BeginTransaction();
        }
        /// <summary>
        /// Delete all related entries
        /// </summary>
        /// <param name="entity"></param>        
        public virtual void DeleteRelatedEntries<E>(E entity) where E : EntityObject
        {
            foreach (var relatedEntity in (((IEntityWithRelationships)entity).RelationshipManager.GetAllRelatedEnds().SelectMany(re => re.CreateSourceQuery().OfType<EntityObject>()).Distinct()).ToArray())
            {
                _ctx.DeleteObject(relatedEntity);
            }//end foreach
        }
        /// <summary>
        /// Delete all related entries
        /// </summary>
        /// <param name="entity"></param>        
        public virtual void DeleteRelatedEntries<E>(E entity, ObservableCollection<string> keyListOfIgnoreEntites) where E : EntityObject
        {
            string KeyProperty = "ID";

            foreach (var relatedEntity in (((IEntityWithRelationships)entity).RelationshipManager.GetAllRelatedEnds().SelectMany(re => re.CreateSourceQuery().OfType<EntityObject>()).Distinct()).ToArray())
            {
                PropertyInfo propInfo = relatedEntity.GetType().GetProperty(KeyProperty);
                if (null != propInfo)
                {
                    string value = (string)propInfo.GetValue(relatedEntity, null);
                    if (!string.IsNullOrEmpty(value) &&
                        keyListOfIgnoreEntites.Contains(value))
                    {
                        continue;
                    }//end if 
                }//end if
                _ctx.DeleteObject(relatedEntity);
            }//end foreach
        }

        #endregion

        #region IDisposable Members

        public void Dispose()
        {
            if (null != _ctx)
            {
                _ctx.Dispose();
            }
        }

        #endregion

    }
}
