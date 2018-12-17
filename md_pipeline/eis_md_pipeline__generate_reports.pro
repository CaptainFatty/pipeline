;+
; NAME: eis_md_pipeline__generate_reports.pro
;
; PURPOSE: Generates the text reports of the processed data.
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
; COMMON BLOCKS: None.
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

pro eis_md_pipeline::generate_reports
  self->log, 'eis_md_pipeline__generate_reports::generate_reports'
  *self.local_logger->stage_title, 'Generate reports'

end
