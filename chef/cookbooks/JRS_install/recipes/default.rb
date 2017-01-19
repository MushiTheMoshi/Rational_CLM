################################################################################
# Licensed Materials - Property of IBM Copyright IBM Corporation 2012. All Rights Reserved.
# U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP
# Schedule Contract with IBM Corp.
################################################################################
################################################################################
# Cookbook Name:: JRS_install
# Recipe:: default

app_server = "localhost"
deploy_dir = node['was']['deploy_dir']
dir_owner = node['was']['owner']
dir_group = node['was']['group']
WAS_BASE_INSTALLATION = node['was']['base']['installation']
WAS_PROFILE_NAME = node['was']['profile']['name']
JRS_INSTALL_LOCATION = node['jrs']['install']['location'] 
JRS_INSTALL_FILE = node['jrs']['install']['file']
JRS_RESPONSE_LOCATION = node['jrs']['response']['location']
JRS_RESPONSE_FILE = node['jrs']['response']['file']
JRS_HOME = node['jrs']['home']
JRS_VERSIONEDCONTENTSERVICE = node['jrs']['versionedcontentservice']
JRS_CONTENTSERVICE = node['jrs']['contentservice']
JRS_PROVISION_FILE = node['jrs']['provision']['file']
JRS_CONFIGURATION_FILES = node['jrs']['configuration']['files']
JRS_CONFIGURATION_LOCATION = node['jrs']['configuration']['location']
JRS_REPOTOOLS_FILE = node['jrs']['repotools']['file']
                         
## Create the deployment directory structure
directory deploy_dir do
  owner dir_owner
  group dir_group
  mode '0755'
  recursive true
end

## Get JRS v6 Installer
execute ">>> Getting JRS6 installer" do
  user "root"
  cwd deploy_dir
  command "wget #{JRS_INSTALL_LOCATION}"
  action :run
end

execute ">>> Getting JRS6 installer" do
  user "root"
  cwd deploy_dir
  command "wget #{JRS_RESPONSE_LOCATION}"
  action :run
end


## Extract JRS v6 Installer
execute ">>> Unzipping  JRS6 Installer" do
  user "root"
  cwd deploy_dir
  command "unzip #{JRS_INSTALL_FILE}"
  action :run
end

## Get JRS v6 Configuration Files
execute ">>> Getting JRS6 Configuration Files" do
  user "root"
  cwd deploy_dir
  command "wget #{JRS_CONFIGURATION_LOCATION}"
  action :run
end

# Unzip the configuration files
execute ">>> Unzipping configuration files" do
  user "root"
  cwd deploy_dir
  command "unzip #{JRS_CONFIGURATION_FILES}"
  action :run
end

## Install JRS v6
execute ">>> Installing JRSv6" do
  user "root"
  cwd deploy_dir
  command "/opt/IBM/InstallationManager/eclipse/tools/imcl -input /srv/#{JRS_RESPONSE_FILE} -accessRights admin -silent -acceptLicense -log JRS_install.log"
  action :run
end

# Create directory for Versioned Content Service
if (!(File.exists?("#{JRS_VERSIONEDCONTENTSERVICE}") && File.directory?("#{JRS_VERSIONEDCONTENTSERVICE}")))
  directory "#{JRS_VERSIONEDCONTENTSERVICE}" do
     owner "root"
     group "root"
     mode "0777"
     recursive true
     action :create
  end   
end

# Create directory for Content Service
if (!(File.exists?("#{JRS_CONTENTSERVICE}") && File.directory?("#{JRS_CONTENTSERVICE}")))
  directory "#{JRS_CONTENTSERVICE}" do
     owner "root"
     group "root"
     mode "0777"
     recursive true
     action :create
  end   
end

## Grant execute 
execute ">>> Changing permission" do
  user "root"
  cwd deploy_dir
  command "chmod +x *.sh"
  action :run
end


## Modify Absolute Paths on Provision Files
execute ">>> Modyfying Paths" do
  user "root"
  cwd deploy_dir
  command "./provisionFiles.sh"
  action :run
end

## Modify Absolute Paths on Repotools Files
execute ">>> Modyfying Paths Repotools" do
  user "root"
  cwd deploy_dir
  command "./repotoolsFilesMod.sh"
  action :run
end

