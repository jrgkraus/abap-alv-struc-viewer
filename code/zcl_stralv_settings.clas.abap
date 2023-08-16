class zcl_stralv_settings definition
  public
  final
  create public .

  public section.
    types self type ref to zcl_stralv_settings.
    data:
      structure_name         type ddobjname,
      container              type ref to cl_gui_container,
      value_width            type i,
      readonly               type flag,
      max_description_length type i,
      use_long_labels        type abap_bool,
      use_medium_labels      type abap_bool,
      use_short_labels       type abap_bool,
      data_ref               type ref to data,
      fields          type ref to zcl_stralv_fields.
    methods:
      constructor,

      field
        importing
          name          type lvc_fname
        returning
          value(result) type ref to zcl_stralv_field
        RAISING
          zcx_stralv_error,

      set_data
        importing
          in            type ref to data
        returning
          value(result) type self,

      set_container
        importing
          in            type ref to cl_gui_container
        returning
          value(result) type self,

      set_value_width
        importing
          in            type i
        returning
          value(result) type self,

      set_readonly
        importing
          in            type abap_bool default abap_true
        returning
          value(result) type self,

      set_description_width
        importing
          in            type i
        returning
          value(result) type self,

      set_use_long_labels
        importing
          in            type abap_bool
        returning
          value(result) type self,

      set_use_medium_labels
        importing
          in            type abap_bool
        returning
          value(result) type self,

      set_use_short_labels
        importing
          in            type abap_bool
        returning
          value(result) type self.
  protected section.
  private section.
endclass.



class zcl_stralv_settings implementation.

  method constructor.
    value_width = 20.
  endmethod.

  method set_data.
    structure_name = cl_abap_typedescr=>describe_by_data_ref( in )->get_relative_name( ).
    data_ref = in.
    fields = new #( in ).
    result = me.
  endmethod.

  method set_container.
    me->container = in.
    result = me.
  endmethod.

  method set_value_width.
    me->value_width = in.
    result = me.
  endmethod.

  method set_readonly.
    me->readonly = in.
    result = me.
  endmethod.

  method set_description_width.
    me->max_description_length = in.
    result = me.
  endmethod.

  method set_use_long_labels.
    me->use_long_labels = in.
    result = me.
  endmethod.

  method set_use_medium_labels.
    me->use_medium_labels = in.
    result = me.
  endmethod.

  method set_use_short_labels.
    me->use_short_labels = in.
    result = me.
  endmethod.


  method field.
    if fields is not bound.
      raise exception type zcx_stralv_not_initialized.
    endif.
    result = fields->get_field( name ).
  endmethod.



endclass.
