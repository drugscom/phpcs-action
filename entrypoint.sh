#!/bin/sh
set -o errexit

NUM_CPU=$(grep -c '^processor' /proc/cpuinfo)
let 'NUM_CPU*=2' || true

REPORT_FILE=$(mktemp)

/usr/local/bin/phpcs \
  --report-full \
  --report-json="${REPORT_FILE}" \
  --parallel="${NUM_CPU}" \
  --extensions='php' \
  -p "${@}" || PHPCS_STATUS=${?}

test -f "${REPORT_FILE}" && jq --raw-output '.files | keys[] as $k | .[$k].messages[] | "::" + (.type|ascii_downcase) + " file=" + $k + ",line=" + (.line|tostring) + ",col=" + (.column|tostring) + "::" + .message' "${REPORT_FILE}"

exit ${PHPCS_STATUS}
