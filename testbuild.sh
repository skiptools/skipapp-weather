#!/bin/sh
#set -o pipefail

#BUILT_PRODUCTS_DIR=".build" xcodebuild -scheme skipapp-Package -derivedDataPath .build/DerivedData-${T} -skipPackagePluginValidation -configuration Debug -sdk "macosx" -destination "platform=macOS" test 2>&1 > /tmp/xcodebuild.out/${T}.txt 2>&1 && echo "${T}: PASSED" || echo "${T}: FAILED"

for _ in `seq 50`; do
    T=`date +%s`
    BUILT_PRODUCTS_DIR=".build" xcodebuild -project App.xcodeproj -scheme AppDroid -derivedDataPath .build/DerivedData-${T} -skipPackagePluginValidation -configuration Debug -sdk "macosx" -destination "platform=macOS" build 2>&1 > /tmp/xcodebuild.out/${T}.txt 2>&1 && echo "${T}: PASSED RELEASE" || echo "${T}: FAILED RELEASE"

    cd ../skipstone
    T=`date +%s`
    BUILT_PRODUCTS_DIR=".build" xcodebuild -workspace Skip.xcworkspace -scheme AppDroid -derivedDataPath .build/DerivedData-${T} -skipPackagePluginValidation -configuration Debug -sdk "macosx" -destination "platform=macOS" build 2>&1 > /tmp/xcodebuild.out/${T}.txt 2>&1 && echo "${T}: PASSED LOCAL" || echo "${T}: FAILED LOCAL"

    cd -
done


