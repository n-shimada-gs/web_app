# frozen_string_literal: true

require 'pg'
require 'rack/utils'
require 'securerandom'
require 'sinatra'

enable :method_override

DB_PARAMS = {
  host: ENV.fetch('DB_HOST', 'localhost'),
  user: ENV.fetch('DB_USER', 'postgres'),
  password: ENV.fetch('DB_PASSWORD', 'postgres'),
  dbname: ENV.fetch('DB_NAME', 'memoapp'),
  port: ENV.fetch('DB_PORT', '5432')
}.freeze

configure do
  set :db, PG.connect(DB_PARAMS)
end

helpers do
  def h(value)
    Rack::Utils.escape_html(value)
  end
end

def memo_params
  {
    'title' => params['title'].to_s,
    'details' => params['details'].to_s
  }
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = settings.db.exec('SELECT * FROM memodata').to_a

  erb :index
end

get '/memos/new' do
  @memo = {}
  @errors = []
  erb :new
end

get '/memos/:id/edit' do
  result = settings.db.exec_params('SELECT * FROM memodata WHERE id = $1', [params[:id]])

  @memo = result.first
  if @memo.nil?
    status 404
    return erb :not_found
  end

  @errors = []
  erb :edit
end

get '/memos/:id' do
  result = settings.db.exec_params('SELECT * FROM memodata WHERE id = $1', [params[:id]])

  @memo = result.first
  if @memo.nil?
    status 404
    return erb :not_found
  end

  erb :show
end

post '/memos' do
  @new_memo = memo_params
  @errors = []

  if @new_memo['title'].strip.empty?
    @errors << 'タイトルを入力してください'
    status 422
    return erb :new
  end

  id = SecureRandom.uuid

  settings.db.exec_params(
    'INSERT INTO memodata (id, title, details) VALUES ($1, $2, $3)',
    [id, @new_memo['title'], @new_memo['details']]
  )

  redirect "/memos/#{id}"
end

patch '/memos/:id' do
  @memo = memo_params
  @errors = []

  if @memo['title'].strip.empty?
    @errors << 'タイトルを入力してください'
    status 422
    @memo['id'] = params[:id]
    return erb :edit
  end

  result = settings.db.exec_params(
    'UPDATE memodata SET title = $1, details = $2 WHERE id = $3',
    [@memo['title'], @memo['details'], params[:id]]
  )

  if result.cmd_tuples.zero?
    status 404
    return erb :not_found
  end

  redirect "/memos/#{params['id']}"
end

delete '/memos/:id' do
  result = settings.db.exec_params('DELETE FROM memodata WHERE id = $1', [params[:id]])

  if result.cmd_tuples.zero?
    status 404
    return erb :not_found
  end

  redirect '/memos'
end

not_found do
  erb :not_found
end
