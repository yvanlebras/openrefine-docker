ExporterManager.MenuItems.push(
    {
      "id" : "biodec/export",
      "label" : "Galaxy exporter",
      "click": function() {
        LocalExporterMenuBar.export("tsv");
      }
    });

LocalExporterMenuBar = {}

LocalExporterMenuBar.export = function(format) {
  var form = document.createElement("form");
  $(form).css("display", "none")
      .attr("method", "post")
      .attr("action", "command/biodec/save")
      .attr("target", "openrefine-export-" + format);

      $('<input />')
      .attr("name", "engine")
      .val(JSON.stringify(ui.browsingEngine.getJSON()))
      .appendTo(form);
  $('<input />')
      .attr("name", "project")
      .val(theProject.id)
      .appendTo(form);
  $('<input />')
      .attr("name", "format")
      .val(format)
      .appendTo(form);

  document.body.appendChild(form);

  window.open("about:blank", "openrefine-export-" + format);
  form.submit();

  document.body.removeChild(form);
}
