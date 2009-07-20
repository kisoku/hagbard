module Hagbard

  require 'rubygems'

begin
  require 'securerandom'
rescue LoadError
  require 'activesupport'
end

  require 'hagbard/constants'

  VERSION = '0.0.1'

  class Coin
    def self.throw
begin
      SecureRandom.random_number(2)
rescue
      ActiveSupport::SecureRandom.random_number(2)
end
    end
  end

  class FourCoin
    def self.throw
      r = []
      1.upto(4) do |i|
        coin = Coin.throw
        if i == 3 and coin == 0
          coin = 1
        else
           coin = coin * i
        end
        r << coin
      end
      sum = r[0] + r[1] + r[2] + r[3]
      if r[2] == 1
        if sum < 8
          6
        else
          8
        end
      elsif r[2] == 3
        if sum < 8
          7
        else
          9
        end
      else
        raise RuntimeError, "3rd coin MUST be 3 or 1"
      end
    end
  end

  class Line
    attr_accessor :value
    def initialize(value)
      if value < 6 or value > 9
        raise ArgumentError, "invalid value, must be between 6 and 9"
      else
        @value = value
      end
    end

    def to_i
      @value
    end

    def to_s
      case @value
        when 6 then '---x---'
        when 7 then '-------'
        when 8 then '--- ---'
        when 9 then '---o---'
        else 
           raise "invalid toss result"
      end
    end
 
    def to_haml
      %Q{%img{:src => "/images/#{value}.png", :alt => "#{to_s}"}}
    end
   
    def yin?
      @value == 6 or @value == 8      
    end

    def yang?
      @value == 7 or @value == 9
    end
 
    def changing?
      @value == 6 or @value == 9
    end

    def becomes?
      case @value
        when 6 then Line.new(7)
        when 9 then Line.new(8)
        else return self
      end
    end
 
    def change!
      case @value
        when 6 then @value= 7
        when 9 then @value= 8
      end
    end
  end

  class TriGram
    attr_accessor :lines

    def initialize(args = {})
      @lines = []

      if args.empty?
        1.upto(3) do
          @lines << Line.new(FourCoin.throw)
        end
      else
        if args.has_key?(:number)
          trigram = Hagbard::TRIGRAMS.find { |t| t[:number] == args[:number] }
        elsif args.has_key?(:name)
          trigram = Hagbard::TRIGRAMS.find { |t| t[:name] == args[:name] }
        elsif args.has_key?(:bin)
          trigram = Hagbard::TRIGRAMS.find { |t| t[:bin] == args[:bin] }
        end
 
        if trigram.nil?
          raise ArgumentError, "Invalid argument for TriGram"
        else
          trigram[:bin].each_char { |c|
            case c
              when "0" then @lines << Line.new(8)
              when "1" then @lines << Line.new(7)
            end
          }
        end
      end
    end

    def to_bin
      bin = ""
      @lines.each do |line|
        if line.yang?
          bin << "1"
        elsif line.yin?
          bin << "0"
        else
          raise RunTimeError, "Invalid line"
        end
      end
      return bin
    end

    def name
      Hagbard::TRIGRAMS.find { |t| t[:bin] == to_bin }[:name]
    end

    def number
      Hagbard::TRIGRAMS.find { |t| t[:bin] == to_bin }[:number]
    end

    def to_s
      s = ""
      @lines.reverse.each do |line|
         s << line.to_s + "\n"
      end
      return s
    end

    def to_haml
      s = ""
      @lines.reverse.each do |line|
         s << line.to_haml + "\n"
      end
      return s
    end

    def change!
      @lines.each do |line|
        line.change!
      end
    end
  end

  class HexaGram
    attr_accessor :inner, :outer

    def initialize(args = {})
      if args.empty?
        @outer = TriGram.new
        @inner = TriGram.new
      else
        if args.has_key?(:number)
          hexagram = Hagbard::HEXAGRAMS.find { |h| h[:number] == args[:number] }
        end
        
        if hexagram.nil?
          raise ArgumentError, "Invalid argument for Hexagram"
        else
          @outer = TriGram.new(:bin => hexagram[:bin].slice(0..2))
          @inner = TriGram.new(:bin => hexagram[:bin].slice(3..5))
        end
      end
      
    end
    
    def to_bin
      @outer.to_bin + @inner.to_bin
    end
  
    def name
      Hagbard::HEXAGRAMS.find { |h| h[:bin] == to_bin }[:name]
    end

    def number
      Hagbard::HEXAGRAMS.find { |h| h[:bin] == to_bin }[:number]
    end

    def to_s
      @inner.to_s + @outer.to_s
    end

    def to_haml
      @inner.to_haml + @outer.to_haml
    end

    def change!
      @inner.change!
      @outer.change!
    end
  end
end
