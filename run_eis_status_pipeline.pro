
; scheduled set when kicked off by cron and/or track table. Ie
; scheduled set for a new run, not ones from pending file.
; If kicked off by cron then perl program will supply date/time by
; parsing orl file(s) or reading a 'last processed' file
pro run_eis_status_pipeline, start_date=start_date, end_date=end_date,       $
                             no_soda=no_soda,       no_fetch=no_fetch,       $
                             fetch_only=fetch_only, no_split=no_split,       $
                             flag=flag,             interactive=interactive, $
                             fits_only=fits_only,                            $
                             scheduled=scheduled,   cron=cron,               $
                             trace=trace,           verbose=verbose

  !quiet=1

  main_log = '/work/localdata/sdtp/merge/logs/pipeline_log.txt'

  run_started = systime()

  ; These are for later reporting what the command line was
  interactive_string = ''
  scheduled_string = ''

  ; Start date/end date. No need for start/end times - 1.5 hrs each
  sdate = ''
  stime = ''

  print, 'run_eis_status_pipeline: Getting main logger'
  main_logger = ptr_new(obj_new('eis_logger'))
  print, 'run_eis_status_pipeline: Got main logger'

  print, 'run_eis_status_pipeline: Opening main log (' + main_log + ')'
  res = *main_logger->open_log(getenv('HOME') + main_log, /append)
  print, 'run_eis_status_pipeline: Opened main log (' + strtrim(string(res),2) + ')'

  *main_logger->log, 'EIS Status Pipeline started ' + run_started

;  print, 'start_date = ', start_date
  if keyword_set(start_date) then begin
     sdate = start_date
;     print, 'run_eis_status_pipeline: Got start date ' + start_date
  endif else begin
     print, 'Require a start date'
     *main_logger->log, 'Exiting: no start date set.'
     exit, /no_confirm, status = -1
  endelse

  if keyword_set(end_date) then begin
     edate = end_date
;     print, 'run_eis_status_pipeline: Got end date ' + end_date
  endif else begin
     print, 'Require an end date'
     *main_logger->log, 'Exiting: no end date set.'
     exit, /no_confirm, status = -2
  endelse

  print, 'run_eis_status_pipeline: Getting eis_status_pipeline'
  pipeline = obj_new('eis_status_pipeline', main_logger, sdate, edate, trace=trace, verbose=verbose)
  print, 'run_eis_status_pipeline: Got eis_status_pipeline'

  pipeline->handle_flags, no_soda=no_soda,no_fetch=no_fetch,fetch_only=fetch_only,no_split=no_split,fits_only=fits_only

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
    pipeline->announce, 'EIS status pipeline started ' + msg + systime(), /title
    pipeline->write_to_logs, 'run_eis_status_pipeline ' + interactive_str + ' ' + flag_str + ' ' + sdate + ' ' + edate
  endif else begin
    if keyword_set(scheduled) then msg = 'by scheduled cron on ' else msg = 'by cron on '
    pipeline->announce, 'EIS status pipeline started ' + msg + systime(), /title
    pipeline->write_to_logs, 'run_eis_status_pipeline ' + flag_str + ' ' + sdate + ' ' + edate
;    print, 'run_eis_status_pipeline: EIS status pipeline started ' + msg + systime()
;    print, 'run_eis_status_pipeline: ' + flag_str + ' ' + sdate + ' ' + edate
  endelse

  *main_logger->debug
  pipeline->debug

  print, 'run_eis_status_pipeline: Logging to local log at ' + pipeline->local_log_filename()
  pipeline->main_log, 'Logging to ' + pipeline->local_log_filename()

  ; ObjRef->classname::method
  ;pipeline->pipeline::debug

  if pipeline->flag_set('fits-only') eq 1 then begin
     print, 'fits-only flag set, skipping fetch'
     goto, reformat
  endif

  if pipeline->flag_set('no-fetch') eq 0 then begin   
     pipeline->stage_title, 'Clear old data'
     pipeline->clear_old_data

     pipeline->stage_title, 'Fetch new data'
     pipeline->fetch_data, received_files
  endif
  
  if pipeline->flag_set('fetch-only') ne 0 then begin
     pipeline->main_log, 'fetch-only flag set, exiting'
     goto, the_exit
  endif

  goto, temp_skip

  if pipeline->flag_set('no-split') eq 0 then begin
     pipeline->stage_title, 'Split archives'
     pipeline->split_files
  endif

  pipeline->create_timing_files

temp_skip:
  
  pipeline->stage_title, 'Check data'
  pipeline->check_data, received_files, damaged_files

  if pipeline->flag_set('force-reformat') ne 0 then begin
    pipeline->main_log, 'force-reformat flag encountered, exiting'
    goto, the_exit
  endif

;;;  halt
  
  ; Align and reformat will be done in the same step...
;  pipeline->stage_title, 'Align data'
;  pipeline->align_data

reformat:

  pipeline->stage_title, 'Reformat data'
  pipeline->reformat, trace=trace

;;;  pipeline->rescue_damaged_data, damaged_files ; will call self->decompress_data, /rescued ...

  if pipeline->flag_set('no-soda') then begin
     pipeline->log, 'no-soda flag set, skipping updates'
     goto, skip_soda_update
  endif

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
  
  pipeline->stage_title, 'Generate reports'
  pipeline->generate_reports
  
  pipeline->stage_title, 'Move reports to DARTS'
  pipeline->move_reports_to_darts
  
  pipeline->stage_title, 'Move ccsds files to DARTS and compress'
  pipeline->move_ccsds
  
the_exit:
  
  pipeline->stage_title, 'Update tracking'
  pipeline->update_tracking
  
  pipeline->stage_title, 'Exit'
  pipeline->debug
  pipeline->exit, 0, 'Ok' ; destroys objects and exits

error:
  pipeline->debug
  *main_logger->log, msg
  *main_logger->exit
  obj_destroy, main_logger
  obj_destroy, pipeline

end
