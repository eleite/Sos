var start = 0;
var paginas = 0;

var upPaginador = function (start, paginas) {
    if (paginas == 0)
        paginas = 1;
    $("div[id^=paginador]").paginate({
        count: paginas,
        start: start,
        display: 15,
        href: function (numPage) {
            return "";
        }
    });
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
    }
};
var upProdutos = function (json) {
    console.log(json);
    App.TemplateProdutos.overwrite('produtos', jQuery.parseJSON(json));
    upContainerProduto();
};