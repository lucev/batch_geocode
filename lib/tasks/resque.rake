require 'resque'
require 'resque/tasks'

namespace :resque do
  task :setup do
    require "#{ROOT_PATH}/lib/geocoder_job"
  end
end
