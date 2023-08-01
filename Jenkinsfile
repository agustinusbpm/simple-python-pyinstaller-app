node {
    checkout scm
    stage('Build') {
        docker.image('python:2-alpine').inside {
            sh 'python -m py_compile sources/add2vals.py sources/calc.py'
            stash(name: 'compiled-results', includes: 'sources/*.py*')
        }
        // Build Docker Image Untuk Deploy Di AWS
        withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
            unstash(name: 'compiled-results')
            docker.build('bagaspm12/submission-python-app:latest', '.')
            // Push Ke Docker Hub
            sh "echo $PASSWORD | docker login -u $USERNAME --password-stdin"
            sh 'docker push bagaspm12/submission-python-app:latest' 
        }    
    }
    stage('Test') {
        docker.image('qnib/pytest').inside {
            try {
                sh 'py.test --junit-xml test-reports/results.xml sources/test_calc.py'
            }
            finally {
                junit 'test-reports/results.xml'
            }
        }
    }
    stage('Manual Approval') {
        input message: 'Lanjutkan ke tahap Deploy?'
    }
    stage('Deploy') {
        def VOLUME = '$(pwd)/sources:/src'
        def IMAGE = 'cdrx/pyinstaller-linux:python2'
        def deploySuccess = true
        def commandAWS = "docker run --rm bagaspm12/submission-python-app 'pyinstaller -F add2vals.py'"
        try {
            // Deploy Di Local
            dir(path: env.BUILD_ID) {
                unstash(name: 'compiled-results')             
                sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F add2vals.py'" 
            }
            // Deploy Di AWS EC2
            sshagent(['ec2-key']) {
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@18.140.5.87 mkdir -p /home/ubuntu/submission-python-app/' + env.BUILD_ID + ''                 
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@18.140.5.87 docker rmi bagaspm12/submission-python-app:latest'  
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@18.140.5.87 docker pull bagaspm12/submission-python-app:latest'  
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@18.140.5.87 docker run --rm -v /home/ubuntu/submission-python-app/' + env.BUILD_ID + ':/src/dist bagaspm12/submission-python-app'
            }
        }
        catch(Exception e) {
            echo e.getMessage()
            deploySuccess = false            
            throw e
        }
        finally {
            if (deploySuccess) {
                // Membuat Artifact Di Local
                archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals"
                // Menjalankan Aplikasi Di AWS EC2
                sshagent(['ec2-key']) {  
                    sh 'ssh -o StrictHostKeyChecking=no ubuntu@18.140.5.87 sudo chmod a+x /home/ubuntu/submission-python-app/' + env.BUILD_ID + '/add2vals'
                    sh 'ssh -o StrictHostKeyChecking=no ubuntu@18.140.5.87 /home/ubuntu/submission-python-app/' + env.BUILD_ID + '/add2vals 20 7'
                }
                // Delay Selama 1 Menit
                sleep(time: 1, unit: 'MINUTES') 
                sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
                sh 'echo "Deploy Success"'
                }
            }
        }
    }