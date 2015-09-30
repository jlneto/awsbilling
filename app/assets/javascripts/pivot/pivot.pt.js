(function() {
  var callWithJQuery;

  callWithJQuery = function(pivotModule) {
    if (typeof exports === "object" && typeof module === "object") {
      return pivotModule(require("jquery"));
    } else if (typeof define === "function" && define.amd) {
      return define(["jquery"], pivotModule);
    } else {
      return pivotModule(jQuery);
    }
  };

  callWithJQuery(function($) {
    var frFmt, frFmtInt, frFmtPct, gcr, nf, r, tpl;
    nf = $.pivotUtilities.numberFormat;
    tpl = $.pivotUtilities.aggregatorTemplates;
    r = $.pivotUtilities.renderers;
    gcr = $.pivotUtilities.gchart_renderers;
    frFmt = nf({
      thousandsSep: ".",
      decimalSep: ","
    });
    frFmtInt = nf({
      digitsAfterDecimal: 0,
      thousandsSep: ".",
      decimalSep: ","
    });
    frFmtPct = nf({
      digitsAfterDecimal: 2,
      scaler: 100,
      suffix: "%",
      thousandsSep: ".",
      decimalSep: ","
    });
    return $.pivotUtilities.locales.pt = {
      localeStrings: {
        renderError: "Ocorreu um error ao renderizar os resultados da Tabela Din&atilde;mica.",
        computeError: "Ocorreu um error ao computar os resultados da Tabela Din&atilde;mica.",
        uiRenderError: "Ocorreu um error ao renderizar a interface da Tabela Din&atilde;mica.",
        selectAll: "Sel. Todos",
        selectNone: "Sel. Nenhum",
        tooMany: "(demais para listar)",
        filterResults: "Filtrar resultados",
        totals: "Totais",
        vs: "X",
        by: "por"
      },
      aggregators: {
        "Contagem": tpl.count(frFmtInt),
        "% do Total": tpl.fractionOf(tpl.count(), "total", frFmtPct),
        "% da Linha": tpl.fractionOf(tpl.count(), "row", frFmtPct),
        "% da Coluna": tpl.fractionOf(tpl.count(), "col", frFmtPct)
      },
      renderers: {
        "Tabela": r["Table"],
        "Graf Barras Emp.": gcr["Stacked Bar Chart"],
        "Graf Barras": gcr["Bar Chart"],
        "Graf Área": gcr["Area Chart"],
        "Graf Linhas": gcr["Line Chart"],
        "Tabela Barras": r["Table Barchart"],
        "Mapa de Calor": r["Heatmap"],
        "Calor p/ Linhas": r["Row Heatmap"],
        "Calor p/ Colunas": r["Col Heatmap"]
      }
    };
  });

}).call(this);
