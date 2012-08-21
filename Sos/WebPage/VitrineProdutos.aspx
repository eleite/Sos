<%@ Page Title="Vitrine Produtos" Language="C#" MasterPageFile="~/WebPage/BasePage.Master" AutoEventWireup="true" CodeBehind="VitrineProdutos.aspx.cs" Inherits="Sos.WebPage.VitrineProdutos" %>

<%@ Register assembly="Ext.Net" namespace="Ext.Net" tagprefix="ext" %>

<%@ Register Src="~/WebPage/UC_GridCarrinhoCompra.ascx" TagName="GridCarrinho" TagPrefix="UC" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" type="text/css" href="/resources/css/Paginador.css" />
    <link rel="stylesheet" type="text/css" href="/resources/css/Vitrine.css" />
    <script type="text/javascript" src="/resources/js/jquery.paginate.js" ></script>
    <script type="text/javascript" src="/resources/js/JQuerySpinBtn.js" ></script>
    <script type="text/javascript" src="/resources/js/jquery-ui-1.8.22.effect-Pulsate.min.js" ></script>
    <script type="text/javascript">
        var start = 0;
        var paginas = 0;

        var upPaginador = function (id, start, paginas) {
            if (paginas == 0)
                paginas = 1;
            $("div[id^=paginador]").paginate({
                count: paginas,
                start: start,
                display: 9,
                onChange: function (page) {
                    moverScroll();
                    var mask = new Ext.LoadMask(Ext.getBody(), { msg: 'Buscando Produtos' });
                    mask.show();
                    App.direct.SendProdutosToPage(id, page, 9, { success: function () { mask.hide(); } });
                }
            });

            $($('.jPag-control-front')[1]).css('left', $($('.jPag-control-front')[0]).css('left'));
        };
        var upContainerProduto = function () {
            if ($(".first").length > 0) {
                $("#vip").css("height", "20px");
                var size = 40;
                $(".first").each(function () {
                    size = size + $(this).height();
                    $("#vip").css("height", size);
                });
                //console.log($("#vip").height());

                // Initialise INPUT element(s) as SpinButtons: (passing options if desired)
                $(".spinbutton").SpinButton(myOptions);
            }
        };
        var upProdutos = function (json) {
            Ext.apply(Ext.util.Format, {
                thousandSeparator: '.',
                decimalSeparator: ',',
                currencySign: 'R$',
                // Brazilian Real
                dateFormat: 'd/m/Y'
            });
            App.TemplateProdutos.overwrite('produtos', jQuery.parseJSON(json));
            upContainerProduto();
        };

        var myOptions = {
            min: 0, 					// Set lower limit.
            max: 100, 				// Set upper limit.
            step: 1
        };
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<ext:XTemplate ID="TemplateProdutos" IDMode="Static" runat="server">
	<Html>
		<tpl for=".">
            <li class="{[xindex % 3 === 1 ? "first" : (xindex % 2 === 0 ? "last" : "")]}">
                <div class="produto">
                    <div class="imagem">
                        <a href="#">
                            <img src="/resources/images/produtos/small/{Imagem}" height="94" alt="{Nome}" />
                        </a>
                    </div>
                    <div class="texto">
                        <div class="descricao_produto">
                            <a href="#">{Nome}</a><br />
                            <span class="black italico28">{[Ext.util.Format.brMoney(values.Preco)]}</span>
                        </div>
                        <div class="cesta bV">
                            <input type="text" value="1" maxlength="24" class="spinbutton spin-button bV" id="produto_{ID}" /> 
							<img src="/resources/images/btn_comprar.jpg" class="comprar bV" onclick="AdicionarProduto($(this).prev());" />
                        </div>
                    </div>
                </div>
            </li>                            
		</tpl>     
	</Html>
</ext:XTemplate>

<div id="paginadorTop">
</div>

<div id="vip" style="padding-top: 5px;">
    <ul id="produtos">
    </ul>
</div>

<div id="paginadorBottom">
</div>

<ext:Panel runat="server" ID="CarrinhoVitrine" IDMode="Static" StyleSpec="right: 250px; bottom: 0px" Collapsible="true" CollapseDirection="Bottom" Title="Seu Carrinho" Icon="Basket" >
    <Content>
        <UC:GridCarrinho ID="UC_Grid" runat="server" Width="250" />
    </Content>
    <Listeners>
        <AfterRender Handler="this.el.setStyle('right', '0'); this.collapse();$(this.header.el.dom).click($.proxy(function () { if(this.collapsed) this.expand(); else this.collapse(); },this));" Delay="750" />
    </Listeners>
    <Buttons>
        <ext:Button ID="btnFinalizar" runat="server" Text="Finalizar compra" Icon="Accept"  >
            <DirectEvents>
                <Click OnEvent="FinalizarCompra_Click" Before="return App.CarrinhoVitrineGrid.store.count() > 0;" Success="Ext.getBody().mask('Redirecionando')" />
            </DirectEvents>
        </ext:Button>
    </Buttons>
</ext:Panel>
<ext:ToolTip runat="server" XTarget="={#{CarrinhoVitrineGrid}.getView().el}" Delegate="td.firstTip" Anchor="right" TrackMouse="true">
    <Listeners>
        <BeforeShow Handler="onBeforeShow(this, #{CarrinhoVitrineGrid});" />
        <Show Handler="onBeforeShow(this, #{CarrinhoVitrineGrid});" Single="true" /> 
    </Listeners>
</ext:ToolTip>
<script type="text/javascript">
    $(document).ready(
    function () {
        //$('#CarrinhoVitrine').css('top', $(document).innerHeight() / 2);
    });
</script>
</asp:Content>
