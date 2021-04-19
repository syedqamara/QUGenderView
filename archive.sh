set -e
function clean {
    PROJECTNAME=$1
    SCHEMENAME=$2
    printMessage "Cleaning Project"
    xcodebuild clean -workspace "$PROJECTNAME.xcworkspace" -configuration Release -scheme "$SCHEMENAME" | xcpretty
}
function archive {
    PROJECTNAME=$1
    SCHEMENAME=$2
    PROVISIONING_FOLDER=$3
    printMessage "Archiving Project"
    xcodebuild archive -workspace "$PROJECTNAME.xcworkspace" -scheme "$SCHEMENAME" -archivePath "$PROJECTNAME.xcarchive" | xcpretty
}
function export_ipa {
    PROJECTNAME=$1
    PROVISIONING_FOLDER=$2
    BUILD_TEMP_FOLDER=$3
    BUILD_ID=$4
    printMessage "Exporting IPA"
    printMessage $PROVISIONING_FOLDER
    mkdir "$BUILD_TEMP_FOLDER/$BUILD_ID"
    xcodebuild -exportArchive -archivePath "$PROJECTNAME.xcarchive" -exportPath "$BUILD_TEMP_FOLDER/$BUILD_ID" -exportOptionsPlist  "$PROVISIONING_FOLDER/ExportOptions.plist" | xcpretty
}
function remove_archive {
    PROJECTNAME=$1
    rm -Rf "$PROJECTNAME.xcarchive"
}
function generate_build {
    PROJECTNAME=$1
    SCHEMENAME=$2
    BUILD_ID=$3
    PROVISIONING_FOLDER=$4
    BUILD_TEMP_FOLDER=$5
    
    clean $PROJECTNAME $SCHEMENAME
    archive $PROJECTNAME $SCHEMENAME $PROVISIONING_FOLDER
    export_ipa $PROJECTNAME $PROVISIONING_FOLDER $BUILD_TEMP_FOLDER $BUILD_ID
    remove_archive $PROJECTNAME
}

function printMessage {
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
    BUILD_TEMP_FOLDER=$6
    CONTINUE="YES"
    
    cd $PROJECTFOLDER
    
    printf '\n'
    echo "$(tput setaf 6)***************** Checking if all required params have been set  ******************$(tput sgr0)";
    printf '\n'

     if [[ -z "$PROJECTNAME" ]] ;
        then
        echo "Cannot find project name. Please pass a Project name as the first Parameter."
    elif [[ -z "$BUILD_ID" ]] ;
        then
        echo "Cannot find project Bundle Identifier. Please pass a Project name as the first Parameter."
    elif [[ -z "$BUILD_MODE" ]] ;
        then
        echo "Cannot find project Bundle Identifier. Please pass a Project name as the first Parameter."
    elif [[ -z "$SCHEMENAME" ]] ;
        then
        echo "Cannot find Xcode Schema name. Please pass a Schema name as the second Parameter."
        printMessage
    else
        for var in PROJECTNAME SCHEMENAME BUILD_ID BUILD_MODE BUILD_TEMP_FOLDER ; do
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
        echo "Generating Builds"
        generate_build $PROJECTNAME $SCHEMENAME $BUILD_ID $BUILD_MODE $BUILD_TEMP_FOLDER
    else
        printMessage "Bye Bye"
    fi
}

build $1 $2 $3 $4 $5 $6
