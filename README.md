# abap-alv-struc-viewer
ABAP: View and edit fields of a structure in an ALV control

This tool generates a table view using ALV out of a DDIC structure. It can be used in control-driven SAPGUI front ends for a replacement of classic dynpro fields.

It includes the following features:
* Automatic search help: Just as in a dynpro field, search help is provided from definitions in the DDIC structure field
* Input validation: all inputs are checked for syntax and data validity using the check tables
* Output format: data entered will be formatted as defined for the data type (respecting conversion exits)
* Display attributes: hotspot, colors, check box and more can be used on selected fields
* Value description: If a description can be found usign a text table, it can be shown besides the value
* Special value description: When no text table is available, you can also choose a field from the check table to be shown (for instance the name of the customer from KNA1)

To learn more about the usage, explore the demo reports.

## 2023-08-17 added toolbar support
