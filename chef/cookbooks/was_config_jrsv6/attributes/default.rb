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

#profile
default['was']['base']['installation'] = "/opt/IBM/WebSphere8/AppServer/bin/"
default['was']['profile']['name'] = "JRS60"
default['was']['scripts']['location'] =  "http://lexdty9150.ecloud.bcsdc.lexington.ibm.com/downloads/was_scripts.zip"
default['was']['scripts']['file'] = "was_scripts.zip"
default['was']['scripts']['security']['file'] = "enableSecurity.jy"
default['was']['scripts']['ldap']['file'] = "configureLdap.jy"
default['was']['scripts']['jvm']['file'] = "clm_was_config.py"
default['was']['scripts']['jrs']['file'] = "clm_deploy.py"
default['was']['scripts']['cert']['file'] = "install_certs"
default['was']['base']['template'] = "/opt/IBM/WebSphere8/AppServer/profileTemplates/default"
