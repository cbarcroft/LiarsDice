task :default => [:travis]

task :travis do
    puts "Starting to run cucumber..."
    system("export DISPLAY=:99.0 && bundle exec cucumber -r lib -v")
    raise "Cucumber failed!" unless $?.exitstatus == 0
end