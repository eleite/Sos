<%@ Page Title="Calcular taxa de entrega" Language="C#" MasterPageFile="~/WebPage/BasePage.Master" AutoEventWireup="true" CodeBehind="CalcularTaxaEntrega.aspx.cs" Inherits="Sos.WebPage.CalcularTaxaEntrega" %>

<%@ Register assembly="Ext.Net" namespace="Ext.Net" tagprefix="ext" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<h2 class="art-postheader">
	Calcule aqui sua taxa de entrega.
</h2>
<div class="art-postcontent">
	<h4>
		O calculo é baseado na distancia entre a loja do SOS Goró e o endereço informado.
		Portanto, favor informar os dados corretamente.<br/>
		Endereço atual: R. Itajubá, 760, Floresta - BH.
	</h4>
    <ext:FormPanel ID="FormEndereco" runat="server" IDMode="Static" BodyPadding="5" Height="240" BodyStyle="background-color: transparent;" Border="false">
        <Items>
            <ext:TextField   runat="server" ID="Rua"    FieldLabel="Rua"    IndicatorText="*" IndicatorCls="red-text" Note="Somente o nome da Avenida, Rua ou Logradouro." AllowBlank="false" AnchorHorizontal="100%" />
            <ext:NumberField runat="server" ID="Numero" FieldLabel="Numero" IndicatorText="*" IndicatorCls="red-text" Note="Somente o número." AllowDecimals="false" AllowBlank="false" MinValue="0" HideTrigger="true"   AnchorHorizontal="100%" />
            <ext:TextField   runat="server" ID="Bairro" FieldLabel="Bairro" IndicatorText="*" IndicatorCls="red-text" Note="Somente o bairro." AnchorHorizontal="100%" AllowBlank="false"/>
            <ext:TextField   runat="server" ID="Cidade" FieldLabel="Cidade" IndicatorText="*" IndicatorCls="red-text" Note="No momento só entregamos em Belo Horizonte." ReadOnly="true" Text="Belo Horizonte" AnchorHorizontal="100%" />
            <ext:TextField   runat="server" ID="Estado" FieldLabel="Estado" IndicatorText="*" IndicatorCls="red-text" Note="No momento só entregamos no estado de Minas Gerais." ReadOnly="true" Text="Minas Gerais" AnchorHorizontal="100%" />
        </Items>
        <Buttons>
            <ext:Button runat="server" Text="Limpar" Height="30">
                <Listeners>
                    <Click Handler="#{FormEndereco}.setValue({Rua: '', Numero: '', Bairro: ''});" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="BtnCalcular" runat="server" Text="Calcular Frete" Height="30">
                <DirectEvents>
                    <Click OnEvent="Calcular" Before="return #{FormEndereco}.isValid()" >
                        <EventMask ShowMask="true" Msg="Caculando" />
                    </Click>
                </DirectEvents>
            </ext:Button>
            
        </Buttons>
        <Listeners>
            <AfterRender Handler="this.setWidth($(this.container.dom).width()); $('td', $(this.el.dom)).css('padding', '0').css('border', 'none');" Delay="10" />
        </Listeners>
    </ext:FormPanel>
    <h4 id="resultado">
	</h4>
	<div class="cleared"></div>
</div><!-- end art-postcontent-->

</asp:Content>
