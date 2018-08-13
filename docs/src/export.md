```@meta
CurrentModule = REDCap
```
# Exporting

Exporting from a REDCap database is straightforward. If not specified, data exports will return as a `json`, turned into a `Dict`. `xml`, `csv`/`df`, and `odm` formats are all valid formats to pass into this API. Some exports, such as version and url/return code for surveys return as simple strings, while most others return in the specified format.

Because REDCap is medical in nature, some information may be identifying information.

From the REDCap Documentation:
<b>Note about export rights:</b>
> Please be aware that Data Export user rights will be applied to this API request. For example, if you have 'No Access' data export rights in the project, then the API data export will fail and return an error. And if you have 'De-Identified' or 'Remove all tagged Identifier fields' data export rights, then some data fields *might* be removed and filtered out of the data set returned from the API. To make sure that no data is unnecessarily filtered out of your API request, you should have 'Full Data Set' export rights in the project.


## Records

```@docs
export_records(config::REDCap.Config; format::String="json", dtype::String="flat", records, fields, forms, events, rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", exportCheckboxLabel::Bool=false, returnFormat::String="json", exportSurveyField::Bool=false, exportDataAccessGroups::Bool=false, filterLogic::String, file_loc::String="")
```

Exported records can be returned normally, or written to a file. Records can be exported by their record id, by specified fields, or even using a boolean logic string such as `[age]>80`

```julia
export_records(config)

export_records(config, records=["1","2"], fields=["record_id", "firstname"], filterLogic="[age]>80")

#records can also be exported directly to a file by passing `file_loc` a path
export_records(config, file_loc="/src/output.csv", format="csv")
```

The label headers

```julia
export_records(config, rawOrLabel="label")
export_records(config, rawOrLabelHeaders="label")
```

dtype - what is it #### Deprec by 0.7
```julia
export_records(config, dtype="eav")
```

## Project Info

Project information, field names, and metadata are all available for export. As above, they can be written directly to a file.

A `.pdf` of the entire project is available through `export_pdf()`, as well as the entire project as an `xml` file through `export_project()`

### Field and Metadata

Both field names and the project metadata can be exported through API calls.

Field names will return a dictionary of field names with the export name, original name, and choice value.

Metadata will return a dictionary of field names, as well as all settings associated with that field.
```julia
#Get a list of field names for the records
fields = export_field_names(config)

#Project metadata can be read and modified this way - See Section on Imports
metadata = export_metadata(config)

#Metadata output can also be formatted
metacsv = export_metadata(config, format="csv")
```

### Full Project Info

The entire project can be exported in a number of ways. Using `export_project()`, the entire project is returned as an xml file. `export_project_information()` returns a dictionary of the projects configuration

```julia
#A dict of the projects information can be retrieved through:
proj_info = export_project_information(config)

#The entire project can also be exported as a xml
export_project(config)

#A PDF summary of entire project
export_pdf(config, "<file-path>", allRecords=true)

#A PDF summary of specific records
export_pdf(config, "<file-path>", record="1", event="", instrument="demographics")
```

### Reports

```@docs
export_report(config::REDCap.Config, report_id::Integer; format::String="json", returnFormat::String="json", rawOrLabel::String="raw", rawOrLabelHeaders::String="raw", exportCheckboxLabel::Bool=false, file_loc::String="")
```

Reports can also be exported using the generated id given on the REDCap dashboard.

#### NOTE:
This is <b>NOT</b> the name of the report.

```julia
report = export_report(config, "2")
```
A Report can contain a subset of records along with a subset of their fields. Report creation is handled through the REDCap project database.


### Version

The version of REDCap you are working with can be shown through `export_version()`

```julia
export_version(config)
```
```bash
"8.1.0"
```

## Users

```@docs
export_users(config::REDCap.Config; format::String="json", returnFormat::String="json", file_loc::String="")
```

A full list of users can be exported and viewed/modified using the `export_users()` function. User Rights can be modified (by a user with appropriate rights) using this method. - See Section on Imports

```julia
#Returns an array of dictionaries
users = export_users(config)
```

## Surveys

REDCap allows surveys to be tied both to a given event and to an individual record. Accessing features of these surveys is easy through the provided API.

A survey link can be generated for a particular record and instrument/event through the `export_survey_link()` function. The instrument name may be different then it is displayed on the REDCap dashboard. Surveys must be enabled for the given instrument.
```julia
#Creates a URL to survey for a given record
link = export_survey_link(config, "23", "demographics", "event")
```
This returns a string of the link.

Return codes and Queue links can also be created by passing mostly the same values. Survey queue must be enabled for queue links to work.
```julia
#Survey return codes
code = export_survey_return_code(config, "1", "demographics", "event")

#Survey queue link
qlink =  export_survey_queue_link(config, "1")

#Survey participant list
list = export_survey_participant_list(config, "demographics", "event")
```

## Arms

```@docs
export_arms(config::REDCap.Config; arms::Array=[], format::String="json", returnFormat::String="json", file_loc::String="")
```

The metadata of a projects arms can be exported with `export_arms(config)`, which by default returns a dictionary containing both the name and number of an arm. Only select arms may be exported by passing an array of arm numbers.
```julia
arms = export_arms(config)
```
This can only be used in a longitudinal project. Exporting arms in a non-longitudinal project will result in an error.


## Events

```@docs
export_events(config::REDCap.Config; arms::Array=[], format::String="json", returnFormat::String="json", file_loc::String="")
```
An array of events is returned, along with the events information.

```julia
events = export_events(config)
```

## Instruments

```@docs
export_instruments(config::REDCap.Config; format::String="json", file_loc::String="")
```

Instrument information may also be exported using `export_instruments(config)`. By default this returns a dictionary of the instrument label and the instruments variable name (which is often different from the label and is needed to access instruments via the API).
```julia
instruments = export_instruments(config)
```

## Instrument Event Mappings

```@docs
export_instrument_event_mappings(config::REDCap.Config, arms::Array=[]; format::String="json", returnFormat::String="json", file_loc::String="")
```

The mappings between events and instruments may be exported using `export_instrument_event_mappings()`

```julia
export_instrument_event_mappings(config, ["1"])
```