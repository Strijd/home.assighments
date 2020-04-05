//Just adding for testing
node{
    ansiColor('xterm'){ 
        stage('Build Image') {
             sh("pwd && ls -la")
             sh("docker build -t ${BUILD_NUMBER}_microservice:latest .")
        }
        
        stage('Deploy'){
             sh("docker run -d --rm --name web-test -p 80:8000 crccheck/hello-world")
        }
    }
}

