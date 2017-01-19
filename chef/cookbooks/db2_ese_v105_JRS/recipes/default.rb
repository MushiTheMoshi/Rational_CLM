################################################################################
# Licensed Materials - Property of IBM Copyright IBM Corporation 2012. All Rights Reserved.
# U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP
# Schedule Contract with IBM Corp.
################################################################################
#
# Cookbook Name:: db2_ese_v105
# Recipe:: default
#

CONFIG_MOUNT = node['config']['mount']
CONFIG_CACHE = node['config']['cache']
DB2_GZIP_LOCATION = node['db2']['gzip']['location']
DB2_RESPONSE_LOCATION = node['db2']['response']['location']
DB2_DBS_LOCATION = node['db2']['dbs']['location']
DB2_GZIP_FILE = node['db2']['gzip']['file']
DB2_TAR_FILE = node['db2']['tar']['file']
DB2_LOG_FILE = node['db2']['log']['file']
DB2_DBS_FILE = node['db2']['dbs']['file']
DB2_RESPONSE_FILE = node['db2']['response']['file']
DB2_ESE_LOCATION = "#{CONFIG_CACHE}" + "/server"

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

# Get the DB2 ESE gzip file
execute "Get DB2 ESE File" do
  user "root"
  cwd CONFIG_CACHE
  command "wget #{DB2_GZIP_LOCATION}"
  action :run
end

# Get the DB2 ESE response file
execute "Get DB2 ESE Response File" do
  user "root"
  cwd CONFIG_CACHE
  command "wget #{DB2_RESPONSE_LOCATION}"
  action :run
end

# Get the DB2 Script for DBs creation
#execute "Get DB2 Script DBs" do
#  user "root"
#  cwd CONFIG_MOUNT
#  command "wget #{DB2_DBS_LOCATION}"
#  action :run
#end

## Grant execute 
#execute "Grant execute" do
#  user "root"
#  cwd CONFIG_MOUNT
#  command "chmod +x *.sh"
#  action :run
#end

# Unzip the DB2 ESE tar ball
execute "Unzip DB2 ESE File" do
  user "root"
  cwd CONFIG_CACHE
  command "gunzip #{DB2_GZIP_FILE}"
  action :run
end

# Untar the DB2 ESE tar ball
execute "Untar DB2 ESE File" do
  user "root"
  cwd CONFIG_CACHE
  command "tar -xvf #{DB2_TAR_FILE}"
  action :run
end

# Install DB2 silently
execute "Install DB2 10.5" do
  user "root"
  cwd CONFIG_CACHE
  command "#{DB2_ESE_LOCATION}/db2setup -l #{DB2_LOG_FILE} -r #{DB2_RESPONSE_FILE}"
  action :run
end

## DBs Creation
##execute "CLM DBs Creation" do
##  user "root"
##  cwd CONFIG_MOUNT
##  command "./createDBs.sh"
##  action :run
##end