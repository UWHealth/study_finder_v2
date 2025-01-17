# config valid for current version and patch releases of Capistrano
lock "~> 3.18.0"

desc "Run on build server"
# get the server name from the environment variable regardless of the stage or environment
set :application, "study_finder"
set :server_name, -> { ENV['SERVER'] || 'server_not_set' }
set :base_path, "/var/www/webapps/#{fetch(:application)}"
set :local_project_dir, Dir.pwd

server fetch(:server_name), user: 'capistrano', roles: %w{app db web}
set :deploy_to, "#{fetch(:base_path)}"
set :passenger_restart_with_touch, true
set :deploy_via, :copy # Copy the files across as an archive rather than using git on the remote machine.
set :bundle_flags, '--deployment --verbose'

namespace :deploy do
  desc "Upload the local project files to the remote server"
  task :upload_local_files do
    on roles(:app) do
      puts "Uploading files from #{fetch(:local_project_dir)} to #{release_path}"
      upload! "#{fetch(:local_project_dir)}/", "#{release_path}", recursive: true
    end
  end
  before :starting, :upload_local_files
end

# execute "mkdir -p #{release_path}"
# desc "Fix permission"
# task :fix_permissions, :roles => [ :web ] do
#   run "chmod 775 -R #{release_path}"
# end

# If you need to exclude a 'local' environment use this (default is %w{development test}):
# set :bundle_without, %w{development test local}.join(' ')

# Default value for :linked_files is []
append :linked_files, "config/application.yml", "config/database.yml, config/secrets.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "storage"

set :keep_releases, 5


