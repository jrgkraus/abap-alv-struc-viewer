interface zif_stralv_main
  public .
*"* public components of class ZCL_DV01_ALV
*"* do not include other source files here!!!
  events enter_pressed .

  events data_has_changed .

  events link_clicked
    exporting
      value(ev_fieldname) type lvc_fname
      value(ev_value) type any .

  events double_clicked
    exporting
      value(ev_fieldname) type lvc_fname
      value(ev_value) type any .

  methods field
    importing
      in            type lvc_fname
    returning
      value(result) type ref to zcl_stralv_field
    raising
      zcx_stralv_error.

  methods set_display_tab
    importing
      it_in type zcl_stralv_types=>alv_table_lines .

  methods set_title
    importing
      iv_title type c
      small    type abap_bool default abap_true.

  methods set_data_by_ref
    importing
      data type ref to data .

  methods refresh
    raising
      zcx_stralv_data_create .

  methods set_label
    importing
      iv_fieldname type lvc_fname
      iv_label     type zcl_stralv_types=>label .

  methods set_readonly
    importing
      iv_readonly type abap_bool
    raising
      zcx_stralv_error .

  methods get_read_only
    returning
      value(rv_res) type abap_bool .

  methods get_label
    importing
      iv_fieldname  type lvc_fname
    returning
      value(rv_res) type zcl_stralv_types=>label.

  methods get_display_tab
    returning
      value(rt_res) type zcl_stralv_types=>alv_table_lines .

  methods display
    importing
      iv_optimized type abap_bool optional
    raising
      zcx_stralv_error .

  methods get_data
    returning
      value(rr_res) type ref to data .

endinterface.
