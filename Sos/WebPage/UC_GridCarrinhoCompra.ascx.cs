using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ext.Net;
using Sos.Negocio.Repositorio.Customizacao;
using Sos.Negocio.Entidades;
using Sos.WebPage.Util;

namespace Sos.WebPage
{
    public partial class UC_GridCarrinhoCompra : System.Web.UI.UserControl
    {
        public string Title { get; set; }
        public string Width { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!X.IsAjaxRequest)
            {
                RefreshGridProdutoCarrinho();
                if (!string.IsNullOrWhiteSpace(Title)) 
                {
                    CarrinhoVitrineGrid.Title = Title;
                    CarrinhoVitrineGrid.TitleAlign = TitleAlign.Center;
                }
                
                if (!string.IsNullOrWhiteSpace(Width))                    
                    CarrinhoVitrineGrid.Width = int.Parse(Width);
            }
        }

        protected void CarrinhoVitrineGrid_Refresh(object sender, StoreReadDataEventArgs e)
        {
            RefreshGridProdutoCarrinho();
        }
        private void RefreshGridProdutoCarrinho()
        {
            var store = CarrinhoVitrineGrid.GetStore();
            var ps = ProdutosCarrinho();
            store.DataSource = ps.Select(x => new { ID = x.Produto.Id, Nome = x.Produto.Nome, Quantidade = x.Quantidade, Preco = x.Produto.Preco });
            store.DataBind();
        }
        private List<ProdutoCarrinho> ProdutosCarrinho()
        {
            if (Session["ProdutosCarrinho"] == null)
                Session["ProdutosCarrinho"] = new List<ProdutoCarrinho>();
            return Session["ProdutosCarrinho"] as List<ProdutoCarrinho>;
        }

        [DirectMethod(Namespace = "UCGridCompras")]
        public void AdicionarProduto(string input, int q)
        {
            if (string.IsNullOrWhiteSpace(input)) return;

            var id_ = input.Replace("produto_", "");

            int id;
            if (int.TryParse(id_, out id))
            {
                var _aux = ProdutosCarrinho().Where(x => x.Produto.Id == id);
                if (_aux.Any())
                {
                    X.MessageBox.Alert("Erro", "Produto já está no carrinho.").Show();
                    return;
                }
                using (var repo = new Repositorio())
                {
                    var p = repo.SelectByKey<Produto>(id);
                    AddProdutoCarrinho(p, q);
                    RefreshGridProdutoCarrinho();
                }
            }
        }

        private void AddProdutoCarrinho(Produto p, int q)
        {
            var pc = new ProdutoCarrinho { Produto = p, Quantidade = q };

            var x = Session["ProdutosCarrinho"];
            if (x == null)
            {
                Session["ProdutosCarrinho"] = new List<ProdutoCarrinho>() { pc };
            }
            else (x as List<ProdutoCarrinho>).Add(pc);
        }

        [DirectMethod(Namespace = "UCGridCompras")]
        public void RemoverProduto(int id)
        {
            RemoverProdutoSession(id);
        }

        private void RemoverProdutoSession(int id)
        {
            var ps = ProdutosCarrinho();
            var _aux = ps.Where(x => x.Produto.Id == id);
            if (_aux.Any())
            {
                ps.Remove(_aux.First());
                Session["ProdutosCarrinho"] = ps;
                RefreshGridProdutoCarrinho();
            }
        }

        [DirectMethod(Namespace = "UCGridCompras")]
        public void Edit(int id, int newQuant)
        {
            var _aux = ProdutosCarrinho().Where(x => x.Produto.Id == id);
            if (_aux.Any())
            {
                var p = _aux.First();

                p.Quantidade = newQuant;

                CarrinhoVitrineGrid.GetStore().GetById(id).Commit();
                X.Js.Call("reRenderGridCarrinho", 100);
            }


        }
    }

    [Serializable]
    public class ProdutoCarrinho
    {
        public Produto Produto { get; set; }
        public int Quantidade { get; set; }
    }
}