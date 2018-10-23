// # REDCap Custom Data Connector v1.0              # //
// # By Charles Waka 2018                           # //
// # This custom connector can be used by valid     # //
// # REDCap and Power BI users licensed at a valid  # //
// # REDCap Consortium instituion.                  # //


// This file contains your Data Connector logic
section PowerBI_REDCap;

[DataSource.Kind="PowerBI_REDCap", Publish="PowerBI_REDCap.Publish"]
shared PowerBI_REDCap.Contents = Value.ReplaceType(REDCapSec,type function(REDCap_URL as Text.Type,API_Token as Password.Type,rawOrlabel as Text.Type, rawOrlabel_Headers as Text.Type, exportCheckboxLabel as Text.Type, exportSurveyFields as Text.Type,exportDataAccessGroups as Text.Type, Fields as Any.Type, Forms as Any.Type, Events as Any.Type) as any);


headers=[
#"Accept"="application/csv",
#"Content-Type" = "application/x-www-form-urlencoded"
];


REDCapSec = (r_url as text, token as text, raw_label as text, raw_label_headers as text, checkbox_label as text, survey_fields as text,export_dag as text, fields as any, forms as any, events as any ) => 


    let
        myurl=Value.ReplaceType(r_url,Uri.Type),
        mytoken=Value.ReplaceType(token,Password.Type),
        field_s=if fields is null then "" else Value.ReplaceType(fields,Text.Type),
        event_s=if events is null then "" else Value.ReplaceType(events,Text.Type),
        form_s=if forms is null then "" else Value.ReplaceType(forms, Text.Type),

        data_source=
            if field_s <>"" and event_s="" and form_s="" then Web.Contents(myurl, [Content = Text.ToBinary("token="&mytoken&"&content=record&format=csv&type=flat&fields="&field_s&"&rawOrLabel="&raw_label&"&rawOrLabelHeaders="&raw_label_headers&"&exportCheckboxLabel="&checkbox_label&"&exportSurveyFields="&survey_fields&"&exportDataAccessGroups="&export_dag&"&returnFormat=json"), Headers = headers])
            else if field_s<>"" and event_s<>"" and form_s<>"" then Web.Contents(myurl, [Content = Text.ToBinary("token="&mytoken&"&content=record&format=csv&type=flat&fields="&field_s&"&forms="&form_s&"&events="&event_s&"&rawOrLabel="&raw_label&"&rawOrLabelHeaders="&raw_label_headers&"&exportCheckboxLabel="&checkbox_label&"&exportSurveyFields="&survey_fields&"&exportDataAccessGroups="&export_dag&"&returnFormat=json"), Headers = headers])
            else if field_s="" and event_s<>"" and form_s<>"" then Web.Contents(myurl, [Content = Text.ToBinary("token="&mytoken&"&content=record&format=csv&type=flat&forms="&form_s&"&events="&event_s&"&rawOrLabel="&raw_label&"&rawOrLabelHeaders="&raw_label_headers&"&exportCheckboxLabel="&checkbox_label&"&exportSurveyFields="&survey_fields&"&exportDataAccessGroups="&export_dag&"&returnFormat=json"), Headers = headers])
            else if field_s="" and event_s="" and form_s<>"" then Web.Contents(myurl, [Content = Text.ToBinary("token="&mytoken&"&content=record&format=csv&type=flat&forms="&form_s&"&rawOrLabel="&raw_label&"&rawOrLabelHeaders="&raw_label_headers&"&exportCheckboxLabel="&checkbox_label&"&exportSurveyFields="&survey_fields&"&exportDataAccessGroups="&export_dag&"&returnFormat=json"), Headers = headers])
            else if field_s="" and event_s<>"" and form_s="" then Web.Contents(myurl, [Content = Text.ToBinary("token="&mytoken&"&content=record&format=csv&type=flat&events="&event_s&"&rawOrLabel="&raw_label&"&rawOrLabelHeaders="&raw_label_headers&"&exportCheckboxLabel="&checkbox_label&"&exportSurveyFields="&survey_fields&"&exportDataAccessGroups="&export_dag&"&returnFormat=json"), Headers = headers])
            else if field_s<>"" and event_s="" and form_s<>"" then Web.Contents(myurl, [Content = Text.ToBinary("token="&mytoken&"&content=record&format=csv&type=flat&fields="&field_s&"&forms="&form_s&"&rawOrLabel="&raw_label&"&rawOrLabelHeaders="&raw_label_headers&"&exportCheckboxLabel="&checkbox_label&"&exportSurveyFields="&survey_fields&"&exportDataAccessGroups="&export_dag&"&returnFormat=json"), Headers = headers])
            else if field_s<>"" and event_s<>"" and form_s="" then Web.Contents(myurl, [Content = Text.ToBinary("token="&mytoken&"&content=record&format=csv&type=flat&fields="&field_s&"&events="&event_s&"&rawOrLabel="&raw_label&"&rawOrLabelHeaders="&raw_label_headers&"&exportCheckboxLabel="&checkbox_label&"&exportSurveyFields="&survey_fields&"&exportDataAccessGroups="&export_dag&"&returnFormat=json"), Headers = headers])
            else Web.Contents(myurl, [Content = Text.ToBinary("token="&mytoken&"&content=record&format=csv&type=flat&rawOrLabel="&raw_label&"&rawOrLabelHeaders="&raw_label_headers&"&exportCheckboxLabel="&checkbox_label&"&exportSurveyFields="&survey_fields&"&exportDataAccessGroups="&export_dag&"&returnFormat=json"), Headers = headers]),
          
        dset=Csv.Document(data_source),
        data=Table.PromoteHeaders(dset)
    in
        data;

        
// Data Source Kind description
PowerBI_REDCap = [
TestConnection=(dataSourcePath)=>{"PowerBI_REDCap.Contents", dataSourcePath},
    Authentication = [
            Anonymous=[]
         ],
         Label="REDCap Power BI"
    //Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
PowerBI_REDCap.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { "Power BI to REDCap Connector", "REDCap to Power BI Data Connector" },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = PowerBI_REDCap.Icons,
    SourceTypeImage = PowerBI_REDCap.Icons
];

PowerBI_REDCap.Icons = [
    Icon16 = { Extension.Contents("PowerBI_REDCap16.png"), Extension.Contents("PowerBI_REDCap20.png"), Extension.Contents("PowerBI_REDCap24.png"), Extension.Contents("PowerBI_REDCap32.png") },
    Icon32 = { Extension.Contents("PowerBI_REDCap32.png"), Extension.Contents("PowerBI_REDCap40.png"), Extension.Contents("PowerBI_REDCap48.png"), Extension.Contents("PowerBI_REDCap64.png") }
];
