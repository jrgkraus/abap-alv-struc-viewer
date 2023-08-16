*&---------------------------------------------------------------------*
*& Report zstralv_demo04
*&---------------------------------------------------------------------*
*& Demo for maintaining values of a structure in an ALV table
*& where one line is shown for each component
*& Demo case: usage of the description column
*&---------------------------------------------------------------------*
report zstralv_demo04.

data okcode type syucomm.
tables zst_stralv_demo.

class application definition.
  public section.
    methods pbo.


  private section.
    data screen_data type zst_stralv_demo.
    data stralv type ref to zif_stralv_main.
    data hotspot type abap_bool value abap_true.
    data readonly type abap_bool value abap_true.

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
endclass.

class application implementation.

  method pbo.
    if stralv is not bound.
      try.
          " screen_data is referenced by the ALV control.
          screen_data = zst_stralv_demo.
          stralv = zcl_stralv_main=>new( get_settings( ) ).
          " Here we react on an input
          set handler on_data_changed for stralv.
          stralv->display( ).
        catch zcx_stralv_error into data(e).
          message e type 'I' display like 'E'.
      endtry.
    endif.
  endmethod.

  method get_settings.
    " set_container and set_data are obligatory
    " furthermore, we hide the client
    result = new zcl_stralv_settings(
            )->set_container( create_a_container( )
            )->set_data( ref #( screen_data )
            )->set_description_width( 30 ).
    " set source for description field for WERKS
    result->field( 'WERKS' )->set_description_field( 'NAME1' ).

  endmethod.

  method create_a_container.
    result  = new cl_gui_custom_container( 'VIEWPORT' ).
  endmethod.

  method on_data_changed.
    " pass data from the control to the classic dynpro
    zst_stralv_demo = screen_data.
    " provocate a pai - pbo turn to refresh the screen
    cl_gui_cfw=>set_new_ok_code( 'ENTER' ).
  endmethod.

endclass.

data app type ref to application.

start-of-selection.
  " preset data to show
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
endmodule.
