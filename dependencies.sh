#POD_NAME=$1
#VERSION=$2
#BRANCH=$3

BUILD_ID=$1
BUILD_MODE=$2
POD_COMMAND=$3
BUILD_TEMP_FOLDER=$4
TOKEN=$5

function printMessage {
    printf '\n'
    echo "$(tput setaf 6)************************************  $1  ***********************************$(tput sgr0)"
    printf '\n'
}
function byeMessage {
    printf '\n'
    echo "$(tput setaf 6)************************************  $1  ***********************************$(tput sgr0)"
    printf '\n'
}

POD_LOCK="Podfile.Lock"
PODS="Pods"

cd Example

function pod_reset {
    printMessage "Removing Previous Pods"
    rm -Rf $POD_LOCK
    rm -Rf $PODS
}
function pod_install {
    printMessage "Installing Cocoapods...\n"
    if pod install --verbose; then
        echo "Pod installed"
    else
        byeMessage "Failed to install Pods"
        exit
    fi
}
function pod_update {
    printMessage "Updating Cocoapods...\n"
    if pod update --verbose; then
        echo "Pod updated"
    else
        byeMessage "Failed to Update Pods"
        exit
    fi
}
function pod_repo_update {
    printMessage "Updating Cocoapods Repo...\n"
    if pod repo update --verbose; then
        echo "Pod updated"
        pod_update
    else
        byeMessage "Failed to Update Pods"
        exit
    fi
}
function archive {
    BUILD_ID=$1
    BUILD_MODE=$2
    POD_COMMAND=$3
    PUBLIC_FOLDER=$4
    BUILD_TEMP_FOLDER="${PUBLIC_FOLDER}/Temp/builds"
    TOKEN=$5
    printMessage "Archieving Project..."
    cd ..
    chmod 777 archive.sh
    ./archive.sh DemoBuild DemoBuild $BUILD_ID $BUILD_MODE Example $BUILD_TEMP_FOLDER
    chmod 777 aws_build.sh
    ./aws_build.sh $BUILD_ID $BUILD_TEMP_FOLDER DemoBuild $TOKEN
#    rm -Rf "${PUBLIC_FOLDER}/Scripts/${BUILD_ID}"
}




if [[ "$POD_COMMAND" = "reset" ]]; then
    pod_reset
    pod_install
elif [[ "$POD_COMMAND" = "install" ]]; then
    pod_install
elif [[ "$POD_COMMAND" = "update" ]]; then
    pod_update
elif [[ "$POD_COMMAND" = "repo-update" ]]; then
    pod_repo_update
else
    echo "...."
fi
archive $BUILD_ID $BUILD_MODE Example $BUILD_TEMP_FOLDER $TOKEN
