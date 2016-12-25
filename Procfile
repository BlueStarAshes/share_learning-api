web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: shoryuken -r ./workers/load_new_courses_worker.rb -C ./workers/shoryuken.yml
