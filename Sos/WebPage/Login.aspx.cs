using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ext.Net;
using System.Web.Security;
using Sos.Negocio.Entidades;
using Sos.Negocio.Repositorio.Customizacao;
using Sos.WebPage.Util;

namespace Sos.WebPage
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //if (Request.IsAuthenticated)
             //   Response.Redirect("~/WebPage/Home.aspx");
        }
        protected void btnCadastro_Click(object sender, DirectEventArgs e) 
        {
            /*
            if (IsValidCustom(e.ExtraParams["challengeValue"], e.ExtraParams["responseValue"])) // Check if Captcha is verified or not.
            {
                // Captcha provided by the user is valid.
                FormsAuthentication.SetAuthCookie(this.txtUsername.Text, false);
            }
            //else
            {
                // Captcha provided by the user is invalid.
                X.MessageBox.Alert("Erro", "Código invalido.").Show();
            }
             */
            if (string.IsNullOrWhiteSpace(this.Senha.Text)) 
            {
                X.MessageBox.Alert("Erro", "Senha invalida.").Show();
                return;
            }
            Usuario usuario = new Usuario 
            {
                Email = this.EmailCadastro.Text,
                Senha = FormsAuthentication.HashPasswordForStoringInConfigFile(this.Senha.Text, "md5")
            };
            Telefone Fixo    = ObterTelefoneFixo();
            Telefone Celular = ObterTelefoneCelular();
            if (Fixo == null && Celular == null) 
            {
                X.MessageBox.Alert("Erro", "Pelo menos um telefone é necessário. Favor preencher ou telefone fixo ou telefone celular.").Show();
                return;
            }

            int numCad;
            if (int.TryParse(this.NumeroCadastro.Text, out numCad))
            {
                var Endereco = new Endereco 
                {
                    Rua = this.RuaCadastro.Text,
                    Numero = numCad,
                    Complemento = this.ComplementoCadastro.Text,
                    Bairro = this.BairroCadastro.Text,
                    Cidade = "Belo Horizonte",
                    Estado = "Minas Gerais"
                };
                if (Endereco.IsValid)
                {
                    using (var repositorio = new Repositorio())
                    {
                        repositorio.Add(Endereco);

                        Endereco.Usuario = usuario;

                        repositorio.Add(usuario);

                        if (Fixo != null) 
                        {
                            Fixo.Usuario = usuario;
                            repositorio.Add(Fixo);
                        }

                        if (Celular != null) 
                        {
                            Celular.Usuario = usuario;
                            repositorio.Add(Celular);
                        }

                        repositorio.Save();
                    }
                }
                else 
                {
                    X.MessageBox.Alert("Erro", "Endereço invalido.").Show();
                    return;                
                }
            }
            

        }

        private Telefone ObterTelefoneCelular()
        {
            if (!string.IsNullOrWhiteSpace(this.PrefixoCelularCadastro.Text) &&
                !string.IsNullOrWhiteSpace(this.RamalCelularCadastro.Text) &&
                this.PrefixoCelularCadastro.Text.Length > 3 &&
                this.RamalCelularCadastro.Text.Length > 3)
            {
                return new Telefone
                {
                    Numero = string.Format("{0} {1} {2}",
                                string.IsNullOrWhiteSpace(this.DDDCelularCadastro.Text) ? "31" : this.DDDCelularCadastro.Text,
                                this.PrefixoCelularCadastro.Text,
                                this.RamalCelularCadastro.Text),
                    Tipo = "Celular"
                };
            }
            return null;
        }

        private Telefone ObterTelefoneFixo()
        {
            if (TelaUtil.TelefoneValido(this.DDDResidenciaCadastro.Text, this.PrefixoResidenciaCadastro.Text, this.RamalResidenciaCadastro.Text))
            {
                return new Telefone
                {
                    Numero = string.Format("{0} {1} {2}",
                                string.IsNullOrWhiteSpace(this.DDDResidenciaCadastro.Text) ? "31" : this.DDDResidenciaCadastro.Text,
                                this.PrefixoResidenciaCadastro.Text,
                                this.RamalResidenciaCadastro.Text),
                    Tipo = "Fixo"
                };
            }
            return null;
        }

        protected void btnLogin_Click(object sender, DirectEventArgs e)
        {
            using (var repositorio = new Repositorio()) 
            {
                var senha = FormsAuthentication.HashPasswordForStoringInConfigFile(this.txtPassword.Text, "md5");
                var aux_ = repositorio.DoQuery<Usuario>().Where(x => x.Email == this.txtUsername.Text && x.Senha == senha);

                if (aux_.Any() && aux_.Count() == 1)
                {
                    SegurancaUsuario.AlterarUsuario(aux_.First());
                    if (!string.IsNullOrWhiteSpace(Request.QueryString["Redirect"]) && Request.QueryString["Redirect"] == "Basket")
                        Response.Redirect("~/WebPage/WizardCompra.aspx");
                    else
                        Response.Redirect("~/WebPage/Home.aspx");
                }
                else
                    X.MessageBox.Alert("Erro", "Usuário não identificado.").Show();
            }
        }

        private bool IsValidCustom(string  challengeValue, string responseValue)
        {
            if (string.IsNullOrWhiteSpace(challengeValue) || string.IsNullOrWhiteSpace(responseValue))
                return false;
            Recaptcha.RecaptchaValidator captchaValidtor = new Recaptcha.RecaptchaValidator
            {
                PrivateKey = Convert.ToString("6LdoxNQSAAAAAJdWATlAmxo6S7apKJ9XpqWMoI0u"), // Get Private key of the CAPTCHA from Web.config file.
                RemoteIP = HttpContext.Current.Request.UserHostAddress,
                Challenge = challengeValue,
                Response = responseValue
            };

            Recaptcha.RecaptchaResponse recaptchaResponse = captchaValidtor.Validate(); // Send data about captcha validation to reCAPTCHA site.
            return recaptchaResponse.IsValid;
        }
    }
}