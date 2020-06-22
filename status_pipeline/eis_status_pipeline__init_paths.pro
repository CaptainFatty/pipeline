;+
; NAME: eis_status_pipeline__init_paths.pro
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

pro eis_status_pipeline::init_paths
  self->trace, 'eis_status_pipeline::init_paths'
;  print, 'eis_status_pipeline::init_paths'

  self->eis_pipeline::init_paths
;  root = getenv('HOME') + '/work/localdata/sdtp/merge/'
  root = self->get_root()
;  root = self->eis_pipeline::get_root()

  self.split_directory          = root + '/split'
  self.timing_directory         = root + '/timing'
  self.timing_files_directory   = self.timing_directory + '/files'
;  self.join_dir                 = root + 'joined'
;  self.nursery_dir              = root + 'nursery'
;  self.decompressed_dir         = root + 'decompressed'
;  self.fits_dir                 = root + 'fits'
;  self.rescued_dir              = root + 'rescued'
;  self.rescued_decompressed_dir = self.rescued_dir + '/decompressed'
;  self.rescued_fits_dir         = self.rescued_dir + '/fits'
  self.pending_file = root + '/pending.txt'
;  self.join         = self.bin + '/join.py' ;;; SHOULD BE IN MD PIPELINE...
;  self.master_dir = getenv('HOME') + '/work/localdata/sdtp/merge/logs/master_log'
end
