# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + "/../app.rb"
require 'rspec'
require 'rack/test'
require 'capybara'
require 'capybara/dsl'

set :environment, :test

describe 'app.rb' do
  include Rack::Test::Methods
  include Capybara::DSL

  def app
    Sinatra::Application
    Capybara.app = Sinatra::Application.new
  end

  it "get index" do
  	get '/'
  	last_response.should be_ok
  end

  it "index contents" do
    get '/'
    last_response.body.should include '案件リスト'
    last_response.body.should include '作業前手順書リスト'
    last_response.body.should include '作業後手順書リスト'
    last_response.body.should include '案件まとめページ作成'
    last_response.body.should include '手順書作成'
  end

  it "link check" do
    visit '/'
    #page.should be_has_content('案件リスト')
    click_link '作業前手順書リスト'
    page.should be_has_content('作業前手順書リスト')
  end
end