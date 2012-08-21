using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ext.Net;
using Sos.Negocio.Repositorio.Customizacao;
using Sos.Negocio.Entidades;
using System.IO;
using Sos.Negocio.Repositorio.Implementacao;

namespace Sos.WebPage
{
    public partial class GerenciarImagemProduto : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!X.IsAjaxRequest)
            {
                string path = Request.Url.AbsoluteUri.Remove(Request.Url.AbsoluteUri.IndexOf(Request.Url.AbsolutePath)) + "/resources/images/produtos/small";

                var store = this.GridPanel1.GetStore();
                using(var repo = new Repositorio())
                {
                    var l = repo.SelectAll<Produto>().Select(x => new {Id = x.Id, nome = x.Nome, url = Path.Combine(path, x.Imagem)});
                    store.DataSource = l;
                }
                
                store.DataBind();
            }
        }

        [DirectMethod]
        public string SalvarImagem() 
        {
            if (this.FileUploadField1.HasFile)
            {
                var id_ = IdProduto_.Text;
                int id;
                if (int.TryParse(id_, out id))
                {
                    using (var repo = new Repositorio())
                    {
                        if (repo.TryEntity<Produto>(new Especificacao<Produto>(x => x.Id == id)))
                        {
                            var n = RandomString(30);
                            var f = Path.Combine(Server.MapPath("~/resources/images/produtos/small"), n);
                            this.FileUploadField1.PostedFile.SaveAs(f);

                            var p = repo.SelectByKey<Produto>(id);
                            p.Imagem = n;
                            repo.Save();
                            string path = Request.Url.AbsoluteUri.Remove(Request.Url.AbsoluteUri.IndexOf(Request.Url.AbsolutePath)) + "/resources/images/produtos/small";

                            return Path.Combine(path, n);
                        }
                    }
                }
            }
            return null;
            
        }

        private readonly Random _rng = new Random();
        private const string _chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

        private string RandomString(int size)
        {
            char[] buffer = new char[size];

            for (int i = 0; i < size; i++)
            {
                buffer[i] = _chars[_rng.Next(_chars.Length)];
            }
            return new string(buffer);
        }
    }
}