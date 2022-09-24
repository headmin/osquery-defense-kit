-- https://posts.specterops.io/hunting-for-bad-apples-part-2-6f2d01b1f7d3
-- Most of these hits end up running out of the Downloads directory
SELECT
  gap.ctime,
  gap.mtime,
  gap.path,
  file.mtime,
  file.uid,
  file.ctime,
  file.gid,
  hash.sha256,
  signature.identifier,
  signature.authority
FROM
  gatekeeper_approved_apps AS gap
  LEFT JOIN file ON gap.path = file.path
  LEFT JOIN hash ON gap.path = hash.path
  LEFT JOIN signature ON gap.path = signature.path
WHERE
  gap.path NOT LIKE "/Users/%/bin/%"
  AND gap.path NOT LIKE "/Users/%/rekor-cli"
  AND gap.path NOT LIKE "/Users/%/scorecard-darwin-amd64"
GROUP BY
  gap.requirement
