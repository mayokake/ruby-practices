#!/Users/masataka_ikeda/.rbenv/versions/3.0.1/bin/ruby
require "optparse"
require "date"

# オプションから引数(年と月）を受け取るためのクラスを定義
class YearMonth
  def initialize
    @options = {}
    opts = OptionParser.new
      opts.on("-y [YEAR]") { |year| @options[:y] = year }
      opts.on("-m [MONTH]") { |month| @options[:m] = month }
      opts.parse!(ARGV)
  end

  def year
    @options[:y]&.to_i || Date.today.year
  end

  def month
    @options[:m]&.to_i || Date.today.month
  end
end

# カレンダー作成まで
class CalReady
  def initialize(year, month)
    @year = year
    @month = month
  end

  def first_day
    first_day = Date.new(@year, @month, 1)
  end

  def last_day
    last_day = Date.new(@year, @month, -1)
  end

  def calendar_output
    puts ("#{@month}月 #{@year}").center(20)
    puts "日 月 火 水 木 金 土"
    print " " * 3 * first_day.wday
    (first_day..last_day).each do |date|
      if date.saturday? || date == last_day
        print date.day.to_s.rjust(2) + " "+ "\n"
      elsif
        print date.day.to_s.rjust(2) + " "
      end
    end
  end
end

# コマンドラインから引数（年と月）を取得
# オプションの指定がない場合は、現在の年月を取得
arguments  = YearMonth.new
year = arguments.year
month = arguments.month
# カレンダー作成
calendar = CalReady.new(year, month)
calendar.calendar_output
