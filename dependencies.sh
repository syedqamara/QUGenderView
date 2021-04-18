#POD_NAME=$1
#VERSION=$2
#BRANCH=$3

BUILD_ID=$1
BUILD_MODE=$2
POD_COMMAND=$3

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
        clear
    else
        byeMessage "Failed to install Pods"
        exit
    fi
}
function pod_update {
    printMessage "Updating Cocoapods...\n"
    if pod update --verbose; then
        clear
    else
        byeMessage "Failed to Update Pods"
        exit
    fi
}
function pod_repo_update {
    printMessage "Updating Cocoapods Repo...\n"
    if pod repo update --verbose; then
        clear
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
    printMessage "Archieving Project..."
    cd ..
    chmod 777 archive.sh
    ./archive.sh DemoBuild DemoBuild $BUILD_ID $BUILD_MODE Example
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
clear
archive $BUILD_ID $BUILD_MODE Example
