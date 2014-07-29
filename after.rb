default_dir = "/var/www/html/sinatra/"

get '/after' do
	#今までに作成されたファイル、ディレクトリを表示
	@title = '作業後手順書リスト'
	after_dir = default_dir + 'after'
	files = Dir::entries(after_dir)
	files = files.delete_if {|item| item =~ /^\./ }

	#下12桁が日時なのでその部分でソートしてリバースする 
	#ただし、一つしかないときは比較できないので比較しない

	if files.size > 1
		files_sorted = files.sort do |a, b|
			a[-12..-1] <=> b[-12..-1]
		end
		files_sorted = files_sorted.reverse
		@files = files_sorted
	else
		@files = files
	end

	@relative_path = '/after/'
	@back_top = '/'
	
	erb :after
end

get '/after/:object' do |object|
	#第一階層についてはファイルかディレクトリを判定し、ファイルなら表示、ディレクトリなら一覧を表示
	#3階層目は想定していないので一覧に表示させないようにしている
	read_object = default_dir + 'after/' + object

	if File::ftype(read_object) == 'file'
		#File.read(read_object)
		@contents = File.read(read_object, :encoding=>"UTF-8")

		erb :after2

	elsif File::ftype(read_object) == 'directory'
		files = Dir::entries(read_object)
		files = files.delete_if {|item| item =~ /^\./ }

		file_tmp_arry = []

		files.each do |file|
			#ディレクトリの中にディレクトリがあっても表示させない
			dir_file = default_dir + 'after/' + object + '/' + file
			if File::ftype(dir_file) == 'file'
				 file_tmp_arry << file
			end
		end
		@title = object
		@files = file_tmp_arry 
		@relative_path = '/after/' + object + '/'	
		
		erb :after
	end		
end

get '/after/:dirname/:filename' do |dir, file|
	#第2階層のファイルの中身を表示
	read_file = default_dir + 'after/' + dir + '/' + file
	
	if %r{.+log$}.match(read_file)
		@txt = File.read(read_file, :encoding=>"Shift_JIS")
	else
		@contents = File.read(read_file, :encoding=>"UTF-8")
	end

    @action = "/after/log/" + dir

	erb :after3	
end


post '/after' do
	file = @params[:file_name]

	contents = File.read(file, :encoding=>"UTF-8")

	@contents = contents.gsub(%r{<button type="submit" class="btn btn-primary">作業終了</button>}, "")

	%r{/var/www/html/sinatra/before/(.+)-(.+-.+)-.+}.match(file)

	t = Time.now
	

	after_file_name = "AFTER-" + $1 + "-" + $2 + "-" + t.strftime("%Y%m%d%H%M")

	dir = "/var/www/html/sinatra/after/" + after_file_name
	Dir.mkdir(dir)
	after_file = dir + "/" + after_file_name + ".html"


	para = @params


	@times = []
	para.each do |key, value|
		if key.include?("sagyo")
			@times << value 
		end		
	end

	@action = "/after/log/" + after_file_name

    @erb = ERB.new(File.read("/var/www/html/sinatra/views/after2.erb", :encoding=>"UTF-8"))

    File.open(after_file, "w") do |file|
    		file.puts @erb.result(binding)
    	end

    	redirect_url = '/after/' + after_file_name + '/' + after_file_name + '.html'

	redirect redirect_url
end

post '/after/log/:object' do |object|

	if  params[:upfile]
		save_path = '/var/www/html/sinatra/after/' + object + '/' + @params[:upfile][:filename]

		File.open(save_path, 'wb') do |f|
			f.write @params[:upfile][:tempfile].read
		end
	end

	redirect_url = '/after/' + object

	redirect redirect_url
end