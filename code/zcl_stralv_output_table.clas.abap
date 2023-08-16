class zcl_stralv_output_table definition
  public
  final
  create public .

  public section.
    types self type ref to zcl_stralv_output_table.
    data fieldcat type lvc_t_fcat.
    data inputs type zcl_stralv_types=>alv_table_lines.
    data screendata type ref to data read-only.
    data fields type ref to zcl_stralv_fields read-only.

    events data_has_changed.

    events enter_pressed.

    events refresh.

    methods constructor
      importing
        struc_name type ddobjname
      raising
        zcx_stralv_error.

    methods set_label_length
      importing
        long          type abap_bool
        medium        type abap_bool
        short         type abap_bool
      returning
        value(result) type self.

    methods set_value_length
      importing
        in            type i
      returning
        value(result) type self.

    methods set_descr_length
      importing
        in            type i
      returning
        value(result) type self.



    methods process_data_changed
      importing
        er_data_changed type ref to cl_alv_changed_data_protocol
      raising
        zcx_stralv_input_error.

    methods process_data_changed_late
      importing
        e_modified type char01.

    methods map_struc_to_screen
      importing
        iv_refresh type abap_bool default abap_true .

    methods is_readonly
      returning
        value(result) type abap_bool.
    methods create_input_table
      returning
        value(result) type self
      raising
        zcx_stralv_data_create.

    methods set_fields
      importing
        in            type ref to zcl_stralv_fields
      returning
        value(result) type self
      raising
        zcx_stralv_data_create.



    methods set_data
      importing
        in type ref to data.

    methods set_readonly
      importing
        in            type abap_bool
      returning
        value(result) type self
      raising
        zcx_stralv_error.

    methods build_fieldcatalog
      returning
        value(result) type self
      raising
        zcx_stralv_data_create.



    methods process_hotspot_click
      importing
        row           type i
      returning
        value(result) type zcl_stralv_types=>field.

    methods process_f4
      importing
        row   type i
        event type ref to cl_alv_event_data.

  protected section.
  private section.
    data readonly type flag .
    data long_descr type abap_bool value abap_true.
    data medium_descr type abap_bool .
    data short_descr type abap_bool .
    data max_outputlen type i .
    data max_outputlen_d type i .
    data structure_name type ddobjname .
    data structure_fields type standard table of dd03p.

    methods analyze_foreign_key
      importing
        field         type types=>field
      returning
        value(result) type types=>foreign_key_result.

    methods read_structure_fields
      returning
        value(result) type types=>structure_fields
      raising
        zcx_stralv_data_create.

    methods set_field_styles
      importing
        field         type types=>field
      returning
        value(result) type lvc_t_styl.

    methods get_field_units
      importing
        is_field      type dd03p
      returning
        value(result) type types=>units.

    methods convert_input
      importing
        field type types=>field
        cell  type lvc_s_modi
      raising
        zcx_stralv_input_error.

    methods check_input
      importing
        field type types=>field
        cell  type lvc_s_modi
      raising
        zcx_stralv_input_error.

    methods convert_output
      importing
        field         type types=>field
        value         type any
      returning
        value(result) type text128 .

    methods description_fill
      importing
        field         type types=>field
      returning
        value(result) type text128.

    methods fill_description_special
      importing
        field         type types=>field
      returning
        value(result) type text128 .

    methods fill_description_from_field
      importing
        field         type types=>field
      returning
        value(result) type text128 .

    methods read_fieldcatalog
      returning
        value(result) type lvc_t_fcat
      raising
        zcx_stralv_data_create.

    methods create_input_table_low
      importing
        old_inputs    type types=>alv_table_lines
      returning
        value(result) type types=>alv_table_lines.

    methods get_fieldlabel
      importing
        field         type zcl_stralv_types=>field
      returning
        value(result) type string.

    methods has_search_help
      importing
        field         type types=>field
      returning
        value(result) type abap_bool.

    methods has_dom_values
      importing
        field         type types=>field
      returning
        value(result) type abap_bool.
    methods set_field_colors
      importing
        field         type types=>field
      returning
        value(result) type lvc_t_scol.

    methods add_checkboxes
      importing
        in            type ref to zcl_stralv_fields
      returning
        value(result) type ref to zcl_stralv_fields.

    methods refresh_input_table.

    methods re_build_fieldcatalog
      raising
        zcx_stralv_data_create.

    methods map_struc_field_to_line
      importing
        line          type zst_stralv_tab_line
      returning
        value(result) type zst_stralv_tab_line.



    methods build_field
      importing
        line          type zst_stralv_tab_line
      returning
        value(result) type zcl_stralv_types=>field.

    methods read_from_checktable
      importing
        field         type types=>field
        sel_lines     type string_table
      returning
        value(result) type text128.

    methods show_search_help
      importing
        field         type zcl_stralv_types=>field
      returning
        value(result) type types=>search_help_return.

    methods use_selected_field
      importing
        i_row     type i
        i_event   type ref to cl_alv_event_data
        it_return type types=>search_help_return.
    methods get_field_attribute
      importing
        name          type dd03p-fieldname
      returning
        value(result) type zcl_stralv_types=>field_attr.



endclass.



class zcl_stralv_output_table implementation.


  method add_checkboxes.
    result = in.
    try.
        loop at structure_fields into data(f) where domname = 'XFELD'.
          result->get_field( f-fieldname )->set_checkbox( ).
        endloop.
      catch zcx_stralv_error ##no_handler.
    endtry.
  endmethod.


  method analyze_foreign_key.

    _get_structure_ref.

    call function 'DDUT_FORKEY_CHECK'
      exporting
        tabname     = field-ddic-tabname
        fieldname   = field-ddic-fieldname
        value_list  = <all>
      tables
        cond_tab    = result-conditions
        failure_tab = result-failures.

  endmethod.


  method build_field.
    result =
      value #(
        let struc = structure_fields[ fieldname = line-ref_field ] in
        ddic = struc
        attribute = get_field_attribute( line-ref_field )
        units = get_field_units( struc )
        value = line-fieldvalue ).
  endmethod.


  method build_fieldcatalog.
    fieldcat = read_fieldcatalog( ).
    data(ref) = ref #( fieldcat[ fieldname = constants=>fieldname-label ] ).
    ref->outputlen = constants=>metrics-output_length.
    ref->key = abap_true.
    ref->edit = abap_false.

    ref = ref #( fieldcat[ fieldname = constants=>fieldname-value ] ).
    ref->outputlen = max_outputlen.
    ref->edit = xsdbool( readonly = abap_false ).
    ref->key = abap_true.

    ref = ref #( fieldcat[ fieldname = 'FIELDDESCR' ] ).
    if max_outputlen_d > 0.
      ref->outputlen = max_outputlen_d.
      ref->edit = abap_false.
    else.
      ref->tech = abap_true.
    endif.
    fieldcat[ fieldname = 'REF_FIELD' ]-tech = abap_true.
    fieldcat[ fieldname = 'REF_TABLE' ]-tech = abap_true.
    fieldcat[ fieldname = 'MAXLEN' ]-tech = abap_true.

    result = me.
  endmethod.


  method check_input.
    _get_structure_ref.
    _get_field_ref field.
    data(lv_fn) = conv fnam_____4( field-ddic-fieldname ).
    call function 'DDUT_INPUT_CHECK'
      exporting
        tabname        = field-ddic-tabname
        fieldname      = lv_fn
        value_list     = <all>
        value          = <value>
      importing
        msgid          = sy-msgid
        msgty          = sy-msgty
        msgno          = sy-msgno
        msgv1          = sy-msgv1
        msgv2          = sy-msgv2
        msgv3          = sy-msgv3
        msgv4          = sy-msgv4
        value_internal = <value>
      exceptions
        others         = 4.

    if sy-subrc <> 0 or sy-msgty ca 'EAF'.
      raise exception type zcx_stralv_input_error
        message id sy-msgid type sy-msgty number sy-msgno
        with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
        exporting
          cell = cell.
    endif.

  endmethod.


  method constructor.
    structure_name = struc_name.
    structure_fields = read_structure_fields( ).
  endmethod.


  method convert_input.
    _get_structure_ref.
    _get_field_ref field.

    data(tabfield) =
      value tabfield(
        tabname = structure_name
        fieldname = field-ddic-fieldname ).

    call function 'RS_CONV_EX_2_IN'
      exporting
        input_external               = cell-value
        table_field                  = tabfield
        currency                     = field-units-currency
      importing
        output_internal              = <value>
      exceptions
        input_not_numerical          = 1
        too_many_decimals            = 2
        more_than_one_sign           = 3
        ill_thousand_separator_dist  = 4
        too_many_digits              = 5
        sign_for_unsigned            = 6
        too_large                    = 7
        too_small                    = 8
        invalid_date_format          = 9
        invalid_date                 = 10
        invalid_time_format          = 11
        invalid_time                 = 12
        invalid_hex_digit            = 13
        unexpected_error             = 14
        invalid_fieldname            = 15
        field_and_descr_incompatible = 16
        input_too_long               = 17
        no_decimals                  = 18
        invalid_float                = 19
        conversion_exit_error        = 20
        others                       = 21.
    if sy-subrc <> 0.
      raise exception type zcx_stralv_input_error
        message id sy-msgid type sy-msgty number sy-msgno
        with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
        exporting
          cell = cell.
    endif.
  endmethod.


  method convert_output.
    if field-units-currency is not initial.
      write value to result currency field-units-currency.
    elseif field-units-qty_unit is not initial.
      write value to result unit field-units-qty_unit.
    else.
      write value to result.
    endif.
    result = condense( result ).
  endmethod.

  method create_input_table.
    inputs = create_input_table_low( inputs ).
    result = me.
  endmethod.


  method create_input_table_low.

    loop at structure_fields into data(f).
      data(field) = value types=>field(
        ddic = f
        attribute = get_field_attribute( f-fieldname )
        value = value #( old_inputs[ ref_field = f-fieldname ]-fieldvalue optional ) ).
      if  field-attribute-no_display = abap_true or
          fields->is_description_field( field-ddic-fieldname ).
        exit.
      endif.
      insert
        value zst_stralv_tab_line(
          fieldlabel = get_fieldlabel( field )
          fieldvalue = field-value
          ref_field = field-ddic-fieldname
          ref_table = field-ddic-tabname
          t_styles = set_field_styles( field )
          t_colors = set_field_colors( field ) )
        into table result.

      if field-ddic-outputlen > max_outputlen.
        max_outputlen = field-ddic-outputlen.
      endif.

    endloop.

  endmethod.


  method description_fill.
    _get_structure_ref.
    _get_field_ref field.
    data(fnam) = conv fnam_____4( field-ddic-fieldname ).
    data(text) = ``.
    call function 'DDUT_TEXT_FOR_VALUE'
      exporting
        tabname   = structure_name
        fieldname = fnam
        value     = <value>
      importing
        text      = text
      exceptions
        others    = 0.
    result = text.
  endmethod.


  method fill_description_from_field.
    field-symbols <description> type any.
    _get_structure_ref.

    assign component field-attribute-struc_descr_field of structure <all> to <description>.
    if sy-subrc = 0.
      result = conv string( <description> ).
    endif.

  endmethod.


  method fill_description_special.

    if  field-ddic-checktable is not initial and
        field-value is not initial.

      data(analysis) = analyze_foreign_key( field ).

      if analysis-failures is initial.
        data(tabs) = value string_table(
          for groups tab of line in analysis-conditions
          group by line-checktable
          ( conv #( tab ) ) ).
        if lines( tabs ) = 1.
          result =
            read_from_checktable(
              field = field
              sel_lines =
                value #(
                  for l in analysis-conditions
                  ( conv #( l-line ) ) ) ).
        endif.
      endif.
    endif.
  endmethod.


  method get_fieldlabel.
    result =
      cond #(
        when field-attribute-no_label = abap_false
        then
          cond #(
            when long_descr = abap_true
              then cond #(
                when field-ddic-scrtext_l is not initial
                  then field-ddic-scrtext_l
                when field-ddic-scrtext_m is not initial
                  then field-ddic-scrtext_m
                else field-ddic-scrtext_s )
            when short_descr = abap_true
              then cond #(
                when field-ddic-scrtext_s is not initial
                  then field-ddic-scrtext_s
                when field-ddic-scrtext_m is not initial
                  then field-ddic-scrtext_m
                else field-ddic-scrtext_l )
            when medium_descr = abap_true
              then cond #(
                when field-ddic-scrtext_m is not initial
                  then field-ddic-scrtext_m
                when field-ddic-scrtext_s is not initial
                  then field-ddic-scrtext_s
                else field-ddic-scrtext_l ) ) ).
  endmethod.


  method get_field_attribute.
    try.
        result = fields->get_field( name )->get_attributes( ).
      catch zcx_stralv_error ##no_handler.
    endtry.
  endmethod.


  method get_field_units.
    field-symbols <lv_value_ref> type c.
    _get_structure_ref.

    if  is_field-reftable = is_field-tabname and
        is_field-reffield is not initial.
      data(ref_field) = structure_fields[ fieldname = is_field-reffield ].
      assign component ref_field-fieldname of structure <all> to <lv_value_ref>.
      if sy-subrc = 0.
        if ref_field-datatype = constants=>datatype-currency.
          result-currency = <lv_value_ref>.
        elseif ref_field-datatype = constants=>datatype-unit.
          result-qty_unit = <lv_value_ref>.
        endif.
      endif.
    endif.
  endmethod.


  method has_dom_values.
    data lt_domvalues type standard table of dd07v.

    call function 'DDUT_DOMVALUES_GET'
      exporting
        name          = field-ddic-domname
        langu         = sy-langu
        texts_only    = abap_false
      tables
        dd07v_tab     = lt_domvalues
      exceptions
        illegal_input = 1
        others        = 2.
    result = xsdbool( lt_domvalues is not initial ).
  endmethod.


  method has_search_help.
    result =
      xsdbool(
        field-ddic-domname <> 'XFELD' and
        ( field-ddic-shlpname is not initial or
          field-ddic-checktable is not initial or
          field-ddic-datatype = 'DATS' or
          field-ddic-datatype = 'TIMS' or
          has_dom_values( field ) ) ).
  endmethod.


  method is_readonly.
    result = readonly.
  endmethod.


  method map_struc_field_to_line.
    field-symbols:
      <field_val>   type any.

    result = line.
    _get_structure_ref.

    data field type types=>field.
    field = build_field( result ).

    assign component line-ref_field of structure <all> to <field_val>.
    if sy-subrc <> 0.
      return.
    endif.

    result-fieldvalue = convert_output(
                          field = field
                          value = <field_val> ).
    field-value = result-fieldvalue.
    result-t_styles = set_field_styles( field ).

    if  max_outputlen_d > 0 and
        field-attribute-checkbox = abap_false and
        field-value is not initial.

      result-fielddescr =
        cond #(
          when field-attribute-description_field is not initial
            then fill_description_special( field )
          when field-attribute-struc_descr_field is not initial
            then fill_description_from_field( field )
          else description_fill( field ) ).
    endif.
  endmethod.


  method map_struc_to_screen.

    loop at inputs into data(line).
      line = map_struc_field_to_line( line ).
      modify inputs from line.
    endloop.

    if iv_refresh = abap_true.
      raise event refresh.
    endif.
  endmethod.


  method process_data_changed.
    _get_structure_ref.

    loop at er_data_changed->mt_good_cells into data(ls_good).
      data(field) = build_field( inputs[ ls_good-row_id ] ).
      _get_field_ref field.

      convert_input(
          field = field
          cell = ls_good ).

      check_input(
          field = field
          cell = ls_good ).
    endloop.

  endmethod.


  method process_data_changed_late.

    if e_modified = abap_true.

      map_struc_to_screen( abap_false ).
      raise event refresh.
      raise event data_has_changed.

    else.
      raise event enter_pressed.
    endif.
  endmethod.


  method process_hotspot_click.
    _get_structure_ref.
    try.
        data(field) = build_field( inputs[ row ] ).
        _get_field_ref field.
        if field-attribute-checkbox = abap_true.
          <value> = xsdbool( <value> = abap_false ).
          map_struc_to_screen( ).
          raise event data_has_changed.
        else.
          result = value #( base field value = <value> ).
        endif.
      catch cx_sy_itab_line_not_found ##no_handler.
    endtry.

  endmethod.


  method read_fieldcatalog.
    call function 'LVC_FIELDCATALOG_MERGE'
      exporting
        i_structure_name       = constants=>struct_name
      changing
        ct_fieldcat            = result
      exceptions
        inconsistent_interface = 1
        program_error          = 2
        others                 = 3.
    if sy-subrc <> 0.
      raise exception type zcx_stralv_data_create.
    endif.

  endmethod.


  method read_from_checktable.
    data lr_data type ref to data.
    field-symbols <ls_struc> type any.
    field-symbols <lv_result> type any.

    create data lr_data type (field-ddic-checktable).
    assign lr_data->* to <ls_struc>.

    select single from (field-ddic-checktable)
      fields *
      where (sel_lines)
      into @<ls_struc>.

    assign component field-attribute-description_field of structure <ls_struc>
      to <lv_result>.
    if sy-subrc = 0.
      result = <lv_result>.
    endif.
  endmethod.


  method read_structure_fields.
    call function 'DDIF_TABL_GET'
      exporting
        name          = structure_name
        state         = 'A'
        langu         = sy-langu
      tables
        dd03p_tab     = result
      exceptions
        illegal_input = 1
        others        = 2.
    if sy-subrc <> 0.
      raise exception type zcx_stralv_data_create.
    endif.
  endmethod.


  method refresh_input_table.
    if inputs is not initial.
      inputs = create_input_table_low( inputs ).
    endif.
  endmethod.


  method re_build_fieldcatalog.
    if fieldcat is not initial.
      build_fieldcatalog( ).
    endif.
  endmethod.


  method set_data.
    screendata = in.
  endmethod.


  method set_descr_length.
    if in is not initial.
      max_outputlen_d = in.
    endif.
    result = me.
  endmethod.


  method set_fields.
    fields = add_checkboxes( in ).
    refresh_input_table( ).
    result = me.
  endmethod.


  method set_field_colors.
    result =
      value #(
        ( fname = constants=>fieldname-label
          color-col =
            cond #(
              when readonly = abap_true
                then col_key
              else col_background ) ) ).
    if field-attribute-readonly = abap_true or readonly = abap_true.
      result =
        value #(
          base result
          ( fname = constants=>fieldname-value
            color =
              cond #(
                when field-attribute-color is not initial
                  then field-attribute-color
                else value #( col = col_normal ) ) ) ).
    endif.
  endmethod.


  method set_field_styles.
    include <cl_alv_control>.
    result =
      value #(
        (
        fieldname = constants=>fieldname-value
        style =
          cond #( when  field-attribute-hotspot = abap_true or
                        field-attribute-checkbox = abap_true then cl_gui_alv_grid=>mc_style_hotspot ) +
          cond #( when field-attribute-readonly = abap_true or
                        field-attribute-checkbox = abap_true then cl_gui_alv_grid=>mc_style_disabled ) +
          cond raw4( when field-attribute-checkbox = abap_true then
                    cond #(
                      when field-value = 'X'  then alv_style_checkbox_checked
                                              else alv_style_checkbox_not_checked ) ) +
          cond #( when has_search_help( field ) then cl_gui_alv_grid=>mc_style_f4 ) ) ).
  endmethod.


  method set_label_length.
    if long && medium && short <> space.
      long_descr = long.
      medium_descr = medium.
      short_descr = short.
    endif.
    result = me.
  endmethod.


  method set_readonly.
    readonly = in.
    re_build_fieldcatalog( ).
    refresh_input_table( ).
    result = me.
  endmethod.


  method set_value_length.
    if in is not initial.
      max_outputlen = in.
    endif.
    result = me.
  endmethod.

  method process_f4.
    if line_exists( inputs[ row ] ).
      data(field) = build_field( inputs[ row ] ).
      if field-attribute-f4_exit = abap_false.

        use_selected_field(
          i_row     = row
          i_event   = event
          it_return = show_search_help( field ) ).

        event->m_event_handled = abap_true.
      endif.
    endif.
  endmethod.

  method use_selected_field.

    if it_return is not initial.
      field-symbols <m_data> type lvc_t_modi.
      assign i_event->m_data->* to <m_data>.
      insert value #( row_id = i_row
                      fieldname = constants=>fieldname-value
                      value = it_return[ 1 ]-fieldval ) into table <m_data>.
    endif.

  endmethod.




  method show_search_help.
    call function 'F4IF_FIELD_VALUE_REQUEST'
      exporting
        tabname    = field-ddic-tabname
        fieldname  = field-ddic-fieldname
      tables
        return_tab = result
      exceptions
        others     = 0.
  endmethod.

endclass.
