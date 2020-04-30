pro eis_pipeline::init_paths
  self->trace, 'eis_pipeline::init_paths'
;  print, 'eis_pipeline::init_paths'
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
