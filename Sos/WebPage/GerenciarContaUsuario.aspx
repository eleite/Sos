<%@ Page Title="" Language="C#" MasterPageFile="~/WebPage/BasePage.Master" AutoEventWireup="true" CodeBehind="GerenciarContaUsuario.aspx.cs" Inherits="Sos.WebPage.GerenciarContaUsuario" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<ext:Store ID="StoreTelefone" runat="server" OnReadData="RefreshTelefone" PageSize="1">
    <AutoLoadParams>
        <ext:Parameter Name="start" Value="0" Mode="Raw" />
    </AutoLoadParams>
    <Proxy>
        <ext:PageProxy />
    </Proxy>
    <Model>
        <ext:Model runat="server">
            <Fields>
                <ext:ModelField Name="ID" />
                <ext:ModelField Name="TipoFixo" />
                <ext:ModelField Name="TipoCelular" />
                <ext:ModelField Name="DDD" />
                <ext:ModelField Name="Prefixo" />
                <ext:ModelField Name="Ramal" />
            </Fields>
        </ext:Model>
    </Model>
    <Listeners>
        <DataChanged Handler="var record = this.getAt(0) || {};#{FormTelefones}.getForm().loadRecord(record);#{FormTelefones}.clearInvalid();" />
        <BeforeLoad Handler="#{FormTelefones}.body.mask('Loading...', 'x-mask-loading');" />
        <Load Handler="#{FormTelefones}.body.unmask();" />
        <Exception Handler="#{FormTelefones}.body.unmask();" />
    </Listeners>
</ext:Store>

<ext:Store ID="StoreEndereco" runat="server" OnReadData="RefreshEnderecos" PageSize="1">
    <AutoLoadParams>
        <ext:Parameter Name="start" Value="0" Mode="Raw" />
    </AutoLoadParams>
    <Proxy>
        <ext:PageProxy />
    </Proxy>
    <Model>
        <ext:Model runat="server">
            <Fields>
                <ext:ModelField Name="ID" />
                <ext:ModelField Name="Rua" />
                <ext:ModelField Name="Numero" />
                <ext:ModelField Name="Complemento" />
                <ext:ModelField Name="Bairro" />
            </Fields>
        </ext:Model>
    </Model>
    <Listeners>
        <DataChanged Handler="var record = this.getAt(0) || {};#{FormEnderecos}.getForm().loadRecord(record);#{FormEnderecos}.clearInvalid();" />
        <BeforeLoad Handler="#{FormEnderecos}.body.mask('Loading...', 'x-mask-loading');" />
        <Load Handler="#{FormEnderecos}.body.unmask();" />
        <Exception Handler="#{FormEnderecos}.body.unmask();" />
    </Listeners>
</ext:Store>

<ext:FormPanel ID="PanelCadastroUsuario" runat="server" Resizable="false" AutoHeight="true" Border="false" Draggable="false" Width="350" BodyPadding="5" Layout="AnchorLayout">
    <Items>
        <ext:FormPanel ID="FormLogin" runat="server" Title="Informações Login" TitleAlign="Center" Border="false" BodyStyle="background-color:transparent;" DefaultAnchor="-10" Layout="AnchorLayout">
            <Items>
                <ext:TextField ID="txtUsername" runat="server" FieldLabel="Email" AllowBlank="false" BlankText="Email obrigatório" AnchorHorizontal="100%" Vtype="email" />
                <ext:TextField ID="txtPassword" runat="server" InputType="Password" FieldLabel="Senha" AllowBlank="false" BlankText="Senha obrigatória." AnchorHorizontal="100%" />
                <ext:TextField ID="Senha" runat="server" IDMode="Static" FieldLabel="Nova Senha" InputType="Password" AllowBlank="false" AnchorHorizontal="100%" />
                <ext:TextField ID="SenhaConfirm" runat="server" Vtype="password" FieldLabel="Confirmar Senha" AllowBlank="false" InputType="Password" MsgTarget="Side" AnchorHorizontal="100%">     
                    <CustomConfig>
                        <ext:ConfigItem Name="initialPassField" Value="Senha" Mode="Value" />
                    </CustomConfig>                      
                </ext:TextField>   
            </Items>
            <Buttons>
                <ext:Button ID="btnLogin" runat="server" Text="Salvar" Icon="Disk">
                    <Listeners>
                        <Click Handler="return false;" />
                    </Listeners>
                    <DirectEvents>
                        <Click OnEvent="btnCadastro_Click">
                            <EventMask ShowMask="true" Msg="Validando usuário..." MinDelay="500" />
                        </Click>
                    </DirectEvents>
                </ext:Button>
            </Buttons>
        </ext:FormPanel>
        <ext:Slider runat="server" AnchorHorizontal="100%" ><Listeners><AfterRender Handler="this.el.select('.x-slider-thumb').remove();" /></Listeners></ext:Slider>
        <ext:FormPanel ID="FormTelefones" runat="server" Title="Gerenciar Telefones" TitleAlign="Center" Border="false" BodyStyle="background-color:transparent;" DefaultAnchor="-10" Layout="Form">
            <Items>
                <ext:RadioGroup runat="server" FieldLabel="Tipo"  ColumnsWidths="100,100">
                    <Items>
                        <ext:Radio ID="FixoField" Name="TipoFixo" runat="server" BoxLabel="Fixo" Checked="true" />
                        <ext:Radio ID="CelularField" Name="TipoCelular" runat="server" BoxLabel="Celular" />
                    </Items>
                </ext:RadioGroup>
                <ext:FieldContainer runat="server" FieldLabel="Número Telefone" CombineErrors="true" MsgTarget="Side" Layout="HBoxLayout">                        
                    <Defaults>
                        <ext:Parameter Name="HideLabel" Value="true" Mode="Raw" />
                    </Defaults>
                    <Items>
                        <ext:DisplayField runat="server" Text="(" />
                        <ext:TextField ID="DDDField" IDMode="Static" runat="server" Name="DDD" Width="29"  MaskRe="[0-9]" MinLength="2" MaxLength="2" /><ext:DisplayField runat="server" Text=")" />
                        <ext:TextField ID="PrefixoField" runat="server" IDMode="Static" Name="Prefixo" Width="48" MaskRe="[0-9]" MinLength="4" MaxLength="5" AllowBlank="false" /><ext:DisplayField runat="server" Text="-" />
                        <ext:TextField ID="RamalField" runat="server" IDMode="Static" Name="Ramal" Width="43" MaskRe="[0-9]" MinLength="4" MaxLength="4" AllowBlank="false" />
                    </Items>
                </ext:FieldContainer>
            </Items>
            <Listeners>
                <ValidityChange Handler="#{btnSaveTelefone}.setDisabled(!valid);" />
            </Listeners>
            <TopBar>
                <ext:Toolbar runat="server">
                    <Items>
                        <ext:Button runat="server" Icon="Add" Text="Adicionar">
                            <DirectEvents>
                                <Click OnEvent="AdicionarTelefone" />
                            </DirectEvents>
                        </ext:Button>
                        <ext:Button runat="server" Icon="Delete" Text="Remover">
                            <DirectEvents>
                                <Click OnEvent="DeletarTelefone">
                                    <ExtraParams>
                                        <ext:Parameter Name="recordId" Value="#{StoreTelefone}.getAt(0).data.ID" Mode="Raw" />
                                    </ExtraParams>
                                </Click>
                            </DirectEvents>
                        </ext:Button>
                        <ext:ToolbarFill runat="server" />
                        <ext:Button ID="btnSaveTelefone" runat="server" Icon="Disk" Text="Savar" Disabled="true">
                            <DirectEvents>
                                <Click OnEvent="SavarTelefone" Before="return #{FormTelefones}.getForm().isValid();" >
                                    <ExtraParams>
                                        <ext:Parameter Name="recordId" Value="#{StoreTelefone}.getAt(0).data.ID" Mode="Raw" />
                                    </ExtraParams>
                                </Click>
                            </DirectEvents>
                        </ext:Button>
                    </Items>
                </ext:Toolbar>
            </TopBar>
            <BottomBar>
                <ext:PagingToolbar runat="server" StoreID="StoreTelefone" DisplayInfo="false" />
            </BottomBar>
        </ext:FormPanel>
        <ext:Slider runat="server" AnchorHorizontal="100%" ><Listeners><AfterRender Handler="this.el.select('.x-slider-thumb').remove();" /></Listeners></ext:Slider>
        <ext:FormPanel ID="FormEnderecos" runat="server" Title="Gerenciar Endereços" TitleAlign="Center" Border="false" BodyStyle="background-color:transparent;" DefaultAnchor="-10" Layout="Form">
            <Items>
                <ext:TextField   ID="RuaField"         Name="Rua"         runat="server" FieldLabel="Rua"         AllowBlank="false" AnchorHorizontal="100%" />
                <ext:NumberField ID="NumeroField"      Name="Numero"      runat="server" FieldLabel="Número"      AllowBlank="false" AllowDecimals="true" MinValue="1" AnchorHorizontal="60%" />
                <ext:TextField   ID="ComplementoField" Name="Complemento" runat="server" FieldLabel="Complemento" AnchorHorizontal="100%" />
                <ext:TextField   ID="BairroField"      Name="Bairro"      runat="server" FieldLabel="Bairro"      AllowBlank="false" AnchorHorizontal="100%" />
            </Items>
            <Listeners>
                <ValidityChange Handler="#{btnSaveEndereco}.setDisabled(!valid);" />
            </Listeners>
            <TopBar>
                <ext:Toolbar runat="server">
                    <Items>
                        <ext:Button runat="server" Icon="Add" Text="Adicionar">
                            <DirectEvents>
                                <Click OnEvent="AdicionarEndereco" />
                            </DirectEvents>
                        </ext:Button>
                        <ext:Button runat="server" Icon="Delete" Text="Remover">
                            <DirectEvents>
                                <Click OnEvent="DeletarEndereco">
                                    <ExtraParams>
                                        <ext:Parameter Name="recordId" Value="#{StoreEndereco}.getAt(0).data.ID" Mode="Raw" />
                                    </ExtraParams>
                                </Click>
                            </DirectEvents>
                        </ext:Button>
                        <ext:ToolbarFill runat="server" />
                        <ext:Button ID="btnSaveEndereco" runat="server" Icon="Disk" Text="Savar" Disabled="true">
                            <DirectEvents>
                                <Click OnEvent="SavarEndereco" Before="return #{FormEnderecos}.getForm().isValid();" >
                                    <ExtraParams>
                                        <ext:Parameter Name="recordId" Value="#{StoreEndereco}.getAt(0).data.ID" Mode="Raw" />
                                    </ExtraParams>
                                </Click>
                            </DirectEvents>
                        </ext:Button>
                    </Items>
                </ext:Toolbar>
            </TopBar>
            <BottomBar>
                <ext:PagingToolbar runat="server" StoreID="StoreEndereco" DisplayInfo="false" />
            </BottomBar>
        </ext:FormPanel>
    </Items>
    <Listeners>
        <AfterRender Handler="this.el.addCls('ux-layout-center-item');$('td', $(this.el.dom)).css('border', 'none')" />
    </Listeners>
</ext:FormPanel>
</asp:Content>
