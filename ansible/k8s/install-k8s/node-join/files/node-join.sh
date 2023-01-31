#!/usr/bin/env bash

# 获取master ip，假设都是第一个节点为master
maser_ip=`head -1 /tmp/hosts |awk '{print $1}'`

# 判断节点是否加入
ssh $maser_ip "kubectl get nodes|grep -q `hostname`"
if [ $? -eq 0 ];then
 exit 0
fi

CERT_KEY=`ssh $maser_ip "kubeadm init phase upload-certs --upload-certs|tail -1"`

join_str=`ssh $maser_ip kubeadm token create --print-join-command`

$( echo $join_str " --certificate-key $CERT_KEY --v=5")