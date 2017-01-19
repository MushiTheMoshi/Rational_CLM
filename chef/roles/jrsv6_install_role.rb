# Licensed Materials - Property of IBM Copyright IBM Corporation 2012. All Rights Reserved.
# U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP
# Schedule Contract with IBM Corp.
################################################################################
name "jrsv6_install"
description "IM Installation, Application server, profile creation,CLM Installation, WAS configuration, CLM Deployment."
run_list(
  "recipe[JRS_install]",
  "recipe[was_config_jrsv6]"
)

