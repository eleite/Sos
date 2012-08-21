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
    public partial class VitrineProdutos : System.Web.UI.Page
    {

        public int PageSize = 9;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!X.IsAjaxRequest) 
            {
                var id = Request.QueryString["ID"];
                int ID;
                if (int.TryParse(id, out ID))
                {
                    SendProdutosToPage(ID, 1, PageSize);
                }
                else 
                {
                    Response.Redirect("~/WebPage/Home.aspx");
                }
            }
        }        

        [DirectMethod]
        public void SendProdutosToPage(int ID, int startPage, int PageSize)
        {
            using (var repositorio = new Repositorio())
            {
                var categoria = repositorio.SelectByKey<CategoriaProduto>(ID);

                if (categoria != null) 
                {
                    var json = TelaUtil.ToJson(categoria.Produtos.Skip((PageSize * (startPage - 1)) + 1).Take(PageSize).Select(p => new { ID = p.Id, Imagem = p.Imagem, Nome = p.Nome, Preco = p.Preco }));

                    X.Js.AddScript(string.Format("upProdutos('{0}');", json));

                    var totalPaginas = (int)decimal.Ceiling(decimal.Divide( categoria.Produtos.Count, PageSize));

                    X.Js.AddScript(string.Format("upPaginador({0}, {1}, {2});", ID, startPage, totalPaginas)); 
                }
            }
        }

        protected void FinalizarCompra_Click(object sender, DirectEventArgs e)
        {
            if (SegurancaUsuario.ObterUsuario() == null)
                Response.Redirect("~/WebPage/Login.aspx?Redirect=Basket");
            else
                Response.Redirect("~/WebPage/WizardCompra.aspx");
        }
    }
}