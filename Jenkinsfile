pipeline {
    agent {
      label 'go'
    }
    parameters {
        string(name:'TAG_NAME',defaultValue: '1.0.0',description:'')
    }
    environment{
        GITHUB_CREDENTIAL_ID='github-id'
        DOCKER_CREDENTIAL_ID='dockerhub-id'
        KUBECONFIG_CREDENTIAL_ID='demo-kubeconfig'
        REGISTRY = 'docker.io'
        DOCKERHUB_NAMESPACE = 'xiangyt'
        GITHUB_ACCOUNT = 'xiangyt'
        APP_NAME='helloworld'
    }
    stages {
        stage('build & push') {
            steps {
                container ('go') {
                    sh 'docker build -t $REGISTRY/$DOCKERHUB_NAMESPACE/$APP_NAME:$TAG_NAME .'
                    withCredentials([usernamePassword(passwordVariable : 'DOCKER_PASSWORD' ,usernameVariable : 'DOCKER_USERNAME' ,credentialsId : "$DOCKER_CREDENTIAL_ID" ,)]) {
                        sh 'echo "$DOCKER_PASSWORD" | docker login $REGISTRY -u "$DOCKER_USERNAME" --password-stdin'
                        sh 'docker push $REGISTRY/$DOCKERHUB_NAMESPACE/$APP_NAME:$TAG_NAME'
                    }
                }
            }
        }

        stage ('deploy app') {
            steps {
                container ('go') {
                    withCredentials([
                        kubeconfigFile(
                            credentialsId: env.KUBECONFIG_CREDENTIAL_ID,
                            variable: 'KUBECONFIG')
                        ]) {
                        sh 'envsubst < ./manifest/deploy.yaml | kubectl apply -f -'
                    }
                }
            }
        }

    }
}