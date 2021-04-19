CURL='/usr/bin/curl'

BUILD_ID=$1
BUILD_TEMP_FOLDER=$2
IPA=$3
TOKEN=$4

BASE_URL="http://127.0.0.1:8080"
BUCKET_NAME="entbuilds"
REGION="ap-southeast-1"
PREFIX="builds/app/"
TITLE="DemoBuild"
IPA_NAME="$IPA.ipa"
cd $BUILD_TEMP_FOLDER
cd $BUILD_ID
unzip $IPA_NAME
BUNDLE_ID=$(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "Payload/DemoBuild.app/info.plist")
VERSION_NUM=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "Payload/DemoBuild.app/info.plist")
BUILD_NUM=$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "Payload/DemoBuild.app/info.plist")
rm -Rf Payload

#aws s3 cp $IPA_NAME "s3://${BUCKET_NAME}/${PREFIX}${IPA_NAME}" --acl public-read-write
ls -la
cd ..
rm -Rf $BUILD_ID
FINAL_URL="https://${BUCKET_NAME}.s3-${REGION}.amazonaws.com/${PREFIX}${IPA_NAME}"
MANIFEST_API_URL="${BASE_URL}/api/build_manifest"
echo "Api URL $MANIFEST_API_URL"
$RESPONSE=$(curl --request POST --url "$MANIFEST_API_URL" --header "Authorization: Bearer ${TOKEN}" --header "Content-Type: application/json" --header "Postman-Token: 11f4f673-479f-47b9-a28e-acc5f6ec03b1" --header "cache-control: no-cache" --data "{\n    \"url\": \"${FINAL_URL}\",\n    \"version\": \"${BUNDLE_ID}\",\n    \"id\": \"${BUILD_ID}\",\n    \"title\": \"${TITLE}\"\n}")
echo "Api Response Returned\n ${RESPONSE}"
