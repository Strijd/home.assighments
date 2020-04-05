//Just adding for testing
node{
    ansiColor('xterm'){ 
        stage('chckout'){
          checkoutRepo()
        }
        stage('Build Image') {
             sh("pwd && ls -la")
             sh("docker build -t ${BUILD_NUMBER}_microservice:latest .")
        }
        
        stage('Deploy'){
             sh("docker run -d --rm  -p 80:8000 crccheck/hello-world")
        }
    }
}

def checkoutRepo() {
    checkout changelog: false, poll: false, scm: [
        $class: 'GitSCM',
        branches: [[name: '*/master']],
        doGenerateSubmoduleConfigurations: false,
        extensions: [[$class: 'LocalBranch', localBranch: "**"]],
        submoduleCfg: [],
        userRemoteConfigs: [[
            url: 'https://github.com/Strijd/home.assighments.git'
        ]]
    ]
}

