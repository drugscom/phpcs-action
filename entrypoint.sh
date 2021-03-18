#!/bin/sh
set -o errexit

REPORT_FILE=$(mktemp)

/usr/local/bin/phpcs \
  --report-full \
  --report-json="${REPORT_FILE}" \
  --parallel="$(grep -c '^processor' /proc/cpuinfo)" \
  --extensions='php' \
  -p "${@}" || PHPCS_STATUS=${?}

test -f "${REPORT_FILE}" && jq --raw-output '.files | keys[] as $k | .[$k].messages[] | "::" + (.type|ascii_downcase) + " file=" + $k + ",line=" + (.line|tostring) + ",col=" + (.column|tostring) + "::" + .message' "${REPORT_FILE}"

exit ${PHPCS_STATUS}
