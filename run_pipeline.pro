
pro run_pipeline, how=interactive, flag=flag, sdate=sdate, edate=edate, stime=stime etime=etime

  eis_pipeline = obj_new('eis_md_pipeline')

  eis_pipeline->init, how=interactive, flag=flag, sdate=sdate, edate=edate, stime=stime etime=etime

  eis_pipeline->clear_old_data
  eis_pipeline->fetch_data
  eis_pipeline->check_data
  if self.force_reformat then goto, the_exit
  if self.fetch_only then goto, the_exit
  eis_pipeline->decompress_data
  eis_pipeline->reformat_data
  eis_pipeline->rescue_damaged_data ; will call self->decompress_data, /rescued ...
  eis_pipeline->compress_fits
  if self.testing then goto, skip_soda_update
  if self.special eq 'no_soda' or self.special eq 'special' then goto, skip_soda_update
  if self.special eq 'recover_test' then goto, the_exit
  eis_pipeline->update_soda
skip_soda_update:
  eis_pipeline->remove_ql
  eis_pipeline->generate_reports
  eis_pipeline->move_reports_to_darts
the_exit:
  eis_pipeline->tidy_up
  eis_pipeline->exit, 0, 'Ok'

  obj_destroy, eis_pipeline

end
