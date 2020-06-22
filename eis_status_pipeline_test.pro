;.comp eis_md_pipeline__define
;.comp run_pipeline
;.comp eis_pipeline__flag_handling

;run_pipeline, flag='fetch_only'

;;;run_eis_status_pipeline, start_date='20150401', end_date='20150403', start_time='1030', end_time='1100', flag='no_soda', /interactive

;run_eis_status_pipeline, start_date='20150401', end_date='20150402', start_time='0000', end_time='1030', flag='fetch_only', /scheduled
;run_eis_status_pipeline, start_date='20150401', end_date='20150402', start_time='0000', end_time='1030', flag='force_reformat', /scheduled


;;;run_eis_status_pipeline, start_date='20180120', end_date='20180120', flag='force_reformat', /scheduled, /trace
;;;run_eis_status_pipeline, start_date='20180120', end_date='20180120', flag='force_reformat', /scheduled
;run_eis_status_pipeline, start_date='20171225', end_date='20171226', flag='force_reformat', /scheduled, /trace
;run_eis_status_pipeline, '20150401', '20150403', '1030', '1100', flag='no_soda', /interactive

;run_eis_status_pipeline, start_date='20180525', end_date='20180526', /fetch_only, /trace

;;run_eis_status_pipeline, start_date='20180525', end_date='20180526', /no_fetch, /no_split, /trace

run_eis_status_pipeline, start_date='20200604', end_date='20206005', /verbose, /trace, /no_fetch, /no_soda
