class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller 
  include Blacklight::Controller
  #layout 'blacklight'

  def layout_name
    "application"
  end

  def feedback_params
    params.permit(:current_url,:comments,:email)
  end

  #hits the jira api
  def feedback
    options = {
                :username => Rails.application.config.jira_user,
                :password => Rails.application.config.jira_password,
                :site     => 'https://tools.lib.umich.edu/',
                :context_path => '/jira',
                :auth_type => :cookie,
                :use_cookies => true,
                :read_timeout => 120,
                :use_ssl => true
    }

    client = JIRA::Client.new(options)

    issue = client.Issue.build

    data = {
              "fields"=> {
                 "project"=>
                 { 
                    "key"=> "HTS"
                 },
                 "labels"=> ["feddocs"],
                 "summary"=> "[FedDoc Registry] Feedback form",
                 "description"=> feedback_params.to_hash.map{|k,v| "#{k}: #{v}"}.join("\r\n"),
                 "issuetype"=> {
                    "name"=> "Website"
                 },
                "assignee"=> {
                    "name"=> Rails.application.config.jira_assignee
                }
             }
          }
    res = issue.save(data)

    redirect_to root_url #why not
  end    
 
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
