#!/Users/masataka_ikeda/.rbenv/versions/3.0.1/bin/ruby
# frozen_string_literal: true

require 'optparse'

parameter = ARGV.getopts('l')
l_option = parameter['l']
files = Dir.glob('*').filter_map { |string| string if File.stat(string).ftype == 'file' }
files_from_argument = ARGV.select { |string| files.include?(string) }

class WordCount
  def self.informations(array, option)
    word_count = WordCount.new(array, option)
    word_count.informations
  end

  def informations
    @array_file_read.each.with_index do |string, i|
      merge_information(string)
      puts " #{@array[i]}"
    end
    total if @array_file_read.size != 1
  end

  def initialize(array, option)
    @array = array
    @option = option
    @array_file_read = @array.map { |string| File.read(string) }
  end

  private

  def merge_information(string)
    lines = lines_number(string).to_s.rjust(8)
    if @option == true
      print lines.to_s
    else
      words = words(string).to_s.rjust(8)
      bytes = bytes(string).to_s.rjust(8)
      print "#{lines}#{words}#{bytes}"
    end
  end

  def total
    lines = lines_number_sum.to_s.rjust(8)
    if @option == true
      puts "#{lines} total"
    else
      words = words_sum.to_s.rjust(8)
      bytes = bytes_sum.to_s.rjust(8)
      puts "#{lines}#{words}#{bytes} total"
    end
  end

  def lines_number(string)
    string.count("\n")
  end

  def words(string)
    string.split(/\s/).count { |item| item.empty? != true }
  end

  def bytes(string)
    string.bytesize
  end

  def lines_number_sum
    numbers = @array_file_read.map { |string| lines_number(string) }
    numbers.sum
  end

  def words_sum
    number = @array_file_read.map { |string| words(string) }
    number.sum
  end

  def bytes_sum
    num = @array_file_read.map { |string| bytes(string) }
    num.sum
  end
end

class WordCountFromStdin
  def self.info_from_stdin(input, option)
    word_count_from_input = WordCountFromStdin.new(input, option)
    word_count_from_input.info_from_stdin
  end

  def info_from_stdin
    lines = line.to_s.rjust(8)
    if @option == true
      puts lines.to_s
    else
      words = word.to_s.rjust(8)
      bytes = byte.to_s.rjust(8)
      puts "#{lines}#{words}#{bytes}"
    end
  end

  def initialize(input, option)
    @input = input
    @option = option
  end

  private

  def line
    @input.count("\n")
  end

  def word
    @input.split(/\s/).count { |item| item.empty? != true }
  end

  def byte
    @input.bytesize
  end
end

if files_from_argument.empty?
  input = $stdin.read
  WordCountFromStdin.info_from_stdin(input, l_option)
else
  WordCount.informations(files_from_argument, l_option)
end
