# frozen_string_literal: true

require 'sinatra'
require 'readline'

get '/' do
  redirect to('/top')
end

get '/top' do
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
