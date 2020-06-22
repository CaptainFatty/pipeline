;+
; NAME: eis_pipeline__write_to_logs.pro
;
; PURPOSE: Super class for the EIS mission data and status data pipelines
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

; create main and local versions
pro eis_pipeline::announce, msg, title=title
  msg1 = 'Announce: ' + msg
  self->main_log, msg1, title=title
  self->log, msg1, title=title
;  self->write_to_logs, msg
end
