################################################################################
# Licensed Materials - Property of IBM Copyright IBM Corporation 2012. All Rights Reserved.
# U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP
# Schedule Contract with IBM Corp.
################################################################################
# Cookbook Name:: was855
# Recipe:: default
#

CONFIG_MOUNT = node['config']['mount']
CONFIG_CACHE = node['config']['cache']
WAS_ZIP_LOCATION1 = node['was']['zip']['location1']
WAS_ZIP_LOCATION2 = node['was']['zip']['location2']
WAS_ZIP_LOCATION3 = node['was']['zip']['location3']
WAS_RESPONSE_LOCATION = node['was']['response']['location']
WAS_FIXPACK_LOC = node['was']['zip']['location4'] 
WAS_ZIP_FILE1 = node['was']['zip']['file1']
WAS_ZIP_FILE2 = node['was']['zip']['file2']
WAS_ZIP_FILE3 = node['was']['zip']['file3']
WAS_RESPONSE_FILE = node['was']['response']['file']
WAS_BASE_INSTALLATION = node['was']['base']['installation']
IM_INSTALL_LOCATION = node['im']['base']
WAS_BASE_TEMPLATE = node['was']['base']['template']
WAS_PROFILE_NAME = node['was']['profile']['name']
WAS_FIXPACK1 = node['was']['zip']['file4']
WAS_FIXPACK2 = node['was']['zip']['file5']
WAS_FP_LOC1 = node['was']['zip']['location4']
WAS_FP_LOC2 = node['was']['zip']['location5']

WAS_BASE_LOCATION = "#{CONFIG_CACHE}" + "/was_install_base"
WAS_INSTALL_LOCATION = "#{WAS_BASE_LOCATION}" + "/WAS"
WAS_FP = "#{CONFIG_CACHE}" + "/FP"
FP_INST_DIR = node['was']['base']['fp']
#FP_INST_DIR = "#{File::join(WAS_BASE_INSTALLATION.split("/")[0...-1]}"


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

# Create directory for FP
if (!(File.exists?("#{CONFIG_CACHE}") && File.directory?("#{CONFIG_CACHE}")))
  directory "#{WAS_FP}" do
     owner "root"
     group "root"
     mode "0755"
     recursive true
     action :create
  end   
end

# Get the WAS zip1 file
execute ">>> Getting WAS File 1" do
  user "root"
  cwd CONFIG_CACHE
  command "wget #{WAS_ZIP_LOCATION1}"
  action :run
end

# Get the WAS zip2 file
execute ">>> Getting WAS File 2" do
  user "root"
  cwd CONFIG_CACHE
  command "wget #{WAS_ZIP_LOCATION2}"
  action :run
end

# Get the WAS zip3 file
execute ">>> Get WAS File 3" do
  user "root"
  cwd CONFIG_CACHE
  command "wget #{WAS_ZIP_LOCATION3}"
  action :run
end

#___________________________________[ was_ifix ]
# Get the WAS FP file1
execute ">>> Get WAS File 4" do
  user "root"
  cwd WAS_FP
  command "wget #{WAS_FP_LOC1}"
  action :run
end

# Get the WAS FP file2
execute ">>> Get WAS File 5" do
  user "root"
  cwd WAS_FP
  command "wget #{WAS_FP_LOC2}"
  action :run
end
#[-------------------------------------]

# Get the WAS response file
execute ">>> Get WAS Response File" do
  user "root"
  cwd CONFIG_CACHE
  command "wget #{WAS_RESPONSE_LOCATION}"
  action :run
end

# Unzip the WAS zip1 file
execute ">>> Unzipping WAS File 1" do
  user "root"
  cwd CONFIG_CACHE
  command "unzip #{WAS_ZIP_FILE1}"
  action :run
end

# Unzip the WAS zip2 file
execute ">>> Unzipping WAS File 2" do
  user "root"
  cwd CONFIG_CACHE
  command "unzip #{WAS_ZIP_FILE2}"
  action :run
end

# Unzip the WAS zip3 file
execute ">>> Unziping WAS File 3" do
  user "root"
  cwd CONFIG_CACHE
  command "unzip #{WAS_ZIP_FILE3}"
  action :run
end

#______________________________________[ was_ifix ]
# Unzip the WAS zip4 file
execute ">>> Unziping WAS File 4" do
  user "root"
  cwd WAS_FP
  command "unzip #{WAS_FIXPACK1}"
  action :run
end

# Unzip the WAS zip5 file
execute ">>> Unziping WAS File 5" do
  user "root"
  cwd WAS_FP
  command "unzip #{WAS_FIXPACK2}"
  action :run
end
#[-------------------------------------]


# Create directory for WAS install base
if (!(File.exists?("#{WAS_BASE_LOCATION}") && File.directory?("#{WAS_BASE_LOCATION}")))
  directory "#{WAS_BASE_LOCATION}" do
     owner "root"
     group "root"
     mode "0755"
     recursive true
     action :create
  end   
end

# Delete Zip Files
execute ">>> Deleting Zip Files" do
  user "root"
  cwd CONFIG_CACHE
  command "rm -f *.zip"
  action :run
end



# Install WAS silently
execute ">>> Installing WAS" do
  user "root"
  cwd IM_INSTALL_LOCATION
  command "#{IM_INSTALL_LOCATION}/imcl input #{WAS_RESPONSE_FILE} -log /var/tmp/install_log.xml -acceptLicense"
  action :run
end



# Create profile
execute ">>> Creating profile" do
  user "root"
  cwd WAS_BASE_INSTALLATION
  command "#{WAS_BASE_INSTALLATION}/manageprofiles.sh -create -templatePath #{WAS_BASE_TEMPLATE} -profileName #{WAS_PROFILE_NAME}"
  action :run
end



# Installing FP
execute ">>> Installing FP" do
  user "root"
  cwd IM_INSTALL_LOCATION
  command "#{IM_INSTALL_LOCATION}/imcl install com.ibm.websphere.BASE.v85_8.5.5009.20160225_0435 -repositories #{WAS_FP} -installationDirectory #{FP_INST_DIR} -sharedResourcesDirectory /opt/IBM/IMShared -showProgress -acceptLicense"
  action :run
end

#delete files after installation 
directory "#{CONFIG_CACHE}" do
   recursive true
   action :delete
end   

# Start WAS
execute ">>> Starting WAS Server" do
  user "root"
  cwd WAS_BASE_INSTALLATION
  command "#{WAS_BASE_INSTALLATION}/startServer.sh server1 -profileName #{WAS_PROFILE_NAME}"
  action :run
end



