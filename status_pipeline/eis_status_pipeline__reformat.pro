;pro eis_status_pipeline::remove_objects
;  self->trace, 'eis_status_pipeline__exit::remove_objects'
;  ; This seems wrong! but works...
;;  if self.decompressor eq !NULL then begin
;;     *self.decompressor->exit
;;     obj_destroy, *self.decompressor
;;  endif
;
;;  if self.md_checker eq !NULL then begin
;;     *self.md_checker->tear_down
;;     obj_destroy, *self.md_checker
;;  endif
;;Remove formatters
;end

pro eis_status_pipeline::reformat, trace=trace
  self->trace, 'eis_status_pipeline__reformat::reformat'

  foreach reformatter, self.reformatters do begin
    self->log, 'Starting reformatter: ' + reformatter
    self.reformatter = ptr_new(obj_new(reformatter))
    *self.reformatter->initialise, self.local_logger, trace=trace ; give split_directory and fits_dir here too
    *self.reformatter->set_dates, self.sdate, self.edate
    *self.reformatter->reformat
    *self.reformatter->debug
    *self.reformatter->tidy_up
    self->log, 'Destroying reformatter: ' + reformatter
    obj_destroy, *self.reformatter ; comment out if error
  endforeach

  ; or...
;  self.reformatter = ptr_new(obj_new('eis_sts1_reformatter'))
;  self.reformatter->initialise, self.local_logger
;  *self.reformatter->reformat, self.split_directory
;  *self.reformatter->tidy_up
;  obj_destroy, *self.reformatter

;  self.reformatter = ptr_new(obj_new('eis_sts2_reformatter'))
;  self.reformatter->initialise, self.local_logger
;  *self.reformatter->reformat, self.split_directory
;  *self.reformatter->tidy_up
;  obj_destroy, *self.reformatter

  ;self->remove_objects
  ;self->eis_pipeline::exit, status, msg
;  status_str = '(status ' + strtrim(string(status), 2) + '): '
;  if status ne 0 then exit_msg = 'Exiting ' + status_str else exit_msg = 'Finished ' + status_str
;  *self.local_logger->stage_title, exit_msg + msg
;  *self.main_logger->log, exit_msg + msg

;  self->tidy_up

;  obj_destroy, *self.local_logger
;  obj_destroy, *self.main_logger

;  exit, /no_confirm, status=status
end
