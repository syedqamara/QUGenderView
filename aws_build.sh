CURL='/usr/bin/curl'

function api_call {
    URL=$1
    TOKEN=$2
    JSON=$3
    OUTPUT_FILE_NAME=$4
    $(curl --request POST --url "$URL" --header "Authorization: Bearer ${TOKEN}" --header "Content-Type: application/json" --header "Postman-Token: 11f4f673-479f-47b9-a28e-acc5f6ec03b1" --header "cache-control: no-cache" --data "$JSON" -o $OUTPUT_FILE_NAME)
}
function aws_upload {
    LOCAL_FILE=$1
    BUCKET_NAME=$2
    PREFIX=$3
    aws s3 cp $LOCAL_FILE "s3://${BUCKET_NAME}/${PREFIX}${LOCAL_FILE}" --acl public-read-write
}

BUILD_ID=$1
BUILD_TEMP_FOLDER=$2
IPA=$3
TOKEN=$4

BASE_URL="http://127.0.0.1:8080"
BUCKET_NAME="entbuilds"
REGION="ap-southeast-1"
PREFIX="builds/app/$BUILD_ID/"
MANIFEST_FILE_NAME="manifest.plist"
TITLE="DemoBuild"
IPA_NAME="$IPA.ipa"
cd $BUILD_TEMP_FOLDER
cd $BUILD_ID
unzip $IPA_NAME
BUNDLE_ID=$(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "Payload/DemoBuild.app/info.plist")
VERSION_NUM=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "Payload/DemoBuild.app/info.plist")
BUILD_NUM=$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "Payload/DemoBuild.app/info.plist")
rm -Rf Payload

aws_upload $IPA_NAME $BUCKET_NAME $PREFIX


AWS_IPA_URL="https://${BUCKET_NAME}.s3-${REGION}.amazonaws.com/${PREFIX}${IPA_NAME}"

#################################
echo "Generating Manifest Plist"
#################################
MANIFEST_API_URL="${BASE_URL}/api/build_manifest"
MANIFEST_JSON_TEMPLATE='{"url":"%s","version":"%s","id":"%s","title":"%s"}'
MANIFEST_JSON=$(printf "$MANIFEST_JSON_TEMPLATE" "$IPA_URL" "$VERSION_NUM" "$BUILD_ID" "$TITLE")
api_call $MANIFEST_API_URL $TOKEN $MANIFEST_JSON $MANIFEST_FILE_NAME


#################################
echo "Uploading Manifest Plist"
#################################
aws_upload $MANIFEST_FILE_NAME $BUCKET_NAME $PREFIX
AWS_MANIFEST_URL="https://${BUCKET_NAME}.s3-${REGION}.amazonaws.com/${PREFIX}${MANIFEST_FILE_NAME}"

#################################
echo "Updating Build Link"
#################################
MANIFEST_API_URL="${BASE_URL}/api/builds/update"
BUILD_UPDATE_JSON_TEMPLATE='{"build_link":"%s","build_status":"success","id":"%s"}'
BUILD_UPDATE_JSON=$(printf "$BUILD_UPDATE_JSON_TEMPLATE" "$AWS_MANIFEST_URL" "$BUILD_ID")
api_call $MANIFEST_API_URL $TOKEN $BUILD_UPDATE_JSON "temp.txt"
rm -RF $MANIFEST_FILE_NAME
rm -RF "temp.txt"


cd ..
rm -Rf $BUILD_ID
