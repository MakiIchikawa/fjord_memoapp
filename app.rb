# frozen_string_literal: true

require 'sinatra'
require 'readline'
require 'csv'

get '/' do
  redirect to('/top')
end

get '/top' do
  @title = 'top|memoapp'
  memo = []
  Dir.children('./memo').sort.each do |f|
    file = File.open("./memo/#{f}", 'r')
    file_content = file.readline.split(/(",")/)
    memo.push([File.basename(f, '.*'), file_content[0].gsub(/^"/, '')])
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
    f.print("\"#{params[:title]}\",\"#{params[:content]}\"")
  end
  p '保存しました'
end

get '/memo/:id' do
  @memo_id = params[:id]
  file = File.open("./memo/#{params[:id]}.txt")
  p file_content = file.read.split(/(",")/)
  file.close
  @memo_title = file_content[0].gsub(/^"/, '')
  @memo_content = file_content[2].gsub(/"$/, '').gsub(/\R/, '<br>')
  erb :show
end

delete '/memo/:id' do
  File.delete("./memo/#{params[:id]}.txt")
  p '削除しました'
end

get '/edit/:id' do
  @memo_id = params[:id]
  file = File.read("./memo/#{params[:id]}.txt")
  file_content = file.split(/(",")/)
  @memo_title = file_content[0].gsub(/^"/, '')
  @memo_content = file_content[2].gsub(/"$/, '').gsub(/\R/, '&#13;')
  erb :edit
end

patch '/memo/:id' do
  File.open("./memo/#{params[:id]}.txt", 'w') do |f|
    f.print("\"#{params[:title]}\",\"#{params[:content]}\"")
  end
  p '変更しました。'
end
