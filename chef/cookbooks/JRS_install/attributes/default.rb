################################################################################
# Licensed Materials - Property of IBM Copyright IBM Corporation 2012. All Rights Reserved.
# U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP
# Schedule Contract with IBM Corp.
################################################################################

#
# Cookbook Name:: jrs_install
# Attributes:: default
#

default['was']['deploy_dir'] = "/srv"
default['was']['group'] = "root"
default['was']['owner'] = "root"

#profile
default['was']['base']['installation'] = "/opt/IBM/WebSphere8/AppServer/bin/"
default['was']['profile']['name'] = "JRS60"
default['jrs']['install']['location'] = "http://lexdty9150.ecloud.bcsdc.lexington.ibm.com/downloads/JTS-CCM-QM-RM-JRS-RELM-repo-6.0.zip"
default['jrs']['install']['file'] = "JTS-CCM-QM-RM-JRS-RELM-repo-6.0.zip"
default['jrs']['response']['location'] = "http://lexdty9150.ecloud.bcsdc.lexington.ibm.com/downloads/JRS6ResponseFile.xml"
default['jrs']['response']['file'] = "JRS6ResponseFile.xml"
default['jrs']['home'] = "/opt/IBM/JRS60/server"
default['jrs']['contentservice'] = "/opt/IBM/JRS60/server/contentservice"
default['jrs']['versionedcontentservice'] = "/opt/IBM/JRS60/server/versionedcontentservice"
default['jrs']['provision']['file'] = "provisionFiles.sh"
default['jrs']['configuration']['files'] = "configurationFiles.zip"
default['jrs']['configuration']['location'] = "http://lexdty9150.ecloud.bcsdc.lexington.ibm.com/downloads/configurationFiles.zip"
default['jrs']['repotools']['file'] = "repotoolsFilesMod.sh"
