
pro eis_pipeline::open_local_log
  self->trace, 'eis_pipeline::open_local_log'
;  print, 'eis_pipeline::open_local_log'
;  openw, lun, self.local_log, /get_lun, error=err
;  self.local_log_unit = lun
;  success = *self.local_logger->open_log('/Users/mcrw/tmp/local_log.txt') ; temp
  success = *self.local_logger->open_log(self.local_log)
end
