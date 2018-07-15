pipeline {
  agent any
  environment {
    DOCKER_IMAGE = null
  }
  stages {
    stage('Build') {
      agent {
          docker {
              image 'maven:3-alpine'
            // do some caching on maven here
              args '-v $HOME/.m2:/root/.m2'
              reuseNode true	
          }
      }
      steps {
        sh 'mvn clean install'
      }
    }
    stage('dockerbuild') {
      steps {
        script {
          DOCKER_IMAGE = docker.build("myapp:latest")
        }
      }
    }
    stage('dockertest') {
      steps {
        script {
          DOCKER_IMAGE.inside {
            sh 'echo tested'
            }
        }
      }
    }    
    stage('dockerpush') {
      steps {
        script {
        	withCredentials([usernamePassword( credentialsId: 'docker-hub-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          		docker.withRegistry('', 'docker-hub-credentials') {
          		    sh "docker login -u ${USERNAME} -p ${PASSWORD}"
          			DOCKER_IMAGE.push('latest')
          		}
        	}
        }
      }
    }    
    stage('dockerrun') {
      steps {
        script {
   			try {	
				id = "myapp"
				docker.script.sh "docker stop ${id} && docker rm -f ${id}"
			} catch(e) {
	    		echo "container ${id} not found"
          	}
          	docker.withServer('tcp://yourserver:2375') {
	        	DOCKER_IMAGE.run('--name myapp -p 8180:8080')
	        }
        }
      }
    }
  }
}

