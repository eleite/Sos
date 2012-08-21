using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ext.Net;

namespace Sos.WebPage
{
    public partial class CalcularTaxaEntrega : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public void Calcular(object sender, DirectEventArgs e)
        {
            if (this.Cidade.Text != "Belo Horizonte" || this.Estado.Text != "Minas Gerais")
                return;
            string resultado = "";

            var address = string.Format("{0}, {1}, {2}, {3} - {4}", 
                this.Rua.Text, this.Numero.Text, this.Bairro.Text, 
                this.Cidade.Text, this.Estado.Text);
            // Use the Google Geocoding service to get information about the user-entered address
            var url = String.Format("http://maps.google.com/maps/api/geocode/xml?address={0}&sensor=false", Server.UrlEncode(address));

            // Load the XML into an XElement object (whee, LINQ to XML!)
            var results = System.Xml.Linq.XElement.Load(url);

            // Determine how many elements exist
            var resultCount = results.Elements("result").Count();

            // How many results did we get back?
            if (resultCount == 1 && results.Element("result").Element("type").Value == "street_address")
            {
                var destination = results.Element("result").Element("formatted_address").Value;

                var origins = "R. Itajubá, 760 - Floresta, Belo Horizonte - Minas Gerais, 31015-280, Brazil";
                url = string.Format("http://maps.googleapis.com/maps/api/distancematrix/xml?origins={0}&destinations={1}&sensor=false", origins, destination);

                results = System.Xml.Linq.XElement.Load(url);

                // Determine how many elements exist
                resultCount = results.Elements("status").Count(c => c.Value == "OK");

                if (resultCount == 1)
                {
                    resultado = string.Format("Distância de {0}, igual a {1}.", destination, results.Element("row").Element("element").Element("distance").Element("text").Value);
                }
            }
            else if (resultCount == 0 || resultCount == 1)
            {
                resultado = "Endereço não encontrado";
            }
            else
            {
                // criar pagina para escolher qual endereço é o correto
                resultado = "";
                resultado = "Endereço não encontrado";
            }
            X.Call("moverScroll");
            X.AddScript(string.Format("$('#resultado').html('{0}')", resultado));
        }
    }
}