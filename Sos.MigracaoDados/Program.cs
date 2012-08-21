using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MySql.Data.MySqlClient;
using System.Data;
using Sos.Negocio.Entidades;

namespace Sos.MigracaoDados
{
    class Program
    {
        static void Main(string[] args)
        {
            MigrarCategoria();
        }

        private static void MigrarCategoria()
        {
            var mConn = new MySqlConnection(" Persist __ Security Info=False;server=localhost;database=sos_cadastrar;uid=sos_sos;pwd=123mudar");

            try
            {
                //abre a conexao
                mConn.Open();
            }
            catch
            {
            }

            //verificva se a conexão esta aberta
            if (mConn.State == ConnectionState.Open)
            {
                //cria um adapter usando a instrução SQL para acessar a tabela Clientes
                var mAdapter = new MySqlCommand("SELECT * FROM categoria_site", mConn);
                var dr = mAdapter.ExecuteReader(CommandBehavior.CloseConnection);
                using (var repositorio = new Sos.Negocio.Repositorio.Customizacao.Repositorio())
                {
                    while (dr.Read())
                    {
                        var categoria = new CategoriaProduto();
                        categoria.Nome = dr["nome"].ToString();
                        repositorio.Add(categoria);
                    }
                    repositorio.Save();
                }

            }
        }

        private static void MigrarProduto()
        {
            var mConn = new MySqlConnection(" Persist Security Info=False;server=localhost;database=sos_cadastrar;uid=sos_sos;pwd=123mudar");

            try
            {
                //abre a conexao
                mConn.Open();
            }
            catch
            {
            }

            //verificva se a conexão esta aberta
            if (mConn.State == ConnectionState.Open)
            {
                //cria um adapter usando a instrução SQL para acessar a tabela Clientes
                var mAdapter = new MySqlCommand("SELECT p.*, c.nome as nomec FROM produtos_site p, categoria_site c where p.idcategoria = c.idcategoria", mConn);
                var dr = mAdapter.ExecuteReader(CommandBehavior.CloseConnection);
                using (var repositorio = new Sos.Negocio.Repositorio.Customizacao.Repositorio())
                {
                    while (dr.Read())
                    {
                        var produto = new Produto();
                        produto.Nome = dr["nome"].ToString();
                        produto.Descricao = dr["descricao"].ToString();
                        produto.Imagem = dr["imagem"].ToString();
                        if (string.IsNullOrWhiteSpace(dr["precoNovo"].ToString()))
                            produto.Preco = 0;
                        else
                            produto.Preco = decimal.Parse(dr["precoNovo"].ToString());

                        if (string.IsNullOrWhiteSpace(dr["precoAntigo"].ToString()))
                            produto.PrecoAntigo = 0;
                        else
                            produto.PrecoAntigo = decimal.Parse(dr["precoAntigo"].ToString());

                        produto.Disponivel = bool.Parse(dr["disponivel"].ToString());
                        var nomeCategoria = dr["nomec"].ToString();
                        var categorias = repositorio.DoQuery<CategoriaProduto>().Where(x => x.Nome == nomeCategoria);
                        if (categorias.Any())
                            produto.Categoria = categorias.First();
                        else
                            continue;
                        repositorio.Add(produto);
                    }
                    repositorio.Save();
                }
                Console.ReadKey();
            }
        }
    }
}
