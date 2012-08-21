using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Sos.Negocio.Repositorio.Customizacao;
using Sos.Negocio.Entidades;
using Ext.Net;
using Sos.Negocio.Repositorio.Implementacao;

namespace Sos.WebPage
{
    public partial class AdicionarProdutoCasco : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!X.IsAjaxRequest)
                RefreshGrid();
        }

        private void RefreshGrid(Repositorio repo) 
        {
            var l = repo.SelectAll<Produto>().Select(x => new { Id = x.Id, Nome = x.Nome, Preco = x.Casco == null ? -1 : x.Casco.Preco });
            this.Store1.DataSource = l;
            this.Store1.DataBind();
        }
        private void RefreshGrid()
        {
            using (var repo = new Repositorio())
            {
                RefreshGrid(repo);
            }
        }

        protected void SalvarPrecoCasco(object sender, DirectEventArgs e)
        {
            if (Preco.Number < 0)
                return;

            using (var repo = new Repositorio()) 
            {
                int idProduto;
                if (int.TryParse(Id.Text, out idProduto)) 
                {
                    if (repo.TryEntity<Produto>(new Especificacao<Produto>(x => x.Id == idProduto))) 
                    {
                        if (Preco.Number == 0)
                        {
                            var p = repo.SelectByKey<Produto>(idProduto);
                            if (p.Casco != null)
                            {
                                repo.Delete<Casco>(p.Casco);
                                p.Casco = null;
                            }
                        }
                        else 
                            repo.Add(repo.SelectByKey<Produto>(idProduto).Casco = new Casco { Preco = decimal.Parse(Preco.Number.ToString()) });
                        
                        repo.Save();
                        RefreshGrid(repo);
                        var s = string.Format("{0}.getForm().reset();", FormPanel1.ClientID);
                        X.AddScript(s);
                        s = string.Format("CorrigirCssTable({0});", GridPanel1.ClientID);
                        X.AddScript(s);
                        if (Preco.Number > 0)
                            X.Msg.Alert("Salvo", "Preço de casco salvo com sucesso").Show();
                        else
                            X.Msg.Alert("Salvo", "Preço de casco excluido.").Show();
                    }
                }
            }
        }
    }
}