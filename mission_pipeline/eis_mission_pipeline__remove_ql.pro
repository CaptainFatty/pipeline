;+
; NAME: eis_md_pipeline__remove_ql.pro
;
; PURPOSE: Removes the quicklook data (if any) for the dates covered by
;          this plan.
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

pro eis_md_pipeline::remove_ql
  self->log, 'eis_md_pipeline__remove_ql::remove_ql'
  *self.local_logger->stage_title, 'Remove ql'

end
