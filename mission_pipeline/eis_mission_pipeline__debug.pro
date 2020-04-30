;+
; NAME: eis_md_pipeline__debug.pro
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
;	01-Aug-2018	mcrw	wrote
;
;-

pro eis_mission_pipeline::debug
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
