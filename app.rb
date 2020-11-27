# frozen_string_literal: true

require 'sinatra'
require 'pg'
require './memo.rb'

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
  @memo = Memo.read_all
  erb :top
end

get '/memos' do
  erb :new
end

post '/memos' do
  memo = Memo.new
  memo.insert(params[:title], params[:content])
  logger.info 'create new'
  redirect to('/top')
end

get '/memos/:id' do
  @memo_id = params[:id]
  memo = Memo.new(params[:id])
  memo_array = memo.read.flatten
  @memo_title = memo_array[0]
  @memo_content = memo_array[1]
  erb :show
end

delete '/memos/:id' do
  memo = Memo.new(params[:id])
  memo.delete
  logger.info 'delete'
  redirect to('/top')
end

get '/edit/:id' do
  @memo_id = params[:id]
  memo = Memo.new(params[:id])
  memo_array = memo.read.flatten
  @memo_title = memo_array[0]
  @memo_content = memo_array[1]
  erb :edit
end

patch '/memos/:id' do
  memo = Memo.new(params[:id])
  memo.update(params[:title], params[:content])
  logger.info 'update'
  redirect to('/top')
end
