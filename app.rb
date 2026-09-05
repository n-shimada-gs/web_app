# frozen_string_literal: true

require 'json'
require 'rack/utils'
require 'securerandom'
require 'sinatra'

enable :method_override

MEMOS_FILE = File.join(__dir__, 'data', 'memos.json')

helpers do
  def h(value)
    Rack::Utils.escape_html(value)
  end
end

def load_memos
  JSON.parse(File.read(MEMOS_FILE))
end

def save_memos(memos)
  File.write(MEMOS_FILE, "#{JSON.pretty_generate(memos)}\n")
end

def find_memo(id)
  load_memos.find { |memo| memo['id'] == id }
end

def find_memo_from(memos, id)
  memos.find { |memo| memo['id'] == id }
end

def memo_params
  {
    'title' => params['title'].to_s,
    'details' => params['details'].to_s
  }
end

get '/' do
  redirect '/top'
end

get '/top' do
  @memos = load_memos
  erb :index
end

get '/top/new' do
  @memo = {}
  @errors = []
  erb :new
end

get '/top/:id/edit' do
  @memo = find_memo(params['id'])
  if @memo.nil?
    status 404
    return erb :not_found
  end

  @errors = []
  erb :edit
end

get '/top/:id' do
  @memo = find_memo(params['id'])
  if @memo.nil?
    status 404
    return erb :not_found
  end

  erb :show
end

post '/top' do
  @new_memo = memo_params
  @errors = []

  if @new_memo['title'].strip.empty?
    @errors << 'タイトルを入力してください'
    status 422
    return erb :new
  end

  memos = load_memos
  memo = { 'id' => SecureRandom.uuid }.merge(@new_memo)
  memos << memo
  save_memos(memos)

  redirect "/top/#{memo['id']}"
end

patch '/top/:id' do
  memos = load_memos
  memo = find_memo_from(memos, params['id'])
  if memo.nil?
    status 404
    return erb :not_found
  end

  @memo = memo.merge(memo_params)
  @errors = []

  if @memo['title'].strip.empty?
    @errors << 'タイトルを入力してください'
    status 422
    return erb :edit
  end

  memo.merge!(@memo)
  save_memos(memos)

  redirect "/top/#{memo['id']}"
end

delete '/top/:id' do
  memos = load_memos
  memo = find_memo_from(memos, params['id'])
  if memo.nil?
    status 404
    return erb :not_found
  end

  memos.delete(memo)
  save_memos(memos)

  redirect '/top'
end

not_found do
  erb :not_found
end

get '/error-example' do
  raise '確認用のエラー'
end
