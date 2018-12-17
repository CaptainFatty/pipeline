
pro eis_status_pipeline::debug
  self->eis_pipeline::debug
  print
  print, 'eis_status_pipeline__define::debug'
;  print, 'timings_directory            : ' + self.timings_directory
  print, 'timing_split_script          : ' + self.timing_split_script
  print, ''
end

pro eis_status_pipeline__define
  print,'eis_status_pipeline__define'
  struct = { eis_status_pipeline,    $
;	  timings_directory		   : '', $
;	  packet_source_directory  : '', $
;	  destination_directory    : '', $
             
             start_times              : make_array(16, /string), $ ;strarr(16), $
             end_times                : strarr(16),              $
             elapsed_time             : make_array(16, /ulong),  $
             split_file_types         : strarr(8),               $
             status_apids             : strarr(8),               $
             
             timing_file_types        : strarr(8),               $
             timing_split_script      : '',                      $
             
             reformatters             : strarr(8),               $
             
             ccsds_reader             : ptr_new(obj_new()),      $
             ccsds_writer             : ptr_new(obj_new()),      $
             
             inherits eis_pipeline }
  print,'eis_status_pipeline__define'
end
