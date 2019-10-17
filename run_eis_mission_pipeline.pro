
;function read_end_orl, orl_dir, sdate, edate, etime
;  return, 1
;end

;function read_last_processed_plan, sdate, stime
;  return, 1
;end

function parse_date_time, sdate, edate, stime, etime
  ret = 1
;  if keyword_set(sdate) then ret = ret and 1 else ret = ret and 0
;  if keyword_set(edate) then ret = ret and 1 else ret = ret and 0
;  if keyword_set(stime) then ret = ret and 1 else ret = ret and 0
;  if keyword_set(etime) then ret = ret and 1 else ret = ret and 0
  print, 'parse_date_time returning ', ret
  return, ret
end

; scheduled set when kicked off by cron and/or track table. Ie
; scheduled set for a new run, not ones from pending file.
; if kicked off by cron then perl program will supply date/time by
; parsing orl file(s)
pro run_eis_mission_pipeline, start_date=start_date, end_date=end_date, start_time=start_time, end_time=end_time, flag=flag, interactive=interactive, scheduled=scheduled
;  if n_params() lt 4 then begin
;;     self->exit
;     print, 'Parameter numbers not correct', n_params()
;     return
;  endif
  if keyword_set(start_date) then print, 'Got start date'
  sdate = string(start_date)
  edate = string(end_date)
  stime = string(start_time)
  etime = string(end_time)

  orl_dir = ''

  main_logger = ptr_new(obj_new('eis_logger'))
  print, 'Got main logger'
;  main_logger = obj_new('eis_logger')
;  *main_logger->initialise, getenv('HOME') + '/pipeline_log.txt'
  res = *main_logger->open_log(getenv('HOME') + '/pipeline_log.txt', /append)
  print, 'Opened main log'

  eis_pipeline = obj_new('eis_mission_pipeline', main_logger, /verbose, /trace)
  print, 'Got eis_mission_pipeline'

;  eis_pipeline->initialise, main_logger, /trace
  eis_pipeline->initialise, /trace

;  flag_str = ''
;  eis_pipeline->set_flag, flag_str
  if keyword_set(flag) then begin
     print, 'FLAG: ' + flag + ' found...'
                                ; Problem here - no_soda (for eg) not
                                ;                known (ie not set in
                                ;                the pipeline yet as a
                                ;                known flag)
    if eis_pipeline->known(flag) then eis_pipeline->set_flag, flag
     flag_str = 'flag=''' + flag + ''''
  end

  eis_pipeline->set_interactive, false
  if keyword_set(interactive) then begin ; read & check start/end times
;;;     *main_logger->log, 'EIS pipeline started interactively at ' + systime()
     msg = 'interactively on '
     *main_logger->log, 'EIS mission pipeline started ' + msg + systime(), /title
     interactive_str = '/interactive'
;;;     if parse_date_time(sdate, edate, stime, etime) then begin
     if self->parse_date_time(sdate, edate, stime, etime) then begin
        eis_pipeline->set_interactive, true
        eis_pipeline->set_date_time, sdate=sdate, edate=edate, stime=stime, etime=etime
        *main_logger->log, 'run_eis_mission_pipeline ' + interactive_str + ' ' + flag_str + ' ' + sdate + ' ' + edate + ' ' + stime  + ' ' + etime
     endif else begin
        msg = 'Interactive date/time Error'
        goto, error
     endelse

  endif else begin

     msg = 'by cron on '
     *main_logger->log, 'EIS mission pipeline started ' + msg + systime(), /title

     ; perl file will supply date/time from orl...
;     ; create start/end date/times
;     if not read_last_processed_plan(sdate, stime) then begin
;        msg = 'Error reading last processed file'
;        goto, error
;     endif else begin
;        if not read_end_orl(orl_dir, sdate, edate, etime) then begin
;           msg = 'Error reading orl file'
;           goto, error
;        endif else begin
           ; read last processed file and read orl file ok
           sdate = '20150410'
           edate = '20150415'
           stime = '0945'
           etime = '1001'
           eis_pipeline->set_date_time, sdate=sdate, edate=edate, stime=stime, etime=etime
           *main_logger->log, 'run_eis_mission_pipeline ' + flag_str + ' ' + sdate + ' ' + edate + ' ' + stime  + ' ' + etime
;        endelse
;     endelse
  endelse

;  eis_pipeline->initialise, main_logger
;  eis_pipeline->initialise

  eis_pipeline->debug
  ; ObjRef->classname::method
  eis_pipeline->eis_pipeline::debug

  eis_pipeline->stage_title, 'Clear old data'
  eis_pipeline->clear_old_data

  eis_pipeline->stage_title, 'Fetch new data'
  eis_pipeline->fetch_data, received_files

  eis_pipeline->stage_title, 'Stitching files'
  eis_pipeline->join_files, received_files, joined_files

  eis_pipeline->check_data, joined_files, damaged_files

  if eis_pipeline->flag_set('force_reformat') then goto, the_exit
  if eis_pipeline->flag_set('fetch_only') then goto, the_exit
  eis_pipeline->decompress_data
  eis_pipeline->reformat_data
  eis_pipeline->rescue_damaged_data, damaged_files ; will call self->decompress_data, /rescued ...
  eis_pipeline->compress_fits
  if eis_pipeline->testing() then goto, skip_soda_update
  if eis_pipeline->special() eq 'no_soda' or eis_pipeline->special() eq 'special' then goto, skip_soda_update
  if eis_pipeline->special() eq 'recover_test' then goto, the_exit
  eis_pipeline->update_soda
skip_soda_update:
  eis_pipeline->remove_ql
  eis_pipeline->generate_reports
  eis_pipeline->move_reports_to_darts
the_exit:
  eis_pipeline->update_tracking

  eis_pipeline->tidy_up
  eis_pipeline->exit, 0, 'Ok'

;  obj_destroy, eis_pipeline ; won't be called after exit

error:
  *main_logger->log, msg
  *main_logger->exit
  obj_destroy, main_logger
  obj_destroy, eis_pipeline

end
