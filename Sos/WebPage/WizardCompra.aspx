<%@ Page Title="" Language="C#" MasterPageFile="~/WebPage/BasePage.Master" AutoEventWireup="true" CodeBehind="WizardCompra.aspx.cs" Inherits="Sos.WebPage.WizardCompra" %>

<%@ Register assembly="Ext.Net" namespace="Ext.Net" tagprefix="ext" %>

<%@ Register Src="~/WebPage/UC_GridCarrinhoCompra.ascx" TagName="GridCarrinho" TagPrefix="UC" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<ext:Panel ID="WizardPanel" runat="server" Title="Passo-a-Passo realizar venda" BodyPadding="15" Height="450" Layout="card" ActiveIndex="0">       
    <Items>
        <ext:Panel ID="Panel4" runat="server" Border="false" Header="false" >
            <Items>
                <ext:GridPanel ID="GridPanelResumoProdutos" runat="server" Height="350" OverflowX="Hidden">
                    <Store>
                        <ext:Store ID="Store3" runat="server">
                            <Model>
                                <ext:Model ID="Model3" runat="server" IDProperty="Id">
                                    <Fields>
                                        <ext:ModelField Name="Id" />
                                        <ext:ModelField Name="nome" />
                                        <ext:ModelField Name="url" />
                                    </Fields>
                                </ext:Model>
                            </Model>
                        </ext:Store>
                    </Store>
                    <ColumnModel>
                        <Columns>
                            <ext:TemplateColumn ID="TemplateColumn1" runat="server" Text="Imagem" Flex="12" DataIndex="url" 
                                TemplateString='<img id="img-{Id}" style="width:39px;height:39px;" class="imgProduto" src="{url}" />' />
                            <ext:Column ID="Column1" runat="server" Text="Produto" DataIndex="nome" Flex="86" />
                        </Columns>    
                    </ColumnModel>
                    <BottomBar>
                        <ext:Toolbar runat="server" ID="tbarResumo" Height="100">
                            <Tpl runat="server" ID="BaseTpl">
                                <Html>
                                    <div style="border:1px solid gray; padding:10px;">
                                        <h3 id="{id}-title">{title}</h3>
                                        <p>{msg}</p>
                                    </div>
                                </Html>
                            </Tpl>
                            <Listeners>
                                <AfterRender Handler="a = this" />
                            </Listeners>
                        </ext:Toolbar>
                    </BottomBar>
                    <Listeners>
                        <AfterRender Handler="CorrigirCssTable(this);" Delay="250" />        
                    </Listeners>
                </ext:GridPanel>
            </Items>
        </ext:Panel>
        <ext:Panel runat="server" IDMode="Static" Border="false" Header="false" >
            <Content>
                <UC:GridCarrinho ID="UC_Grid" runat="server" Title="Produtos selecionados" />
            </Content>
        </ext:Panel>
        <ext:Panel runat="server" Border="false" Header="false" >
            <Items>
                <ext:ComboBox ID="ComboBoxEndereco" runat="server" Width="380" FieldLabel="Endereço" Editable="false" DisplayField="Rua" ValueField="ID" TypeAhead="true" QueryMode="Local" ForceSelection="true" TriggerAction="All" EmptyText="Selecione um endereço" SelectOnFocus="true">  
                    <Store>
                        <ext:Store ID="Store1" runat="server" >
                            <Model>
                                <ext:Model ID="Model1" runat="server" IDProperty="ID" >
                                    <Fields>
                                        <ext:ModelField Name="ID" />
                                        <ext:ModelField Name="Rua" />
                                        <ext:ModelField Name="Numero" />
                                        <ext:ModelField Name="Complemento" />
                                        <ext:ModelField Name="Bairro" />
                                        <ext:ModelField Name="Cidade" />
                                        <ext:ModelField Name="Estado" />
                                    </Fields>
                                </ext:Model>
                            </Model>
                        </ext:Store>
                    </Store>
                    <ListConfig>
                        <ItemTpl ID="ItemTpl1" runat="server">
                            <Html>
						        <h3 style="margin: 0;">{Rua} - {Numero}</h3>
							        {Rua}, {Numero}<tpl if="Complemento != ''">, {Complemento}</tpl>, {Bairro}. {Cidade} - {Estado}.
				            </Html>    
                        </ItemTpl>
                    </ListConfig>
                </ext:ComboBox>

                <ext:ComboBox ID="ComboBoxTelefone" runat="server" Width="380" FieldLabel="Telefone" Editable="false" DisplayField="Numero" ValueField="ID" TypeAhead="true" QueryMode="Local" ForceSelection="true" TriggerAction="All" EmptyText="Selecione um telefone" SelectOnFocus="true">  
                    <Store>
                        <ext:Store ID="Store2" runat="server" >
                            <Model>
                                <ext:Model ID="Model2" runat="server" IDProperty="ID" >
                                    <Fields>
                                        <ext:ModelField Name="ID" />
                                        <ext:ModelField Name="Numero" />
                                        <ext:ModelField Name="Tipo" />
                                    </Fields>
                                </ext:Model>
                            </Model>
                        </ext:Store>
                    </Store>
                    <ListConfig>
                        <ItemTpl ID="ItemTpl2" runat="server">
                            <Html>
						        <h3>{Tipo}: {Numero}</h3>
				            </Html>    
                        </ItemTpl>
                    </ListConfig>
                </ext:ComboBox>
            </Items>
            <Listeners>
                <AfterRender Handler="$('table tbody tr td', $(this.el.dom)).css('padding', '0').css('border', 'none'); $('table td', $(this.el.dom)).css('padding', '0').css('border', 'none');" Delay="50" />
            </Listeners>
        </ext:Panel>
        <ext:Panel ID="Panel1" runat="server" Border="false" Header="false" >
            <Items>
                <ext:RadioGroup ID="RadioGroup1" runat="server" ColumnsNumber="1" LabelStyle="font-weight: bold" LabelAlign="Top" FieldLabel="O sistema identificou menos de 20 itens com casco retornavel. Selecione uma opção" >
                    <Items>
                        <ext:Radio ID="Radio2" runat="server" BoxLabel="Trocar cascos no momento da entrega" Checked="true" />
                        <ext:Radio ID="Radio1" runat="server" BoxLabel="Comprar cascos" />                        
                    </Items>
                </ext:RadioGroup>
            </Items>
            <Listeners>
                <AfterRender Handler="CorrigirCssTable(this)" Delay="250" />                
            </Listeners>
        </ext:Panel>
        <ext:Panel ID="Panel2" runat="server" Border="false" Header="false" >
            <Items>
                <ext:RadioGroup ID="RadioGroup2" runat="server" ColumnsNumber="1" LabelStyle="font-weight: bold" LabelAlign="Top" FieldLabel="O sistema identificou mais de 20 itens com casco retornavel. Selecione uma opção" >
                    <Items>
                        <ext:Radio ID="Radio4" runat="server" BoxLabel="Trocar cascos no momento da entrega" Checked="true" />
                        <ext:Radio ID="Radio5" runat="server" BoxLabel="Comprar cascos" />
                        <ext:Radio ID="Radio3" runat="server" BoxLabel="Deixar um calção" />                                                
                    </Items>
                </ext:RadioGroup>
            </Items>
            <Listeners>
                <AfterRender Handler="CorrigirCssTable(this)" Delay="250" />                
            </Listeners>
        </ext:Panel>
        <ext:Panel ID="Panel3" runat="server" Html="<h1>Congratulations!</h1><p>Step 3 of 3 - Complete</p>" Border="false" Header="false" />
    </Items>         
    <Buttons>
        <ext:Button ID="btnPrev" runat="server" Text="Voltar" Disabled="true" Icon="PreviousGreen">
            <DirectEvents>
                <Click OnEvent="Prev_Click">
                    <ExtraParams>
                        <ext:Parameter Name="index" Value="#{WizardPanel}.items.indexOf(#{WizardPanel}.layout.activeItem)" Mode="Raw" />
                    </ExtraParams>
                </Click>
            </DirectEvents>
        </ext:Button>
        <ext:Button ID="btnNext" runat="server" Text="Proximo" Icon="NextGreen">
            <DirectEvents>
                <Click OnEvent="Next_Click">
                    <ExtraParams>
                        <ext:Parameter Name="index" Value="#{WizardPanel}.items.indexOf(#{WizardPanel}.layout.activeItem)" Mode="Raw" />
                    </ExtraParams>
                </Click>
            </DirectEvents>
        </ext:Button>
    </Buttons>     
</ext:Panel>
</asp:Content>
