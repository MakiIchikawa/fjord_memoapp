# frozen_string_literal: true

require 'sinatra'
require 'readline'

get '/' do
  redirect to('/top')
end

get '/top' do
  @title = 'top|memoapp'
  memo = []
  Dir.children('./memo').sort.each do |f|
    file = File.open("./memo/#{f}", 'r')
    file_content = file.readline.split(/,/)
    memo.push([File.basename(f, '.*'), file_content[0]])
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

get '/memo/:id' do
  @memo_id = params[:id]
  file = File.open("./memo/#{params[:id]}.txt", 'r')
  file_content = file.readline.split(/,/)
  @memo_title = file_content[0]
  @memo_content = file_content[1]
  file.close
  erb :show
end

delete '/memo/:id' do
  File.delete("./memo/#{params[:id]}.txt")
  p '削除しました'
end

get '/edit/:id' do
  @memo_id = params[:id]
  file = File.open("./memo/#{params[:id]}.txt", 'r')
  file_content = file.readline.split(/,/)
  @memo_title = file_content[0]
  @memo_content = file_content[1]
  file.close
  erb :edit
end

patch '/memo/:id' do
  file = File.open("./memo/#{params[:id]}.txt", 'w')
  file.write("#{params[:title]},#{params[:content]}")
  file.close
  p '変更しました。'
end
