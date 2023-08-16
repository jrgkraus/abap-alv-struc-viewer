class ZCX_STRALV_INVALID_PARA definition
  public
  inheriting from ZCX_STRALV_ERROR
  create public .

public section.

  constants ZCX_STRALV_INVALID_PARA type SOTR_CONC value '005056B16FE81EEE8ECD6148AF6D1825' ##NO_TEXT.

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_STRALV_INVALID_PARA IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
 IF textid IS INITIAL.
   me->textid = ZCX_STRALV_INVALID_PARA .
 ENDIF.
  endmethod.
ENDCLASS.
