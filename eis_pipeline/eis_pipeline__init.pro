;+
; NAME: eis_pipeline__init.pro
;
; PURPOSE: 
;
; CATEGORY: Science
;
; CALLING SEQUENCE: None
;
; INPUTS: None
;
; KEYWORD PARAMETERS: None
;
; OUTPUTS: None
;
; CALLS: None
;
; COMMON BLOCKS:None.
;
; PROCEDURE:
;
; RESTRICTIONS: Uses SolarSoft
;
; MODIFICATION HISTORY:
;	  23/11/05 mcrw	wrote
;   14/08/06 mcrw	added documentation
;
;-

function eis_pipeline::init, main_logger, trace=trace, verbose=verbose
  if keyword_set(verbose) then begin
     self->set_verbose, verbose
     self->trace, 'eis_pipeline::init'
  endif
  if keyword_set(trace) then begin
     self->set_trace, trace
;     self->trace, 'eis_pipeline::init'
  endif
  self.main_logger = main_logger

;  self->init_paths
;  self->init_logs

;  self->initialize
  
  return, 1
end
