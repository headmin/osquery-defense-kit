-- Find programs which have cleared their environment
--
-- references:
--   * https://www.sandflysecurity.com/blog/bpfdoor-an-evasive-linux-backdoor-technical-analysis/
--
-- tags: persistent state daemon process
-- platform: linux
-- interval: 600
SELECT
  COUNT(key) AS count,
  p.pid,
  p.path,
  p.on_disk,
  hash.sha256,
  p.parent,
  p.cmdline,
  pp.name AS parent_name,
  pp.cmdline AS parent_cmd
-- Processes is 20X faster to scan than process_envs
FROM processes p
  LEFT JOIN hash ON p.path = hash.path
  LEFT JOIN process_envs pe ON p.pid = pe.pid
  LEFT JOIN processes pp ON p.parent = pp.pid
WHERE -- This time should match the interval
  p.start_time > (strftime('%s', 'now') - 600)
  -- This pattern is common with kthreadd processes
  AND p.parent != 2
GROUP BY
  p.pid
HAVING
  count == 0;

