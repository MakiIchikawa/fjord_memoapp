# frozen_string_literal: true

require 'sinatra'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect to('/top')
end

get '/top' do
  @title = 'top|memoapp'
  memo = []
  Dir.children('./memos').sort.each do |f|
    file = File.open("./memos/#{f}", 'r')
    file_content = file.read.split(/(, )/)
    memo.push([File.basename(f, '.*'), file_content[0]])
    file.close
  end
  @memo = memo
  erb :top
end

get '/memos' do
  erb :new
end

post '/memos' do
  max_number = 0
  Dir.each_child('./memos') do |f|
    number = File.basename(f, '.*').to_i
    max_number = number > max_number ? number : max_number
  end
  File.open("./memos/#{max_number + 1}.txt", 'w') do |f|
    f.print(h(params[:title]) + ', ' + h(params[:content]))
  end
  logger.info 'create new'
  redirect to('/top')
end

get '/memos/:id' do
  @memo_id = params[:id]
  file = File.open("./memos/#{params[:id]}.txt")
  file_content = file.read.split(/(, )/)
  file.close
  @memo_title = file_content[0]
  @memo_content = file_content[2]
  erb :show
end

delete '/memos/:id' do
  File.delete("./memos/#{params[:id]}.txt")
  logger.info 'delete'
  redirect to('/top')
end

get '/edit/:id' do
  @memo_id = params[:id]
  file = File.read("./memos/#{params[:id]}.txt")
  file_content = file.split(/(, )/)
  @memo_title = file_content[0]
  @memo_content = file_content[2]
  erb :edit
end

patch '/memos/:id' do
  File.open("./memos/#{params[:id]}.txt", 'w') do |f|
    f.print(h(params[:title]) + ', ' + h(params[:content]))
  end
  logger.info 'update'
  redirect to('/top')
end
