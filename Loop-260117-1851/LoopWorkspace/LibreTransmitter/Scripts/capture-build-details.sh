#!/bin/sh

#  capture-build-details.sh
#  Loop
#
#  Copyright © 2019 LoopKit Authors. All rights reserved.

echo "Libretransmitter Gathering build details in ${SRCROOT}"
cd "${SRCROOT}"

plist="${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}"

# Check if plist exists, if not, create it from the source plist
if [ ! -f "${plist}" ]; then
  echo "Warning: ${plist} does not exist yet. Creating from source..."
  source_plist="${SRCROOT}/LibreTransmitterPlugin/Info.plist"
  if [ -f "${source_plist}" ]; then
    mkdir -p "$(dirname "${plist}")"
    cp "${source_plist}" "${plist}"
  else
    echo "Error: Source plist not found at ${source_plist}"
    exit 1
  fi
fi

prefix="com-loopkit-libre"

# Function to safely update plist
update_plist() {
  local key="$1"
  local value="$2"
  if plutil -replace "$key" -string "$value" "${plist}" 2>/dev/null; then
    echo "Updated ${key}"
  else
    echo "Warning: Failed to update ${key}"
  fi
}

if [ -e .git ]; then
  rev=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
  dirty=$([[ -z $(git status -s 2>/dev/null) ]] || echo '-dirty')
  update_plist "$prefix-git-revision" "${rev}${dirty}"
  
  branch=$(git branch 2>/dev/null | grep \* | cut -d ' ' -f2- || echo "unknown")
  update_plist "$prefix-git-branch" "${branch}"

  remoteurl=$(git config --get remote.origin.url 2>/dev/null || echo "unknown")
  update_plist "$prefix-git-remote" "${remoteurl}"
fi

update_plist "$prefix-srcroot" "${SRCROOT}"
update_plist "$prefix-build-date" "$(date)"
update_plist "$prefix-xcode-version" "${XCODE_PRODUCT_BUILD_VERSION}"

echo "Listing all custom plist properties:"
plutil -p "${plist}" 2>/dev/null | grep "$prefix" || echo "No custom properties found"



