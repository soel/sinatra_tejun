# -*- coding: utf-8 -*-
require 'sinatra'
require 'sinatra/reloader'
require 'rack/csrf'
require 'erb'
include ERB::Util
require 'time'
#require './utils.rb' #ユーティリティを外部ファイルにまとめる
require './before.rb' #/before の処理については別ファイル
require './new_switch.rb' #/new_switch の処理については別ファイル
require './after.rb' #/after の処理については別ファイル

default_url = "http://localhost:4567"
default_dir = "/var/www/html/sinatra/"

#トップレベルのアドレスはグローバル変数化
before do
	@before_link = '/before'
	@before_link_name = 'before'
	@after_link = '/after'
	@after_link_name = 'after'
	@new_switch_link = '/new_switch'
	@new_switch_link_name = 'new_switch'
end

configure do
  set :app_file, __FILE__
  use Rack::Session::Cookie, :secret => 'bbtwebapp'
  use Rack::Csrf, :raise => true
end

helpers do
  def csrf_token
    Rack::Csrf.csrf_token(env)
  end

  def csrf_tag
    Rack::Csrf.csrf_tag(env)
  end
end

get '/' do
	#トップページは一覧の参照と作成のリンクのみ
	#上記 before do に記述してあるものをレンダリングする
	
	erb :index
end