define _get_structure_ref.
    field-symbols <all>         type any.
    assign output_table->screendata->* to <all>.
end-of-definition.

define _get_field_ref.
  field-symbols <value> type any.
  assign component &1-ref_field of structure <all> to <value>.
end-of-definition.
