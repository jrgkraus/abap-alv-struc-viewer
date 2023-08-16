*&---------------------------------------------------------------------*
*& Report zstralv_demo01
*&---------------------------------------------------------------------*
*& Demo for maintaining values of a structure in an ALV table
*& where one line is shown for each component
*&---------------------------------------------------------------------*
report zstralv_demo03.

data okcode type syucomm.
tables zst_stralv_demo.

class application definition.
  public section.
    methods pbo.
    methods reset_field_attributes
      importing
        command type sy-ucomm.

  private section.
    data screen_data type zst_stralv_demo.
    data stralv type ref to zif_stralv_main.
    " Flags for toggling field attributes:
    data hotspot type abap_bool value abap_true.
    data readonly type abap_bool value abap_true.
    data color type abap_bool.

    methods create_a_container
      returning
        value(result) type ref to cl_gui_custom_container.

    methods get_settings
      returning
        value(result) type zcl_stralv_settings=>self
      raising
        zcx_stralv_error.

    methods on_data_changed
        for event data_has_changed of zif_stralv_main.

    methods on_hotspot_clicked
        for event link_clicked of zif_stralv_main.
endclass.

class application implementation.

  method pbo.

    if stralv is not bound.
      try.
          screen_data = zst_stralv_demo.
          stralv = zcl_stralv_main=>new( get_settings( ) ).
          set handler on_data_changed for stralv.
          set handler on_hotspot_clicked for stralv.
          stralv->display( ).
        catch zcx_stralv_error into data(e).
          message e type 'I' display like 'E'.
      endtry.
    endif.
  endmethod.

  method get_settings.
    " set_container and set_data are obligatory
    result = new zcl_stralv_settings(
            )->set_container( create_a_container( )
            )->set_data( ref #( screen_data ) ).
    " set initial attributes of field LONG_TEXT
    result->field( 'LONG_TEXT' )->set_readonly( )->set_hotspot( )->set_color( value #( col = col_total ) ).

  endmethod.

  method create_a_container.
    result  = new cl_gui_custom_container( 'VIEWPORT' ).
  endmethod.

  method on_data_changed.
    " pass control data to the classic dynpro
    zst_stralv_demo = screen_data.
    " provocate a pai - pbo turn to refresh the screen
    cl_gui_cfw=>set_new_ok_code( 'ENTER' ).
  endmethod.


  method reset_field_attributes.
    " Dynamically change field settings
    try.
        case okcode.
          when 'RDONLY'.
            " toggle readonly flag
            readonly = xsdbool( readonly = abap_false ).
            stralv->field( 'LONG_TEXT' )->set_readonly( readonly ).
            stralv->refresh( ).
          when 'HOTSPOT'.
            hotspot = xsdbool( hotspot = abap_false ).
            stralv->field( 'LONG_TEXT' )->set_hotspot( hotspot ).
            stralv->refresh( ).
          when 'COLOR'.
            color = xsdbool( color = abap_false ).
            if color = abap_true.
              stralv->field( 'LONG_TEXT' )->set_color( value #( ) ).
            else.
              stralv->field( 'LONG_TEXT' )->set_color( value #( col = col_total ) ).
            endif.
            stralv->refresh( ).
        endcase.
      catch zcx_stralv_error.
    endtry.
  endmethod.

  method on_hotspot_clicked.
    message 'Link has been clicked' type 'I'.
  endmethod.

endclass.

data app type ref to application.

start-of-selection.
  zst_stralv_demo = value #( long_text = 'Sample data'
                             yesno = abap_true ).
  app = new #( ).
  call screen 2.

*&---------------------------------------------------------------------*
*&      Module  STATUS_0001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module status_0001 output.
  set pf-status '1'.
  set titlebar '1'.
  app->pbo( ).
endmodule.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_0001 input.
  if okcode = 'EXIT'.
    set screen 0.
  endif.
  app->reset_field_attributes( okcode ).
endmodule.
