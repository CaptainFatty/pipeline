pro eis_mission_pipeline::init_paths
;  root = getenv('HOME') + '/work/localdata/sdtp/merge/data/'

  root = self->eis_pipeline::get_root()
;  self.log_dir                  = root + 'logs'
  self.merge_dir                = root + 'merge'
;  self.received_dir             = root + 'received'
  self.join_dir                 = root + 'joined'
  self.nursery_dir              = root + 'nursery'
  self.decompressed_dir         = root + 'decompressed'
;  self.fits_dir                 = root + 'fits'
  self.rescued_dir              = root + 'rescued'
  self.rescued_decompressed_dir = self.rescued_dir + '/decompressed'
  self.rescued_fits_dir         = self.rescued_dir + '/fits'

;  self.master_dir = getenv('HOME') + '/work/localdata/sdtp/merge/master_logs'
end

pro eis_mission_pipeline::init_logs
  sdate = self.sdate
  self.local_log   = self.log_dir + '/mission_log_' + sdate + '.txt'
  self.shutter_log = self.log_dir + '/shutter_log_' + sdate + '.txt'
  self.received_files_log = self.log_dir + '/received_files_' + sdate + '.txt'
  ; Next 2 done by decompressor and reformatter
;  self.decompression_log  = self.log_dir + '/decompressed_log_' + sdate + '.txt'
;  self.reformat_log       = self.log_dir + '/reformat_log_' + sdate + '.txt'
  self.decompression_master_record = self.master_dir + '/decompression_master_record.txt'

;  root = getenv('HOME') + '/work/localdata/sdtp/merge/logs/'

end

;pro eis_mission_pipeline::init_logs
;;;;  eis_local = '/nasA_solar1/work/eis/localdata'
;  eis_local = '/Volumes/Data/Hinode/tmp'
;  logs = eis_local + '/log'
;  self.log_dir = logs + '/pipeline'
;  self.shutter_dir = logs + '/shutter'
;  self.local_log = logs + '/local_log.txt'
;end

pro eis_mission_pipeline::open_local_log
;  openw, lun, self.local_log, /get_lun, error=err
;  self.local_log_unit = lun
success = *self.local_logger->open_log('/Users/mcrw/tmp/local_log.txt',/append) ; temp
;  success = *self.local_logger->open_log(self.local_log)
end

;pro eis_mission_pipeline::initialise, main_logger, trace=trace
pro eis_mission_pipeline::initialise, trace=trace
;pro eis_mission_pipeline::initialise
  self->trace, 'eis_mission_pipeline::initialise'

    print, 'Calling eis_pipeline::initialise'
;    self->eis_pipeline::initialise, main_logger
    self->eis_pipeline::initialise

;  self.main_logger = main_logger
;  *self.main_logger->log, 'eis_mission_pipeline::initialise'

  self.local_logger = ptr_new(obj_new('eis_logger'))
  self.decompressor = ptr_new(obj_new('eis_md_decompressor', self.local_logger)) ; do in decompress?
  self.md_checker = ptr_new(obj_new('eis_md_ccsds_checker'))  ; do later?

  self->init_paths
  self->init_logs
  self->open_local_log

  *self.md_checker->initialise, self.local_logger
  if keyword_set(trace) then *self.local_logger->set_trace, /trace

  ; self.sdtp = '${HOME}/bin/sdtp'
;   self.join = '${HOME}/bin/join.py'
end
