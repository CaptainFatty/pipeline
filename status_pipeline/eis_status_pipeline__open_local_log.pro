
pro eis_status_pipeline::open_local_log
  self->trace, 'eis_status_pipeline::open_local_log'
;  print, 'eis_status_pipeline::open_local_log'

;  openw, lun, self.local_log, /get_lun, error=err
;  self.local_log_unit = lun
;;;  success = *self.local_logger->open_log('/Users/mcrw/tmp/local_log.txt') ; temp

  ; FIX: self.sdate and self.edate returning empty strings
  print, 'eis_status_pipeline::open_local_log: sdate = ' + self.sdate
  print, 'eis_status_pipeline::open_local_log: edate = ' + self.edate
  success = *self.local_logger->open_log('/Users/mcrw/work/localdata/sdtp/merge/status/logs/status_' + self.sdate + '_' + self.edate + '_log.txt',/append)

;  success = *self.local_logger->open_log(self.local_log)
end
