get '/new_switch' do
	@title = '手順書作成'

	switch_front_list =[]
	File.open('switch_front_list.txt', 'r') do |f|
		f.each_line do |line|
			line.chomp!
			switch_front_list << line
		end
	end

	@switch_front_list = switch_front_list

	erb :new_switch
end

post '/new_switch' do
	type = @params[:switch_type]
	name = @params[:switch_name]
	ope  = @params[:ope_type]

	switch_params = name.split(" ")
	if ope == "create"
		if type == 'front'
			if switch_params[1] == 'L3'
				if switch_params[2] == 'cisco'
					redirect "/new_switch/l3_cisco_create_form/#{switch_params[0]}"
				end
			elsif switch_params[1] == 'L2'

			end
		elsif  type == 'back'

		end
	elsif ope == "delete"
		if type == 'front'
			if switch_params[1] == 'L3'
				if switch_params[2] == 'cisco'
					redirect "/new_switch/l3_cisco_dlete_form/#{switch_params[0]}"
				end
			elsif switch_params[1] == 'L2'

			end
		elsif  type == 'back'

		end
	end
end

get '/new_switch/l3_cisco_create_form/:switch_name' do |switch_name|
	@title = switch_name
	@action = "/new_switch/l3_cisco_create_form/#{switch_name}"
	erb :l3_cisco_create_form
end

post '/new_switch/l3_cisco_create_form/:switch_name' do |switch_name|
	@title = switch_name
	@conf_save = switch_name.match(%r{(.+?).colo03})[1]

	@ticket_num = @params[:ticket_number]

	@ope_a = @params[:operator_a]
	@ope_b = @params[:operator_b]
	
	@conf_br = @params[:config]

	@vlan = @params[:vlan_number]
	@vlan_n = @params[:vlan_name]

	@address = @params[:ip_address]
	
	#第3オクテットまでを抜き出す
	@vip = @address.match(%r{^\d+\.\d+\.\d+})

	@hsrp  = @params[:hsrp_number]

	@acl = @params[:acl_name]

	@action = "/after"

	t = Time.now

	#一覧表示の処理で下12桁をソートの条件としているので変更する際には注意すること
	file_name = "/var/www/html/sinatra/before/" + @ticket_num + "-" + @conf_save + "-" + t.strftime("%Y%m%d%H%M") + ".html"

	@file_name = file_name

    @erb = ERB.new(File.read("/var/www/html/sinatra/views/l3_cisco_create_template.erb"))

    File.open(file_name, "w") do |file|
    	file.puts @erb.result(binding)
    end

	erb :l3_cisco_create_template
end