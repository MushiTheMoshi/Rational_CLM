################################################################################
# Licensed Materials - Property of IBM Copyright IBM Corporation 2012. All Rights Reserved.
# U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP
# Schedule Contract with IBM Corp.
################################################################################

#
# Cookbook Name:: jts_install
# Attributes:: default
#

default['was']['deploy_dir'] = "/srv"
default['was']['group'] = "root"
default['was']['owner'] = "root"

#profile
default['was']['base']['installation'] = "/opt/IBM/WebSphere8/AppServer/bin/"
default['was']['profile']['name'] = "CLM5"
default['jts']['install']['location'] = "http://lexdty9150.ecloud.bcsdc.lexington.ibm.com/downloads/JTS-CCM-QM-RM-repo-5.0.2.zip"
default['jts']['install']['file'] = "JTS-CCM-QM-RM-repo-5.0.2.zip"
default['jts']['response']['location'] = "http://lexdty9150.ecloud.bcsdc.lexington.ibm.com/downloads/clm5ResponseFile.xml"
default['jts']['response']['file'] = "clm5ResponseFile.xml"
default['jts']['home'] = "/opt/IBM/JazzTeamServer/server"
default['jts']['contentservice'] = "/opt/IBM/JazzTeamServer/server/contentservice"
default['jts']['versionedcontentservice'] = "/opt/IBM/JazzTeamServer/server/versionedcontentservice"
default['jts']['provision']['file'] = "provisionFiles.sh"
default['jts']['configuration']['files'] = "configurationFiles.zip"
default['jts']['configuration']['location'] = "http://lexdty9150.ecloud.bcsdc.lexington.ibm.com/downloads/configurationFiles.zip"
default['jts']['repotools']['file'] = "repotoolsFilesMod.sh"
