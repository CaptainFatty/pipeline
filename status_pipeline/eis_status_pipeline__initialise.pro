pro eis_status_pipeline::init_paths
  print, 'eis_status_pipeline::init_paths'
  self->eis_pipeline::init_paths
;  root = getenv('HOME') + '/work/localdata/sdtp/merge/'
	root = self->get_root()
;  root = self->eis_pipeline::get_root()
;  self.log_dir                  = root + 'logs'
;  self.merge_dir                = root + 'merge'
;  self.received_dir             = root + 'received'
;  self.packet_source_directory  = root + 'received'
  self.split_directory          = root + 'split'
  self.timing_directory         = root + 'timing'
  self.timing_files_directory   = self.timing_directory + '/files'
;  self.join_dir                 = root + 'joined'
;  self.nursery_dir              = root + 'nursery'
;  self.decompressed_dir         = root + 'decompressed'
;  self.fits_dir                 = root + 'fits'
;  self.rescued_dir              = root + 'rescued'
;  self.rescued_decompressed_dir = self.rescued_dir + '/decompressed'
;  self.rescued_fits_dir         = self.rescued_dir + '/fits'
  self.pending_file = root + 'pending.txt'
;  self.join         = self.bin + '/join.py' ;;; SHOULD BE IN MD PIPELINE...
;  self.master_dir = getenv('HOME') + '/work/localdata/sdtp/merge/logs/master_log'
end

pro eis_status_pipeline::init_logs
  print, 'eis_status_pipeline::init_logs'
  self->eis_pipeline::init_logs
  sdate = self.sdate
  self.local_log   = self.log_dir + '/status_log_' + sdate + '.txt'
  self.received_files_log = self.log_dir + '/received_files_' + sdate + '.txt'
  ; Next 2 done by decompressor and reformatter
;  self.decompression_log  = self.log_dir + '/decompressed_log_' + sdate + '.txt'
;  self.reformat_log       = self.log_dir + '/reformat_log_' + sdate + '.txt'

;  root = getenv('HOME') + '/work/localdata/sdtp/merge/logs/'

end

;pro eis_status_pipeline::init_logs
;;;;  eis_local = '/nasA_solar1/work/eis/localdata'
;  eis_local = '/Volumes/Data/Hinode/tmp'
;  logs = eis_local + '/log'
;  self.log_dir = logs + '/pipeline'
;  self.shutter_dir = logs + '/shutter'
;  self.local_log = logs + '/local_log.txt'
;end

pro eis_status_pipeline::open_local_log
  print, 'eis_status_pipeline::open_local_log'
;  openw, lun, self.local_log, /get_lun, error=err
;  self.local_log_unit = lun
;;;  success = *self.local_logger->open_log('/Users/mcrw/tmp/local_log.txt') ; temp
  success = *self.local_logger->open_log('/Users/mcrw/work/localdata/sdtp/merge/status/logs/status_' + self.sdate + '_' + self.edate + '_log.txt',/append)
;  success = *self.local_logger->open_log(self.local_log)
end

;pro eis_status_pipeline::initialise, main_logger, trace=trace
pro eis_status_pipeline::initialise, trace=trace
  print, 'Calling eis_pipeline::initialise'
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
