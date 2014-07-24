server "107.170.100.69", :app, :web, :db, :primary => true
set :deploy_to, "/var/deploy/capistrano/lms"
set :branch,    "deploy"
set :scm_passphrase, ""
set :smart_lms_data_files, "#{deploy_to}/data/files"

