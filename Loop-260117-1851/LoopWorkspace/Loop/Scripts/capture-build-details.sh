#!/bin/sh

#  capture-build-details.sh
#  Loop
#
#  Copyright © 2019 LoopKit Authors. All rights reserved.

SCRIPT="$(basename "${0}")"
SCRIPT_DIRECTORY="$(dirname "${0}")"

error() {
  echo "ERROR: ${*}" >&2
  echo "Usage: ${SCRIPT} [-r|--git-source-root git-source-root] [-p|--provisioning-profile-path provisioning-profile-path]" >&2
  echo "Parameters:" >&2
  echo "  -p|--provisioning-profile-path <provisioning-profile-path> path to the .mobileprovision provisioning profile file to check for expiration; optional, defaults to \${HOME}/Library/MobileDevice/Provisioning Profiles/\${EXPANDED_PROVISIONING_PROFILE}.mobileprovision" >&2
  exit 1
}

warn() {
  echo "WARN: ${*}" >&2
}

info() {
  echo "INFO: ${*}" >&2
}

info_plist_path="${BUILT_PRODUCTS_DIR}/${CONTENTS_FOLDER_PATH}/BuildDetails.plist"
xcode_build_version=${XCODE_PRODUCT_BUILD_VERSION:-$(xcodebuild -version | grep version | cut -d ' ' -f 3)}

while [[ $# -gt 0 ]]
do
  case $1 in
    -i|--info-plist-path)
      info_plist_path="${2}"
      shift 2
      ;;
    -p|--provisioning-profile-path)
      provisioning_profile_path="${2}"
      shift 2
      ;;
  esac
done

if [ ${#} -ne 0 ]; then
  error "Unexpected arguments: ${*}"
fi

# Check if plist exists, create it if it doesn't
if [ "${info_plist_path}" == "/" ]; then
  error "Invalid plist path: ${info_plist_path}"
fi

if [ ! -e "${info_plist_path}" ]; then
  info "BuildDetails.plist does not exist, creating it at ${info_plist_path}"
  mkdir -p "$(dirname "${info_plist_path}")"
  # Create an empty plist file
  echo '<?xml version="1.0" encoding="UTF-8"?>' > "${info_plist_path}"
  echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> "${info_plist_path}"
  echo '<plist version="1.0">' >> "${info_plist_path}"
  echo '<dict/>' >> "${info_plist_path}"
  echo '</plist>' >> "${info_plist_path}"
fi

info "Gathering build details in ${PWD}"

# Function to safely update plist
update_plist() {
  local key="$1"
  local value="$2"
  if plutil -replace "$key" -string "$value" "${info_plist_path}" 2>/dev/null; then
    info "Updated ${key}"
  else
    warn "Failed to update ${key}"
  fi
}

if [ -e .git ]; then
  rev=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
  if [ -n "$rev" ] && [ "$rev" != "unknown" ]; then
    update_plist "com-loopkit-Loop-git-revision" "${rev:0:7}"
  else
    warn "Could not get git revision"
  fi
  branch=$(git branch --show-current 2>/dev/null || echo "")
  if [ -n "$branch" ]; then
    update_plist "com-loopkit-Loop-git-branch" "${branch}"
  else
    warn "No git branch found, not setting com-loopkit-Loop-git-branch"
  fi
fi

update_plist "com-loopkit-Loop-srcroot" "${PWD}"
update_plist "com-loopkit-Loop-build-date" "$(date)"
update_plist "com-loopkit-Loop-xcode-version" "${xcode_build_version}"

# Determine the provisioning profile path
if [ -z "${provisioning_profile_path}" ]; then
  if [ -e "${HOME}/Library/MobileDevice/Provisioning Profiles/${EXPANDED_PROVISIONING_PROFILE}.mobileprovision" ]; then
    provisioning_profile_path="${HOME}/Library/MobileDevice/Provisioning Profiles/${EXPANDED_PROVISIONING_PROFILE}.mobileprovision"
  elif [ -e "${HOME}/Library/Developer/Xcode/UserData/Provisioning Profiles/${EXPANDED_PROVISIONING_PROFILE}.mobileprovision" ]; then
    provisioning_profile_path="${HOME}/Library/Developer/Xcode/UserData/Provisioning Profiles/${EXPANDED_PROVISIONING_PROFILE}.mobileprovision"
  else
    warn "Provisioning profile not found in expected locations"
  fi
fi

if [ -e "${provisioning_profile_path}" ]; then
  profile_expire_date=$(security cms -D -i "${provisioning_profile_path}" 2>/dev/null | plutil -p - 2>/dev/null | grep ExpirationDate | cut -b 23-)
  if [ -n "$profile_expire_date" ]; then
    # Convert to plutil format
    profile_expire_date=$(date -j -f "%Y-%m-%d %H:%M:%S" "${profile_expire_date}" +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || echo "")
    if [ -n "$profile_expire_date" ]; then
      if plutil -replace com-loopkit-Loop-profile-expiration -date "${profile_expire_date}" "${info_plist_path}" 2>/dev/null; then
        info "Updated provisioning profile expiration"
      else
        warn "Failed to update provisioning profile expiration"
      fi
    fi
  fi
else
  warn "Invalid provisioning profile path ${provisioning_profile_path}"
fi

# determine if this is a workspace build
# if so, fill out the git revision and branch
if [ -e ../.git ]
then
    pushd . > /dev/null
    cd ..
    rev=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
    if [ -n "$rev" ] && [ "$rev" != "unknown" ]; then
      update_plist "com-loopkit-LoopWorkspace-git-revision" "${rev:0:7}"
    fi
    branch=$(git branch --show-current 2>/dev/null || echo "")
    if [ -n "$branch" ]; then
        update_plist "com-loopkit-LoopWorkspace-git-branch" "${branch}"
    fi
    popd . > /dev/null
fi
