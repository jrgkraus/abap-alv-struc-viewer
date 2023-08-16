class zcl_stralv_field definition
  public
  final
  create public .

  public section.
    types self type ref to zcl_stralv_field.
    methods constructor
      importing
        i_name type lvc_fname.

    methods:
      set_checkbox
        importing
          in type abap_bool default abap_true
        returning
          value(result) type self,
      set_hotspot
        importing
          in            type lvc_hotspt default abap_true
        returning
          value(result) type self,
      set_readonly
        importing
          in            type abap_bool default abap_true
        returning
          value(result) type self,
      set_description_field
        importing
          in            type lvc_fname
        returning
          value(result) type self,
      set_struc_descr_field
        importing
          in            type lvc_fname
        returning
          value(result) type self,
      set_radio_group
        importing
          in            type char3
        returning
          value(result) type self,
      set_no_display
        importing
          in            type abap_bool default abap_true
        returning
          value(result) type self,
      set_no_label
        importing
          in            type abap_bool default abap_true
        returning
          value(result) type self,
      set_f4_exit
        importing
          in            type abap_bool default abap_true
        returning
          value(result) type self,
      set_color
        importing
          in            type lvc_s_colo
        returning
          value(result) type self,
      get_attributes
        returning
          value(result) type zcl_stralv_types=>field_attr.

  protected section.
  private section.
    data attributes type types=>field_attr.
ENDCLASS.



CLASS ZCL_STRALV_FIELD IMPLEMENTATION.


  method constructor.
    attributes-fieldname = i_name.
  endmethod.


  method get_attributes.
    result = me->attributes.
  endmethod.


  method set_checkbox.
    attributes-checkbox = in.
    result = me.
  endmethod.


  method set_color.
    attributes-color = in.
    result = me.
  endmethod.


  method set_description_field.
    attributes-description_field = in.
    result = me.
  endmethod.


  method set_f4_exit.
    attributes-f4_exit = in.
    result = me.
  endmethod.


  method set_hotspot.
    attributes-hotspot = in.
    result = me.
  endmethod.


  method set_no_display.
    attributes-no_display = in.
    result = me.
  endmethod.


  method set_no_label.
    attributes-no_label = in.
    result = me.
  endmethod.


  method set_radio_group.
    attributes-radio_group = in.
    result = me.
  endmethod.


  method set_readonly.
    attributes-readonly = in.
    result = me.
  endmethod.


  method set_struc_descr_field.
    attributes-struc_descr_field = in.
    result = me.
  endmethod.
ENDCLASS.
