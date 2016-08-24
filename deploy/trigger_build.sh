# Trigger the deployment project
curl -X POST \
     -F token=$DEPLOY_TRIGGER_TOKEN \
     -F ref=master \
     -F variables[CLUSTER]=$CLUSTER \
     https://gitlab.com/api/v3/projects/1473961/trigger/builds
