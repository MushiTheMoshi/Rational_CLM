################################################################################
# Licensed Materials - Property of IBM Copyright IBM Corporation 2012. All Rights Reserved.
# U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP
# Schedule Contract with IBM Corp.
################################################################################
##config
default['config']['mount'] = "/opt/IBM"
default['config']['cache'] = "/opt/IBM/wastmp"

#was
#__________[ BINARIES ZIP ]
default['was']['zip']['file1'] = "WAS_V8.5.5_1_OF_3.zip"
default['was']['zip']['file2'] = "WAS_V8.5.5_2_OF_3.zip"
default['was']['zip']['file3'] = "WAS_V8.5.5_3_OF_3.zip"

#__________[ BINARIES LOC ]
default['was']['zip']['location1'] = "http://lexdty9150.ecloud.bcsdc.lexington.ibm.com/downloads/WAS_V8.5.5_1_OF_3.zip"
default['was']['zip']['location2'] = "http://lexdty9150.ecloud.bcsdc.lexington.ibm.com/downloads/WAS_V8.5.5_2_OF_3.zip"
default['was']['zip']['location3'] = "http://lexdty9150.ecloud.bcsdc.lexington.ibm.com/downloads/WAS_V8.5.5_3_OF_3.zip"

#__________[ FIX PACK INSTALLER ]
default['was']['zip']['location4'] = "http://lexdty9150.ecloud.bcsdc.lexington.ibm.com/downloads/8.5.5-WS-WAS-FP0000009-part1.zip"
default['was']['zip']['location5'] = "http://lexdty9150.ecloud.bcsdc.lexington.ibm.com/downloads/8.5.5-WS-WAS-FP0000009-part2.zip"
default['was']['zip']['file4'] = "8.5.5-WS-WAS-FP0000009-part1.zip"
default['was']['zip']['file5'] = "8.5.5-WS-WAS-FP0000009-part2.zip"
default['was']['base']['fp'] = "/opt/IBM/WebSphere8/AppServer"

#__________[ RESPONSE FILE CONFIG ]
default['was']['response']['location'] = "http://lexdty9150.ecloud.bcsdc.lexington.ibm.com/downloads/was85ResponseFile.xml"
default['was']['response']['file'] = "/opt/IBM/wastmp/was85ResponseFile.xml"

#__________[ LOG ]
default['was']['log']['file'] = "/opt/IBM/wastmp/wassetup.log"
default['im']['base'] = "/opt/IBM/InstallationManager/eclipse/tools/"


#profile
default['was']['base']['installation'] = "/opt/IBM/WebSphere8/AppServer/bin/"
default['was']['profile']['name'] = "CLM60"
default['was']['profile']['location'] = "/opt/IBM/WebSphere8/AppServer/profiles/"
default['was']['base']['template'] = "/opt/IBM/WebSphere8/AppServer/profileTemplates/default"
