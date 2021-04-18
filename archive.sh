set -e
function clean {
    PROJECTNAME=$1
    SCHEMENAME=$2
    printMessage "Cleaning Project"
    xcodebuild clean -workspace "$PROJECTNAME.xcworkspace" -configuration Release -scheme "$SCHEMENAME"
}
function archive {
    PROJECTNAME=$1
    SCHEMENAME=$2
    BUILD_FOLDER=$3
    printMessage "Archiving Project"
    xcodebuild archive -workspace "$PROJECTNAME.xcworkspace" -scheme "$SCHEMENAME" -archivePath "$PROJECTNAME.xcarchive"
}
function export_ipa {
    PROJECTNAME=$1
    BUILD_FOLDER=$2
    printMessage "Exporting IPA"
    xcodebuild -exportArchive -archivePath "$PROJECTNAME.xcarchive" -exportPath "$BUILD_FOLDER" -exportOptionsPlist  "$BUILD_FOLDER/ExportOptions.plist"
}
function remove_archive {
    PROJECTNAME=$1
    rm -Rf "$PROJECTNAME.xcarchive"
}
function generate_build {
    PROJECTNAME=$1
    SCHEMENAME=$2
    BUILD_ID=$3
    BUILD_FOLDER=$4
    
    clean $PROJECTNAME $SCHEMENAME
    archive $PROJECTNAME $SCHEMENAME
    export_ipa $PROJECTNAME $BUILD_FOLDER
    remove_archive $PROJECTNAME
}

function printMessage {
    clear
    printf '\n'
    echo "$(tput setaf 6)************************************  $1  ***********************************$(tput sgr0)"
    printf '\n'
}

function build {
    
    PROJECTNAME=$1
    SCHEMENAME=$2
    BUILD_ID=$3
    BUILD_MODE=$4
    PROJECTFOLDER=$5
    CONTINUE="YES"
    
    cd $PROJECTFOLDER
    
    printf '\n'
    echo "$(tput setaf 6)***************** Checking if all required params have been set  ******************$(tput sgr0)";
    printf '\n'

     if [[ -z "$PROJECTNAME" ]] ;
        then
        echo "Cannot find project name. Please pass a Project name as the first Parameter."
        printMessage
    elif [[ -z "$PROJECTNAME" ]] ;
        then
        echo "Cannot find project name. Please pass a Project name as the first Parameter."
    elif [[ -z "$SCHEMENAME" ]] ;
        then
        echo "Cannot find Xcode Schema name. Please pass a Schema name as the second Parameter."
        printMessage
    else
        for var in PROJECTNAME SCHEMENAME ; do
            if [ -n "${!var}" ] ;
                then
                echo "$var is set to ${!var}"
            else
                echo "$var is not set"
                CONTINUE="NO"
            fi
        done
    fi

    printf '\n'
    echo "$(tput setaf 6)*********************** Attempting to sign the .ipa binary file now.  ***********************$(tput sgr0)"
    printf '\n'

    if [ "$CONTINUE" = "YES" ];
        then
        generate_build $1 $2 $3 $4
        printMessage "Bye Bye"
    else
        printMessage "Bye Bye"
    fi
}

build $1 $2 $3 $4
