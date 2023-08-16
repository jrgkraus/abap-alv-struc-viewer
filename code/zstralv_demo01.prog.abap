*&---------------------------------------------------------------------*
*& Report zstralv_demo01
*&---------------------------------------------------------------------*
*& Demo for display values of a structure in an ALV table
*& where one line is shown for each component
*&---------------------------------------------------------------------*
report zstralv_demo01.

data okcode type syucomm.
tables zst_stralv_demo.

class application definition.
  public section.
    methods pbo.

  private section.
    data screen_data type zst_stralv_demo.
    data stralv type ref to zif_stralv_main.

    methods create_a_container
      returning
        value(result) type ref to cl_gui_custom_container.

    methods get_settings
      returning
        value(result) type zcl_stralv_settings=>self
      raising
        zcx_stralv_error.
endclass.

class application implementation.

  method pbo.
    if stralv is not bound.
      screen_data = zst_stralv_demo.
      try.
          stralv = zcl_stralv_main=>new( get_settings( ) ).
          stralv->display( ).
        catch zcx_stralv_error into data(e).
          message e type 'I' display like 'E'.
      endtry.
    endif.
  endmethod.

  method get_settings.
    " set_container and set_data are obligatory
    " furthermore, we set the control to display only
    result = new zcl_stralv_settings(
            )->set_container( create_a_container( )
            )->set_data( ref #( screen_data )
            )->set_readonly( ).

  endmethod.

  method create_a_container.
    result  = new cl_gui_custom_container( 'VIEWPORT' ).
  endmethod.


endclass.

data app type ref to application.

start-of-selection.
  zst_stralv_demo =
    value #(
      long_text = 'Sample data'
      menge = 1
      meins = 'ST' ).
  app = new #( ).
  call screen 1.

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
endmodule.
