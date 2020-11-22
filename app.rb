# frozen_string_literal: true

require 'sinatra'
require 'readline'
require 'csv'
require './memo.rb'

get '/' do
  redirect to('/top')
end

get '/top' do
  @title = 'top|memoapp'
  @memo = Memo.read_all
  erb :top
end

get '/memo' do
  erb :new
end

post '/memo' do
  memo = Memo.new
  memo.write(params[:title], params[:content])
  p '保存しました'
end

get '/memo/:id' do
  @memo_id = params[:id]
  memo = Memo.new(params[:id])
  memo_array = memo.read
  @memo_title = memo_array[0]
  @memo_content = memo_array[1].gsub(/\R/, '<br>')
  erb :show
end

delete '/memo/:id' do
  memo = Memo.new(params[:id])
  memo.delete
  p '削除しました'
end

get '/edit/:id' do
  @memo_id = params[:id]
  memo = Memo.new(params[:id])
  memo_array = memo.read
  @memo_title = memo_array[0]
  @memo_content = memo_array[1].gsub(/\R/, '&#13;')
  erb :edit
end

patch '/memo/:id' do
  memo = Memo.new(params[:id])
  memo.write(params[:title], params[:content])
  p '変更しました'
end
