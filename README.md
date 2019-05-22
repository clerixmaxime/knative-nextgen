# knative-nextgen

https://api.ocp4.sandbox438.opentlc.com:6443

```bash

oc expose svc istio-ingressgateway --hostname=greeter.nextgen-paris.apps.ocp4.sandbox438.opentlc.com --name=greeter-xx -n istio-system

kubectl apply -f 01-service.yaml -n nextgen-serving

kubectl apply -f 02-service-env.yaml -n nextgen-serving

knctl service list

knctl revision list

knctl route list

## run poll.sh script
./poll.sh

REVISION_1=`kubectl get rev -l serving.knative.dev/configuration=greeter --sort-by="{.metadata.creationTimestamp}" | awk 'NR==2{print $1}'`

REVISION_2=`kubectl get rev -l serving.knative.dev/configuration=greeter --sort-by="{.metadata.creationTimestamp}" | awk 'NR==3{print $1}'`

cat 03-route_all_rev1.yaml | yq w - 'spec.traffic[0].revisionName' $REVISION_1 | kubectl apply -f -

cat 04-route_all_to_revision.yaml | yq w - 'spec.traffic[0].revisionName' $REVISION_2 | kubectl apply -f -

cat 05-route_rev1-50_rev2-50.yaml | yq w - 'spec.traffic[0].revisionName' $REVISION_1 | yq w - 'spec.traffic[1].revisionName' $REVISION_2 | kubectl apply -f -

# cleanup
kubectl delete -f 01-service.yaml
kubectl delete -f 02-service-env.yaml

# KNative Eventing
kubectl apply -f 06-service.yaml

kubectl apply -f 07-channel.yaml

kubectl apply -f 08-event-source.yaml

kubectl apply -f 09-channel-subscriber.yaml
```