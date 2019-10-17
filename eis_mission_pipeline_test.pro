;.comp eis_md_pipeline__define
;.comp run_pipeline
.comp eis_pipeline__flag_handling

;run_pipeline, flag='fetch_only'

;;;run_pipeline, start_date='20150401', end_date='20150403', start_time='1030', end_time='1100', flag='no_soda', /interactive
run_eis_mission_pipeline, start_date='20150401', end_date='20150403', start_time='1030', end_time='1100', flag='no-soda'

;run_pipeline, '20150401', '20150403', '1030', '1100', flag='no_soda', /interactive
