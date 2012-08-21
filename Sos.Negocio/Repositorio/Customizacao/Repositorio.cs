using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Sos.Negocio.Repositorio.Util;
using Sos.Negocio.Repositorio.Implementacao;
using Sos.Negocio.Entidades;

namespace Sos.Negocio.Repositorio.Customizacao
{
    public class Repositorio : RepositorioBase<ModelSosContainer>
    {
        public Repositorio() : base(FactoryContextEntity.InstanceSos) { }
    }
}
