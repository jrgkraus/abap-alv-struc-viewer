class zcl_stralv_main definition
  public
  inheriting from cl_gui_alv_grid
  final
  create private .

  public section.
    interfaces zif_stralv_main.

    class-methods new
      importing
        settings      type ref to zcl_stralv_settings
      returning
        value(result) type ref to zif_stralv_main
      raising
        zcx_stralv_error.

    methods constructor
      importing
        structure_name         type ddobjname
        container              type ref to cl_gui_container
        max_value_length       type i
        readonly               type flag
        max_description_length type i
        fields                 type ref to zcl_stralv_fields
        use_long_labels        type abap_bool
        use_medium_labels      type abap_bool
        use_short_labels       type abap_bool
      raising
        zcx_stralv_error .
  protected section.
  private section.
    data output_table type ref to zcl_stralv_output_table.
    data cols_optimized type abap_bool .
    data gv_title type lvc_title .
    data small_title type abap_bool.

    methods on_refresh
        for event refresh of zcl_stralv_output_table.

    methods on_hotspot_clicked
        for event hotspot_click of zcl_stralv_main
      importing
        !es_row_no .

    methods on_f4
        for event onf4 of zcl_stralv_main
      importing
        !es_row_no
        !er_event_data .

    methods on_internal_double_click
        for event double_click of zcl_stralv_main
      importing
        !es_row_no .

    methods on_after_refresh
        for event after_refresh of zcl_stralv_main .

    methods on_internal_data_changed
        for event data_changed of zcl_stralv_main
      importing
        !er_data_changed.

    methods on_data_changed_late
        for event data_changed_finished of cl_gui_alv_grid
      importing
        !e_modified
        !et_good_cells .

    methods build_toolbar_exclude
      returning
        value(result) type ui_functions .

    methods on_data_changed
        for event data_has_changed of zcl_stralv_output_table.

    methods on_enter_pressed
        for event enter_pressed of zcl_stralv_output_table.

    methods on_toolbar
        for event toolbar of zcl_stralv_main
        importing sender
                  e_object
                  e_interactive.

    methods on_user_command
        for event user_command of zcl_stralv_main
        importing sender
                  e_ucomm.


    methods put_log_dch
      importing
        io_data_changed type ref to cl_alv_changed_data_protocol
        exception       type ref to zcx_stralv_input_error.

    methods build_layout
      importing
        iv_optimized     type abap_bool
      returning
        value(rs_layout) type lvc_s_layo.
endclass.



class zcl_stralv_main implementation.


  method constructor.
    super->constructor( container ).

    output_table = new #( structure_name ).

    set handler on_data_changed for output_table.
    set handler on_enter_pressed for output_table.
    set handler on_refresh for output_table.

    register_f4_for_fields(
      value #(
        ( fieldname = constants=>fieldname-value
          getbefore = abap_true
          register = abap_true
          chngeafter = abap_true ) ) ).
    me->register_edit_event( mc_evt_enter ).

    set handler on_internal_data_changed for me.
    set handler on_data_changed_late for me.
    set handler on_after_refresh for me.
    set handler on_internal_double_click for me.
    set handler on_hotspot_clicked for me.
    set handler on_f4 for me.
    set handler on_toolbar for me.
    set handler on_user_command for me.


    output_table->set_label_length(
        long = use_long_labels
        medium = use_medium_labels
        short = use_short_labels
      )->set_fields( fields
      )->set_readonly( readonly
      )->set_value_length( max_value_length
      )->set_descr_length( max_description_length
      )->build_fieldcatalog(
      )->create_input_table( ).
  endmethod.


  method on_after_refresh.
*     mt_data = output_table->set_style( mt_data ).
****************
*    set_data_table(
*      changing
*        data_table = mt_data ).
*    call method set_auto_redraw
*      exporting
*        enable = 1.

  endmethod.


  method build_toolbar_exclude.
    result =
      value #(
        ( cl_gui_alv_grid=>mc_fc_auf )
        ( cl_gui_alv_grid=>mc_fc_average )
        ( cl_gui_alv_grid=>mc_fc_back_classic )
        ( cl_gui_alv_grid=>mc_fc_call_abc )
        ( cl_gui_alv_grid=>mc_fc_call_chain )
        ( cl_gui_alv_grid=>mc_fc_call_crbatch )
        ( cl_gui_alv_grid=>mc_fc_call_crweb )
        ( cl_gui_alv_grid=>mc_fc_call_lineitems )
        ( cl_gui_alv_grid=>mc_fc_call_master_data )
        ( cl_gui_alv_grid=>mc_fc_call_more )
        ( cl_gui_alv_grid=>mc_fc_call_report )
        ( cl_gui_alv_grid=>mc_fc_call_xint )
        ( cl_gui_alv_grid=>mc_fc_call_xxl )
        ( cl_gui_alv_grid=>mc_fc_check )
        ( cl_gui_alv_grid=>mc_fc_col_invisible )
        ( cl_gui_alv_grid=>mc_fc_col_optimize )
        ( cl_gui_alv_grid=>mc_fc_count )
        ( cl_gui_alv_grid=>mc_fc_current_variant )
        ( cl_gui_alv_grid=>mc_fc_data_save )
        ( cl_gui_alv_grid=>mc_fc_delete_filter )
        ( cl_gui_alv_grid=>mc_fc_deselect_all )
        ( cl_gui_alv_grid=>mc_fc_detail )
        ( cl_gui_alv_grid=>mc_fc_excl_all )
        ( cl_gui_alv_grid=>mc_fc_expcrdata )
        ( cl_gui_alv_grid=>mc_fc_expcrdesig )
        ( cl_gui_alv_grid=>mc_fc_expcrtempl )
        ( cl_gui_alv_grid=>mc_fc_expmdb )
        ( cl_gui_alv_grid=>mc_fc_extend )
        ( cl_gui_alv_grid=>mc_fc_f4 )
        ( cl_gui_alv_grid=>mc_fc_filter )
        ( cl_gui_alv_grid=>mc_fc_find )
        ( cl_gui_alv_grid=>mc_fc_fix_columns )
        ( cl_gui_alv_grid=>mc_fc_graph )
        ( cl_gui_alv_grid=>mc_fc_help )
        ( cl_gui_alv_grid=>mc_fc_html )
        ( cl_gui_alv_grid=>mc_fc_info )
        ( cl_gui_alv_grid=>mc_fc_load_variant )
        ( cl_gui_alv_grid=>mc_fc_loc_append_row )
        ( cl_gui_alv_grid=>mc_fc_loc_copy )
        ( cl_gui_alv_grid=>mc_fc_loc_copy_row )
        ( cl_gui_alv_grid=>mc_fc_loc_cut )
        ( cl_gui_alv_grid=>mc_fc_loc_delete_row )
        ( cl_gui_alv_grid=>mc_fc_loc_insert_row )
        ( cl_gui_alv_grid=>mc_fc_loc_move_row )
        ( cl_gui_alv_grid=>mc_fc_loc_paste )
        ( cl_gui_alv_grid=>mc_fc_loc_paste_new_row )
        ( cl_gui_alv_grid=>mc_fc_loc_undo )
        ( cl_gui_alv_grid=>mc_fc_maintain_variant )
        ( cl_gui_alv_grid=>mc_fc_maximum )
        ( cl_gui_alv_grid=>mc_fc_minimum )
        ( cl_gui_alv_grid=>mc_fc_pc_file )
        ( cl_gui_alv_grid=>mc_fc_print )
        ( cl_gui_alv_grid=>mc_fc_print_back )
        ( cl_gui_alv_grid=>mc_fc_print_prev )
        ( cl_gui_alv_grid=>mc_fc_refresh )
        ( cl_gui_alv_grid=>mc_fc_reprep )
        ( cl_gui_alv_grid=>mc_fc_save_variant )
        ( cl_gui_alv_grid=>mc_fc_select_all )
        ( cl_gui_alv_grid=>mc_fc_send )
        ( cl_gui_alv_grid=>mc_fc_separator )
        ( cl_gui_alv_grid=>mc_fc_sort )
        ( cl_gui_alv_grid=>mc_fc_sort_asc )
        ( cl_gui_alv_grid=>mc_fc_sort_dsc )
        ( cl_gui_alv_grid=>mc_fc_subtot )
        ( cl_gui_alv_grid=>mc_fc_sum )
        ( cl_gui_alv_grid=>mc_fc_to_office )
        ( cl_gui_alv_grid=>mc_fc_to_rep_tree )
        ( cl_gui_alv_grid=>mc_fc_unfix_columns )
        ( cl_gui_alv_grid=>mc_fc_url_copy_to_clipboard )
        ( cl_gui_alv_grid=>mc_fc_variant_admin )
        ( cl_gui_alv_grid=>mc_fc_views )
        ( cl_gui_alv_grid=>mc_fc_view_crystal )
        ( cl_gui_alv_grid=>mc_fc_view_excel )
        ( cl_gui_alv_grid=>mc_fc_view_grid )
        ( cl_gui_alv_grid=>mc_fc_view_lotus )
        ( cl_gui_alv_grid=>mc_fc_word_processor ) ).


  endmethod.



  method on_internal_data_changed.
    try.
        output_table->process_data_changed( er_data_changed ).
      catch zcx_stralv_input_error into data(e).
        put_log_dch(
            io_data_changed = er_data_changed
            exception = e ).
        er_data_changed->display_protocol( ).
    endtry.
  endmethod.

  method put_log_dch.
    data(message) = exception->if_t100_message~t100key.

    io_data_changed->add_protocol_entry(
        i_msgid     = message-msgid
        i_msgty     = 'E'
        i_msgno     = message-msgno
        i_msgv1     = exception->if_t100_dyn_msg~msgv1
        i_msgv2     = exception->if_t100_dyn_msg~msgv2
        i_msgv3     = exception->if_t100_dyn_msg~msgv3
        i_msgv4     = exception->if_t100_dyn_msg~msgv4
        i_fieldname = 'FIELDVALUE'
        i_row_id    = exception->cell-row_id ).
  endmethod.

  method on_data_changed.
    raise event zif_stralv_main~data_has_changed.
    clear m_eventid.
  endmethod.

  method on_enter_pressed.
    if m_eventid = evt_enter.
      cl_gui_control=>get_focus(
        importing
          control           = data(control)
        exceptions
          cntl_error        = 1
          cntl_system_error = 2
          others            = 3 ).
      if  sy-subrc = 0 and
          control = me.
        raise event zif_stralv_main~enter_pressed.
      endif.
    endif.
  endmethod.

  method on_data_changed_late.
    output_table->process_data_changed_late( e_modified ).
  endmethod.



  method zif_stralv_main~display.

    cols_optimized = iv_optimized.

    output_table->create_input_table(
      )->map_struc_to_screen( abap_false ).

    set_table_for_first_display(
       exporting
         is_layout                     = build_layout( iv_optimized )
         it_toolbar_excluding          = build_toolbar_exclude( )
      changing
        it_outtab                     = output_table->inputs
        it_fieldcatalog               = output_table->fieldcat
      exceptions
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3 ).
    case sy-subrc.
      when 1.
        raise exception type zcx_stralv_invalid_para.
      when 2.
        raise exception type zcx_stralv_program_error.
      when 3.
        raise exception type zcx_stralv_too_many_lines.
    endcase.
  endmethod.

  method build_layout.

    rs_layout =
          value #(
            stylefname = constants=>fieldname-t_styles
            no_headers = abap_true
            sel_mode = 'A'
            no_rowins = abap_true
            no_rowmark = abap_true
            grid_title = gv_title
            smalltitle = small_title
            ctab_fname = constants=>fieldname-t_colors
            cwidth_opt = iv_optimized ).

  endmethod.

  method on_internal_double_click.
    _get_structure_ref.
    try.
        data(input) = output_table->inputs[ es_row_no-row_id ].
        _get_field_ref input.
        if sy-subrc = 0.
          raise event zif_stralv_main~double_clicked exporting
            ev_fieldname = input-ref_field
            ev_value = <value>.
        endif.
      catch cx_sy_itab_line_not_found ##no_handler.
    endtry.
  endmethod.


  method on_f4.
    output_table->process_f4(
        row   = es_row_no-row_id
        event = er_event_data ).
  endmethod.



  method zif_stralv_main~get_data.
    rr_res = output_table->screendata.
  endmethod.


  method zif_stralv_main~get_display_tab.
    rt_res = output_table->inputs.
  endmethod.

  method zif_stralv_main~get_label.
    rv_res = output_table->inputs[ ref_field = iv_fieldname ]-fieldlabel.
    "strip icon, if present
    if rv_res(1) = '@'.
      rv_res = condense( segment( val = rv_res index = 3 sep = '@' ) ).
    endif.
  endmethod.


  method zif_stralv_main~get_read_only.
    rv_res = output_table->is_readonly( ).
  endmethod.


  method on_hotspot_clicked.
    data(field) = output_table->process_hotspot_click(
                    row = es_row_no-row_id ).

    if field is not initial.
      raise event zif_stralv_main~link_clicked exporting
        ev_fieldname = field-ddic-fieldname
        ev_value = field-value.
    endif.
  endmethod.



  method zif_stralv_main~refresh.
    output_table->create_input_table( ).
    output_table->map_struc_to_screen( ).
    refresh_table_display( ).
  endmethod.


  method on_refresh.
    if cols_optimized = abap_true.

      get_frontend_layout(
        importing
          es_layout = data(ls_layo) ).

      ls_layo-cwidth_opt = abap_true.

      set_frontend_layout( ls_layo ).
    endif.
    refresh_table_display(
       is_stable      = value #( row = abap_true col = abap_true )
       i_soft_refresh = abap_true ).
  endmethod.


  method zif_stralv_main~set_data_by_ref.
    output_table->set_data( data ).
  endmethod.


  method zif_stralv_main~set_display_tab.
    output_table->inputs = it_in.
  endmethod.



  method zif_stralv_main~set_label.
    output_table->inputs[ ref_field = iv_fieldname ]-fieldlabel = iv_label.
  endmethod.


  method zif_stralv_main~set_readonly.
    output_table->set_readonly( iv_readonly ).

    zif_stralv_main~display( ).
  endmethod.




  method zif_stralv_main~set_title.
    gv_title = iv_title.
    small_title = small.
  endmethod.

  method new.
    result =
      new zcl_stralv_main(
            structure_name         = settings->structure_name
            container              = settings->container
            max_value_length       = settings->value_width
            readonly               = settings->readonly
            max_description_length = settings->max_description_length
            fields                 = settings->fields
            use_long_labels        = settings->use_long_labels
            use_medium_labels      = settings->use_medium_labels
            use_short_labels       = settings->use_short_labels ).

    result->set_data_by_ref( settings->data_ref ).
  endmethod.

  method zif_stralv_main~field.
    result = output_table->fields->get_field( in ).
  endmethod.

  method on_toolbar.
    raise event zif_stralv_main~toolbar
      exporting
        e_object = e_object
        e_interactive = e_interactive.
  endmethod.

  method on_user_command.
    raise event zif_stralv_main~user_command
      exporting
        e_ucomm = e_ucomm.

  endmethod.

endclass.
