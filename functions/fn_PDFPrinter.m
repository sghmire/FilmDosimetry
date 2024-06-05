function PDF_Doc = fn_PDFPrinter(MRN_ID, Plan_ID, REF_Image, Film_Image, XProfileImage, YProfileImage, ...
    DD, DTA, Compar1, ShiftsX, ShiftsY, PassingRate, GammaMap)
    makeDOMCompilable();
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
    date = datetime("today");

    % Create a PDF report
    PDF_Doc = Report('MyReport', "pdf");

    % Open the report
    open(PDF_Doc);

    if strcmpi(PDF_Doc.Type, "pdf")
        pageLayoutObj = PDFPageLayout;
    else
        pageLayoutObj = DOCXPageLayout;
    end

    pageLayoutObj.PageMargins.Top = "0.25in";
    pageLayoutObj.PageMargins.Bottom = "0.25in";
    pageLayoutObj.PageMargins.Left = "0.25in";
    pageLayoutObj.PageMargins.Right = "0.25in";
    pageLayoutObj.PageSize.Orientation = "portrait";
    pageLayoutObj.PageSize.Height = "11.69in";
    pageLayoutObj.PageSize.Width = "8.27in";
    add(PDF_Doc, pageLayoutObj);

    % Adding title as paragraph
    t = Paragraph("Film Dosimetry Report");
    t.BackgroundColor = 'lightblue';
    t.Style = [t.Style, {HAlign('center'), Bold(true), FontSize('18pt')}];
    t.Style = [t.Style {OuterMargin("0in", "0in", "0in", "0.2in")}];
    append(PDF_Doc, t);


    % Add plan information to the report
    MRN = MRN_ID;
    PlanID = string(Plan_ID);
    Date = {datestr(date, 'mm-dd-yyyy')};
    var_names1 = {' MRN ', ' PlanID ', ' Date '};
    Info = table(MRN, PlanID, Date, 'VariableNames', var_names1);
    mltableObjCombined = MATLABTable(Info);   
    mltableObjCombined.Style = [mltableObjCombined.Style {OuterMargin("0.5in", "0in", "0in", "0.2in")}];
    mltableObjCombined.Header.Style = [mltableObjCombined.Header.Style {Bold(true), HAlign('center'), FontSize('12pt')}];
    append(PDF_Doc, mltableObjCombined);

    % First heading for the profile
    heading1 = Heading(1, "2D Plan and Film Dose: ");
    heading1.Style = [heading1.Style {OuterMargin("0.5in", "0in", "0.5in", "0.0in")}];
    append(PDF_Doc, heading1);

    % Add an image to the report
    imgStyle = {ScaleToFit(true), HAlign('center'), OuterMargin("0in","0in","0in","0in")};
    img1 = Image(which(REF_Image));
    img1.Style = imgStyle;
    img2 = Image(which(Film_Image));
    img2.Style = imgStyle;
    lot1 = Table({img1,  img2});
    lot1.entry(1, 1).Style = {Width('3in'), Height('2in')};
    lot1.entry(1, 2).Style = {Width('3in'), Height('2in')};
    lot1.Style = {ResizeToFitContents(false), Width('100%'), HAlign('center')}; % Center align the table
    add(PDF_Doc, lot1);

    % Second heading for the profile
    heading2 = Heading(1, "X and Y Profile along the Plan and Film Center: ");
    heading2.Style = [heading2.Style {OuterMargin("0.5in", "0in", "0in", "0.0in")}];
    append(PDF_Doc, heading2);

    % Add an image to the report
    img3 = Image(which(XProfileImage));
    img3.Style = imgStyle;
    img4 = Image(which(YProfileImage));
    img4.Style = imgStyle;
    lot2 = Table({img3,  img4});
    lot2.entry(1, 1).Style = {Width('3in'), Height('2in')};
    lot2.entry(1, 2).Style = {Width('3in'), Height('2in')};
    lot2.Style = {ResizeToFitContents(false), Width('100%'), HAlign('center')}; % Center align the table
    add(PDF_Doc, lot2);

    % Second heading for the profile
    heading3 = Heading(1, "Gamma Result: ");
    heading3.Style = [heading3.Style {OuterMargin("0.5in", "0in", "0in", "0.0in")}];
    append(PDF_Doc, heading3);

    % Add an image to the report
    img5 = Image(which(GammaMap));
    img5.Style = imgStyle;
    lot5 = Table({img5});
    lot5.entry(1, 1).Style = {Width('5in'), Height('2.5in')};
    lot5.Style = {ResizeToFitContents(false), Width('100%'), HAlign('center')}; % Center align the table
    add(PDF_Doc, lot5);

    % Gamma Criteria
    % Add plan information to the report
    DTA_mm = cellstr(string(DTA));
    DD_per = cellstr(string(DD));
    ShiftsX = sprintf('%.2f', round(ShiftsX,2));
    ShiftsY = sprintf('%.2f',round(ShiftsY,2));
    Shifts = {strtrim(ShiftsX), strtrim(ShiftsY)};
    Comparison = {Compar1};
    percent =  sprintf('%.2f',round(PassingRate,2));
    PassinRate_per = {strtrim(percent)};

    var_names2 = {'DD(%)  ', 'DTA(mm)   ', 'Comparision  ', 'X(mm)-Y(mm)  ', 'PassingRate(%)  '};

    gamma = table(DTA_mm, DD_per, Comparison, Shifts, PassinRate_per, ...
        'VariableNames', var_names2);
    mltableObjCombined = MATLABTable(gamma);
    mltableObjCombined.Style = [mltableObjCombined.Style {OuterMargin("0.5in", "0in", "0in", "0.2in")}];
    mltableObjCombined.Header.Style = [mltableObjCombined.Header.Style {Bold(true), HAlign('center'), FontSize('12pt')}];
    append(PDF_Doc, mltableObjCombined);

    close(PDF_Doc);

end
