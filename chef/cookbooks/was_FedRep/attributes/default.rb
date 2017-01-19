################################################################################
# Licensed Materials - Property of IBM Copyright IBM Corporation 2012. All Rights Reserved.
# U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP
# Schedule Contract with IBM Corp.
################################################################################

#
# Cookbook Name:: was_config
# Attributes:: default
#

default['was']['deploy_dir'] = "/srv"
default['was']['group'] = "root"
default['was']['owner'] = "root"
default['was']['prop'] = "wasadmin"

#profile
default['was']['base']['installation'] = "/opt/IBM/WebSphere8/AppServer/bin/"
default['was']['base']['abs'] = "/opt/IBM/WebSphere8"
default['was']['profile']['name'] = "CLM5"
default['was']['scripts']['location'] =  "http://lexdty9150.ecloud.bcsdc.lexington.ibm.com/downloads/was_Fed_scripts.zip"
default['was']['scripts']['file'] = "was_Fed_scripts.zip"
default['was']['scripts']['tune']['file']     = "4was_tuneup.jy"
default['was']['scripts']['federate']['file'] = "3federate_repo.jy"
default['was']['scripts']['dply']['file']     = "5CLM_deploy.jy"
default['was']['scripts']['cert']['file']     = "2install_certs.jy"
default['was']['scripts']['proc']['file']     = "1process_exe.jy"
