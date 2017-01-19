# Licensed Materials - Property of IBM Copyright IBM Corporation 2012. All Rights Reserved.
# U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP
# Schedule Contract with IBM Corp.
################################################################################
name "jtsv6_install"
description "IM Installation, Application server, profile creation,JTS Installation, WAS configuration, JTS Deployment."
run_list(
  "recipe[im_18]",
  "recipe[was855_jtsv6]",
  "recipe[JTSv6_install]",
  "recipe[was_config_jtsv6]"
  )
