/*
 * Function invoked to initialize the extension.
 */
function init() {
  // Script files to inject into /project page
  ClientSideResourceManager.addPaths(
    "project/scripts",
    module,
    [
      "scripts/exporter-menu.js"
    ]
  );

  // Style files to inject into /project page
  ClientSideResourceManager.addPaths(
    "project/styles",
    module,
    [
      "styles/project-injection.css"
    ]
  );

var RefineServlet = Packages.com.google.refine.RefineServlet;
var LocalExportCommand = Packages.com.biodec.refine.commands.LocalExportCommand;
RefineServlet.registerCommand(module, "save", new LocalExportCommand());

}


