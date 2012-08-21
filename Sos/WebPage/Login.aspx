<%@ Page Title="Entrar" Language="C#" MasterPageFile="~/WebPage/BasePage.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Sos.WebPage.Login" %>

<%@ Register assembly="Ext.Net" namespace="Ext.Net" tagprefix="ext" %>
<%@ Register Assembly="Recaptcha" Namespace="Recaptcha" TagPrefix="recaptcha" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<script type="text/javascript" >
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        
<ext:Panel ID="Window1" runat="server" Header="false" Border="false" Width="360" Height="150" BodyBorder="0" Layout="Accordion">
    <LayoutConfig>
        <ext:AccordionLayoutConfig OriginalHeader="true"  />
    </LayoutConfig>
    <Items>    
    
<ext:FormPanel ID="LoginPanel"
    runat="server" Resizable="false" Height="150" Icon="Lock" Title="Já sou cliente" Draggable="false" Width="350"
    BodyPadding="5" Layout="AnchorLayout">
    <Items>
        <ext:TextField ID="txtUsername" runat="server" FieldLabel="Email" AllowBlank="false" BlankText="Email obrigatório" AnchorHorizontal="100%" Vtype="email" />
        <ext:TextField ID="txtPassword" runat="server" InputType="Password" FieldLabel="Senha" AllowBlank="false" BlankText="Senha obrigatória." AnchorHorizontal="100%" />
    </Items>
    <Listeners>
        <BeforeExpand Handler="#{Window1}.setHeight(150)" />
    </Listeners>
    <Buttons>
        <ext:Button ID="btnLogin" runat="server" Text="Login" Icon="Accept">
            <Listeners>
                <Click Handler="
                    if (!#{txtUsername}.validate() || !#{txtPassword}.validate()) {
                        Ext.Msg.alert('Error','Usuário e senha são campos obrigatórios');
                        return false; 
                    }" />
            </Listeners>
            <DirectEvents>
                <Click OnEvent="btnLogin_Click">
                    <EventMask ShowMask="true" Msg="Validando usuário..." MinDelay="500" />
                </Click>
            </DirectEvents>
        </ext:Button>
    </Buttons>
</ext:FormPanel>


<ext:FormPanel ID="FormPanelCadastro" runat="server" Resizable="false" Height="510" Icon="Lock" Title="Minha primeira compra" Draggable="false" Width="350" BodyPadding="5" Layout="AnchorLayout">
    <Items>
        <ext:TextField ID="EmailCadastro" runat="server" FieldLabel="Email" AllowBlank="false" BlankText="Email obrigatório" AnchorHorizontal="100%" Vtype="email" />
        <ext:TextField ID="Senha" runat="server" IDMode="Static" FieldLabel="Senha" InputType="Password" AllowBlank="false" AnchorHorizontal="100%" />
        <ext:TextField ID="SenhaConfirm" runat="server" Vtype="password" FieldLabel="Confirmar Senha" AllowBlank="false" InputType="Password" MsgTarget="Side" AnchorHorizontal="100%">     
            <CustomConfig>
                <ext:ConfigItem Name="initialPassField" Value="Senha" Mode="Value" />
            </CustomConfig>                      
        </ext:TextField>   
        <ext:Panel runat="server" AutoHeight="true" Layout="AnchorLayout" Title="Contato" AnchorHorizontal="100%">
            <Items>
                <ext:FieldContainer runat="server" FieldLabel="Residencial" CombineErrors="true" MsgTarget="Side" Layout="HBoxLayout">                        
                    <Defaults>
                        <ext:Parameter Name="HideLabel" Value="true" Mode="Raw" />
                    </Defaults>
                    <Items>
                        <ext:DisplayField runat="server" Text="(" />
                        <ext:TextField ID="DDDResidenciaCadastro" IDMode="Static" runat="server" Name="DDDResidenciaCadastro" Width="29" MaskRe="[0-9]" EnableKeyEvents="true" >
                            <Listeners>
                                <KeyUp Fn="Teste" > <CustomConfig><ext:ConfigItem Name="Size" Value="2" Mode="Value" /><ext:ConfigItem Name="Next" Value="PrefixoResidenciaCadastro" Mode="Value" /></CustomConfig></KeyUp>
                            </Listeners>
                        </ext:TextField>
                        <ext:DisplayField runat="server" Text=")" />
                        <ext:TextField ID="PrefixoResidenciaCadastro" runat="server" IDMode="Static" Name="PrefixoResidenciaCadastro" Width="48" MaskRe="[0-9]" EnableKeyEvents="true" >
                            <Listeners>
                                <KeyUp Fn="Teste" ><CustomConfig><ext:ConfigItem Name="Size" Value="5" Mode="Value" /><ext:ConfigItem Name="Next" Value="RamalResidenciaCadastro" Mode="Value" /></CustomConfig></KeyUp>
                            </Listeners>
                        </ext:TextField>
                        <ext:DisplayField runat="server" Text="-" />
                        <ext:TextField ID="RamalResidenciaCadastro" runat="server" IDMode="Static" Name="RamalResidenciaCadastro" Width="43" MaskRe="[0-9]" EnableKeyEvents="true" >
                            <Listeners>
                                <KeyUp Fn="Teste" ><CustomConfig><ext:ConfigItem Name="Size" Value="4" Mode="Value" /><ext:ConfigItem Name="Next" Value="DDDCelularCadastro" Mode="Value" /></CustomConfig></KeyUp>
                            </Listeners>
                        </ext:TextField>
                    </Items>
                </ext:FieldContainer>
                <ext:FieldContainer runat="server" FieldLabel="Celular" CombineErrors="true" MsgTarget="Side" Layout="HBoxLayout">                        
                    <Defaults>
                        <ext:Parameter Name="HideLabel" Value="true" Mode="Raw" />
                    </Defaults>
                    <Items>
                        <ext:DisplayField runat="server" Text="(" />
                        <ext:TextField ID="DDDCelularCadastro" IDMode="Static" runat="server" Name="DDDResidenciaCadastro" Width="29"  MaskRe="[0-9]" EnableKeyEvents="true" >
                            <Listeners>
                                <KeyUp Fn="Teste" > <CustomConfig><ext:ConfigItem Name="Size" Value="2" Mode="Value" /><ext:ConfigItem Name="Next" Value="PrefixoCelularCadastro" Mode="Value" /></CustomConfig></KeyUp>
                            </Listeners>
                        </ext:TextField>
                        <ext:DisplayField runat="server" Text=")" />
                        <ext:TextField ID="PrefixoCelularCadastro" runat="server" IDMode="Static" Name="PrefixoCelularCadastro" Width="48" MaskRe="[0-9]" EnableKeyEvents="true" >
                            <Listeners>
                                <KeyUp Fn="Teste" ><CustomConfig><ext:ConfigItem Name="Size" Value="5" Mode="Value" /><ext:ConfigItem Name="Next" Value="RamalCelularCadastro" Mode="Value" /></CustomConfig></KeyUp>
                            </Listeners>
                        </ext:TextField>
                        <ext:DisplayField runat="server" Text="-" />
                        <ext:TextField ID="RamalCelularCadastro" runat="server" IDMode="Static" Name="RamalCelularCadastro" Width="43" MaskRe="[0-9]" EnableKeyEvents="true" >
                            <Listeners>
                                <KeyUp Fn="Teste" ><CustomConfig><ext:ConfigItem Name="Size" Value="4" Mode="Value" /><ext:ConfigItem Name="Next" Value="RuaCadastro" Mode="Value" /></CustomConfig></KeyUp>
                            </Listeners>
                        </ext:TextField>
                    </Items>
                </ext:FieldContainer>
            </Items>
        </ext:Panel>
        <ext:Panel runat="server" AutoHeight="true" Layout="AnchorLayout" Title="Endereço">
            <Items>
                <ext:TextField ID="RuaCadastro" IDMode="Static" runat="server" FieldLabel="Rua" AllowBlank="false" AnchorHorizontal="100%" />
                <ext:NumberField ID="NumeroCadastro" runat="server" FieldLabel="Número" AllowBlank="false" AllowDecimals="true" MinValue="0" AnchorHorizontal="60%" />
                <ext:TextField ID="ComplementoCadastro" runat="server" FieldLabel="Complemento" AnchorHorizontal="100%" />
                <ext:TextField ID="BairroCadastro" runat="server" FieldLabel="Bairro" AllowBlank="false" AnchorHorizontal="100%" />
            </Items>
        </ext:Panel>

        <ext:Panel runat="server" Border="false" >
            <Content>
                <ReCaptcha:RecaptchaControl ID="reCaptcha" runat="server"  Theme="clean"
                    PublicKey="6LdoxNQSAAAAALER7GN66B1wl5NngiVnQj4b3HI9" 
                    PrivateKey="6LdoxNQSAAAAAJdWATlAmxo6S7apKJ9XpqWMoI0u" />
            </Content>
        </ext:Panel>
    </Items>
    <Listeners>
        <BeforeExpand Handler="moverScroll(); #{Window1}.setHeight(510)" Delay="100" />
    </Listeners>
    <Buttons>
        <ext:Button runat="server" Text="Cadastrar" Icon="Accept">
            <Listeners>
                <Click Handler="
                    if (!#{FormPanelCadastro}.isValid()) {
                        Ext.Msg.alert('Error','Favor preencher os campos obrigatórios');
                        return false; 
                    }" />
            </Listeners>
            <DirectEvents>
                <Click OnEvent="btnCadastro_Click">
                    <EventMask ShowMask="true" Msg="Validando usuário..." MinDelay="500" />
                     <ExtraParams>
                        <ext:Parameter Name="challengeValue" Value="$('input#recaptcha_challenge_field').val()" Mode="Raw" />
                        <ext:Parameter Name="responseValue" Value="$('input#recaptcha_response_field').val()" Mode="Raw" />
                    </ExtraParams>
                </Click>
            </DirectEvents>
        </ext:Button>
    </Buttons>
</ext:FormPanel>
    </Items>
    <Listeners>
        <AfterRender Handler="this.el.addCls('ux-layout-center-item');$('td', $(this.el.dom)).css('border', 'none')" />
    </Listeners>
</ext:Panel>
</asp:Content>
