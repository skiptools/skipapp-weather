#!/bin/bash
# 
# CLI interface to skipapp
#
# Usage:
# skip.sh assemble-ipa
# skip.sh assemble-apk
set -e
set -o noglob
set -o pipefail

SKIP_DESTDIR="Packages/Skip/artifacts/"

unset stop
while test "$#" -gt 0 -a -z "$stop"; do
    case $1 in
    --output|-o)
        SKIP_DESTDIR="$2"
        if test -z "$SKIP_DESTDIR"; then
            echo "skip.sh error: --output requires an argument" >&2
            exit 1
        fi
        shift;shift;;
    --prefix)
        SKIP_DESTDIR="$2"
        if test -z "$SKIP_DESTDIR"; then
            echo "skip.sh: error: --prefix requires an argument" >&2
            exit 1
        fi
        shift;shift;;
    --clean)
        SKIP_CLEAN=1
        shift;;
    --yes|-y)
        SKIP_YES=1
        shift;;
    --debug|-d)
        SKIP_DEBUG=1
        shift;;
    --release|-r)
        SKIP_RELEASE=1
        shift;;
    --help|-h|help)
        echo "Skip help available at: https://skip.tools/docs"
        exit;;
    assemble-ipa)
        SKIP_ASSEMBLE_IPA=1
        shift;;
    assemble-apk)
        SKIP_ASSEMBLE_APK=1
        shift;;
    assemble)
        # assemble both IPA and APK
        SKIP_ASSEMBLE_IPA=1
        SKIP_ASSEMBLE_APK=1
        shift;;
    *)
        echo "skip.sh: unknown argument: $1"
        exit 1;;
        #stop=1;;
    esac
done

unset stop

prompt_yes_no() {
    if test -n "$SKIP_YES"; then
        return 0
    fi

    local question=$1
    local response

    while true; do
        read -p "$question (Y/n): " response
        case $response in
            [Yy]*|"") return 0 ;; # Return 0 for "yes" or blank response
            [Nn]*) return 1 ;;    # Return 1 for "no"
            *) echo "Invalid response. Please enter 'Y' or 'n'." ;;
        esac
    done
}

clean_build() {
    xcodebuild -scheme "AppDroid" clean
    xcodebuild -scheme "App" clean
}

assemble_ipa() {
    echo "Assembling ipa…"

    build_ipa() {
        ARCHIVE_PATH=".build/Skip/artifacts/${APPCONFIG}/${APPARTIFACT}.xcarchive"
        BUILT_PRODUCTS_DIR=".build" xcodebuild -skipPackagePluginValidation -archivePath "${ARCHIVE_PATH}" -configuration "${APPCONFIG}" -scheme "App" -sdk "iphoneos" -destination "generic/platform=iOS" -jobs 1 archive CODE_SIGNING_ALLOWED=YES CODE_SIGNING_IDENTITY="-" CODE_SIGN_STYLE=Manual

        cd "${ARCHIVE_PATH}"/Products/
        mv "Applications" "Payload"
        # create zip file with predictable timestamps for reproducible content
        find "Payload" -exec touch -t 197001010000 {} \;

        ditto -c -k --sequesterRsrc --keepParent "Payload" "${APPARTIFACT}.ipa"
        ls -la
        pwd
        cd -
        mkdir -p "${SKIP_DESTDIR}"
        cp -av "${ARCHIVE_PATH}"/Products/"${APPARTIFACT}.ipa" "${SKIP_DESTDIR}"
    }

    if test -n "$SKIP_DEBUG" || ! test -n "$SKIP_RELEASE"; then
        APPARTIFACT="App-debug"
        APPCONFIG="Debug"
        build_ipa
    fi

    if test -n "$SKIP_RELEASE" || ! test -n "$SKIP_DEBUG"; then
        APPARTIFACT="App"
        APPCONFIG="Release"
        build_ipa
    fi
}

assemble_apk() {
    echo "Assembling apk…"

    build_apk() {
        BUILT_PRODUCTS_DIR=".build" xcodebuild -skipPackagePluginValidation -configuration ${APPCONFIG} -sdk "macosx" -destination "platform=macosx" -scheme "AppDroid" -jobs 1 build CODE_SIGNING_ALLOWED=NO

        APPARTIFACT="App-Android-${APPCONFIG}"

        mkdir -p "${SKIP_DESTDIR}"
        # fix the name of the default release and debug apks
        if [ "${APPCONFIG}" == "Release" ]; then
            mv "${SKIP_DESTDIR}"/AppUI-release.apk "${SKIP_DESTDIR}"/App.apk
        else
            mv "${SKIP_DESTDIR}"/AppUI-debug.apk "${SKIP_DESTDIR}"/App-debug.apk
        fi

        ls -la "${SKIP_DESTDIR}"/
        return
    }

    # build the debug version, or release version, or both

    if test -n "$SKIP_DEBUG" || ! test -n "$SKIP_RELEASE"; then
        APPARTIFACT="App-debug"
        APPCONFIG="Debug"
        build_apk
    fi

    if test -n "$SKIP_RELEASE" || ! test -n "$SKIP_DEBUG"; then
        APPARTIFACT="App"
        APPCONFIG="Release"
        build_apk
    fi
}

assemble() {
    if test -n "$SKIP_CLEAN"; then
        clean_build
    fi

    if test -n "$SKIP_ASSEMBLE_IPA"; then
        assemble_ipa
        ls -lah "${SKIP_DESTDIR}"/
    fi

    if test -n "$SKIP_ASSEMBLE_APK"; then
        assemble_apk
        ls -lah "${SKIP_DESTDIR}"/
    fi
}


welcome() {
    echo "–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––"
    echo " Ahoy Skipper! This script with help setup your system for Skip development."
    echo "–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––"
    echo "Every action will be proceeded by a prompt unless you specify the --yes flag."
}

version_gte() {
    local check_version=$1
    local minimum_version=$2

    if [[ $(printf '%s\n' "$minimum_version" "$check_version" | sort -V | head -n1) != "$minimum_version" ]]; then
        echo "Version ${minimum_version} required ($check_version found)."
        return 1
    else
        return 0
    fi
}


check_macos_version() {
    HW_TARGET=$(uname)/$(uname -m)

    case $HW_TARGET in
    Darwin/arm64)
        HW_ARCH=darwin/aarch64;;
    Darwin/x86_64)
        HW_ARCH=darwin/x86-64;;
    #Linux/arm64|Linux/aarch64)
        #HW_ARCH=linux/aarch64;;
    #Linux/x86_64)
        #HW_ARCH=linux/x86-64;;
    *)
        echo "Skip: unsupported OS or architecture ($HW_TARGET)" >&2
        exit 1;;
    esac

    local required_version="13.4"
    printf "Checking mimumum macOS version ${required_version} … "
    local macos_version="$(sw_vers -productVersion)"
    echo "${macos_version}"
    if ! version_gte $macos_version $required_version; then
        echo "Error: Skip required macOS version $required_version."
        exit 1
    fi
}

check_homebrew() {
    if ! command -v brew &>/dev/null; then
        echo "Homebrew needs to be installed to proceed."
        echo "You can install it manually from https://brew.sh, or this script can do it for you."
        echo ""
        if prompt_yes_no "Would you like to download and install Homebrew (requires root)"; then 
            local install_script="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
            echo "Running Homebrew installer from ${install_script}…"
            /bin/bash -c "$(curl -fsSL ${install_script})"
        fi
    fi

    local required_version="4.0.21"
    printf "Checking minimum Homebrew version ${required_version} … "
    local brew_version="$(brew --version | cut -f 2 -d ' ' | head -n 1)"

    echo "${brew_version}"

    if ! version_gte $brew_version $required_version; then
        echo "Error: Homebrew version $required_version or higher is required."
        if prompt_yes_no "Would you like to run brew upgrade?"; then 
            brew upgrade
        else
            echo "Aborting due to insufficient Homebrew version."
            echo 1
        fi
    fi
}

check_gradle() {
    if ! command -v gradle &>/dev/null; then
        echo "Gradle needs to be installed to proceed."
        echo ""
        if prompt_yes_no "Would you like to run brew install gradle?"; then 
            brew install gradle
        fi
    fi

    local required_version="8.1.1"
    printf "Checking minimum Gradle version ${required_version} … "
    local gradle_version="$(gradle --version | grep 'Gradle' | cut -f 2- -d ' ' | head -n 1)"

    echo "${gradle_version}"

    if ! version_gte $gradle_version $required_version; then
        echo "Error: Gradle version $required_version or higher is required."
        if prompt_yes_no "Would you like to run brew upgrade gradle?"; then 
            brew upgrade gradle
        else
            echo "Aborting due to insufficient Gradle version."
            echo 1
        fi
    fi
}

check_android_commandlinetools() {
    PATH=${ANDROID_HOME}/tools/bin/:${PATH}

    if ! command -v sdkmanager &>/dev/null; then
        echo "Android command line tools needs to be installed to proceed."
        echo ""
        if prompt_yes_no "Would you like to run brew install android-commandlinetools?"; then 
            brew install android-commandlinetools
        fi
    fi

    local required_version="8.0"
    printf "Checking minimum Android sdkmanager version ${required_version} … "
    local sdkmanager_version="$(sdkmanager --version | head -n 1)"

    echo "${sdkmanager_version}"

    if ! version_gte $sdkmanager_version $required_version; then
        echo "Error: Android sdkmanager version $required_version or higher is required."
        if prompt_yes_no "Would you like to run brew upgrade android-commandlinetools?"; then 
            brew upgrade android-commandlinetools
        else
            echo "Aborting due to insufficient Gradle version."
            echo 1
        fi
    fi
}

check_avdmanager() {
    export ANDROID_SDK_ROOT="/usr/local/share/android-commandlinetools/"
    avdmanager list avd

    sdkmanager --list_installed
    sdkmanager "build-tools;33.0.0" "platform-tools" "emulator" "system-images;android-33;google_apis;x86_64" "platforms;android-33"
    sdkmanager --list_installed

    avdmanager list avd
    avdmanager create avd -n "Pixel_5" -d "pixel_5" -k "system-images;android-33;google_apis;x86_64"
    avdmanager list avd
}

create_app() {
    echo "Creating Skip app project"
}


#welcome
#check_macos_version
#check_homebrew
#check_gradle
#check_android_commandlinetools
#check_avdmanager
#create_app

assemble

exit
