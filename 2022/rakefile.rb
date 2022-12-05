require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['day*.rb']
  t.verbose = true
end
