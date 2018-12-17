pro eis_pipeline::init_paths
  print, 'eis_pipeline::init_paths'
  home = getenv('HOME')
  root = self->get_root()
;    root = home + '/work/localdata/sdtp/merge/'

  self.bin          = home + '/bin'
  self.log_dir      = root + 'logs'
  self.merge_dir    = root + 'merge'
  self.received_dir = root + 'received'
  self.fits_dir     = root + 'fits'
  self.master_dir   = root + '/work/localdata/sdtp/merge/master_logs'
  self.packet_source_directory  = root + 'received'
  self.sdtp         = self.bin + '/sdtp'
  self.pending_file = root + 'pending.txt'
;  self.join_dir                 = root + 'joined'
;  self.nursery_dir              = root + 'nursery'
;  self.decompressed_dir         = root + 'decompressed'
    
;  self.rescued_dir              = root + 'rescued'
;  self.rescued_decompressed_dir = self.rescued_dir + '/decompressed'
;  self.rescued_fits_dir         = self.rescued_dir + '/fits'

    
end

pro eis_pipeline::init_logs
  print, 'eis_pipeline::init_logs'
  sdate = self.sdate
  self.local_log          = self.log_dir + '/mission_log_' + sdate + '.txt'
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

pro eis_pipeline::open_local_log
;  openw, lun, self.local_log, /get_lun, error=err
;  self.local_log_unit = lun
  success = *self.local_logger->open_log('/Users/mcrw/tmp/local_log.txt') ; temp
;  success = *self.local_logger->open_log(self.local_log)
end

;pro eis_pipeline::initialise, main_logger
pro eis_pipeline::initialise
;pro eis_md_pipeline::initialise
  print, 'eis_pipeline::initialise'
;  self.main_logger = main_logger

  self->init_paths
  self->init_logs

  self.known_flags[0] = 'no-soda'
  self.known_flags[1] = 'fetch-only'
  self.known_flags[2] = 'no-fetch'
  self.known_flags[3] = 'no-split'
  self.known_flags[4] = 'fits-only'
  self.known_flags[5] = 'testing'
  self.known_flags[6] = 'special'
  
;  root = getenv('HOME') + '/work/localdata/sdtp/merge/data/'

;  self.pending_file                  = root + 'pending.txt'
;print, 'Setting pending file to ' + root + 'pending.txt'
end
