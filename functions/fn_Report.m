function PDF_Path = fn_Report
        import mlreportgen.dom.*;
        import mlreportgen.report.*;
        PDF_Doc = Report('MyReport', "pdf");
        open(PDF_Doc);
        close(PDF_Doc);
        PDF_Path = PDF_Doc.OutputPath;
end
