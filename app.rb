# frozen_string_literal: true

require 'sinatra'
require 'readline'

get '/' do
  redirect to('/top')
end

get '/top' do
  @title = 'top|memoapp'
  memo = []
  Dir.each_child('./memo') do |f|
    file = File.open("./memo/#{f}", 'r')
    content = file.readline.split(/,/)
    memo.push([File.basename(f, '.*'), content[0]])
    file.close
  end
  @memo = memo
  erb :top
end

get '/memo' do
  erb :new
end

post '/memo' do
  max_number = 0
  Dir.each_child('./memo') do |f|
    number = File.basename(f, '.*').to_i
    max_number = number > max_number ? number : max_number
  end
  File.open("./memo/#{max_number + 1}.txt", 'w') do |f|
    f.write("#{params[:title]},#{params[:content]}")
  end
  p '保存しました'
end
