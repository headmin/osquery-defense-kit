SELECT
  *
FROM
  kernel_extensions
WHERE
  path NOT LIKE "/System/Library/Extensions/%"
  AND NOT (
    idx = 0
    AND name = "__kernel__"
  );
