using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ext.Net;
using Sos.WebPage.Util;
using Sos.Negocio.Repositorio.Customizacao;
using Sos.Negocio.Entidades;
using System.IO;

namespace Sos.WebPage
{
    public partial class WizardCompra : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (SegurancaUsuario.ObterUsuario() == null)
            {
                Response.Redirect("~/WebPage/Login.aspx?Redirect=Basket");
                return;
            }
            else 
            {
                if (!X.IsAjaxRequest) 
                {
                    RefreshGridProdutoCarrinho();
                    using (var repositorio = new Repositorio()) 
                    {
                        var usuario = repositorio.SelectByKey<Usuario>(SegurancaUsuario.ObterUsuario().Id);
                        ComboBoxEndereco.GetStore().DataSource = usuario.Enderecos.Select(x => new
                        {
                            ID = x.Id,
                            Rua = x.Rua,
                            Numero = x.Numero,
                            Complemento = x.Complemento,
                            Bairro = x.Bairro,
                            Cidade = x.Cidade,
                            Estado = x.Estado
                        });
                        ComboBoxEndereco.GetStore().DataBind();

                        ComboBoxTelefone.GetStore().DataSource = usuario.Telefones.ToList().Select(x => new 
                        {
                            ID = x.Id,
                            Numero = string.Format("({0}) {1}-{2}", x.Numero.Split(' ')),
                            Tipo = x.Tipo
                        });
                        ComboBoxTelefone.GetStore().DataBind();
                    }
                }
            }
        }


        private void RefreshGridProdutoCarrinho()
        {
            string path = Request.Url.AbsoluteUri.Remove(Request.Url.AbsoluteUri.IndexOf(Request.Url.AbsolutePath)) + "/resources/images/produtos/small";
            var store = this.GridPanelResumoProdutos.GetStore();
            var ps = ProdutosCarrinho();
            store.DataSource = ps.Select(x => new { Id = x.Produto.Id, nome = x.Produto.Nome, url = Path.Combine(path, x.Produto.Imagem) });
            store.DataBind();
        }
        private List<ProdutoCarrinho> ProdutosCarrinho()
        {
            if (Session["ProdutosCarrinho"] == null)
                Session["ProdutosCarrinho"] = new List<ProdutoCarrinho>();
            return Session["ProdutosCarrinho"] as List<ProdutoCarrinho>;
        }

        protected void Next_Click(object sender, DirectEventArgs e)
        {
            int index = int.Parse(e.ExtraParams["index"]);

            if ((index + 1) < this.WizardPanel.Items.Count)
            {
                this.WizardPanel.ActiveIndex = index + 1;
            }

            this.CheckButtons();
        }

        protected void Prev_Click(object sender, DirectEventArgs e)
        {
            int index = int.Parse(e.ExtraParams["index"]);

            if ((index - 1) >= 0)
            {
                this.WizardPanel.ActiveIndex = index - 1;
            }

            this.CheckButtons();
        }

        private void CheckButtons()
        {
            int index = this.WizardPanel.ActiveIndex;

            this.btnNext.Disabled = index == (this.WizardPanel.Items.Count - 1);
            this.btnPrev.Disabled = index == 0;
        }
    }
}