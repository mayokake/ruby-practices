# frozen_string_literal: true

require 'etc'
require 'optparse'

# Dir.chdir('/usr/bin')
# Dir.chdir('/usr/sbin')
# Dir.chdir("/Users/masataka_ikeda")

parameter = ARGV.getopts('lar')
l_option = parameter['l']
array_for_a_option = parameter['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
array_for_ar_option = parameter['r'] ? array_for_a_option.reverse : array_for_a_option
array_for_stat = array_for_ar_option.map do |string|
  File.lstat(string).ftype == 'link' ? File.lstat(string) : File.stat(string)
end
block_number = array_for_stat.map(&:blocks).sum


class ArrayWithoutLongOption
  COLUMNS = 3

  def self.transposed_array(array)
    array_without_l_option = ArrayWithoutLongOption.new(array)
    array_without_l_option.transposed_array
  end

  def transposed_array
    divisible_array.each_slice(@row_size).to_a.transpose
  end

  def initialize(array)
    @array = array
    @array_size = @array.size
    @condition = @array_size.divmod(COLUMNS)
    @element_max_size = @array.map(&:size).max
  end

  private

  def divisible_array
    @row_size = @condition[1].zero? ? @condition[0] : @condition[0] + 1
    adding_string_num = @row_size - @array_size.divmod(@row_size)[1]
    divisible_array = @array + Array.new(adding_string_num, '')
    row_width = @element_max_size > 25 ? @element_max_size : 25
    @size_ajustment = divisible_array.map { |string| string.ljust(row_width) }
  end
end

class ModeAndPermission
  def self.my_file_permission(array)
    my_file_permission = ModeAndPermission.new(array)
    my_file_permission.file_and_permission
  end

  def initialize(array1)
    @array1 = array1
    @hash1 = { 'file' => '-', 'directory' => 'd', 'characterSpecial' => 'c', 'blockSpecial' => 'b',
               'fifo' => 'p', 'link' => 'l', 'socket' => 's', 'unknown' => '?' }
    @hash2 = { '7' => 'rwx', '6' => 'rw-', '5' => 'r-x', '4' => 'r--', '3' => '-wx', '2' => '-w-', '1' => '--x',
               '0' => '---' }
    @hash3 = { '7' => 'rws', '6' => 'rwS', '5' => 'r-s', '4' => 'r-S', '3' => '-ws', '2' => '-wS', '1' => '--s',
               '0' => '--S' }
  end

  def file_and_permission
    @array1.map do |stat|
      file_permission(stat)
    end
  end

  private

  def file_type(file)
    @hash1[file.ftype]
  end

  def rwx(number)
    @hash2[number]
  end

  def id(number)
    @hash3[number]
  end

  def file_mode_owner(file)
    local_mode = file.mode.to_s(8).slice(-3)
    id_mode = file.mode.to_s(8).slice(-4)
    if id_mode == '4'
      id(local_mode)
    else
      rwx(local_mode)
    end
  end

  def file_mode_group(file)
    local_mode = file.mode.to_s(8).slice(-2)
    id_mode = file.mode.to_s(8).slice(-4)
    if id_mode == '2'
      id(local_mode)
    else
      rwx(local_mode)
    end
  end

  def file_mode_other(file)
    local_mode = file.mode.to_s(8).slice(-1)
    sticky_mode = file.mode.to_s(8).slice(-4)
    if local_mode == '4' && sticky_mode == '1'
      'r-T'
    elsif local_mode == '5' && sticky_mode == '1'
      'r-t'
    else
      rwx(local_mode)
    end
  end

  def file_permission(file)
    arr_atribute = []
    arr_atribute << file_type(file)
    arr_atribute << file_mode_owner(file)
    arr_atribute << file_mode_group(file)
    arr_atribute << file_mode_other(file)
    arr_atribute.join.ljust(11)
  end
end

class Uid
  def self.uid_information(array)
    uid = Uid.new(array)
    uid.uid_information
  end

  def uid_information
    width_uid = @array.map { |stat| Etc.getpwuid(stat.uid).name.size }.max
    @array.map { |stat| Etc.getpwuid(stat.uid).name.rjust(width_uid) }
  end

  def initialize(array)
    @array = array
  end
end

class Gid
  def self.gid_information(array)
    gid = Gid.new(array)
    gid.gid_information
  end

  def gid_information
    width_gid = @array.map { |stat| Etc.getgrgid(stat.gid).name.size }.max
    @array.map { |stat| Etc.getgrgid(stat.gid).name.rjust(width_gid) }
  end

  def initialize(array)
    @array = array
  end
end

class DateObject
  def self.date_object(array)
    date_object = DateObject.new(array)
    date_object.date_object
  end

  def initialize(array)
    @array = array
  end

  def date_object
    @array.map do |stat|
      if ((Time.now - stat.mtime) / 60 / 60 / 24).round > 365 / 2
        "#{month(stat)} #{day(stat)} #{year(stat)}"
      else
        "#{month(stat)} #{day(stat)} #{time_obj(stat)}"
      end
    end
  end

  private

  def year(stat)
    stat.mtime.year.to_s.rjust(5)
  end

  def month(stat)
    stat.mtime.month.to_s.rjust(2)
  end

  def day(stat)
    stat.mtime.day.to_s.rjust(2)
  end

  def time_obj(stat)
    stat.mtime.strftime('%H:%M')
  end
end

class ArrayWithLongOption
  def self.transposed_array(array1, array2)
    array_with_l_option = ArrayWithLongOption.new(array1, array2)
    array_with_l_option.transposed_array
  end

  def transposed_array
    matrix_with_long.transpose
  end

  def initialize(array1, array2)
    @array1 = array1
    @array2 = array2
  end

  private

  def link
    @array2.map { |stat| stat.nlink.to_s.rjust(4) }
  end

  def size
    @array2.map { |stat| stat.size.to_s.rjust(9) }
  end

  def symbolic_link
    @array1.map.with_index do |string, index|
      @array2[index].symlink? ? "-> #{File.readlink(string)}" : ''
    end
  end

  def matrix_with_long
    matrix = []
    matrix << ModeAndPermission.my_file_permission(@array2)
    matrix << link
    matrix << Uid.uid_information(@array2)
    matrix << Gid.gid_information(@array2)
    matrix << size
    matrix << DateObject.date_object(@array2)
    matrix << @array1
    matrix << symbolic_link
    matrix
  end
end

def output_display(array)
  array.each do |file|
    file.each.with_index do |element, index|
      if file.size == index + 1
        print "#{element}\n"
      else
        print element
      end
    end
  end
end

def display(array1, array2, option, block)
  if option
    puts "total #{block}"
    output_display(array2)
  else
    output_display(array1)
  end
end

array_without_l_option = ArrayWithoutLongOption.transposed_array(array_for_ar_option)
array_with_l_option = ArrayWithLongOption.transposed_array(array_for_ar_option, array_for_stat)

display(array_without_l_option, array_with_l_option, l_option, block_number)
