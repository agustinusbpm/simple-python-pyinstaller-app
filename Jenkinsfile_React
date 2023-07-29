node{
    withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
        stage('Build') {
            checkout scm
            docker.image('node:16-buster-slim').inside('-p 3000:3000') {
                sh 'npm install'
                artifacts: 'node_modules/**'
                }
            sh 'docker build -t $USERNAME/submission-react-app .'
            sh "echo $PASSWORD | docker login -u $USERNAME --password-stdin"
            sh 'docker push $USERNAME/submission-react-app'        
            }
    docker.image('bagaspm12/submission-react-app').inside('-p 3000:3000') {
        stage('Test') {
                sh './jenkins/scripts/test.sh'
        }
        stage('Manual Approval') {
            input message: 'Lanjutkan ke tahap Deploy?'
        }
    }
        stage('Deploy') {
            //Deploy Di Local
            docker.image('bagaspm12/submission-react-app').inside('-p 3000:3000') {
                sh './jenkins/scripts/deliver.sh'
                sleep(time: 1, unit: 'MINUTES')
                sh './jenkins/scripts/kill.sh'
                }
            //Deploy Di AWS EC2
            withCredentials([sshUserPrivateKey(credentialsId: 'ec2-key', keyFileVariable: 'PRIVATE', usernameVariable: 'USER')]) {
                sh 'ssh -i $PRIVATE -o StrictHostKeyChecking=no $USER@54.179.63.68 docker pull bagaspm12/submission-react-app'
                sh 'ssh -i $PRIVATE -o StrictHostKeyChecking=no $USER@54.179.63.68 docker stop submission-react-app'
                // sh 'ssh -i $PRIVATE -o StrictHostKeyChecking=no $USER@54.179.63.68 docker rm submission-react-app'
                sh 'ssh -i $PRIVATE -o StrictHostKeyChecking=no $USER@54.179.63.68 docker run --rm -d --name submission-react-app -p 3000:3000 bagaspm12/submission-react-app'
                }
            }
        }
    }