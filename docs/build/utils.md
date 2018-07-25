


<a id='Other-Functionality-1'></a>

# Other Functionality


<a id='Config-1'></a>

## Config


All REDCap projects need to be tied to their url and API Key, which is done by creating a Config object


```julia
config = REDCap.Config("<url>", "<32-digit_API_key>")
```


This object is then passed to all API calling functions. 


<a id='Project-Creation-1'></a>

## Project Creation


Projects can be created by first constructing a superConfig object, and initializing a project with desired settings. The function returns the config object for that project.


```julia
superconfig = REDCap.Config("<url>", "<64-digit_superAPI_key>")

config = create_project(superconfig, "<New Project Name>", 0) #0 indicates a test project
```


<a id='Deletion-1'></a>

## Deletion

<a id='REDCap.delete_records-Tuple{REDCap.Config,Array}' href='#REDCap.delete_records-Tuple{REDCap.Config,Array}'>#</a>
**`REDCap.delete_records`** &mdash; *Method*.



```
delete_records(config::Config, records=[]; arm::Int=0)
```

Delete one or more records from project.

**Parameters:**

  * `config` - struct containing the url and api-key
  * `records` - array of record names to delete
  * `arm` - number of arm containing records

**Returns:**

number of records successfully deleted
