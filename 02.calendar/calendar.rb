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
      @year = :y
      @month = :m
  end

  def get_year
    if @options.include?(@year) && @options[@year] != nil
      @options[@year].to_i
    else
      Date.today.strftime("%Y").to_i
    end
  end

  def get_month
   if @options.include?(@month) && @options[@month] != nil
      @options[@month].to_i
    else
      Date.today.strftime("%m").to_i
    end
  end
end

# カレンダー作成まで
class CalReady
  def initialize(a, b)
    @a = a
    @b = b
  end
  def cal_days
    day_first = Date.new(@a, @b)
    day_last = Date.new(@a, @b, -1)
    @days = (day_last - day_first).to_i + 1
    yohaku = Date.parse("#{@a}-#{@b}-1")
    yohaku_margin = yohaku.strftime('%u')
    @margin = yohaku_margin.to_i % 7
  end

  def day_for_display
    Array.new(@days) do |index|
      if index == 0
        " " * 3 * (@margin) + " 1 "
      elsif  
        index < 9
        " #{index + 1} "
      else
        "#{index + 1} "
      end
    end
  end

  def kazari
    haba = "10 11 12 13 14 15 16".length
    puts ("#{@b}月 #{@a}").center(haba)
    puts "日 月 火 水 木 金 土"
  end

  def display
    day_for_display.each do |youso|
      if Date.parse("#{@a}-#{@b}-#{youso.to_i}").strftime('%a') == "Sat"
        print youso.to_s + "\n"
      elsif youso.to_i == day_for_display.length
        print youso.to_s + "\n"
      else
        print youso.to_s
      end
    end
  end

end

# コマンドラインから引数（年と月）を取得
# オプションの指定がない場合は、現在の年月を取得
arguments  = YearMonth.new
year = arguments.get_year
month = arguments.get_month


# カレンダー作成
calender = CalReady.new(year, month)
calender.cal_days
calender.day_for_display
calender.kazari
calender.display
