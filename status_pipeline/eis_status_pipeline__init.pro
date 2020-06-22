
function eis_status_pipeline::init, main_logger, sdate, edate, trace=trace, verbose=verbose
  self->trace, 'eis_status_pipeline::init'

;  print, 'eis_status_pipeline::init'
  
  if keyword_set(verbose) then begin
     self->set_verbose, verbose
     self->trace, 'eis_status_pipeline::init'
  endif

  if keyword_set(trace) then begin
     self->set_trace, trace
  endif

  self.main_logger = main_logger

  self->set_verbose, 1
  self->set_trace, 1

  self->initialise, sdate, edate

  return, 1

end
