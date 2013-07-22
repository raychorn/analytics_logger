class Admin::ServersController < ApplicationController
  def index
    @servers = [{
      :text => "summary", :cls => "leaf", :leaf => true, :data => { :server_url => "admin/servers.html" }
    }, {
      :text => "dev",
      :cls => "folder",
      :expanded => true,
      :data => {
        :load_balancer => "dev.analytics.smithmicro.net",
        :events_post_url => "http://dev.analytics.smithmicro.net/events | https://dev.analytics.smithmicro.net/events" 
      },
      :children => [
        { :text => "dev1", :cls => "leaf", :leaf => true, 
          :data => { :events_socket => "10.100.162.53:80", :server_url => "http://10.100.162.53:8080/admin/events" } 
        }, 
        { :text => "dev2", :cls => "leaf", :leaf => true,  
          :data => { :events_socket => "10.100.162.54:80", :server_url => "http://10.100.162.54:8080/admin/events" } 
        }
      ]
    }, {
        :text => "vzmmdev",
        :cls => "folder",
        :expanded => true,
        :data => {
          :load_balancer => "vzmmdev.analytics.smithmicro.net",
          :events_post_url => "http://vzmmdev.analytics.smithmicro.net/events | https://vzmmdev.analytics.smithmicro.net/events" 
        },
        :children => [
        { :text => "dev1", :cls => "leaf", :leaf => true, 
          :data => { :events_socket => "10.100.162.53:81", :server_url => "http://10.100.162.53:8081/admin/events" } 
        },  
        { :text => "dev2", :cls => "leaf", :leaf => true, 
          :data => { :events_socket => "10.100.162.54:81", :server_url => "http://10.100.162.54:8081/admin/events" } 
        }
      ]
    }]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :text => @servers.to_json }
      format.xml  { render :xml => @servers.to_xml }
    end
  end
end
