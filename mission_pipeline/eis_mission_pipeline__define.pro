;+
; NAME: eis_md_pipeline__define.pro
;
; PURPOSE: Super class for the mission data pipeline
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
;	23/11/05 mcrw	wrote
;   14/08/06 mcrw	added documentation
;
;-

pro eis_md_pipeline::debug
  print, 'eis_md_pipeline__define::debug'
  print, 'join_dir                    : ' + self.join_dir
  print, 'decompressed_dir            : ' + self.decompressed_dir
  print, 'nursery_dir                 : ' + self.nursery_dir
  print, 'rescued_dir                 : ' + self.rescued_dir
  print, 'rescued_decompressed_dir    : ' + self.rescued_decompressed_dir
  print, 'rescued_fits_dir            : ' + self.rescued_fits_dir
  print, 'md_split_check_log          : ' + self.md_split_check_log
  print, 'joined_files_log            : ' + self.joined_files_log
  print, 'ccsds_check_log             : ' + self.ccsds_check_log
  print, 'decompression_log           : ' + self.decompression_log
  print, 'decompression_master_record : ' + self.decompression_master_record
  print, 'reformat_log                : ' + self.reformat_log
  print, 'shutter_log                 : ' + self.shutter_log
  print, 'join                        : ' + self.join
  print, ''

end

pro eis_md_pipeline__define

  struct = { eis_md_pipeline,                       $

             join_dir                         : '', $
             decompressed_dir                 : '', $
             nursery_dir                      : '', $
             rescued_dir                      : '', $
             rescued_decompressed_dir         : '', $
             rescued_fits_dir                 : '', $

             md_split_check_log               : '', $
             joined_files_log                 : '', $
             ccsds_check_log                  : '', $
             decompression_log                : '', $
             decompression_master_record      : '', $
             reformat_log                     : '', $
             shutter_log                      : '', $

;	 pending_file                     : '', $

             join                             : '', $

             compressed_files_count           : 0L, $
             decompressed_files_count         : 0L, $
             rescued_compressed_files_count   : 0L, $
             rescued_decompressed_files_count : 0L, $
             rescued_fits_files_count         : 0L, $

             reformatter                      : ptr_new(obj_new()), $
             decompressor                     : ptr_new(obj_new()), $
             md_checker                       : ptr_new(obj_new()), $

             inherits eis_pipeline}

end
