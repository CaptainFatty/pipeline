
;pro eis_pipeline::initialise, main_logger
pro eis_pipeline::initialise
;pro eis_md_pipeline::initialise
  self->trace, 'eis_pipeline::initialise'
  print, 'eis_pipeline::initialise'
;  self.main_logger = main_logger

  self->init_paths
  self->init_logs

  self.known_flags[0] = 'no-soda'
  self.known_flags[1] = 'fetch-only'
  self.known_flags[2] = 'no-fetch'
  self.known_flags[3] = 'no-split'
  self.known_flags[4] = 'fits-only'
  self.known_flags[5] = 'testing'
  self.known_flags[6] = 'special'
  
;  root = getenv('HOME') + '/work/localdata/sdtp/merge/data/'

;  self.pending_file                  = root + 'pending.txt'
;print, 'Setting pending file to ' + root + 'pending.txt'
end
