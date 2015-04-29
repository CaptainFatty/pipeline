pro eis_md_pipeline::init_paths
  root = getenv('HOME') + '/work/localdata/sdtp/merge/data/'

  self.log_dir                  = root + 'logs'
  self.received_dir             = root + 'received'
  self.join_dir                 = root + 'joined'
  self.nursery_dir              = root + 'nursery'
  self.decompressed_dir         = root + 'decompressed'
  self.fits_dir                 = root + 'fits'
  self.rescued_dir              = root + 'rescued'
  self.rescued_decompressed_dir = self.rescued_dir + '/decompressed'
  self.rescued_fits_dir         = self.rescued_dir + '/fits'

  self.master_dir = getenv('HOME') + '/work/localdata/sdtp/merge/master_logs'
end

pro eis_md_pipeline::init_logs
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

pro eis_md_pipeline::open_local_log
;  openw, lun, self.local_log, /get_lun, error=err
;  self.local_log_unit = lun
  success = *self.local_logger->open_log('/Users/mcrw/tmp/local_log.txt') ; temp
;  success = *self.local_logger->open_log(self.local_log)
end

function eis_md_pipeline::flag_set, flag
  return, self.flag eq flag
end

pro eis_md_pipeline::initialise, main_logger
;pro eis_md_pipeline::initialise

  self.main_logger = main_logger
  *self.main_logger->log, 'eis_md_pipeline::initialise'

  self.decompressor = ptr_new(obj_new('eis_md_decompressor')) ; do in decompress?
  self.md_checker = ptr_new(obj_new('eis_md_ccsds_checker'))  ; do later?
  self.local_logger = ptr_new(obj_new('eis_logger'))

  self->init_paths
  self->init_logs
  self->open_local_log

  *self.md_checker->initialise, self.local_logger

  self.sdtp = '${HOME}/bin/sdtp'
  self.join = '${HOME}/bin/join.py'
end
