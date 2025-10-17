It will create a namespace called `lbc-app` and a service called `nodejs-application` that will be exposed on the NLB.

NLB configuration uses ip target type, it is better than instance target type, because it is more reliable and faster, because it is not dependent on the instance state. So 

http://k8s-lbcapp-nodejsap-6760a93c83-2eb9ae98a463e68e.elb.us-east-1.amazonaws.com:3000/