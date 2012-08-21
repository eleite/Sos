<%@ Page Title="" Language="C#" MasterPageFile="~/WebPage/BasePage.Master" AutoEventWireup="true" CodeBehind="GerenciarImagemProduto.aspx.cs" Inherits="Sos.WebPage.GerenciarImagemProduto" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<script type="text/javascript">
    var Mouseover = function () {
        var p = $(this).offset();
        App.ContentPlaceHolder1_IdProduto_.setValue($(this).attr("id").substr('img-'.length));
        App.ContentPlaceHolder1_BtnEdit.showAt(10, 20);
        App.ContentPlaceHolder1_BtnEdit.showAt(p.left + 57, p.top);
    };
    var Mouseout = function (e) {
        var xC = App.ContentPlaceHolder1_BtnEdit.pageX - 2;
        var yC = App.ContentPlaceHolder1_BtnEdit.pageY;
        var my = yC + 42;
        var mx = xC + 25;
        if (e.pageX > mx || e.pageX < xC || e.pageY > my || e.pageY < yC)
            App.ContentPlaceHolder1_BtnEdit.hide();
    };
    var SalvarArquivo = function (fn, v) {
        var b = $('#img-' + App.ContentPlaceHolder1_IdProduto_.getValue());
        if (v && b.length == 1) {
            if (!Ext.get(b[0]))
                return;
            Ext.get(b[0]).parent('div').mask('Enviando...');
            App.direct.SalvarImagem({ success: function (res) {
                if (res) {
                    b.attr("src", res);
                }
                Ext.get(b[0]).parent('div').unmask();
            } 
            });
        }
    };
    
</script>
<ext:Panel ID="Panel1" runat="server" Width="500" Height="400" Title="Imagem produtos" Layout="Fit">
    <Items>
        <ext:GridPanel ID="GridPanel1" runat="server">
            <Store>
                <ext:Store ID="Store1" runat="server">
                    <Model>
                        <ext:Model ID="Model1" runat="server" IDProperty="Id">
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
                    <ext:TemplateColumn ID="TemplateColumn1" runat="server" Text="Imagem" Flex="20" DataIndex="url" 
                        TemplateString='<img id="img-{Id}" style="width:79px;height:79px;" class="imgProduto" src="{url}" />' />
                    <ext:Column ID="Column1" runat="server" Text="Produto" DataIndex="nome" Flex="80" />
                </Columns>    
            </ColumnModel>
            <Listeners>
                <AfterRender Handler="CorrigirCssTable(this); $.each($('.imgProduto'), function(){ $(this).mouseover(Mouseover).parents('tr.x-grid-row').mouseout(Mouseout); });" Delay="250" />        
            </Listeners>
        </ext:GridPanel>        
    </Items>
</ext:Panel>
<ext:Panel runat="server" ID="BtnEdit" Layout="AbsoluteLayout" Width="22" Height="22" >
    <Items>
        <ext:Hidden runat="server" ID="IdProduto_" />
        <ext:FileUploadField ID="FileUploadField1" runat="server" ButtonOnly="true" ButtonText="" Icon="ImageAdd" >
            <Listeners>
                <Change Fn="SalvarArquivo" />
                <AfterRender Handler="CorrigirCssTable(this); Ext.get(this.el.setStyle('z-index','80000').select('.x-btn-default-small').elements[0]).setStyle('padding', 0).setStyle('border-style', 'initial')" />
            </Listeners>
        </ext:FileUploadField>    
    </Items>
</ext:Panel>


</asp:Content>
