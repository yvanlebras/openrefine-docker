
package com.biodec.refine.commands;

import java.io.IOException;
import java.io.Writer;
import java.io.FileWriter;
import java.io.OutputStreamWriter;
import java.util.Enumeration;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.refine.model.Project;
import com.google.refine.util.ParsingUtilities;

import com.google.refine.ProjectManager;
import com.google.refine.browsing.Engine;
import com.google.refine.commands.Command;
import com.google.refine.exporters.CsvExporter;
import com.google.refine.exporters.Exporter;
import com.google.refine.exporters.ExporterRegistry;
import com.google.refine.exporters.StreamExporter;
import com.google.refine.exporters.WriterExporter;


public class LocalExportCommand extends Command {

    @SuppressWarnings("unchecked")
    static public Properties getRequestParameters(HttpServletRequest request) {
        Properties options = new Properties();

        Enumeration<String> en = request.getParameterNames();
        while (en.hasMoreElements()) {
            String name = en.nextElement();
            options.put(name, request.getParameter(name));
        }
        return options;
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        ProjectManager.singleton.setBusy(true);

        try {
            System.out.println("LocalExportCommand");

            Project project = getProject(request);

            System.out.println("Getting parameters...");
            Engine engine = getEngine(request, project);
            Properties params = getRequestParameters(request);

            String format = params.getProperty("format");
            String encoding = params.getProperty("encoding");
            System.out.println("Format " + format + "; encoding: " + encoding);
            System.out.println("Getting exporter...");

            Exporter exporter = ExporterRegistry.getExporter(format);

            System.out.println("Getting writer...");

            String filename = "/import/openrefine-" + project.getMetadata().getName() + ".tsv";
            FileWriter writer = new FileWriter(filename);

            System.out.println("Exporting to " + filename);

            ((WriterExporter) exporter).export(project, params, engine, writer);

            System.out.println("Done writing.");

            writer.close();

            try {
                System.out.println("Calling python script");
                String[] cmd = {"/python-galaxy/bin/python", "/python-galaxy/upload-file.py", filename};
                Process p = Runtime.getRuntime().exec(cmd);
                p.waitFor();
                int exitstatus = p.exitValue();
                System.out.println(p.exitValue());
            } catch (Exception e) {
                System.out.println(e);
            } finally {
            }

            response.setCharacterEncoding(encoding != null ? encoding : "UTF-8");
            Writer oswriter = encoding == null ?
                    response.getWriter() :
                    new OutputStreamWriter(response.getOutputStream(), encoding);
            oswriter.write("Dataset has been exported to Galaxy, please close this tab");
            oswriter.close();


        } catch (Exception e) {
            // This is an unexpected exception, so we log it.
            respondException(response, e);
        } finally {
            ProjectManager.singleton.setBusy(false);
        }
    }
}
