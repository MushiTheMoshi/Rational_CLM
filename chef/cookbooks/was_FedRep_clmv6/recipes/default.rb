################################################################################
# Licensed Materials - Property of IBM Copyright IBM Corporation 2012. All Rights Reserved.
# U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP
# Schedule Contract with IBM Corp.
################################################################################



app_server = "localhost"
deploy_dir = node['was']['deploy_dir']
dir_owner = node['was']['owner']
dir_group = node['was']['group']
was_owner = node['was']['prop'] 

WAS_BASE_INSTALLATION = node['was']['base']['installation']
WAS_ABS_PATH = node['was']['base']['abs']
WAS_PROFILE_NAME = node['was']['profile']['name']
WAS_SCRIPTS_LOCATION = node['was']['scripts']['location']
WAS_SCRIPTS_FILE = node['was']['scripts']['file']
WAS_SCRIPTS_FEDERATE_FILE = node['was']['scripts']['federate']['file']
WAS_SCRIPTS_TUNE_FILE     = node['was']['scripts']['tune']['file']
WAS_SCRIPTS_DPLY_FILE     = node['was']['scripts']['dply']['file']
WAS_SCRIPTS_CERT_FILE     = node['was']['scripts']['cert']['file']
WAS_SCRIPTS_PROC_FILE     = node['was']['scripts']['proc']['file']
WAS_SCRIPTS_GROUPS_FILE   = node['was']['scripts']['groups']['file']

#_______________________________________[ Directory Structure ]
directory deploy_dir do
  owner dir_owner
  group dir_group
  mode '0755'
  recursive true
end

## Get WAS Scripts
execute ">>> Getting WAS Scripts file" do
  user "root"
  cwd deploy_dir
  command "wget #{WAS_SCRIPTS_LOCATION}"
  action :run
end

## Extract WAS Scripts
execute ">>> Unziping WAS Scripts" do
  user "root"
  cwd deploy_dir
  command "unzip #{WAS_SCRIPTS_FILE}"
  action :run
end


#_______________________________________[ Changing WAS Process Execution to wasadmin ]
#execute ">>> Changing process execution" do
#  user "root"
#  cwd deploy_dir
#  command "#{WAS_BASE_INSTALLATION}/wsadmin.sh -lang jython -f #{WAS_SCRIPTS_PROC_FILE}"
#  action :run
#end


#_______________________________________[ Import Certificates ]
execute ">>> Importing Certificates" do
  user "root"
  cwd deploy_dir
  command "#{WAS_BASE_INSTALLATION}/wsadmin.sh -lang jython -f #{WAS_SCRIPTS_CERT_FILE}"
  action :run
end



#_______________________________________[ WAS Restart ]
# Stop WAS
execute ">>> Stoping WAS Server" do
  user "root"
  cwd "#{WAS_BASE_INSTALLATION}"
  command "#{WAS_BASE_INSTALLATION}/stopServer.sh server1 -profileName #{WAS_PROFILE_NAME}"
  action :run
end



#_______________________________________[ Changing ownership ]
#execute ">>> Changing ownership to wasadmin" do
#  user "root"
#  command "chown -Rf wasadmin.wasadmin #{WAS_ABS_PATH}"
#  action :run
#end



#_______________________________________[ Starting WAS ]
execute ">>> Starting WAS Server" do
  user "root"
  command "#{WAS_BASE_INSTALLATION}/startServer.sh server1 -profileName #{WAS_PROFILE_NAME}"
  action :run
end



#_______________________________________[ Federate Repo ]
execute ">>> Federating Repositories" do
  user "root"
  cwd deploy_dir
  command "#{WAS_BASE_INSTALLATION}/wsadmin.sh -lang jython -f #{WAS_SCRIPTS_FEDERATE_FILE}"
  action :run
end



#_______________________________________[ WAS_tune-up, JVM, etc ]
execute ">>> Updating JVS Custom Properties" do
  user "root"
  cwd deploy_dir
  command "#{WAS_BASE_INSTALLATION}/wsadmin.sh -lang jython -f #{WAS_SCRIPTS_TUNE_FILE} /opt/IBM/CLM60"
  action :run
end



#_______________________________________[ Deploy CLM ]
execute ">>> Deploying CLM WAR Files" do
  user "root"
  cwd deploy_dir
  command "#{WAS_BASE_INSTALLATION}/wsadmin.sh -lang jython -f #{WAS_SCRIPTS_DPLY_FILE} /opt/IBM/CLM60"
  action :run
end



#_______________________________________[ Restart WAS ]
# Stop WAS
execute "Stoping WAS Server" do
  user "root"
  cwd WAS_BASE_INSTALLATION
  command "#{WAS_BASE_INSTALLATION}/stopServer.sh server1 -profileName #{WAS_PROFILE_NAME} && #{WAS_BASE_INSTALLATION}/startServer.sh server1 -profileName #{WAS_PROFILE_NAME}"
  action :run
end


execute ">>> Adding dstjazzadmins group" do
  user "root"
  cwd deploy_dir
  command "#{WAS_BASE_INSTALLATION}/wsadmin.sh -lang jython -f #{WAS_SCRIPTS_GROUPS_FILE} dstjazzadmins"
  action :run
end

#_______________________________________[ WAS Restart ]
# WAS Restart
execute ">>> Restarting WAS Server" do
  user "root"
  cwd "#{WAS_BASE_INSTALLATION}"
  command "#{WAS_BASE_INSTALLATION}/stopServer.sh server1 -profileName #{WAS_PROFILE_NAME} && #{WAS_BASE_INSTALLATION}/startServer.sh server1 -profileName #{WAS_PROFILE_NAME} "
  action :run
end


# _______________________________________[ Change process execution to WASADMIN ]
execute "changing process execution" do
  user "root"
  cwd deploy_dir
  command "#{WAS_BASE_INSTALLATION}/wsadmin.sh -lang jython -f #{WAS_SCRIPTS_PROC_FILE}"
  action :run
end

# Stop WAS
execute "Stop WAS Server" do
  user "root"
  cwd WAS_BASE_INSTALLATION
  command "./stopServer.sh server1 -profileName #{WAS_PROFILE_NAME}"
  action :run
end

#________________________________________[ creating user/group ]
execute ">>> Creating wasadmin user/group" do
  user "root"
  command "sh -c 'groupadd wasadmin ;useradd -m -g wasadmin wasadmin; chown -R wasadmin.wasadmin /opt/IBM/WebSphere8 /opt/IBM/CLM60'"
  action :run
end


# _______________________________________[ Start WAS as wasadmin ]
execute "Start WAS Server" do
  user "root"
  cwd WAS_BASE_INSTALLATION
  command "su - #{was_owner} -c '#{WAS_BASE_INSTALLATION}/startServer.sh server1 -profileName #{WAS_PROFILE_NAME}'"
  action :run
end

