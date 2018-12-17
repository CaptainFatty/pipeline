;+
; NAME: eis_pipeline__known.pro
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

;function eis_pipeline::known, flag
;  return, 1
;end

function eis_pipeline::known, flag
  self->trace, 'eis_pipeline_flag_handling::known'
  return, self->check_flag(self.known_flags, flag)
end
