node {
    checkout scm
    stage('Build') {
        docker.image('python:2-alpine').inside {
            sh 'python -m py_compile sources/add2vals.py sources/calc.py'
            stash(name: 'compiled-results', includes: 'sources/*.py*')
        }
        withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
            // docker.build('$USERNAME/python:2-alpine', '.')
            dir(path: env.BUILD_ID) {
                unstash(name: 'compiled-results')
                sh 'pwd'
                sh 'ls'
                sh 'ls sources'
            }
            docker.build('bagaspm12/submission-python-app:latest', '--build-arg --build-arg BUILD_ID=${env.BUILD_ID} .')
            // Push Ke Docker Hub
            // sh "echo $PASSWORD | docker login -u $USERNAME --password-stdin"
            // sh 'docker push bagaspm12/submission-python-app:latest' 
        }    
    }
    // stage('Test') {
    //     docker.image('qnib/pytest').inside {
    //         try {
    //             sh 'py.test --junit-xml test-reports/results.xml sources/test_calc.py'
    //         }
    //         finally {
    //             junit 'test-reports/results.xml'
    //         }
    //     }
    // }
    // // stage('Manual Approval') {
    // //     input message: 'Lanjutkan ke tahap Deploy?'
    // // }
    // stage('Deploy') {
    //     def VOLUME = '$(pwd)/sources:/src'
    //     def IMAGE = 'bagaspm12/submission-python-app:latest'
    //     def deploySuccess = true
    //     //Deploy Di Local
    //     try {
    //         dir(path: env.BUILD_ID) {
    //             unstash(name: 'compiled-results')            
    //             sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F add2vals.py'" 
    //             withCredentials([sshUserPrivateKey(credentialsId: 'ec2-key', keyFileVariable: 'PRIVATE', usernameVariable: 'USER')]) {
    //                 // sh "ssh -i $PRIVATE -o StrictHostKeyChecking=no $USER@54.179.63.68 docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F add2vals.py'"
    //             }
    //         }
    //     }
    //     catch(Exception e) {
    //         echo e.getMessage()
    //         deploySuccess = false            
    //         throw e
    //     }
    //     finally {
    //         if (deploySuccess) {
    //             archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals" 
    //             sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
    //             }
    //         }
    //     }
    }

    // post {
    //     success {
    //         archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals" 
    //         sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
    //         }
    //     }  
   // }
//DECLARATIVE PIPELINE EXAMPLE
// pipeline {
//     agent none
//     options {
//         skipStagesAfterUnstable()
//     }
//     stages {
//         stage('Build') {
//             agent {
//                 docker {
//                     image 'python:2-alpine'
//                 }
//             }
//             steps {
//                 sh 'python -m py_compile sources/add2vals.py sources/calc.py'
//                 stash(name: 'compiled-results', includes: 'sources/*.py*')
//             }
//         }
//         stage('Test') {
//             agent {
//                 docker {
//                     image 'qnib/pytest'
//                 }
//             }
//             steps {
//                 sh 'py.test --junit-xml test-reports/results.xml sources/test_calc.py'
//             }
//             post {
//                 always {
//                     junit 'test-reports/results.xml'
//                 }
//             }
//         }
//         stage('Deliver') { 
//             agent any
//             environment { 
//                 VOLUME = '$(pwd)/sources:/src'
//                 IMAGE = 'cdrx/pyinstaller-linux:python2'
//             }
//             steps {
//                 dir(path: env.BUILD_ID) { 
//                     unstash(name: 'compiled-results') 
//                     sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F add2vals.py'" 
//                 }
//             }
//             post {
//                 success {
//                     archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals" 
//                     sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
//                 }
//             }
//         }
//     }
// }