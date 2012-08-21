using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Sos.WebPage.Util
{
    public class TelaUtil
    {
        public static string ToJson(object obj ) 
        {
            var oSerializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            return oSerializer.Serialize(obj);
        }

        public static bool TelefoneValido(string DDD, string Prefixo, string Ramal)
        {
            if (!string.IsNullOrWhiteSpace(Prefixo) && !string.IsNullOrWhiteSpace(Ramal) && (Prefixo.Length > 3 && Ramal.Length > 3) && (string.IsNullOrWhiteSpace(DDD) || DDD.Length == 2))
                return true;
            return false;
        }

        internal static bool EnderecoValido(string rua, double numero, string complemento, string bairro)
        {
            return !string.IsNullOrWhiteSpace(rua) && !string.IsNullOrWhiteSpace(complemento) && !string.IsNullOrWhiteSpace(bairro) && numero > 0 ;
        }
    }
}