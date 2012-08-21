using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ext.Net;
using Sos.Negocio.Entidades;
using Sos.Negocio.Repositorio.Customizacao;
using Sos.WebPage.Util;

namespace Sos.WebPage
{
    public partial class GerenciarContaUsuario : System.Web.UI.Page
    {
        public Usuario Usuario(Repositorio repositorio) {
            var usuario = SegurancaUsuario.ObterUsuario();
            if (usuario == null)
                return null;

            var aux_ = repositorio.DoQuery<Usuario>().Where(x => x.Id == usuario.Id);
            if (aux_.Any())
                return aux_.First();
            return null;
        }
        public bool Validado = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            Usuario usuario = null;
            if ((usuario = SegurancaUsuario.ObterUsuario()) == null)
            {
                Response.Redirect("~/WebPage/Login.aspx");
                return;
            }
            else if (!Validado) 
            {
                Validado = true;
                using (var repositorio = new Repositorio()) 
                {
                    var aux_ = repositorio.DoQuery<Usuario>().Where(x => x.Id == usuario.Id);
                    if (aux_.Any())
                    {
                        SegurancaUsuario.AlterarUsuario(aux_.First());
                    }
                    else 
                    {
                        Response.Redirect("~/WebPage/Login.aspx");
                        return; 
                    }
                }
            }

            if (!X.IsAjaxRequest) 
            {
                DataSourceTelefone_ = null;
                DataSourceEndereco_ = null;
                X.Js.Call("moverScroll");
            }
            
        }
        protected void btnCadastro_Click(object sender, DirectEventArgs e)
        { }


        #region Gerenciar Telefones

        #region Util Telefone
        
        private List<Telefone> DataSourceTelefone_
        {
            get
            {
                return Session["DataSource.Telefones"] as List<Telefone>;
            }
            set
            {
                Session["DataSource.Telefones"] = value;
            }
        }

        private List<Telefone> DataSourceTelefone
        {
            get
            {
                if (DataSourceTelefone_ != null) return DataSourceTelefone_;

                using (var repositorio = new Repositorio())
                {
                    var usuarioLogado = Usuario(repositorio);
                    if (usuarioLogado == null)
                        return DataSourceTelefone_ = new List<Telefone>();
                    DataSourceTelefone_ = usuarioLogado.Telefones.ToList();
                }

                return DataSourceTelefone_;
            }
        }

        private void SyncTelefoneDataSource()
        {
            DataSourceTelefone_ = DataSourceTelefone;
        }

        private int QuantidadeTelefone(bool Salvos)
        {
            int controle = 0;
            using (var repositorio = new Repositorio())
            {
                var usuarioLogado = Usuario(repositorio);
                if (usuarioLogado == null)
                    return 0;
                foreach (var item in DataSourceTelefone)
                {
                    var aux_ = usuarioLogado.Telefones.Where(x => x.Id == item.Id);
                    if (aux_.Any() == Salvos)
                        controle++;
                }
            }
            return controle;
        }
        #endregion

        #region Listeners Tela
        protected void RefreshTelefone(object sender, StoreReadDataEventArgs e)
        {
            var l = new List<Telefone> { DataSourceTelefone[e.Start] }.Select(
                        x => new
                        {
                            ID = x.Id,
                            TipoFixo = x.Tipo == "Fixo",
                            TipoCelular = x.Tipo != "Fixo",
                            DDD = x.Numero.Split(' ')[0],
                            Prefixo = x.Numero.Split(' ')[1],
                            Ramal = x.Numero.Split(' ')[2]
                        });
            this.StoreTelefone.DataSource = l;
            this.StoreTelefone.DataBind();

            e.Total = DataSourceTelefone.Count;
        }

        protected void DeletarTelefone(object sender, DirectEventArgs e)
        {
            int id = int.Parse(e.ExtraParams["recordId"]);

            if (!DataSourceTelefone.Any(x => x.Id == id))
                return;

            using (var repositorio = new Repositorio())
            {
                var usuarioLogado = Usuario(repositorio);
                if (usuarioLogado == null)
                    return;
                var aux_ = usuarioLogado.Telefones.Where(x => x.Id == id);
                if (aux_.Any())
                {
                    int controle = QuantidadeTelefone(true);
                    if (controle == 1)
                    {
                        X.Msg.Alert("Erro", "Pelo menos um telefone deve está cadastrado").Show();
                        return;
                    }

                    repositorio.Delete<Telefone>(aux_.First());
                    repositorio.Save();
                }
                var telefone = DataSourceTelefone.First(x => x.Id == id);

                var index = DataSourceTelefone.IndexOf(telefone);

                DataSourceTelefone.Remove(telefone);

                if (index == DataSourceTelefone.Count)
                {
                    index--;
                }

                if (index >= 0)
                {
                    StoreTelefone.LoadPage(index + 1);
                }
                SyncTelefoneDataSource();
                X.Msg.Alert("Sucesso", "Registro excluído com sucesso.").Show();
            }
        }

        protected void AdicionarTelefone(object sender, DirectEventArgs e)
        {
            int controle = QuantidadeTelefone(false);//nao salvos
            if (controle == 1)
            {
                X.Msg.Alert("Erro", "Para adicionar um outro telefone, será necessário salvar esse telefone.").Show();
                return;
            }
            Telefone data = new Telefone();
            data.Numero = "   ";
            data.Tipo = "Fixo";
            DataSourceTelefone.Add(data);
            SyncTelefoneDataSource();
            StoreTelefone.LoadPage(DataSourceTelefone.Count);
        }

        protected void SavarTelefone(object sender, DirectEventArgs e)
        {
            int id = int.Parse(e.ExtraParams["recordId"]);

            using (var repositorio = new Repositorio())
            {
                var usuarioLogado = Usuario(repositorio);
                if (usuarioLogado == null)
                    return;

                Telefone tel = null;

                var aux_ = usuarioLogado.Telefones.Where(x => x.Id == id);

                tel = aux_.Any() ? aux_.First() : new Telefone();

                if (TelaUtil.TelefoneValido(this.DDDField.Text, this.PrefixoField.Text, this.RamalField.Text))
                {
                    tel.Numero = string.Format("{0} {1} {2}", this.DDDField.Text, this.PrefixoField.Text, this.RamalField.Text);
                    tel.Tipo = this.FixoField.Checked ? "Fixo" : "Celular";
                    if (!aux_.Any())//novo
                        usuarioLogado.Telefones.Add(tel);
                    repositorio.Save();
                    DataSourceTelefone_ = usuarioLogado.Telefones.ToList();
                    X.Msg.Alert("Sucesso", string.Format("Telefone {0} com sucesso.", aux_.Any() ? "alterado" : "cadastrado")).Show();
                }
                else
                {
                    X.Msg.Alert("Erro", "Numero de telefone invalido.").Show();
                }
            }

        }
        #endregion
        
        #endregion

        #region Gerenciar Enderecos

        #region Util Endereco

        private List<Endereco> DataSourceEndereco_
        {
            get
            {
                return Session["DataSource.Enderecos"] as List<Endereco>;
            }
            set
            {
                Session["DataSource.Enderecos"] = value;
            }
        }

        private List<Endereco> DataSourceEndereco
        {
            get
            {
                if (DataSourceEndereco_ != null) return DataSourceEndereco_;

                using (var repositorio = new Repositorio())
                {
                    var usuarioLogado = Usuario(repositorio);
                    if (usuarioLogado == null)
                        return DataSourceEndereco_ = new List<Endereco>();
                    DataSourceEndereco_ = usuarioLogado.Enderecos.ToList();
                }

                return DataSourceEndereco_;
            }
        }

        private void SyncEnderecoDataSource()
        {
            DataSourceEndereco_ = DataSourceEndereco;
        }

        private int QuantidadeEndereco(bool Salvos)
        {
            int controle = 0;
            using (var repositorio = new Repositorio())
            {
                foreach (var item in DataSourceEndereco)
                {
                    var usuarioLogado = Usuario(repositorio);
                    if (usuarioLogado == null)
                        return 0;
                    var aux_ = usuarioLogado.Enderecos.Where(x => x.Id == item.Id);
                    if (aux_.Any() == Salvos)
                        controle++;
                }
            }
            return controle;
        }
        #endregion

        #region Listeners Tela
        protected void RefreshEnderecos(object sender, StoreReadDataEventArgs e)
        {
            var l = new List<Endereco> { DataSourceEndereco[e.Start] }.Select(
                        x => new
                        {
                            ID = x.Id,
                            Rua = x.Rua,
                            Numero = x.Numero,
                            Complemento = x.Complemento,
                            Bairro = x.Bairro
                        });
            this.StoreEndereco.DataSource = l;
            this.StoreEndereco.DataBind();

            e.Total = DataSourceEndereco.Count;
        }

        protected void DeletarEndereco(object sender, DirectEventArgs e)
        {
            int id = int.Parse(e.ExtraParams["recordId"]);

            if (!DataSourceEndereco.Any(x => x.Id == id))
                return;

            using (var repositorio = new Repositorio())
            {
                var usuarioLogado = Usuario(repositorio);
                if (usuarioLogado == null)
                    return;
                var aux_ = usuarioLogado.Enderecos.Where(x => x.Id == id);
                if (aux_.Any())
                {
                    int controle = QuantidadeEndereco(true);
                    if (controle == 1)
                    {
                        X.Msg.Alert("Erro", "Pelo menos um Endereço deve está cadastrado").Show();
                        return;
                    }
                    repositorio.Delete<Endereco>(aux_.First());
                    repositorio.Save();
                }

                var endereco = DataSourceEndereco.First(x => x.Id == id);

                var index = DataSourceEndereco.IndexOf(endereco);

                DataSourceEndereco.Remove(endereco);

                if (index == DataSourceEndereco.Count)
                {
                    index--;
                }

                if (index >= 0)
                {
                    StoreEndereco.LoadPage(index + 1);
                }
                SyncEnderecoDataSource();
                X.Msg.Alert("Sucesso", "Registro excluído com sucesso.").Show();
            }
        }

        protected void AdicionarEndereco(object sender, DirectEventArgs e)
        {
            int controle = QuantidadeEndereco(false);//nao salvos
            if (controle == 1)
            {
                X.Msg.Alert("Erro", "Para adicionar um outro endereço, será necessário salvar esse endereço.").Show();
                return;
            }
            DataSourceEndereco.Add(new Endereco());
            SyncEnderecoDataSource();
            StoreEndereco.LoadPage(DataSourceEndereco.Count);
        }

        protected void SavarEndereco(object sender, DirectEventArgs e)
        {
            int id = int.Parse(e.ExtraParams["recordId"]);

            using (var repositorio = new Repositorio())
            {
                var usuarioLogado = Usuario(repositorio);
                if (usuarioLogado == null)
                    return;
                Endereco endereco = null;

                var aux_ = usuarioLogado.Enderecos.Where(x => x.Id == id);

                endereco = aux_.Any() ? aux_.First() : new Endereco();

                if (TelaUtil.EnderecoValido(this.RuaField.Text, this.NumeroField.Number, this.ComplementoField.Text, this.BairroField.Text))
                {
                    endereco.Rua = this.RuaField.Text;
                    endereco.Numero = (int)this.NumeroField.Number;
                    endereco.Complemento = this.ComplementoField.Text;
                    endereco.Bairro = this.BairroField.Text;
                    endereco.Cidade = "Belo Horizonte";
                    endereco.Estado = "Minas Gerais";
                    if (!aux_.Any())//novo
                        usuarioLogado.Enderecos.Add(endereco);
                    repositorio.Save();
                    DataSourceEndereco_ = usuarioLogado.Enderecos.ToList();
                    X.Msg.Alert("Sucesso", string.Format("Endereço {0} com sucesso.", aux_.Any() ? "alterado" : "cadastrado")).Show();
                }
                else
                {
                    X.Msg.Alert("Erro", "Endereço invalido.").Show();
                }
            }

        }
        #endregion

        #endregion

    }
}