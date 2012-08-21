using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ext.Net;
using Sos.Negocio.Repositorio.Customizacao;
using Sos.WebPage.Util;
using Sos.Negocio.Entidades;

namespace Sos.WebPage
{
    [DirectMethodProxyID(IDMode = DirectMethodProxyIDMode.None)]
    public partial class BasePage : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!X.IsAjaxRequest) 
            {
                if (SegurancaUsuario.ObterUsuario() != null) 
                {
                    /*
                    var child = this.ContentPlaceHolder1.Page.GetType().FullName;
                    if (!child.Contains("login")) 
                    {
                        Response.Redirect("~/WebPage/Login.aspx");
                        return;
                    }
                    */
                    X.Js.AddScript("$('#liLogin').remove();$('span.t', $('#liGerenciar')).html('Gerenciar Conta').width(100); ");
                    X.Js.AddScript("$('span.t', $('#liSair')).html('Sair').width(50).parent().click(function() { App.direct.SairUsuario(); });");
                }else
                    X.Js.AddScript("$('#liGerenciar').remove();$('#liSair').remove();"); 

                string json = "";
                using(var repositorio = new Repositorio())
                    json = TelaUtil.ToJson(repositorio.SelectAll<CategoriaProduto>().Select(x => new { ID = x.Id, Nome = x.Nome }));

                X.Js.AddScript(string.Format("upCategoria('{0}');", json));
            }
        }

        [DirectMethod]
        public void SairUsuario()
        {
            SegurancaUsuario.RemoverUsuario();
            Response.Redirect("~/WebPage/Home.aspx");
        }
    }
}