<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UC_GridCarrinhoCompra.ascx.cs" Inherits="Sos.WebPage.UC_GridCarrinhoCompra" %>

<%@ Register assembly="Ext.Net" namespace="Ext.Net" tagprefix="ext" %>

    <style type="text/css">
        .x-grid-row-summary .x-grid-cell-Cost .x-grid-cell-inner{
            background-color : #e1e2e4;
        }    

        .x-grid-row-summary .x-grid-cell-inner {
            font-weight      : bold;
            font-size        : 11px;
            background-color : #f1f2f4;
        } 
    </style>

<script type="text/javascript" src="/resources/js/jquery-ui-1.8.22.effect-Pulsate.min.js" ></script>
<script type="text/javascript">

    var totalCostBasket = function (records) {
        var i = 0,
                length = records.length,
                total = 0,
                record;

        for (; i < length; ++i) {
            record = records[i];
            total += record.get('Preco') * record.get('Quantidade');
        }

        return total;
    };

    var edit = function (editor, e) {
        /*
        "e" is an edit event with the following properties:

        grid - The grid
        record - The record that was edited
        field - The field name that was edited
        value - The value being set
        originalValue - The original value for the field, before the edit.
        row - The grid table row
        column - The grid Column defining the column that was edited.
        rowIdx - The row index that was edited
        colIdx - The column index that was edited
        */

        // Call DirectMethod
        if (e.value !== e.originalValue) {
            UCGridCompras.ContentPlaceHolder1_UC_Grid.Edit(e.record.data.ID, e.value);
            reRenderGridCarrinho();
        }
    };

    var reRenderGridCarrinho = function (delay) {
        if (!delay) delay = 1;
        Ext.Function.defer(function () {
            var CarrinhoCmp = $(Ext.getCmp('CarrinhoVitrineGrid').el.dom);
            $('table tbody tr:first th', CarrinhoCmp).css('padding', '0').css('border', 'none');
            $('table td', CarrinhoCmp).css('padding', '0').css('border', 'none');
            $('tr.x-grid-row td.x-grid-cell-first', CarrinhoCmp).addClass('firstTip');
        }, delay);
    };

    var AdicionarProduto = function (el) {
        var CarrinhoVitrineEL = Ext.getCmp('CarrinhoVitrine');

        var maskElProduto = Ext.get(el.parents('.produto')[0]);

        if (!CarrinhoVitrineEL.collapsed)
            CarrinhoVitrineEL.body.mask('Atualizando cesta...', 'x-mask-loading');
        else
            maskElProduto.mask('Enviando cesta...', 'x-mask-loading');

        UCGridCompras.ContentPlaceHolder1_UC_Grid.AdicionarProduto(el.attr('id'), el.val(), { success: function () {
            if (!CarrinhoVitrineEL.collapsed)
                CarrinhoVitrineEL.body.unmask();
            else {
                maskElProduto.unmask();
                $('#CarrinhoVitrine').effect("pulsate", { times: 10 }, 150);
            }
            Ext.Function.defer(function () { MouseOverEdit(); }, 100);
        }
        });

    };

    var MouseOverEdit = function (a, b, c, d, e, f) {
        $('td:eq(1)', $('table tbody tr.x-grid-row', $(App.CarrinhoVitrineGrid.el.dom))).mouseover(function () {
            var grid = App.CarrinhoVitrineGrid;
            var jEl = $(this);
            var column = grid.getView().getHeaderByCell(Ext.getDom(this));

            var index = jEl.parent().index();
            var r = grid.store.getAt(index - 1);
            var edit = grid.plugins[0];
            if (edit.startEdit) {
                edit.startEdit(r, column);
            }
        });
    }
</script>
<ext:GridPanel ID="CarrinhoVitrineGrid" IDMode="Static" runat="server" ForceFit="true" Height="200">
            <Store>
                <ext:Store ID="Store1" runat="server" OnReadData="CarrinhoVitrineGrid_Refresh" >
                    <Model>
                        <ext:Model ID="Model1" runat="server" IDProperty="ID" >
                            <Fields>
                                <ext:ModelField Name="ID" />
                                <ext:ModelField Name="Nome" />
                                <ext:ModelField Name="Quantidade" />
                                <ext:ModelField Name="Preco" />
                            </Fields>
                        </ext:Model>
                    </Model>
                    <Listeners>
                        <DataChanged Handler="reRenderGridCarrinho();var len = store.data.length; if (#{CarrinhoVitrine}) #{CarrinhoVitrine}.setTitle(Ext.util.Format.format('Seu Carrinho - {0} {1}.', len, len == 1 ? 'item' : 'itens'));" Delay="50" />
                    </Listeners>
                </ext:Store>
            </Store>
            <ColumnModel ID="ColumnModel1" runat="server" ForceFit="true">
                <Columns>
                    <ext:SummaryColumn ID="SummaryColumn1" runat="server" Text="Nome" DataIndex="Nome" Width="45" MenuDisabled="true" Resizable="false" Sortable="false">
                        <SummaryRenderer Handler="return '&nbsp;';" />
                    </ext:SummaryColumn>
                    <ext:SummaryColumn ID="SummaryColumn2" runat="server" Width="20" Text="Quant." DataIndex="Quantidade" SummaryType="Sum" MenuDisabled="true" Resizable="false">
                        <SummaryRenderer Handler="return value;" />
                        <Editor>
                            <ext:NumberField ID="NumberField1" runat="server" AllowBlank="false" AllowDecimals="false" MinValue="1" AllowNegative="false" StyleSpec="text-align:left" />
                        </Editor>
                        <Listeners>
                            <AfterRender Handler="MouseOverEdit()" Delay="500" />
                        </Listeners>
                    </ext:SummaryColumn>
                    <ext:SummaryColumn ID="SummaryColumn3" runat="server" Text="Preço Un." Width="25" DataIndex="Preco" MenuDisabled="true" CustomSummaryType="totalCostBasket" Resizable="false">
                        <Renderer Handler="return Ext.util.Format.brMoney(value);" />
                        <SummaryRenderer Handler="return Ext.util.Format.brMoney(value);" />
                    </ext:SummaryColumn>
                    <ext:CommandColumn ID="CommandColumn1" runat="server" Width="10" Resizable="false">
                        <Commands>
                            <ext:GridCommand Icon="Delete" CommandName="Delete">
                            </ext:GridCommand>
                        </Commands>
                        <Listeners>
                            <Command Handler="UCGridCompras.ContentPlaceHolder1_UC_Grid.RemoverProduto(record.data.ID);" />
                        </Listeners>
                    </ext:CommandColumn>
                </Columns>
            </ColumnModel>
            <Features>               
                <ext:Summary ID="Summary1" runat="server" />                   
            </Features>
            <SelectionModel>
                <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" Mode="Single" />
            </SelectionModel> 
            <View>
                <ext:GridView ID="GridView1" runat="server" StripeRows="true" TrackOver="true" OverflowX="Hidden" OverflowY="Auto" />
            </View>     
            <Listeners>
                <AfterRender Handler="$('table tbody tr:first th', $(this.el.dom)).css('padding', '0').css('border', 'none');" Delay="50" />
            </Listeners>   
            <Plugins>
                <ext:CellEditing ID="CellEditing1" runat="server">
                    <Listeners>
                        <Edit Fn="edit" />
                    </Listeners>
                </ext:CellEditing>
            </Plugins>  
        </ext:GridPanel>