#!/bin/bash -xe
source /home/ec2-user/.bash-profile
[ -d "/home/ec2-user/app/release"] && \
cd /home/ec2-user/app/release && \
npm stop