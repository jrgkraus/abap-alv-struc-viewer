class zcl_stralv_fields definition
  public
  final
  create public .

  public section.
    methods constructor
      importing
        data_ref type ref to data.
    methods get_field
      importing
        name          type lvc_fname
      returning
        value(result) type ref to zcl_stralv_field
      raising zcx_stralv_unknown_field.

    methods is_description_field
      importing
        name          type lvc_fname
      returning
        value(result) type abap_bool.

  protected section.
  private section.
    data field_objects type types=>field_objects.
    data data_ref type ref to data.

    methods add_field
      importing
        name          type lvc_fname
      returning
        value(result) type ref to zcl_stralv_field
      raising
        zcx_stralv_unknown_field.
endclass.



class zcl_stralv_fields implementation.

  method constructor.
    me->data_ref = data_ref.
  endmethod.

  method get_field.
    try.
        result = field_objects[ name = name ]-object.
      catch cx_sy_itab_line_not_found.
        result = add_field( name ).
    endtry.

  endmethod.

  method add_field.
    field-symbols <f> type any.
    field-symbols <s> type any.
    " check if field is present
    assign data_ref->* to <s>.
    assign component name of structure <s> to <f>.
    if sy-subrc <> 0.
      raise exception type zcx_stralv_unknown_field
        exporting
          name = name.
    endif.
    result = new #( name ).
    insert value #( name = name object = result )
        into table field_objects.
  endmethod.


  method is_description_field.
    loop at field_objects into data(line).
      data(attr) = line-object->get_attributes( ).
      if attr-description_field = name.
        result = abap_true.
        return.
      endif.
    endloop.
  endmethod.

endclass.
