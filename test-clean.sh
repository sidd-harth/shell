#!/bin/bash

VMID=$(jc dmidecode | jq .[1].values.uuid -r)
SAPID="$VMID-$1"

#SAPID=$(jc dmidecode | jq .[1].values.SAPID -r)
echo "**********************************************************************************"
echo "* Evaluating the Solution for ID - $SAPID *"
echo "**********************************************************************************"


mkdir -p /tmp/test
touch score-$SAPID.txt
touch /tmp/test/correct-$SAPID.txt
touch /tmp/test/error-$SAPID.txt
touch /tmp/test/total-$SAPID.txt
touch /tmp/test/percentage-$SAPID.txt
touch /tmp/test/score-percentage-$SAPID.txt
touch /tmp/test/dreyfus-$SAPID.txt


########### Question 1 ###########
#echo Question 1
#echo " "
podName=$(kubectl get pod -n default -o=jsonpath='{.items[*].metadata.name}')
containerImageName=$(kubectl get po -n default -o=jsonpath='{.items[?(@.metadata.name=="nginx-448939")].spec.containers[0].image}')
podStatus=$(kubectl get po -n default -o=jsonpath='{.items[?(@.metadata.name=="nginx-448939")].status.phase}')

#echo $containerImageName
#echo $podStatus

echo $podName | grep nginx-448939 > /dev/null

if [ $? -eq 0 ] ;
then
        echo "Q1 yes pod exists" >> /tmp/test/correct-$SAPID.txt &&   echo "Name: Question1" > /tmp/test/score-$SAPID.txt && echo "a: 4" >> /tmp/test/score-$SAPID.txt;

        if [[ $containerImageName = 'nginx:alpine' ]]
        then
          echo "Q1 true - container image name is nginx:alpine" >> /tmp/test/correct-$SAPID.txt && echo "b: 3" >> /tmp/test/score-$SAPID.txt;
        else
          echo "Q1 - b - container image is not nginx:alpine" >> /tmp/test/error-$SAPID.txt  && echo "b: 0" >> /tmp/test/score-$SAPID.txt;
        fi


        if [[ $podStatus = 'Running' ]]
        then
          echo "Q1 true pod is running" >> /tmp/test/correct-$SAPID.txt && echo "c: 3" >> /tmp/test/score-$SAPID.txt;
        else
          echo "Q1 - c - pod is not in Running Status" >> /tmp/test/error-$SAPID.txt && echo "c: 0" >> /tmp/test/score-$SAPID.txt;
        fi
else
        echo "Q1 - a - pod doesnt exist" >> /tmp/test/error-$SAPID.txt && echo "Name: Question1" >> /tmp/test/score-$SAPID.txt && echo "a: 0" >> /tmp/test/score-$SAPID.txt;
fi
echo "######..................................5%"
########### Question 1 ###########

########### Question 2 ###########
# echo Question 2
# echo " "
availableNamespaces=$(kubectl get ns -o=jsonpath='{.items[*].metadata.name}')
checkLabelInNamespace=$(kubectl get ns -o=jsonpath='{.items[?(@.metadata.name=="istio-prod-73845")].metadata.labels.istio-injection}')

#echo $checkLabelInNamespace

echo $availableNamespaces | grep istio-prod-73845 > /dev/null

if [ $? -eq 0 ] ;
then
        echo "Q2 yes namespace exists" >> /tmp/test/correct-$SAPID.txt && echo "Name: Question2" >> /tmp/test/score-$SAPID.txt && echo "a: 2" >> /tmp/test/score-$SAPID.txt;

        if [[ $checkLabelInNamespace = 'enabled' ]]
        then
          echo "Q2 true label is added correctly" >> /tmp/test/correct-$SAPID.txt && echo "b: 8" >> /tmp/test/score-$SAPID.txt;
        else
          echo "Q2 - b - namespace does not contain label istio-injection as enabled" >> /tmp/test/error-$SAPID.txt && echo "b: 0" >> /tmp/test/score-$SAPID.txt;
        fi
else
        echo "Q2 - a - namespace doesnt exist" >> /tmp/test/error-$SAPID.txt &&  echo "Name: Question2" >> /tmp/test/score-$SAPID.txt && echo "a: 0" >> /tmp/test/score-$SAPID.txt;
fi
echo "############............................25%"
########### Question 2 ###########


########### Question 3 ###########
# echo Question 3
# echo " "
availableDeployments=$(kubectl get deploy -n default -o=jsonpath='{.items[*].metadata.name}')
checkReplicas=$(kubectl get deploy -n default  -o=jsonpath='{.items[?(@.metadata.name=="nginx-frontend")].spec.replicas}')
checkImage=$(kubectl get deploy -n default  -o=jsonpath='{.items[?(@.metadata.name=="nginx-frontend")].spec.template.spec.containers[0].image}')

# echo $checkReplicas
# echo $checkImage

echo $availableDeployments | grep nginx-frontend > /dev/null

if [ $? -eq 0 ] ;
then
        echo " Q3 yes deployment exists" >> /tmp/test/correct-$SAPID.txt  && echo "Name: Question3" >> /tmp/test/score-$SAPID.txt && echo "a: 5" >> /tmp/test/score-$SAPID.txt;

        if [[ $checkReplicas = 3 ]]
        then
          echo "Q3 true correct number of replicas" >> /tmp/test/correct-$SAPID.txt && echo "b: 3" >> /tmp/test/score-$SAPID.txt;
        else
          echo "Q3 - b - replicas not equal to 3" >> /tmp/test/error-$SAPID.txt && echo "b: 0" >> /tmp/test/score-$SAPID.txt;
        fi

        if [[ $checkImage = "nginx:1.19-alpine" ]]
        then
          echo "Q3 true image name is correct" >> /tmp/test/correct-$SAPID.txt && echo "c: 2" >> /tmp/test/score-$SAPID.txt;
        else
          echo "Q3 - c - image name should be nginx:1.19-alpine" >> /tmp/test/error-$SAPID.txt && echo "c: 0" >> /tmp/test/score-$SAPID.txt;
        fi
else
        echo "Q3 - a - deployment doesnt exist" >> /tmp/test/error-$SAPID.txt &&  echo "Name: Question3" >> /tmp/test/score-$SAPID.txt && echo "a: 0" >> /tmp/test/score-$SAPID.txt;
fi
echo "##################......................50%"
########### Question 3 ###########


########### Question 4 ###########
# echo Question 4
# echo " "
availableReplicaSet=$(kubectl get rs -n frontend-prod -o=jsonpath='{.items[*].metadata.name}')
checkReadyReplicas=$(kubectl get rs -n frontend-prod  -o=jsonpath='{.items[?(@.metadata.name=="rs-nginx557")].status.readyReplicas}')
checkImage=$(kubectl get rs -n frontend-prod  -o=jsonpath='{.items[?(@.metadata.name=="rs-nginx557")].spec.template.spec.containers[0].image}')

# echo $checkReadyReplicas
# echo $checkImage

echo $availableReplicaSet | grep rs-nginx557 > /dev/null

if [ $? -eq 0 ] ;
then
        echo "Q4 yes rs rs-nginx557 exists" >> /tmp/test/correct-$SAPID.txt && echo "Name: Question4" >> /tmp/test/score-$SAPID.txt && echo "a: 0" >> /tmp/test/score-$SAPID.txt;

        if [[ $checkReadyReplicas = 3 ]]
        then
          echo "Q4 true correct number of replicas" >> /tmp/test/correct-$SAPID.txt && echo "b: 6" >> /tmp/test/score-$SAPID.txt;
        else
          echo "Q4 - c - number of ready replicas is not equal to 3" >> /tmp/test/error-$SAPID.txt && echo "b: 0" >> /tmp/test/score-$SAPID.txt;
        fi

        if [[ $checkImage = "nginx" ]]
        then
          echo "Q4 true image name" >> /tmp/test/correct-$SAPID.txt && echo "c: 4" >> /tmp/test/score-$SAPID.txt;
        else
          echo "Q4 - d - image name should be nginx" >> /tmp/test/error-$SAPID.txt && echo "c: 0" >> /tmp/test/score-$SAPID.txt;
        fi
else
        echo "Q4 - a - replicaSet rs-nginx557 doesnt exist" >> /tmp/test/error-$SAPID.txt &&  echo "Name: Question4" >> /tmp/test/score-$SAPID.txt && echo "a: 0" >> /tmp/test/score-$SAPID.txt;
fi
echo "########################................70%"
########### Question 4 ###########

########### Question 5 ###########
# echo Question 5
# echo " "
availableDeploy=$(kubectl get deployment -n db-critical -o=jsonpath='{.items[*].metadata.name}')
availableService=$(kubectl get svc -n db-critical -o=jsonpath='{.items[*]}')
serviceName=$(kubectl get svc -n db-critical -o=jsonpath='{.items[?(@.metadata.name=="database-service")].metadata.name}')
servicePort=$(kubectl get svc -n db-critical -o=jsonpath='{.items[?(@.metadata.name=="database-service")].spec.ports[].port}')
serviceTargetPort=$(kubectl get svc -n db-critical -o=jsonpath='{.items[?(@.metadata.name=="database-service")].spec.ports[].targetPort}')
serviceType=$(kubectl get svc -n db-critical -o=jsonpath='{.items[?(@.metadata.name=="database-service")].spec.type}')
serviceSelector=$(kubectl get svc -n db-critical -o=jsonpath='{.items[?(@.metadata.name=="database-service")].spec.selector.app}')

# echo $availableDeploy;
# #echo $availableService;
# echo $serviceName;
# echo $servicePort;
# echo $serviceTargetPort;
# echo $serviceSelector;
# echo $serviceType;

echo $availableDeploy | grep mysql-db > /dev/null

if [ $? -eq 0 ] ;
then
        echo " Q5 yes deployment mysql-db exists" >> /tmp/test/correct-$SAPID.txt && echo "Name: Question5" >> /tmp/test/score-$SAPID.txt && echo "a: 0" >> /tmp/test/score-$SAPID.txt;

        echo $availableService | grep database-service > /dev/null
        if [ $? -eq 0 ] && [[ $serviceName = "database-service" ]]
          then
            echo " Q5 service database-service exists" >> /tmp/test/correct-$SAPID.txt && echo "b: 1" >> /tmp/test/score-$SAPID.txt;
          else
            echo "Q5 - b - service name might be wrong or database-service doesnt exists" >> /tmp/test/error-$SAPID.txt && echo "b: 0" >> /tmp/test/score-$SAPID.txt;
          fi
        if [[ $serviceSelector = "mysql-db" ]];
          then
            echo " Q5 service database-service exists" >> /tmp/test/correct-$SAPID.txt && echo "c: 2" >> /tmp/test/score-$SAPID.txt;
          else
            echo "Q5 - c - selector labels are wrong" >> /tmp/test/error-$SAPID.txt && echo "c: 0" >> /tmp/test/score-$SAPID.txt;
          fi
        if [[ $servicePort = 3308 ]] && [[ $serviceTargetPort = 3306 ]];
          then
            echo " Q5 Ports are correct" >> /tmp/test/correct-$SAPID.txt && echo "d: 5" >> /tmp/test/score-$SAPID.txt;
          else
            echo "Q5 - d - one or more svc ports are wrong" >> /tmp/test/error-$SAPID.txt && echo "d: 0" >> /tmp/test/score-$SAPID.txt;
          fi

        if [[ $serviceType = "ClusterIP" ]] ;
          then
            echo " Q5 Svc Type is Correct" >> /tmp/test/correct-$SAPID.txt && echo "e: 2" >> /tmp/test/score-$SAPID.txt;
          else
            echo "Q5 - e - Service Type is wrong" >> /tmp/test/error-$SAPID.txt && echo "e: 0" >> /tmp/test/score-$SAPID.txt;
          fi

else
        echo "Q5 - a - deployment mysql-db doesnt exist" >> /tmp/test/error-$SAPID.txt &&  echo "Name: Question5" >> /tmp/test/score-$SAPID.txt && echo "a: 0" >> /tmp/test/score-$SAPID.txt;
fi
echo "##############################..........90%"
########### Question 5 ###########


########### Question 6 ###########
# echo Question 6
# echo " "
availablePod=$(kubectl get pod -n default -o=jsonpath='{.items[*].metadata.name}')

# echo $availablePod;

echo $availablePod | grep mysql-pod > /dev/null

if [ $? -eq 0 ] ;
then
        echo "Q6 yes pod mysql-pod exists" >> /tmp/test/correct-$SAPID.txt && echo "Name: Question6" >> /tmp/test/score-$SAPID.txt && echo "a: 0" >> /tmp/test/score-$SAPID.txt;


        if [[ -f /opt/k8s/mysql-pod.logs ]] ;
          then
            echo "Q6 File exists" >> /tmp/test/correct-$SAPID.txt && echo "b: 2" >> /tmp/test/score-$SAPID.txt;
          else
            echo "Q6 - a - Logs file doesnt exists under /opt/k8s/mysql-pod.logs" >> /tmp/test/error-$SAPID.txt && echo "b: 0" >> /tmp/test/score-$SAPID.txt;
          fi

        diff -N /opt/k8s/mysql-pod.logs /tmp/mysql-pod.logs > /dev/null;
        if [ $? -eq 0 ];
        then
            echo "Q6 Files Logs Matched" >> /tmp/test/correct-$SAPID.txt && echo "c: 8" >> /tmp/test/score-$SAPID.txt;
        else
            echo "Q6 - a - Invalid logs" >> /tmp/test/error-$SAPID.txt && echo "c: 0" >> /tmp/test/score-$SAPID.txt;
        fi

else
        echo "Q6 - a - pod mysql-pod doesnt exist" >> /tmp/test/error-$SAPID.txt &&  echo "Name: Question6" >> /tmp/test/score-$SAPID.txt && echo "a: 0" >> /tmp/test/score-$SAPID.txt;
fi
echo "#######################################.100%"
########### Question 6 ###########
















################ Score Calculation ####################
#echo "Score Caculation"

var=/tmp/test/total-$SAPID.txt

cat << EOF > $var
Name: total
EOF


awk '/^Name:/ { if (name) printf("%s: %d\n", name, score); name = $2; score = 0; next }
              { score += $2 }
     END      { printf("%s: %d\n", name, score) }' /tmp/test/score-$SAPID.txt >> /tmp/test/total-$SAPID.txt

#echo "---------------------------"

#cat /tmp/test/total-$SAPID.txt

#echo "---------------------------"
awk 'function output() { if (name) printf("%s\n %3d\n %.1f\n", name, score, score*10/count) }
     /^Name:/          { output(); name = $2; score = count = 0; next }
                       { score += $2; ++count }
     END               { output() }' /tmp/test/total-$SAPID.txt > /tmp/test/score-percentage-$SAPID.txt

cat /tmp/test/score-percentage-$SAPID.txt | jc --csv | jq .[1].total -r > /tmp/test/percentage-$SAPID.txt

################ Score Calculation ####################


################ Dreyfus Rating ####################

# percentage=$(cat /tmp/test/percentage-$SAPID.txt)
# #echo $percentage

# if [ $percentage -gt 30 ] ;
# then
#         #echo "Novice (L1)" >> /tmp/test/dreyfus-$SAPID.txt;

#         if [[ $percentage -ge 30 ]] || [[ $percentage -le 40 ]] ;
#           then
#             echo "Novice (L1)" > /tmp/test/dreyfus-$SAPID.txt;
#           elif [[ $percentage -ge 41 ]] || [[ $percentage -le 55 ]];
#             then
#             echo "Advance Beginner (L2)" > /tmp/test/dreyfus-$SAPID.txt;
#           elif [[ $percentage -ge 56 ]] || [[ $percentage -le 65 ]];
#             then
#             echo "Competent (L3)" > /tmp/test/dreyfus-$SAPID.txt;
#           elif [[ $percentage -ge 66 ]] || [[ $percentage -le 80 ]];
#             then
#             echo "Proficient (L4)" > /tmp/test/dreyfus-$SAPID.txt;
#           else
#             echo "Expert (L5)" > /tmp/test/dreyfus-$SAPID.txt;
#           fi
# else
#         echo "Dreyfus rating not applicable as the score is less than 30%" > /tmp/test/dreyfus-$SAPID.txt;
# fi

################ Dreyfus Rating ####################


################ GIT #####################


    cd /tmp/test 
  #  git clone git@gitlab.com:sidd-harth/k8s-dnapass.git
    git init > /dev/null 2>&1
    git checkout -b $SAPID > /dev/null 2>&1
    git checkout $SAPID > /dev/null 2>&1
    git add . > /dev/null 2>&1
    git commit -m $SAPID > /dev/null 2>&1
    git branch -M $SAPID > /dev/null 2>&1
    #git remote add origin git@github.com:sidd-harth/re.git
    git remote add origin git@gitlab.com:sidd-harth/k8s-dnapass.git > /dev/null 2>&1
    git push -u origin $SAPID > /dev/null 2>&1



################ GIT #####################
