# Licensed Materials - Property of IBM Copyright IBM Corporation 2012. All Rights Reserved.
# U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP
# Schedule Contract with IBM Corp.
################################################################################
name "qmv6_install"
description "IM Installation, Application server, profile creation,CLM Installation, WAS configuration, CLM Deployment."
run_list(
  "recipe[im_18]",
  "recipe[was855_qmv6]",
  "recipe[RQMv6_install]",
  "recipe[was_config_qmv6]"
  )
