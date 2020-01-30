
pro eis_status_pipeline::debug
  self->eis_pipeline::debug
  print
  print, 'eis_status_pipeline__define::debug'
;  print, 'timings_directory            : ' + self.timings_directory
  print, 'timing_split_script          : ' + self.timing_split_script
  print, 'timing_directory             : ' + self.timing_directory
  print, 'timing_files_directory       : ' + self.timing_files_directory
  print, ''
end
