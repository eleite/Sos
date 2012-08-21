using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ext.Net;

namespace Sos.WebPage
{
    public partial class FaleConosco : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public void Enviar(object sender, DirectEventArgs e)
        {
            X.AddScript(string.Format("$('#resultado').html('{0}')", "Email enviado com sucesso. Assim que possível entraremos em contato."));
        }
    }
}