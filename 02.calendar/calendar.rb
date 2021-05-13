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
    if @options[:y] != nil
      @options[:y].to_i
    else
      Date.today.year
    end
  end

  def month
    if @options[:m] != nil
      @options[:m].to_i
    else
      Date.today.month
    end
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

  def calendar_range
    rng = []
    (first_day..last_day).each {|d| rng << d.to_s}
  end

  def margin
    margin = first_day.wday
  end

  def final_day
    last_day.day
  end

  def make_calendar
    puts ("#{@month}月 #{@year}").center(20)
    puts "日 月 火 水 木 金 土"
    print " " * 3 * margin
    temp = []
    cal = calendar_range.each {|d| temp << d.to_s}
    cal.each do |element|
      if element.saturday? || element.day == final_day
        print element.day.to_s.rjust(2) + " "+ "\n"
      elsif
        print element.day.to_s.rjust(2) + " "
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
calendar.make_calendar
