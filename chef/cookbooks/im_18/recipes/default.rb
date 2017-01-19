################################################################################
# Licensed Materials - Property of IBM Copyright IBM Corporation 2012. All Rights Reserved.
# U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP
# Schedule Contract with IBM Corp.
################################################################################
# Cookbook Name:: im_18
# Recipe:: default
#

CONFIG_MOUNT = node['config']['mount']
CONFIG_CACHE = node['config']['cache']

IM_ZIP_LOCATION = node['im']['zip']['location']
IM_ZIP_FILE = node['im']['zip']['file']
IM_BASE_LOCATION = "#{CONFIG_CACHE}" + "/im_install_base"

# Create directory for config cache
if (!(File.exists?("#{CONFIG_CACHE}") && File.directory?("#{CONFIG_CACHE}")))
  directory "#{CONFIG_CACHE}" do
     owner "root"
     group "root"
     mode "0755"
     recursive true
     action :create
  end   
end

# Get the IM zip file
execute "Get IM File" do
  user "root"
  cwd CONFIG_CACHE
  command "wget #{IM_ZIP_LOCATION}"
  action :run
end

# Unzip the IM zip file
execute "Unzip IM File" do
  user "root"
  cwd CONFIG_CACHE
  command "unzip #{IM_ZIP_FILE}"
  action :run
end

# Install IM silently
execute "Install IM" do
  user "root"
  cwd CONFIG_CACHE
  command "#{CONFIG_CACHE}/installc -acceptLicense"
  action :run
end

# Delete Installers
execute "Delete installers" do
  user "root"
  cwd CONFIG_CACHE
  command "rm -rf *"
  action :run
end