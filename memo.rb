# frozen_string_literal: true

# Class that handles memo information
class Memo
  attr_reader :id
  def initialize(id = nil)
    if id
      @id = id
    else
      max_number = 0
      Memo.read_all.each do |memo|
        max_number = memo[0].to_i > max_number ? memo[0].to_i : max_number
      end
      @id = max_number + 1
    end
  end

  def read
    file = []
    File.open("./memo/#{@id}.txt") do |f|
      file = f.read.split(/(",")/)
    end
    title = file[0].gsub(/^"/, '')
    content = file[2].gsub(/"$/, '')
    [title, content]
  end

  def write(title, content)
    File.open("./memo/#{@id}.txt", 'w') do |f|
      f.print("\"#{title}\",\"#{content.gsub(/\\r\\n?/, "\n")}\"")
    end
  end

  def self.read_all
    memo_all = []
    Dir.children('./memo').sort.each do |child|
      File.open("./memo/#{child}", 'r') do |f|
        file_content = f.readline.split(/(",")/)
        memo_all.push([File.basename(child, '.*'), file_content[0].gsub(/^"/, '')])
      end
    end
    memo_all
  end
end
