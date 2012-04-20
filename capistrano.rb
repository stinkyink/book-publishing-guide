set :application,       'publishing-guide'
set :repository,        '_site'
set :scm,               :none
set :deploy_via,        :copy
set :copy_compression,  :gzip
set :use_sudo,          false
set :host,              'lb1.stinkyink.com'

role :web,  host
role :app,  host
role :db,   host, :primary => true

set :user, 'deploy'

set(:dest) { Capistrano::CLI.ui.ask("Destination: ") }

set :deploy_to,    "/home/#{user}/#{application}"

before 'deploy:update', 'deploy:update_jekyll'

namespace :deploy do

  [:start, :stop, :restart, :finalize_update].each do |t|
    desc "#{t} task is a no-op with jekyll"
    task t, :roles => :app do ; end
  end
  
  desc 'Run jekyll to update site before uploading'
  task :update_jekyll do
    %x(rm -rf _site/* && jekyll --no-auto)
  end
end