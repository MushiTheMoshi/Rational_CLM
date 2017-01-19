################################################################################
# Licensed Materials - Property of IBM Copyright IBM Corporation 2012. All Rights Reserved.
# U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP
# Schedule Contract with IBM Corp.
##################################################################################
#config
default['config']['mount'] = "/opt/IBM"
default['config']['cache'] = "/opt/IBM/db2tmp"

#db2
default['db2']['gzip']['file'] = "DB2_Svr_10.5.0.3_Linux_x86-64.tar.gz"
default['db2']['tar']['file'] = "DB2_Svr_10.5.0.3_Linux_x86-64.tar"
default['db2']['gzip']['location'] = "http://lexdty9150.ecloud.bcsdc.lexington.ibm.com/downloads/DB2_Svr_10.5.0.3_Linux_x86-64.tar.gz"
default['db2']['response']['location'] = "http://lexdty9150.ecloud.bcsdc.lexington.ibm.com/downloads/db2server_CLMv6.rsp"
default['db2']['dbs']['location'] = "http://lexdty9150.ecloud.bcsdc.lexington.ibm.com/downloads/createDBs.sh"
default['db2']['dbs']['file'] = "/opt/IBM/db2tmp/createDBs.sh"
default['db2']['log']['file'] = "/opt/IBM/db2tmp/db2setup.log"
default['db2']['response']['file'] = "/opt/IBM/db2tmp/db2server_CLMv6.rsp"
default['db2']['host_name'] = node['ipaddress']


######################################################################################
