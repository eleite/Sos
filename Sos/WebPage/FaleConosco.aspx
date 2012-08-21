<%@ Page Title="Fale Conosco" Language="C#" MasterPageFile="~/WebPage/BasePage.Master" AutoEventWireup="true" CodeBehind="FaleConosco.aspx.cs" Inherits="Sos.WebPage.FaleConosco" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<h2 class="art-postheader">
	Fale Conosco
</h2>
<h4>
	&nbsp;&nbsp;&nbsp;&nbsp;Mande suas mensagens e/ou sugestões para o SOS GORÓ, preenchendo o cadastro abaixo e 
	clicando em ENVIAR. Todos os campos são de preenchimento obrigatório. 
</h4>
<div class="art-postcontent" style="text-align:center">
    <ext:FormPanel ID="FormEmail" runat="server" IDMode="Static" BodyPadding="5" Height="180" BodyStyle="background-color: transparent;" Border="false">
        <Items>
            <ext:TextField runat="server" ID="Nome"     FieldLabel="Nome"     IndicatorText="*" IndicatorCls="red-text" AllowBlank="false" AnchorHorizontal="100%" />
            <ext:TextField runat="server" ID="Email"    FieldLabel="Email"    IndicatorText="*" IndicatorCls="red-text" AllowBlank="false" Vtype="email" AnchorHorizontal="100%" />
            <ext:TextField runat="server" ID="Assunto"  FieldLabel="Assunto"  IndicatorText="*" IndicatorCls="red-text" AllowBlank="false" AnchorHorizontal="100%" />
            <ext:TextArea  runat="server" ID="Mensagem" FieldLabel="Mensagem" IndicatorText="*" IndicatorCls="red-text" AllowBlank="false" AnchorHorizontal="100%" />
        </Items>
        <Buttons>
            <ext:Button runat="server" Text="Limpar" Height="30">
                <Listeners>
                    <Click Handler="#{FormEmail}.setValue({Nome: '', Email: '', Assunto: '', Mensagem: ''});" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="BtnEnviar" runat="server" Text="Enviar" Height="30">
                <DirectEvents>
                    <Click OnEvent="Enviar" Before="return #{FormEmail}.isValid()" >
                        <EventMask ShowMask="true" Msg="Enviando email..." />
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
