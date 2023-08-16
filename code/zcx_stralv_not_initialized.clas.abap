class ZCX_STRALV_NOT_INITIALIZED definition
  public
  inheriting from ZCX_STRALV_ERROR
  final
  create public .

public section.

  constants ZCX_STRALV_NOT_INITIALIZED type SOTR_CONC value '005056B16FE81EDE8ED66FBF88226656' ##NO_TEXT.

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_STRALV_NOT_INITIALIZED IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
 IF textid IS INITIAL.
   me->textid = ZCX_STRALV_NOT_INITIALIZED .
 ENDIF.
  endmethod.
ENDCLASS.
