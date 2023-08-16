define _get_structure_ref.
    field-symbols <all>         type any.
    assign screendata->* to <all>.
end-of-definition.

define _get_field_ref.
  field-symbols <value> type any.
  assign component &1-ddic-fieldname of structure <all> to <value>.
  if sy-subrc <> 0.
    return.
  endif.
end-of-definition.
