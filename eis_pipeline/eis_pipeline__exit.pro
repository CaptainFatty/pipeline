
pro eis_pipeline::exit, status, msg
  self->trace, 'eis_pipeline__exit::exit'
  self->save_logs
  status_str = '(status ' + strtrim(string(status), 2) + '): '
  if status ne 0 then exit_msg = 'Exiting ' + status_str else exit_msg = 'Finished ' + status_str
  *self.local_logger->stage_title, exit_msg + msg
  *self.main_logger->log, exit_msg + msg
  *self.main_logger->log, ''
  self->tidy_up, status_str

  obj_destroy, *self.local_logger
  obj_destroy, *self.main_logger

  exit, /no_confirm, status=status
end
