;+
; NAME: eis_md_pipeline__update_soda.pro
;
; PURPOSE: Moves the generated fits files from their temporary location to
;          the correct location in SODA according to their filename.
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

pro eis_md_pipeline::update_soda
  self->log, 'eis_md_pipeline__update_soda::update_soda'
  *self.local_logger->stage_title, 'Update soda'

end
