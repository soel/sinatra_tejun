# -*- coding: utf-8 -*-
require 'sinatra'
require 'sinatra/reloader'
require 'rack/csrf'

default_url = "http://localhost:4567"
default_dir = "/var/www/html/sinatra/"

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
	@title = "top page"
	
	@summary_link = '/summary'
	@summary_link_name = '案件リスト'
	@before_link = '/before'
	@before_link_name = '作業前手順書リスト'
	@after_link = '/after'
	@after_link_name = '作業後手順書リスト'

	@new_summary_link = '/new_summary'
	@new_summary_link_name = '案件まとめページ作成'
	@new_operation_link = '/new_operation'
	@new_operation_link_name = '手順書作成'
	
	erb :index
end

get '/before' do
	#今までに作成されたファイル、ディレクトリを表示
	@title = 'Before List'
	before_dir = default_dir + 'before'
	files = Dir::entries(before_dir)
	@files = files.delete_if {|item| item =~ /^\./ }
	@relative_path = '/before/'
	@back_top = '/'
	
	erb :before
end

get '/before/:object' do |object|
	#第一階層についてはファイルかディレクトリを判定し、ファイルなら表示、ディレクトリなら一覧を表示
	#3階層目は想定していないので一覧に表示させないようにしている
	read_object = default_dir + 'before/' + object
	if File::ftype(read_object) == 'file'
		File.read(read_object)

	elsif File::ftype(read_object) == 'directory'
		files = Dir::entries(read_object)
		files = files.delete_if {|item| item =~ /^\./ }

		file_tmp_arry = []

		files.each do |file|
			#ディレクトリの中にディレクトリがあっても表示させない
			dir_file = default_dir + 'before/' + object + '/' + file
			if File::ftype(dir_file) == 'file'
				 file_tmp_arry << file
			end
		end
		@title = object + ' List'
		@files = file_tmp_arry 
		@relative_path = '/before/' + object + '/'
		@back_list = default_url + '/before'	
		
		erb :before
	end		
end

get '/before/:dirname/:filename' do |dir, file|
	#第2階層のファイルの中身を表示
	read_file = default_dir + 'before/' + dir + '/' + file
	File.read(read_file)
end

get '/new' do
	@title = "new"
	@head = "新規作成"

	switch_list_arry = []
	File.open '/var/www/html/sinatra/switch_front_list.txt' do |f|
		f.each_line do |line|
			switch_list_arry << line
		end
	end
end