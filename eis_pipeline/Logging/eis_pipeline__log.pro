;+
; NAME: eis_pipeline__log.pro
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

pro eis_pipeline::log, msg, title=title
  *self.local_logger->log, msg, title=title
;  lu = self.local_log_unit
;  if not keyword_set(title) then msg1 = '	' + msg else msg1 = msg
;  print, msg1
;;  printf, lu, msg1
end
