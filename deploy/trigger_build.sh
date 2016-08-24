# Trigger the deployment project
curl -X POST \
     -F token=$DEPLOY_TRIGGER_TOKEN \
     -F ref=master \
     -F variables[CLUSTER]=$CLUSTER \
     -F variables[DOCKER_IMAGE]=registry.gitlab.com/$CI_PROJECT_NAMESPACE/$CI_PROJECT_NAME:$CI_BUILD_REF_NAME
     https://gitlab.com/api/v3/projects/1473961/trigger/builds
