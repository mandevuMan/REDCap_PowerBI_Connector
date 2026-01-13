// This file contains your Data Connector logic
[Version = "1.0.0"]
section REDCap_Connector;

[DataSource.Kind = "REDCap_Connector", Publish = "REDCap_Connector.Publish"]
shared REDCap_Connector.Contents = Value.ReplaceType(
    REDCapSec,
    type function (
        REDCap_URL as Text.Type,
        API_Token as Password.Type,
        rawOrlabel as Text.Type,
        rawOrlabel_Headers as Text.Type,
        exportCheckboxLabel as Text.Type,
        exportSurveyFields as Text.Type,
        exportDataAccessGroups as Text.Type,
        Fields as Any.Type,
        Forms as Any.Type,
        Events as Any.Type
    ) as any
);

// Helper function to build query parameters dynamically
BuildQueryParams = (
    token as text,
    raw_label as text,
    raw_label_headers as text,
    checkbox_label as text,
    survey_fields as text,
    export_dag as text,
    field_s as text,
    form_s as text,
    event_s as text
) =>
    let
        // Base parameters that are always included
        baseParams = "token=" & token & "&content=record&format=csv&type=flat",
        // Conditionally add optional parameters
        fieldParam = if field_s <> "" then "&fields=" & field_s else "",
        formParam = if form_s <> "" then "&forms=" & form_s else "",
        eventParam = if event_s <> "" then "&events=" & event_s else "",
        // Always included configuration parameters
        configParams = "&rawOrLabel="
            & raw_label
            & "&rawOrLabelHeaders="
            & raw_label_headers
            & "&exportCheckboxLabel="
            & checkbox_label
            & "&exportSurveyFields="
            & survey_fields
            & "&exportDataAccessGroups="
            & export_dag
            & "&returnFormat=json",
        // Combine all parameters
        queryString = baseParams & fieldParam & formParam & eventParam & configParams
    in
        queryString;

REDCapSec = (
    r_url as text,
    token as text,
    raw_label as text,
    raw_label_headers as text,
    checkbox_label as text,
    survey_fields as text,
    export_dag as text,
    fields as any,
    forms as any,
    events as any
) =>
    let
        // Clean and validate inputs
        myurl = Value.ReplaceType(r_url, Uri.Type),
        mytoken = Value.ReplaceType(token, Password.Type),
        field_s = if fields is null then "" else Value.ReplaceType(fields, Text.Type),
        event_s = if events is null then "" else Value.ReplaceType(events, Text.Type),
        form_s = if forms is null then "" else Value.ReplaceType(forms, Text.Type),
        // Build query string dynamically
        queryString = BuildQueryParams(
            mytoken, raw_label, raw_label_headers, checkbox_label, survey_fields, export_dag, field_s, form_s,
            event_s
        ),
        // Headers for the API request
        headers = [
            #"Accept" = "application/csv",
            #"Content-Type" = "application/x-www-form-urlencoded"
        ],
        // Make API call with RelativePath for auto-refresh support
        // Using RelativePath allows Power BI Gateway to properly cache and refresh the data
        data_source = Web.Contents(
            myurl,
            [
                RelativePath = "",
                Content = Text.ToBinary(queryString),
                Headers = headers,
                ManualStatusHandling = {400, 403, 404, 500}
            ]
        ),
        // Parse CSV response
        dset = Csv.Document(data_source, [Delimiter = ",", Encoding = 65001]),
        data = Table.PromoteHeaders(dset, [PromoteAllScalars = true])
    in
        data;

// Data Source Kind description
REDCap_Connector = [
    TestConnection = (dataSourcePath) =>
        let
            json = Json.Document(dataSourcePath), url = json[REDCap_URL], token = json[API_Token]
        in
            {"PowerBI_REDCap.Contents", url, token},
    Authentication = [
        // Anonymous authentication for backward compatibility
        Anonymous = [],
        // Key authentication is recommended for Power BI Gateway refresh
        Key = [
            KeyLabel = "REDCap API Token",
            Label = "API Key"
        ]
    ],
    Label = "REDCap Power BI"
];

// Data Source UI publishing description
REDCap_Connector.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = {Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp")},
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = REDCap_Connector.Icons,
    SourceTypeImage = REDCap_Connector.Icons
];

REDCap_Connector.Icons = [
    Icon16 = {
        Extension.Contents("REDCap_Connector16.png"),
        Extension.Contents("REDCap_Connector20.png"),
        Extension.Contents("REDCap_Connector24.png"),
        Extension.Contents("REDCap_Connector32.png")
    },
    Icon32 = {
        Extension.Contents("REDCap_Connector32.png"),
        Extension.Contents("REDCap_Connector40.png"),
        Extension.Contents("REDCap_Connector48.png"),
        Extension.Contents("REDCap_Connector64.png")
    }
];
