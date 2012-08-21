using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Sos.Negocio.Entidades;

namespace Sos.WebPage.Util
{
    public class SegurancaUsuario
    {

        public static Usuario ObterUsuario() 
        {
            var usuObj_ = HttpContext.Current.Session["ControleInterno.User"];
            return usuObj_ as Usuario;
        }

        public static void AlterarUsuario(Usuario CurrentUser)
        {
            HttpContext.Current.Session["ControleInterno.User"] = CurrentUser;
        }

        public static void RemoverUsuario()
        {
            HttpContext.Current.Session.Remove("ControleInterno.User");
        }
    }
}