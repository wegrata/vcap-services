# Copyright (c) 2009-2011 VMware, Inc.
require 'time'

SERVICES = 5
INSTANCES_PER_SERVICE = 100
BACKUPS_PER_INSTANCE = 10
GUID_LENGTH = 20
GUID_CHARS = ('a'..'f').to_a + ('0'..'9').to_a
DAYS_BACK = 15
ONE_DAY = 60*60*24

# when called from the command line, generate backups relative to now
# when called from unit tests, generated backups relative to the mock manager's timestamp
TIMESTAMP = ($0==__FILE__ ? Time.now : Time.parse("2010-01-20 09:10:20 UTC")).to_i

def populate_complicated(root)
  puts "#{File.basename(__FILE__)}: Populating complicated test directory #{root}..."
  puts "  ... deleting old data"
  system "rm -rf #{File.join(root, "service*")}"
  (1 .. SERVICES).each { |s|
    puts "  ... service #{s} of #{SERVICES}"
    INSTANCES_PER_SERVICE.times {
      guid = ''
      GUID_LENGTH.times {
        guid << GUID_CHARS[rand(GUID_CHARS.length)]
      }
      BACKUPS_PER_INSTANCE.times {
        begin
          timestamp = TIMESTAMP - (ONE_DAY*DAYS_BACK*rand).to_i
          path = File.join(root, "service#{s}", guid[0,2], guid[2,2], guid[4,2], guid, timestamp.to_s)
        end while Dir.exist?(path) # make sure our random timestamps don't collide
        system "mkdir -p #{path}"
        system "touch #{path}/data"
      }
    }
  }
  puts "#{File.basename(__FILE__)}: Done populating complicated test directory"
end

# when called from the command line, just do it
# when called from the unit tests, the unit tests need to make it happen explicitly
populate_complicated(File.dirname(__FILE__)) if $0==__FILE__
