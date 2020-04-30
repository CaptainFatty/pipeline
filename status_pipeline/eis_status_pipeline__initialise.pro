
;pro eis_status_pipeline::initialise, main_logger, trace=trace
pro eis_status_pipeline::initialise, trace=trace
  self->trace, 'eis_status_pipeline::initialise'
  print, 'eis_status_pipeline::initialise'
;  self->eis_pipeline::initialise, main_logger
  self->eis_pipeline::initialise

;  self.main_logger = main_logger
;  *self.main_logger->log, 'eis_md_pipeline::initialise'

  self.local_logger = ptr_new(obj_new('eis_logger'))
  if keyword_set(trace) then *self.local_logger->set_trace, trace=trace

  self->init_paths
  self->init_logs
  self->open_local_log

  self.start_times      = ['0000','0130','0300','0430','0600','0730','0900','1030','1200','1330','1500','1630','1800','1930','2100','2230']
  self.end_times        = ['0130','0300','0430','0600','0730','0900','1030','1200','1330','1500','1630','1800','1930','2100','2230','0000']
  self.elapsed_time     = [0, 5400, 10800, 16200, 21600, 27000, 32400, 37800, 43200, 48600, 54000, 59400, 64800, 70200, 75600, 81000]
  self.split_file_types = ['sts1','sts2','sts3','hk1','hk2','sot','eismdp','aocs1']
  self.status_apids     = ['05C4'x, '05C6'x, '05C8'x, '0420'x, '0428'x, '0542'x, '05C2'x, '0440'x]

  self.reformatters = ['eis_sts1_reformatter', 'eis_sts2_reformatter','eis_sts3_reformatter','eis_hk1_reformatter','eis_hk2_reformatter','eis_sot_reformatter','eis_eismdp_reformatter','eis_aocs1_reformatter']
;;;  self.reformatters = ['eis_sts1_reformatter', 'eis_sts2_reformatter', 'eis_sts3_reformatter']
;;;  self.reformatters = ['eis_sts1_reformatter', 'eis_sts2_reformatter', 'eis_sts3_reformatter', 'eis_hk1_reformatter', 'eis_hk2_reformatter']

;  self.sdtp = '${HOME}/bin/sdtp'
  ;;;self.timing_split_script = self.bin + '/split_timings.sh'

;;;;  self->set_flag, ''

end
