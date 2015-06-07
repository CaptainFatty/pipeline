pro eis_md_pipeline::rescue_damaged_data
  
  self->decompress_data, /rescued
  self->reformat_data, /rescued
end
