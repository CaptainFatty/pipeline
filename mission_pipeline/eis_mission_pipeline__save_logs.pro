
pro eis_mission_pipeline::save_logs
  self->trace, 'eis_mission_pipeline__save_logs::save_logs'

  self->eis_pipeline::save_logs
  
end
