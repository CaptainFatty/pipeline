;+
; NAME: eis_pipeline__define.pro
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


pro eis_pipeline__define
;  print,'eis_pipeline::eis_pipeline__define'
  struct = { eis_pipeline,                  $

             bin                      : '', $
             sdtp                     : '', $

             master_dir               : '', $
             log_dir                  : '', $
             merge_dir                : '', $
             received_dir             : '', $
             fits_dir                 : '', $
             
             packet_source_directory  : '', $
             destination_directory    : '', $

             ; move to eis_mission_pipeline
             split_directory          : '', $

             date_string	      : '', $
             
             main_log                 : '', $
             local_log                : '', $
             received_files_log       : '', $
             
             flag                     : '',  $
;             known_flags_expt              : ['no-soda','fetch-only','no-fetch','no-split','fits-only','no-update','no-update-plots','no-update-trends','no-update-qcm','no-update-ss','testing','special', 'reformat-only'], $
             known_flags              : strarr(7), $
             set_flags                : strarr(7), $

             ; Move this lot to eis_mission_pipeline
;             no_soda                  : 0B, $
;             fetch_only               : 0B, $
;             no_fetch                 : 0B, $
;             fits_only                : 0B, $
;             force_reformat           : 0, $
;;             testing                  : 0B, $
;;             special                  : 0B, $
;             testing                  : '', $
;             special                  : '', $
             
;            ccsds_check_log      : '', $
;            reformat_log         : '', $
             
             pending_file             : '', $
                          
             received_files_count     : 0L, $
             fits_files_count         : 0L, $
             
             sdate                    : '', $
             edate                    : '', $
             stime                    : '', $
             etime                    : '', $
             
             interactive              : 0,  $
             scheduled                : 0,  $
                          
             reformatter              : ptr_new(obj_new()), $
             
;             summary              : DICTIONARY(), $
             main_logger              : ptr_new(obj_new()), $
             local_logger             : ptr_new(obj_new()), $
             
             inherits base_object }

end
