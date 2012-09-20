require 'etc'
require 'colorize'
require 'iconv'

CUSTOMIZATIONS = []
ICONV = Iconv.new('UTF-8//IGNORE', 'UTF-8')

class Customization
    def initialize(regex, action)
        @regex = regex
        @action = action
    end

    def action
        @action
    end

    def regex
        @regex
    end
end

def if_seen(regex, &action)
    CUSTOMIZATIONS << Customization.new(regex, action)
end

def load_user_preferences
    user_pref = File.join(Etc.getpwuid.dir, ".stream_prettifier")
    load user_pref if File.exists?(user_pref)    
end

def apply_color(line)
    CUSTOMIZATIONS.each do |c|
        line = ICONV.iconv(line + ' ')[0..-2]
        line = c.action.call(line) if line.match(c.regex)
    end
    line
end
