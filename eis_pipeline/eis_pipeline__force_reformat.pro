;+
; NAME: eis_pipeline__force_reformat.pro
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


function eis_pipeline::force_reformat
  self->trace, 'eis_pipeline__define::force_reformat'
  return, self.force_reformat eq 1
end
