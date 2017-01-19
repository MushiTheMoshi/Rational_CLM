################################################################################
# Licensed Materials - Property of IBM Copyright IBM Corporation 2012. All Rights Reserved.
# U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP
# Schedule Contract with IBM Corp.
################################################################################
################################################################################
# Cookbook Name:: jts_install
# Recipe:: default

app_server = "localhost"
deploy_dir = node['was']['deploy_dir']
dir_owner = node['was']['owner']
dir_group = node['was']['group']
WAS_BASE_INSTALLATION = node['was']['base']['installation']
WAS_PROFILE_NAME = node['was']['profile']['name']
JTS_INSTALL_LOCATION = node['jts']['install']['location'] 
JTS_INSTALL_FILE = node['jts']['install']['file']
JTS_RESPONSE_LOCATION = node['jts']['response']['location']
JTS_RESPONSE_FILE = node['jts']['response']['file']
JTS_HOME = node['jts']['home']
JTS_VERSIONEDCONTENTSERVICE = node['jts']['versionedcontentservice']
JTS_CONTENTSERVICE = node['jts']['contentservice']
JTS_PROVISION_FILE = node['jts']['provision']['file']
JTS_CONFIGURATION_FILES = node['jts']['configuration']['files']
JTS_CONFIGURATION_LOCATION = node['jts']['configuration']['location']
JTS_REPOTOOLS_FILE = node['jts']['repotools']['file']
                         
## Create the deployment directory structure
directory deploy_dir do
  owner dir_owner
  group dir_group
  mode '0755'
  recursive true
end

## Get CCM v6 Installer
execute ">>> Getting CCM6 installer" do
  user "root"
  cwd deploy_dir
  command "wget #{JTS_INSTALL_LOCATION}"
  action :run
end

execute ">>> Getting CCM6 installer" do
  user "root"
  cwd deploy_dir
  command "wget #{JTS_RESPONSE_LOCATION}"
  action :run
end


## Extract CCM v6 Installer
execute ">>> Unzipping  CCM6 Installer" do
  user "root"
  cwd deploy_dir
  command "unzip #{JTS_INSTALL_FILE}"
  action :run
end

## Get CCM v6 Configuration Files
execute ">>> Getting CCM6 Configuration Files" do
  user "root"
  cwd deploy_dir
  command "wget #{JTS_CONFIGURATION_LOCATION}"
  action :run
end

# Unzip the configuration files
execute ">>> Unzipping configuration files" do
  user "root"
  cwd deploy_dir
  command "unzip #{JTS_CONFIGURATION_FILES}"
  action :run
end

## Install CCM v6
execute ">>> Installing CCMv6" do
  user "root"
  cwd deploy_dir
  command "/opt/IBM/InstallationManager/eclipse/tools/imcl -input #{JTS_RESPONSE_FILE} -accessRights admin -silent -acceptLicense -log CCM_install.log"
  action :run
end

# Create directory for Versioned Content Service
if (!(File.exists?("#{JTS_VERSIONEDCONTENTSERVICE}") && File.directory?("#{JTS_VERSIONEDCONTENTSERVICE}")))
  directory "#{JTS_VERSIONEDCONTENTSERVICE}" do
     owner "root"
     group "root"
     mode "0777"
     recursive true
     action :create
  end   
end

# Create directory for Content Service
if (!(File.exists?("#{JTS_CONTENTSERVICE}") && File.directory?("#{JTS_CONTENTSERVICE}")))
  directory "#{JTS_CONTENTSERVICE}" do
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

