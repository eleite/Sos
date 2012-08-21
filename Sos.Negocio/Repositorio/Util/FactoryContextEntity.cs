using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Sos.Negocio.Entidades;

namespace Sos.Negocio.Repositorio.Util
{
    public class FactoryContextEntity
    {
        public static ModelSosContainer InstanceSos
        {
            get { return new ModelSosContainer(); }
        }
    }
}
