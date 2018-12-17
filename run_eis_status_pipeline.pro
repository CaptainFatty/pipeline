
;function read_last_processed_plan, sdate, stime
;  return, 1
;end

; function parse_date_time, sdate, edate, stime, etime
;   ret = 1
; ;  if keyword_set(sdate) then ret = ret and 1 else ret = ret and 0
; ;  if keyword_set(edate) then ret = ret and 1 else ret = ret and 0
; ;  if keyword_set(stime) then ret = ret and 1 else ret = ret and 0
; ;  if keyword_set(etime) then ret = ret and 1 else ret = ret and 0
;   print, 'parse_date_time returning ', ret
;   return, ret
; end

; scheduled set when kicked off by cron and/or track table. Ie
; scheduled set for a new run, not ones from pending file.
; if kicked off by cron then perl program will supply date/time by
; parsing orl file(s) or reading a 'last processed' file
pro run_eis_status_pipeline, start_date=start_date, end_date=end_date, no_soda=no_soda, no_fetch=no_fetch, fetch_only=fetch_only, no_split=no_split, flag=flag, interactive=interactive, scheduled=scheduled, trace=trace
;  if n_params() lt 4 then begin
;;     self->exit
;     print, 'Parameter numbers not correct', n_params()
;     return
;  endif
  ; These are for later reporting what the command line was
  interactive_string = ''
  scheduled_string = ''

  sdate = ''
  edate = ''
  stime = ''
  etime = ''

  if keyword_set(start_date) then begin
     sdate = start_date
     print, 'Got start date: ' + start_date
  endif

  if keyword_set(end_date) then begin
     edate = end_date
     print, 'Got end date: ' + end_date
  endif

  main_logger = ptr_new(obj_new('eis_logger'))
  print, 'Got main logger'
  res = *main_logger->open_log(getenv('HOME') + '/work/localdata/sdtp/merge/logs/pipeline_log.txt', /append)
  print, 'Opened main log'

  pipeline = obj_new('eis_status_pipeline', main_logger)
  print, 'Got eis_status_pipeline'

;;;;  pipeline = obj_new('eis_status_pipeline', main_logger)

; pipeline, eis_md_pipeline and eis_status_pipeline need own initialize
;  pipeline->initialise, main_logger, trace=trace
  pipeline->set_date_time, sdate=sdate, edate=edate, stime=stime, etime=etime
  pipeline->initialise, trace=trace
  print, 'Initialised'

  if keyword_set(no_soda) then begin
     print, 'no_soda set, setting flag'
     pipeline->set_flag, 'no-soda'
  end

  if keyword_set(no_fetch) then begin
     print, 'no_fetch set, setting flag'
     pipeline->set_flag, 'no-fetch'
  end

  if keyword_set(fetch_only) then begin
     print, 'fetch_only set, setting flag'
     pipeline->set_flag, 'fetch-only'
  end

  if keyword_set(no_split) then begin
     print, 'no_split set, setting flag'
     pipeline->set_flag, 'no-split'
  end

  flag_str = ''
  if keyword_set(flag) then begin
     if pipeline->known(flag) then pipeline->set_flag, flag
     flag_str = 'flag = ''' + flag + ''''
  end
  
  pipeline->set_interactive, false
  if keyword_set(interactive) then begin ; read & check start/end times
    interactive_str = '/interactive'
    pipeline->set_interactive, true
    msg = 'interactively on '
    pipeline->write_to_logs, 'EIS status pipeline started ' + msg + systime(), /title
    pipeline->write_to_logs, 'run_eis_status_pipeline ' + interactive_str + ' ' + flag_str + ' ' + sdate + ' ' + edate + ' ' + stime  + ' ' + etime
  endif else begin
    if keyword_set(scheduled) then msg = 'by scheduled cron on ' else msg = 'by cron on '
    pipeline->write_to_logs, 'EIS status pipeline started ' + msg + systime(), /title
    pipeline->write_to_logs, 'run_eis_status_pipeline ' + flag_str + ' ' + sdate + ' ' + edate + ' ' + stime  + ' ' + etime
  endelse

  pipeline->main_log, 'Logging to ' + pipeline->local_log_filename()

  pipeline->debug
  ; ObjRef->classname::method
  ;pipeline->pipeline::debug

  if pipeline->flag_set('no-fetch') eq 0 then begin   
     pipeline->stage_title, 'Clear old data'
;;;     pipeline->clear_old_data

     pipeline->stage_title, 'Fetch new data'
;;;     pipeline->fetch_data, received_files
  endif
  
  if pipeline->flag_set('fetch-only') ne 0 then begin
     pipeline->main_log, 'fetch-only flag set, exiting'
     goto, the_exit
  endif

  if pipeline->flag_set('no-split') eq 0 then begin
     pipeline->stage_title, 'Split archives'
;;;     pipeline->split_files
  endif

  ;pipeline->stage_title, 'Check data'
  ;pipeline->check_data, received_files, damaged_files

  if pipeline->flag_set('force-reformat') ne 0 then begin
    pipeline->main_log, 'force-reformat flag encountered, exiting'
    goto, the_exit
  endif

;;;  halt
  
  ; Align and reformat will be done in the same step...
;  pipeline->stage_title, 'Align data'
;  pipeline->align_data

  pipeline->stage_title, 'Reformat data'
  pipeline->reformat, trace=trace

;  pipeline->rescue_damaged_data, damaged_files ; will call self->decompress_data, /rescued ...

  if pipeline->testing() then begin
      pipeline->main_log, 'testing flag set, skipping soda update'
      goto, skip_soda_update
  endif

  if pipeline->special() eq 'no_soda' then begin
      pipeline->main_log, 'no_soda flag set, skipping soda update'
      goto, skip_soda_update
  endif else begin
      if pipeline->special() eq 'special' then begin
          pipeline->main_log, 'special flag set, skipping soda update'
          goto, skip_soda_update
      endif
  endelse

  if pipeline->special() eq 'recover_test' then begin
      pipeline->main_log, 'recover_test flag set, exiting'
      goto, the_exit
  endif

  pipeline->stage_title, 'Daily check'
  pipeline->daily_check

  pipeline->stage_title, 'Make housekeeping plots'
  pipeline->daily_plots

  pipeline->stage_title, 'Update trends'
  pipeline->update_trends

  pipeline->stage_title, 'Update QCM logs'
  pipeline->update_qcm_logs

  pipeline->stage_title, 'Update shutter move log'
  pipeline->update_shutter_move_log

; HK fits files stored on DARTS, not SODA
;  pipeline->stage_title, 'Move fits files to SODA'
;  pipeline->update_soda

  pipeline->stage_title, 'Compress status fits files'
  pipeline->compress_fits

  if pipeline->flag_set('no-soda') eq 0 then begin
     pipeline->stage_title, 'Move fits files to DARTS'
     pipeline->move_fits_files_to_darts
  endif
  
skip_soda_update:
  
  pipeline->stage_title, 'Remove status QL'
  pipeline->remove_ql
  
;  pipeline->stage_title, 'Generate reports'
;  pipeline->generate_reports
  
  pipeline->stage_title, 'Move reports to DARTS'
  pipeline->move_reports_to_darts
  
  pipeline->stage_title, 'Move ccsds files to DARTS and compress'
  pipeline->move_ccsds
  
the_exit:
  
  pipeline->stage_title, 'Update tracking'
  pipeline->update_tracking
  
; Done in exit
;  pipeline->stage_title, 'Tidy up'
;  pipeline->tidy_up

  pipeline->stage_title, 'Exit'
  pipeline->exit, 0, 'Ok'

;  obj_destroy, pipeline ; done in exit

error:
  *main_logger->log, msg
  *main_logger->exit
  obj_destroy, main_logger
  obj_destroy, pipeline

end
