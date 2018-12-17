;+
; NAME: eis_pipeline__flag_set.pro
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

;function eis_pipeline::flag_set, flag
;  return, self.flag eq flag
;end

function eis_pipeline::flag_set, flag
  self->trace, 'eis_pipeline_flag_handling::flag_set'
  return, self->check_flag(self.set_flags, flag)
end
