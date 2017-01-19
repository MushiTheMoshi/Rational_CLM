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
WAS_PROFILE_NAME = node['was']['profile']['name']
WAS_SCRIPTS_LOCATION = node['was']['scripts']['location']
WAS_SCRIPTS_FILE = node['was']['scripts']['file']
WAS_SCRIPTS_SECURITY_FILE = node['was']['scripts']['security']['file']
WAS_SCRIPTS_LDAP_FILE = node['was']['scripts']['ldap']['file']
WAS_SCRIPTS_JVM_FILE = node['was']['scripts']['jvm']['file']
WAS_SCRIPTS_JTS_FILE = node['was']['scripts']['jts']['file']
WAS_SCRIPTS_CERT_FILE = node['was']['scripts']['cert']['file']
WAS_SCRIPTS_PROC_FILE = node['was']['scripts']['pros']['file']

## Create the deployment directory structure
directory deploy_dir do
  owner dir_owner
  group dir_group
  mode '0755'
  recursive true
end

## Get WAS Scripts
execute "Get WAS Scripts file" do
  user "root"
  cwd deploy_dir
  command "wget #{WAS_SCRIPTS_LOCATION}"
  action :run
end

## Extract WAS Scripts
execute "Unzip WAS Scripts" do
  user "root"
  cwd deploy_dir
  command "unzip #{WAS_SCRIPTS_FILE}"
  action :run
end

# Import Certificates
execute "Import Certificates" do
  user "root"
  cwd deploy_dir
  command "#{WAS_BASE_INSTALLATION}wsadmin.sh -lang jython -f #{WAS_SCRIPTS_CERT_FILE}"
  action :run
end
#_____________________________________[ restart was ]
# Stop WAS
execute "Stop WAS Server" do
  user "root"
  cwd WAS_BASE_INSTALLATION
  command "./stopServer.sh server1 -profileName #{WAS_PROFILE_NAME}"
  action :run
end

# Start WAS
execute "Start WAS Server" do
  user "root"
  cwd WAS_BASE_INSTALLATION
  command "./startServer.sh server1 -profileName #{WAS_PROFILE_NAME}"
  action :run
end


# _________________________________[ Enable Global Security and App Security on WAS ]
execute "Enable Security" do
  user "root"
  cwd deploy_dir
  command "#{WAS_BASE_INSTALLATION}/wsadmin.sh -lang jython -f #{WAS_SCRIPTS_SECURITY_FILE}"
  action :run
end

# _________________________________[ Configure Bluepages LDAP ]
execute "Configure LDAP" do
  user "root"
  cwd deploy_dir
  command "#{WAS_BASE_INSTALLATION}/wsadmin.sh -lang jython -f #{WAS_SCRIPTS_LDAP_FILE} CUSTOM bluepages.ibm.com 636 o=ibm.com dstacces@us.ibm.com '(&(emailaddress=%v)(objectclass=ePerson))' '(&(cn=%v)(|(objectclass=groupOfNames)(objectclass=groupOfUniqueNames)))' *:emailaddress *:cn 'ibm-allGroups:member;ibm-allGroups:uniqueMember'"
  action :run
end	

# _________________________________[ Configure JVS Custom properties ]
execute "JVS Custom Properties" do
  user "root"
  cwd deploy_dir
  command "#{WAS_BASE_INSTALLATION}/wsadmin.sh -lang jython -f #{WAS_SCRIPTS_JVM_FILE} /opt/IBM/CLM60/server/conf"
  action :run
end


# change default path
execute "Modifying deploy warpath" do
  user "root"
  cwd deploy_dir
  command "sed -i 's|JazzTeamServer|CLM60|g' #{WAS_SCRIPTS_JTS_FILE}"
  action :run
end

# change number apps 
execute "Modifying deploy warpath" do
  user "root"
  cwd deploy_dir
  command "sed -i 's|\"admin\",||g' #{WAS_SCRIPTS_JTS_FILE}"
  action :run
end

# _______________________________________[ Deploy CLM .war files ]
execute "Deploy CLM WAR Files" do
  user "root"
  cwd deploy_dir
  command "#{WAS_BASE_INSTALLATION}/wsadmin.sh -lang jython -f #{WAS_SCRIPTS_JTS_FILE}"
  action :run
end

#________________________________________[ Stop WAS ]
execute "Stop WAS Server" do
  user "root"
  cwd WAS_BASE_INSTALLATION
  command "./stopServer.sh server1 -profileName #{WAS_PROFILE_NAME}"
  action :run
end

# _______________________________________[ Start WAS as wasadmin ]
execute "Start WAS Server" do
  user "root"
  cwd WAS_BASE_INSTALLATION
  command "./startServer.sh server1 -profileName #{WAS_PROFILE_NAME}"
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

