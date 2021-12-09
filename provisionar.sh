#!/bin/bash
#set -x
terraform apply
#

$(terraform output | grep ssh)
