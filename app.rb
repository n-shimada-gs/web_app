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

def load_memos
  settings.db.exec('SELECT * FROM memodata').to_a
end

def find_memo(id)
  settings.db.exec_params('SELECT * FROM memodata WHERE id = $1', [id]).first
end

def create_memo(memo)
  id = SecureRandom.uuid
  settings.db.exec_params(
    'INSERT INTO memodata (id, title, details) VALUES ($1, $2, $3)',
    [id, memo['title'], memo['details']]
  )
  id
end

def updata_memo(id, memo)
  result = settings.db.exec_params(
    'UPDATE memodata SET title = $1, details = $2 WHERE id = $3',
    [memo['title'], memo['details'], id]
  )
  result.cmd_tuples.positive?
end

def delete_memo(id)
  result = settings.db.exec_params('DELETE FROM memodata WHERE id = $1', [id])
  result.cmd_tuples.positive?
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
  @memos = load_memos
  erb :index
end

get '/memos/new' do
  @memo = {}
  @errors = []
  erb :new
end

get '/memos/:id/edit' do
  @memo = find_memo(params[:id])
  if @memo.nil?
    status 404
    return erb :not_found
  end

  @errors = []
  erb :edit
end

get '/memos/:id' do
  @memo = find_memo(params[:id])
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

  id = create_memo(@new_memo)
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

  unless updata_memo(params[:id], @memo)
    status 404
    return erb :not_found
  end

  redirect "/memos/#{params['id']}"
end

delete '/memos/:id' do
  unless delete_memo(params[:id])
    status 404
    return erb :not_found
  end

  redirect '/memos'
end

not_found do
  erb :not_found
end
