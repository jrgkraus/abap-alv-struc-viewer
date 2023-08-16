class zcl_stralv_types definition
  public
  abstract
  create public .

  public section.
    types:
      begin of field_attr,
        fieldname         type lvc_fname,
        checkbox          type abap_bool,
        hotspot           type lvc_hotspt,
        readonly          type abap_bool,
        description_field type lvc_fname,
        struc_descr_field type lvc_fname,
        radio_group       type char3,
        no_display        type abap_bool,
        no_label          type abap_bool,
        f4_exit           type abap_bool,
        color             type lvc_s_colo,
      end of field_attr,
      field_attributes type standard table of field_attr with empty key.


    types alv_table_lines type standard table of zst_stralv_tab_line with default key.

    types:
      begin of field_object,
        name   type lvc_fname,
        object type ref to zcl_stralv_field,
      end of field_object,
      field_objects type standard table of field_object with empty key.

    types label type c length 128.
    types structure_fields type standard table of dd03p with default key.

    types:
      begin of units,
        qty_unit type meinh,
        currency type waers,
      end of units.

    types:
      begin of field,
        ddic      type dd03p,
        attribute type field_attr,
        units     type units,
        value     type string,
      end of field.

    types:
      begin of foreign_key_result,
        failures   type standard table of ddfkeyrc with default key,
        conditions type standard table of ddwherecnd with empty key,
      end of foreign_key_result.

    types search_help_return type standard table of ddshretval with default key.
  protected section.
  private section.
endclass.



class zcl_stralv_types implementation.
endclass.
