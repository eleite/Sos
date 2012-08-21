using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Sos.Negocio.Entidades
{
    public partial class Endereco
    {
        public bool IsValid 
        {
            get 
            {
                return !string.IsNullOrWhiteSpace(this.Rua) && this.Numero > 0 && !string.IsNullOrWhiteSpace(this.Bairro);
            }
        }
    }
}
