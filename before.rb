default_dir = "/var/www/html/sinatra/"

get '/before' do
	#今までに作成されたファイル、ディレクトリを表示
	@title = '作業前手順書リスト'
	before_dir = default_dir + 'before'
	files = Dir::entries(before_dir)
	files = files.delete_if {|item| item =~ /^\./ }

	#下12桁が日時なのでその部分でソートしてリバースする 
	#ただし、一つしかないときは比較できないので比較しない
	#ファイル名に.html の5文字が含まれているのでそこは除外する
	if files.size > 1
		files_sorted = files.sort do |a, b|
			a[-17..-5] <=> b[-17..-5]
		end
		files_sorted = files_sorted.reverse
		@files = files_sorted
	else
		@files = files
	end

	@relative_path = '/before/'
	@back_top = '/'
	
	erb :before
end

get '/before/:object' do |object|
	#第一階層についてはファイルかディレクトリを判定し、ファイルなら表示、ディレクトリなら一覧を表示
	#3階層目は想定していないので一覧に表示させないようにしている
	read_object = default_dir + 'before/' + object
	if File::ftype(read_object) == 'file'
		@contents = File.read(read_object)

		erb :before2

	elsif File::ftype(read_object) == 'directory'
		files = Dir::entries(read_object)
		files = files.sort.reverse
		files = files.delete_if {|item| item =~ /^\./ }

		file_tmp_arry = []

		files.each do |file|
			#ディレクトリの中にディレクトリがあっても表示させない
			dir_file = default_dir + 'before/' + object + '/' + file
			if File::ftype(dir_file) == 'file'
				 file_tmp_arry << file
			end
		end
		@title = object
		@files = file_tmp_arry 
		@relative_path = '/before/' + object + '/'	
		
		erb :before
	end		
end

get '/before/:dirname/:filename' do |dir, file|
	#第2階層のファイルの中身を表示
	read_file = default_dir + 'before/' + dir + '/' + file
	File.read(read_file)
end
