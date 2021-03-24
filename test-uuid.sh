#!/bin/bash

uuid=$(jc dmidecode | jq .[1].values.uuid -r)
echo $uuid


mkdir -p /tmp/test
touch score-$uuid.txt
touch /tmp/test/error-$uuid.txt
touch /tmp/test/total-$uuid.txt
touch /tmp/test/percentage-$uuid.txt
touch /tmp/test/score-percentage-$uuid.txt


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
        echo yes pod exists &&   echo "Name: Question1" > /tmp/test/score-$uuid.txt && echo "a: 4" >> /tmp/test/score-$uuid.txt;

        if [[ $containerImageName = 'nginx:alpine' ]]
        then
          echo "true" && echo "b: 3" >> /tmp/test/score-$uuid.txt;
        else
          echo "Q1 - b - container image is not nginx:alpine" > /tmp/test/error-$uuid.txt  && echo "b: 0" >> /tmp/test/score-$uuid.txt;
        fi


        if [[ $podStatus = 'Running' ]]
        then
          echo "true" && echo "c: 3" >> /tmp/test/score-$uuid.txt;
        else
          echo "Q1 - c - pod is not in Running Status" >> /tmp/test/error-$uuid.txt && echo "c: 0" >> /tmp/test/score-$uuid.txt;
        fi
else
        echo "Q1 - a - pod doesnt exist" > /tmp/test/error-$uuid.txt && echo "Name: Question1" > /tmp/test/score-$uuid.txt && echo "a: 0" > /tmp/test/score-$uuid.txt;
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
        echo yes namespace exists && echo "Name: Question2" >> /tmp/test/score-$uuid.txt && echo "a: 2" >> /tmp/test/score-$uuid.txt;

        if [[ $checkLabelInNamespace = 'enabled' ]]
        then
          echo "true" && echo "b: 8" >> /tmp/test/score-$uuid.txt;
        else
          echo "Q2 - b - namespace does not contain label istio-injection as enabled" > /tmp/test/error-$uuid.txt && echo "b: 0" >> /tmp/test/score-$uuid.txt;
        fi
else
        echo "Q2 - a - namespace doesnt exist" > /tmp/test/error-$uuid.txt &&  echo "Name: Question2" >> /tmp/test/score-$uuid.txt && echo "a: 0" >> /tmp/test/score-$uuid.txt;
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
        echo yes deployment exists && echo "Name: Question3" >> /tmp/test/score-$uuid.txt && echo "a: 5" >> /tmp/test/score-$uuid.txt;

        if [[ $checkReplicas = 3 ]]
        then
          echo "true" && echo "b: 3" >> /tmp/test/score-$uuid.txt;
        else
          echo "Q3 - b - replicas not equal to 3" > /tmp/test/error-$uuid.txt && echo "b: 0" >> /tmp/test/score-$uuid.txt;
        fi

        if [[ $checkImage = "nginx:1.19-alpine" ]]
        then
          echo "true" && echo "c: 2" >> /tmp/test/score-$uuid.txt;
        else
          echo "Q3 - c - image name should be nginx:1.19-alpine" >> /tmp/test/error-$uuid.txt && echo "c: 0" >> /tmp/test/score-$uuid.txt;
        fi
else
        echo "Q3 - a - deployment doesnt exist" > /tmp/test/error-$uuid.txt &&  echo "Name: Question3" >> /tmp/test/score-$uuid.txt && echo "a: 0" >> /tmp/test/score-$uuid.txt;
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
        echo yes rs rs-nginx557 exists && echo "Name: Question4" >> /tmp/test/score-$uuid.txt && echo "a: 0" >> /tmp/test/score-$uuid.txt;

        if [[ $checkReadyReplicas = 3 ]]
        then
          echo "true" && echo "b: 6" >> /tmp/test/score-$uuid.txt;
        else
          echo "Q4 - b - number of ready replicas is not equal to 3" > /tmp/test/error-$uuid.txt && echo "b: 0" >> /tmp/test/score-$uuid.txt;
        fi

        if [[ $checkImage = "nginx" ]]
        then
          echo "true" && echo "c: 4" >> /tmp/test/score-$uuid.txt;
        else
          echo "Q4 - c - image name should be nginx" >> /tmp/test/error-$uuid.txt && echo "c: 0" >> /tmp/test/score-$uuid.txt;
        fi
else
        echo "Q4 - a - replicaSet rs-nginx557 doesnt exist" > /tmp/test/error-$uuid.txt &&  echo "Name: Question4" >> /tmp/test/score-$uuid.txt && echo "a: 0" >> /tmp/test/score-$uuid.txt;
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
        echo yes deployment mysql-db exists && echo "Name: Question5" >> /tmp/test/score-$uuid.txt && echo "a: 0" >> /tmp/test/score-$uuid.txt;

        echo $availableService | grep database-service > /dev/null
        if [ $? -eq 0 ] && [[ $serviceName = "database-service" ]]
          then
            echo service database-service exists && echo "b: 1" >> /tmp/test/score-$uuid.txt;
          else
            echo "Q5 - b - service name might be wrong or database-service doesnt exists" > /tmp/test/error-$uuid.txt && echo "b: 0" >> /tmp/test/score-$uuid.txt;
          fi
        if [[ $serviceSelector = "mysql-db" ]];
          then
            echo service database-service exists && echo "c: 2" >> /tmp/test/score-$uuid.txt;
          else
            echo "Q5 - c - selector labels are wrong" > /tmp/test/error-$uuid.txt && echo "c: 0" >> /tmp/test/score-$uuid.txt;
          fi
        if [[ $servicePort = 3308 ]] && [[ $serviceTargetPort = 3306 ]];
          then
            echo Ports are correct && echo "d: 5" >> /tmp/test/score-$uuid.txt;
          else
            echo "Q5 - d - one or more svc ports are wrong" >> /tmp/test/error-$uuid.txt && echo "d: 0" >> /tmp/test/score-$uuid.txt;
          fi

        if [[ $serviceType = "ClusterIP" ]] ;
          then
            echo Svc Type is Correct && echo "e: 2" >> /tmp/test/score-$uuid.txt;
          else
            echo "Q5 - e - Service Type is wrong" >> /tmp/test/error-$uuid.txt && echo "e: 0" >> /tmp/test/score-$uuid.txt;
          fi

else
        echo "Q5 - a - deployment mysql-db doesnt exist" > /tmp/test/error-$uuid.txt &&  echo "Name: Question5" >> /tmp/test/score-$uuid.txt && echo "a: 0" >> /tmp/test/score-$uuid.txt;
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
        echo yes pod mysql-pod exists && echo "Name: Question6" >> /tmp/test/score-$uuid.txt && echo "a: 0" >> /tmp/test/score-$uuid.txt;


        if [[ -f /opt/k8s/mysql-pod.logs ]] ;
          then
            echo File exists && echo "b: 2" >> /tmp/test/score-$uuid.txt;
          else
            echo "Q6 - a - Logs file doesnt exists under /opt/k8s/mysql-pod.logs" > /tmp/test/error-$uuid.txt && echo "b: 0" >> /tmp/test/score-$uuid.txt;
          fi

        diff /opt/k8s/mysql-pod.logs /tmp/mysql-pod.logs > /dev/null;
        if [ $? -eq 0 ];
        then
            echo Files Logs Matched echo && echo "c: 8" >> /tmp/test/score-$uuid.txt;
        else
            echo "Q6 - a - Invalid logs" >> /tmp/test/error-$uuid.txt && echo "c: 0" >> /tmp/test/score-$uuid.txt;
        fi

else
        echo "Q6 - a - pod mysql-pod doesnt exist" > /tmp/test/error-$uuid.txt &&  echo "Name: Question6" >> /tmp/test/score-$uuid.txt && echo "a: 0" >> /tmp/test/score-$uuid.txt;
fi
echo "---------------------------"
########### Question 6 ###########
















################ Score Calculation ####################
echo "Score Caculation"

var=/tmp/test/total-$uuid.txt

cat << EOF > $var
Name: total
EOF


awk '/^Name:/ { if (name) printf("%s: %d\n", name, score); name = $2; score = 0; next }
              { score += $2 }
     END      { printf("%s: %d\n", name, score) }' /tmp/test/score-$uuid.txt >> /tmp/test/total-$uuid.txt

echo "---------------------------"

cat /tmp/test/total-$uuid.txt

echo "---------------------------"
awk 'function output() { if (name) printf("%s\n %3d\n %.1f%\n", name, score, score*10/count) }
     /^Name:/          { output(); name = $2; score = count = 0; next }
                       { score += $2; ++count }
     END               { output() }' /tmp/test/total-$uuid.txt > /tmp/test/score-percentage-$uuid.txt

cat /tmp/test/score-percentage-$uuid.txt | jc --csv | jq .[1].total -r > /tmp/test/percentage-$uuid.txt

################ Score Calculation ####################



################ GIT #####################


    cd /tmp/test
  #  git clone git@gitlab.com:sidd-harth/k8s-dnapass.git
    git init
    git checkout -b $uuid
    git checkout $uuid
    git add .
    git commit -m $uuid
    git branch -M $uuid
    #git remote add origin git@github.com:sidd-harth/re.git
    git remote add origin git@gitlab.com:sidd-harth/k8s-dnapass.git
    git push -u origin $uuid



################ GIT #####################