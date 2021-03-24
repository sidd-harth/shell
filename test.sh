#!/bin/bash

########### Question 1 ###########
echo Question 1
echo " "
podName=$(kubectl get pod -n default -o=jsonpath='{.items[*].metadata.name}')
containerImageName=$(kubectl get po -n default -o=jsonpath='{.items[?(@.metadata.name=="nginx-448939")].spec.containers[0].image}')
podStatus=$(kubectl get po -n default -o=jsonpath='{.items[?(@.metadata.name=="nginx-448939")].status.phase}')

echo $containerImageName
echo $podStatus

echo $podName | grep nginx-448939 > /dev/null

if [ $? -eq 0 ] ;
then
        echo yes pod exists && mkdir -p /tmp/test && touch score.txt && echo "Name: Question1" > /tmp/test/score.txt && echo "a: 4" >> /tmp/test/score.txt;

        if [[ $containerImageName = 'nginx:alpine' ]]
        then
          echo "true" && echo "b: 3" >> /tmp/test/score.txt;
        else
          echo {"error":"container image is not nginx:alpine"} echo "b: 0" >> /tmp/test/score.txt;
        fi


        if [[ $podStatus = 'Running' ]]
        then
          echo "true" && echo "c: 3" >> /tmp/test/score.txt;
        else
          echo "pod is not in Running Status" echo "c: 0" >> /tmp/test/score.txt;
        fi
else
        echo pod doesnt exist && mkdir -p /tmp/test && touch score.txt && echo "Name: Question1" > /tmp/test/score.txt && echo "a: 0" > /tmp/test/score.txt;
fi
echo "---------------------------"
########### Question 1 ###########

########### Question 2 ###########
echo Question 2
echo " "
availableNamespaces=$(kubectl get ns -o=jsonpath='{.items[*].metadata.name}')
checkLabelInNamespace=$(kubectl get ns -o=jsonpath='{.items[?(@.metadata.name=="istio-prod-73845")].metadata.labels.istio-injection}')

echo $checkLabelInNamespace

echo $availableNamespaces | grep istio-prod-73845 > /dev/null

if [ $? -eq 0 ] ;
then
        echo yes namespace exists && echo "Name: Question2" >> /tmp/test/score.txt && echo "a: 2" >> /tmp/test/score.txt;

        if [[ $checkLabelInNamespace = 'enabled' ]]
        then
          echo "true" && echo "b: 8" >> /tmp/test/score.txt;
        else
          echo "namespace does not contain label istio-injection as enabled" && echo "b: 0" >> /tmp/test/score.txt;
        fi
else
        echo namespace doesnt exist &&  echo "Name: Question2" >> /tmp/test/score.txt && echo "a: 0" >> /tmp/test/score.txt;
fi
echo "---------------------------"
########### Question 2 ###########


########### Question 3 ###########
echo Question 3
echo " "
availableDeployments=$(kubectl get deploy -n default -o=jsonpath='{.items[*].metadata.name}')
checkReplicas=$(kubectl get deploy -n default  -o=jsonpath='{.items[?(@.metadata.name=="nginx-frontend")].spec.replicas}')
checkImage=$(kubectl get deploy -n default  -o=jsonpath='{.items[?(@.metadata.name=="nginx-frontend")].spec.template.spec.containers[0].image}')

echo $checkReplicas
echo $checkImage

echo $availableDeployments | grep nginx-frontend > /dev/null

if [ $? -eq 0 ] ;
then
        echo yes deployment exists && echo "Name: Question3" >> /tmp/test/score.txt && echo "a: 5" >> /tmp/test/score.txt;

        if [[ $checkReplicas = 3 ]]
        then
          echo "true" && echo "b: 3" >> /tmp/test/score.txt;
        else
          echo "replicas should be 3" && echo "b: 0" >> /tmp/test/score.txt;
        fi

        if [[ $checkImage = "nginx:1.19-alpine" ]]
        then
          echo "true" && echo "c: 2" >> /tmp/test/score.txt;
        else
          echo "image name should be nginx:1.19-alpine" && echo "c: 0" >> /tmp/test/score.txt;
        fi
else
        echo deployment doesnt exist &&  echo "Name: Question3" >> /tmp/test/score.txt && echo "a: 0" >> /tmp/test/score.txt;
fi
echo "---------------------------"
########### Question 3 ###########


########### Question 4 ###########
echo Question 4
echo " "
availableReplicaSet=$(kubectl get rs -n frontend-prod -o=jsonpath='{.items[*].metadata.name}')
checkReadyReplicas=$(kubectl get rs -n frontend-prod  -o=jsonpath='{.items[?(@.metadata.name=="rs-nginx557")].status.readyReplicas}')
checkImage=$(kubectl get rs -n frontend-prod  -o=jsonpath='{.items[?(@.metadata.name=="rs-nginx557")].spec.template.spec.containers[0].image}')

echo $checkReadyReplicas
echo $checkImage

echo $availableReplicaSet | grep rs-nginx557 > /dev/null

if [ $? -eq 0 ] ;
then
        echo yes rs rs-nginx557 exists && echo "Name: Question4" >> /tmp/test/score.txt && echo "a: 0" >> /tmp/test/score.txt;

        if [[ $checkReadyReplicas = 3 ]]
        then
          echo "true" && echo "b: 6" >> /tmp/test/score.txt;
        else
          echo "ready replicas should be 3" && echo "b: 0" >> /tmp/test/score.txt;
        fi

        if [[ $checkImage = "nginx" ]]
        then
          echo "true" && echo "c: 4" >> /tmp/test/score.txt;
        else
          echo "image name should be nginx" && echo "c: 0" >> /tmp/test/score.txt;
        fi
else
        echo replicaSet rs-nginx557 doesnt exist &&  echo "Name: Question4" >> /tmp/test/score.txt && echo "a: 0" >> /tmp/test/score.txt;
fi
echo "---------------------------"
########### Question 4 ###########

########### Question 5 ###########
echo Question 5
echo " "
availableDeploy=$(kubectl get deployment -n db-critical -o=jsonpath='{.items[*].metadata.name}')
availableService=$(kubectl get svc -n db-critical -o=jsonpath='{.items[*]}')
serviceName=$(kubectl get svc -n db-critical -o=jsonpath='{.items[?(@.metadata.name=="database-service")].metadata.name}')
servicePort=$(kubectl get svc -n db-critical -o=jsonpath='{.items[?(@.metadata.name=="database-service")].spec.ports[].port}')
serviceTargetPort=$(kubectl get svc -n db-critical -o=jsonpath='{.items[?(@.metadata.name=="database-service")].spec.ports[].targetPort}')
serviceType=$(kubectl get svc -n db-critical -o=jsonpath='{.items[?(@.metadata.name=="database-service")].spec.type}')
serviceSelector=$(kubectl get svc -n db-critical -o=jsonpath='{.items[?(@.metadata.name=="database-service")].spec.selector.app}')

echo $availableDeploy;
#echo $availableService;
echo $serviceName;
echo $servicePort;
echo $serviceTargetPort;
echo $serviceSelector;
echo $serviceType;

echo $availableDeploy | grep mysql-db > /dev/null

if [ $? -eq 0 ] ;
then
        echo yes deployment mysql-db exists && echo "Name: Question5" >> /tmp/test/score.txt && echo "a: 0" >> /tmp/test/score.txt;

        echo $availableService | grep database-service > /dev/null
        if [ $? -eq 0 ] && [[ $serviceName = "database-service" ]] && [[ $serviceSelector = "mysql-db" ]];
          then
            echo service database-service exists && echo "b: 3" >> /tmp/test/score.txt;
          else
            echo service name or selector labels might be wrong or database-service doesnt exists;
          fi

        if [[ $servicePort = 3308 ]] && [[ $serviceTargetPort = 3306 ]];
          then
            echo Ports are correct && echo "b: 5" >> /tmp/test/score.txt;
          else
            echo one or more svc ports are wrong && echo "b: 0" >> /tmp/test/score.txt;
          fi

        if [[ $serviceType = "ClusterIP" ]] ;
          then
            echo Svc Type is Correct && echo "c: 2" >> /tmp/test/score.txt;
          else
            echo Svc Type is Correct is wrong && echo "c: 0" >> /tmp/test/score.txt;
          fi

else
        echo deployment mysql-db doesnt exist &&  echo "Name: Question5" >> /tmp/test/score.txt && echo "a: 0" >> /tmp/test/score.txt;
fi
echo "---------------------------"
########### Question 5 ###########


########### Question 6 ###########
echo Question 6
echo " "
availablePod=$(kubectl get pod -n default -o=jsonpath='{.items[*].metadata.name}')

echo $availablePod;

echo $availablePod | grep mysql-pod > /dev/null

if [ $? -eq 0 ] ;
then
        echo yes pod mysql-pod exists && echo "Name: Question6" >> /tmp/test/score.txt && echo "a: 0" >> /tmp/test/score.txt;


        if [[ -f /opt/k8s/mysql-pod.logs ]] ;
          then
            echo File exists && echo "b: 2" >> /tmp/test/score.txt;
          else
            echo Logs file doesnt exists under /opt/k8s/mysql-pod.logs ;
          fi

        diff /opt/k8s/mysql-pod.logs /tmp/mysql-pod.logs > /dev/null;
        if [ $? -eq 0 ];
        then
            echo Files Logs Matched echo && echo "c: 8" >> /tmp/test/score.txt;
        else
            echo Invalid logs && echo "c: 0" >> /tmp/test/score.txt;
        fi

else
        echo pod mysql-pod doesnt exist &&  echo "Name: Question6" >> /tmp/test/score.txt && echo "a: 0" >> /tmp/test/score.txt;
fi
echo "---------------------------"
########### Question 6 ###########

















################ Score Calculation ####################
echo "Score Caculation" 
uuid=$(jc dmidecode | jq .[1].values.uuid -r) 
echo $uuid

touch /tmp/test/total-$uuid.txt
touch /tmp/test/percentage-$uuid.txt

var=/tmp/test/total-$uuid.txt

cat << EOF > $var
Name: total
EOF


awk '/^Name:/ { if (name) printf("%s: %d\n", name, score); name = $2; score = 0; next }
              { score += $2 }
     END      { printf("%s: %d\n", name, score) }' /tmp/test/score.txt >> /tmp/test/total-$uuid.txt

echo "---------------------------"
cat /tmp/test/total-$uuid.txt

echo "---------------------------"
awk 'function output() { if (name) printf("%s\t score = %3d, mean = %.1f\n", name, score, score*10/count) }
     /^Name:/          { output(); name = $2; score = count = 0; next }
                       { score += $2; ++count }
     END               { output() }' /tmp/test/total-$uuid.txt >> /tmp/test/percentage-$uuid.txt


cat /tmp/test/percentage-$uuid.txt

################ Score Calculation ####################
