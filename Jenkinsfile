// node {
//     checkout scm
//     stage('Build') {
//         docker.image('python:2-alpine').inside {
//             sh 'python -m py_compile sources/add2vals.py sources/calc.py'
//             stash(name: 'compiled-results', includes: 'sources/*.py*')
//         }
//     }
//     stage('Test') {
//         docker.image('qnib/pytest').inside {
//             try {
//                 sh 'py.test --junit-xml test-reports/results.xml sources/test_calc.py'
//             }
//             finally {
//                 junit 'test-reports/results.xml'
//             }
//         }
//     }
//     // stage('Manual Approval') {
//     //     input message: 'Lanjutkan ke tahap Deploy?'
//     // }
//     stage('Deploy') {
//         //Deploy Di Local
//         dir(path: env.BUILD_ID) {
//             unstash(name: 'compiled-results')
//             // docker.image('cdrx/pyinstaller-linux:python2').inside('-v /submission-python/sources:/src', "--entrypoint=''") {
//             sh "docker run --rm -v /submission-python/sources:/src --entrypoint='' cdrx/pyinstaller-linux:python2 'pyinstaller -F add2vals.py'" 
//             // sh 'pyinstaller -F add2vals.py'
//             // unstash(name: 'compiled-results') 
//             }
//         }
//     }
//     // post {
//     //     success {
//     //         archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals" 
//     //         sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
//     //         }
//     //     }  
//    // }
//DECLARATIVE PIPELINE EXAMPLE
pipeline {
    agent none
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Build') {
            agent {
                docker {
                    image 'python:2-alpine'
                }
            }
            steps {
                sh 'python -m py_compile sources/add2vals.py sources/calc.py'
                stash(name: 'compiled-results', includes: 'sources/*.py*')
            }
        }
        stage('Test') {
            agent {
                docker {
                    image 'qnib/pytest'
                }
            }
            steps {
                sh 'py.test --junit-xml test-reports/results.xml sources/test_calc.py'
            }
            post {
                always {
                    junit 'test-reports/results.xml'
                }
            }
        }
        stage('Deliver') { 
            agent any
            environment { 
                VOLUME = '$(pwd)/sources:/src'
                IMAGE = 'cdrx/pyinstaller-linux:python2'
            }
            steps {
                dir(path: env.BUILD_ID) { 
                    unstash(name: 'compiled-results') 
                    sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F add2vals.py'" 
                }
            }
            post {
                success {
                    archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals" 
                    sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
                }
            }
        }
    }
}