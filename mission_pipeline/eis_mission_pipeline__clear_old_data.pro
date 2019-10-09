;+
; NAME: eis_md_pipeline__clear_old_data.pro
;
; PURPOSE: Deletes any data left lying around by a previous reformat.
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
;pro eis_md_pipeline::clear_merge_directories
;  self->log, 'eis_md_pipeline__clear_old_data::clear_merge_directories'
;  self->shell, '/bin/cd ' + self.received_dir + ' && /bin/rm -f eis_md_* eis_status* eis_dmp*'
;  *self.local_logger->shell, '/bin/cd ' + self.join_dir  + ' && /bin/rm -f eis_md*'
;end

pro eis_md_pipeline::clear_rescue_directories
  self->log, 'eis_md_pipeline__clear_old_data::clear_rescue_directories'
  self->shell, '/bin/cd ' + self.rescued_dir + ' && /bin/rm -f eis_md_*'
  self->shell, '/bin/cd ' + self.rescued_decompressed_dir + ' && /bin/rm -f eis_md_*'
  self->shell, '/bin/cd ' + self.rescued_fits_dir + ' && /bin/rm -f eis_md_*'
end

;pro eis_md_pipeline::clear_fits_directories
;  self->log, 'eis_md_pipeline__clear_old_data::clear_fits_directories'
;  self->shell, '/bin/cd ' + self.fits_dir  + ' && /bin/rm -f eis_l0*'
;; Next line is identical to previous line
;;  *self.local_logger->shell, '/bin/cd ' + self.fits_dir  + ' && /bin/rm -f eis_l0*'
;end

;pro eis_md_pipeline::clear_temporary_log_directories
;  self->log, 'eis_md_pipeline__clear_old_data::clear_temporary_log_directories'
;end

pro eis_md_pipeline::clear_old_data
  self->log, 'eis_md_pipeline__clear_old_data::clear_old_data'
  self->eis_pipeline::clear_old_data
;  *self.local_logger->stage_title, 'Removing old data'
;  self->stage_title, 'Removing old data'
  self->clear_rescue_directories
end
