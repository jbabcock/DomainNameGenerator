require 'dnsruby'
include Dnsruby
require 'whois'
require 'optparse'

class DomainNameGenerator

  MAX_WORD_LENGTH = 6

  def initialize(fn = "wordlist.txt")
    @file = File.new(fn, "r")
    @res = Dnsruby::Resolver.new
    @who = Whois::Client.new
    @counter = 0
    @performwhois = false # default off
    OptionParser.new do |opts|
      opts.banner = "Usage: DomainNameGenerator.rb <options> baseword"
      opts.on('-w', '--whois', "Perform a WHOIS check as well") { @performwhois = true}
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
      begin
        @domainword = opts.parse![0]
        if @domainword.to_s.length == 0
          puts "ERROR: Missing baseword"
          puts opts
          exit
        end
      rescue OptionParser::InvalidOption, OptionParser::MissingArgument
        puts $!.to_s
        puts opts
        exit
      end
    end
  end

  def get_next
    line = @file.gets
    unless line.nil?
      line.to_s.strip
    end
  end

  def done
    @file.close
  end

  def process
    puts "Searching for domain for word: #{@domainword}"
    puts "Using whois? : #{@performwhois}"
    puts "-------------------------"
    while ((word = get_next))
      if (word.length <= DomainNameGenerator::MAX_WORD_LENGTH)
        # {word}print
        dnsname = "#{word}#{@domainword}.com"
        if is_available(dnsname)
          puts "#{dnsname}"
        end
        @counter = @counter + 1
        # print{word}
        dnsname = "#{@domainword}#{word}.com"
        if is_available(dnsname)
          puts "#{dnsname}"
        end
        @counter = @counter + 1
        
        if (@counter >= 10)
          @counter = 0
          sleep 3 # rest a bit
        end
      end
    end
  end

  def is_available(dnsname) # check whether exists in DNS, optionally check whois if not in DNS
    available = false
    if check_dns_availability(dnsname)
      if @performwhois
        if check_registrar_availability(dnsname)
          available = true # available in DNS and whois
        end
      else
        available = true # did not check whois, is available in DNS
      end
    end
    available
  end

  def check_dns_availability(dnsname)
    begin
      @res.query(dnsname)
    rescue Dnsruby::NXDomain, Dnsruby::ServFail # catch does not exist, mark as true for available
      true
    else # does exist, mark as not available
      false
    end
  end

  def check_registrar_availability(dnsname)
    a = @who.query(dnsname)
    a.available? # return whether it's available or not
  end

end

gen = DomainNameGenerator.new
gen.process
gen.done
