pro eis_md_pipeline::remove_objects
  ; This seems wrong! but works...
  if self.decompressor eq !NULL then begin
     *self.decompressor->exit
     obj_destroy, *self.decompressor
  endif

  if self.md_checker eq !NULL then begin
     *self.md_checker->tear_down
     obj_destroy, *self.md_checker
  endif
;skip_this:
end

pro eis_md_pipeline::exit, status, msg
  status_str = strtrim(string(status), 2)
  final_msg = msg + ' (' + status_str + ')'
  *self.local_logger->stage_title, 'Exiting: ' + final_msg
  *self.main_logger->log, 'Finished: ' + final_msg 
  self->remove_objects
  self->tidy_up

  obj_destroy, *self.local_logger

  exit, /no_confirm, status=status
end
