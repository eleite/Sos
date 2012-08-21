<%@ Page Title="" Language="C#" MasterPageFile="~/WebPage/BasePage.Master" AutoEventWireup="true" CodeBehind="AdicionarProdutoCasco.aspx.cs" Inherits="Sos.WebPage.AdicionarProdutoCasco" %>

<%@ Register assembly="Ext.Net" namespace="Ext.Net" tagprefix="ext" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

<script type="text/javascript">
    
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" ClientIDMode="Static" runat="server">

 <ext:Panel ID="Panel1" runat="server" Width="500" Height="450" Layout="BorderLayout">
    <Items>
        <ext:FormPanel ID="FormPanel1" runat="server" Region="North" Title="Preço Casco" BodyStyle="background-color: #DFE8F6" BodyPadding="10" LabelWidth="100" MarginsSummary="5 5 5 0">
            <Items>
                <ext:Hidden runat="server" ID="Id" />
                <ext:TextField ID="NomeProduto" runat="server" FieldLabel="Nome" Name="Nome" ReadOnly="true" AnchorHorizontal="90%" />
                <ext:NumberField ID="Preco" runat="server" FieldLabel="Preço" Name="Preco" MinValue="0" DecimalPrecision="2" DecimalSeparator=","  AnchorHorizontal="90%" />
            </Items>
            <BottomBar>
                <ext:Toolbar ID="Toolbar2" runat="server">
                    <Items>
                        <ext:ToolbarFill ID="ToolbarFill2" runat="server" />
                        <ext:Button ID="Button2" runat="server" Text="Salvar">
                            <DirectEvents>
                                <Click OnEvent="SalvarPrecoCasco" Before="#{FormPanel1}.el.mask('Salvando...');" Complete="#{FormPanel1}.el.unmask();" />
                            </DirectEvents>
                        </ext:Button>
                    </Items>
                </ext:Toolbar>
            </BottomBar>
        </ext:FormPanel>
        <ext:GridPanel ID="GridPanel1" runat="server" Region="Center" Width="450" Title="Produtos cadastrados" MarginsSummary="5 5 5 5">                    
            <Store>
                <ext:Store ID="Store1" runat="server">
                    <Model>
                        <ext:Model ID="Model1" runat="server">
                            <Fields>
                                <ext:ModelField Name="Id" />
                                <ext:ModelField Name="Nome" />
                                <ext:ModelField Name="Preco" />
                            </Fields>
                        </ext:Model>
                    </Model>
                    <Listeners>
                        <DataChanged Handler="CorrigirCssTable(#{GridPanel1})" />
                    </Listeners>
                </ext:Store>
            </Store>
            <ColumnModel>
                <Columns>
                    <ext:Column ID="Column1" runat="server" Text="Nome Produto" Width="160" DataIndex="Nome" Flex="1" />
                    <ext:Column ID="Column2" runat="server" Text="Casco(R$)" Width="100" DataIndex="Preco" >
                        <Renderer Handler="return record.data.Preco == -1 ? 'Sem Casco' : Ext.util.Format.brMoney(record.data.Preco);" />
                    </ext:Column>
                </Columns>
            </ColumnModel>
            <SelectionModel>
                <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" Mode="Single" >
                    <Listeners>
                        <Select Handler="var a = this.selected.items[0]; if (a.data.Preco == -1) a.data.Preco = 0; App.FormPanel1.getForm().loadRecord(a)" />
                    </Listeners>
                </ext:RowSelectionModel>
            </SelectionModel> 
            <Features>
                <ext:GridFilters runat="server" ID="GridFilters1" Local="true">
                    <Filters>
                        <ext:StringFilter DataIndex="Nome" />
                    </Filters>
                    <Listeners>
                        <FilterUpdate Fn="function(){ CorrigirCssTable(#{GridPanel1}); return true; }" Delay="500" />
                    </Listeners>
                </ext:GridFilters>
            </Features>
            <Listeners>
                <AfterRender Handler="CorrigirCssTable(this)" Delay="250" />
            </Listeners>            
        </ext:GridPanel>

    </Items>
    <BottomBar>
        <ext:Toolbar ID="Toolbar1" runat="server">
            <Items>
                <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                <ext:Button ID="Button1" runat="server" Text="Reset">
                    <Listeners>
                        <Click Handler="#{Store1}.loadData(#{Store1}.proxy.data); #{FormPanel1}.getForm().reset();CorrigirCssTable(#{GridPanel1}); " />
                    </Listeners>
                </ext:Button>
            </Items>
        </ext:Toolbar>
    </BottomBar>
    <Listeners>
        <AfterRender Handler="CorrigirCssTable(this)" Delay="250" />        
    </Listeners>
</ext:Panel> 
</asp:Content>
