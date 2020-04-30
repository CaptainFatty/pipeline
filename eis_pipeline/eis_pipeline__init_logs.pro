
pro eis_pipeline::init_logs
  self->trace, 'eis_pipeline::init_logs'
;  print, 'eis_pipeline::init_logs'
  sdate = self.sdate
  self.local_log          = self.log_dir + '/mission_log_' + sdate + '.txt'
  self.received_files_log = self.log_dir + '/received_files_' + sdate + '.txt'
  ; Next 2 done by decompressor and reformatter
;  self.decompression_log  = self.log_dir + '/decompressed_log_' + sdate + '.txt'
;  self.reformat_log       = self.log_dir + '/reformat_log_' + sdate + '.txt'

;  root = getenv('HOME') + '/work/localdata/sdtp/merge/logs/'

end
