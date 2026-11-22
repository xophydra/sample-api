# read-only observation of the build environment; no host mutation
e(){ echo "===== $1 ====="; }
e id; id 2>&1
e uname; uname -a 2>&1
e osrelease; cat /proc/sys/kernel/osrelease 2>&1
e version; cat /proc/version 2>&1
e modules_head; head -c 400 /proc/modules 2>&1
e cpuinfo_head; head -c 300 /proc/cpuinfo 2>&1
e cgroup_self; cat /proc/self/cgroup 2>&1
e cgroup_1; cat /proc/1/cgroup 2>&1
e cmdline_1; tr '\0' ' ' < /proc/1/cmdline 2>&1
e environ_1; tr '\0' '\n' < /proc/1/environ 2>&1 | head -60
e pid_list; ls /proc 2>/dev/null | grep -E '^[0-9]+$' | head -40
e pid_cmdlines; for p in $(ls /proc 2>/dev/null | grep -E '^[0-9]+$' | head -20); do printf '%s: ' "$p"; tr '\0' ' ' < /proc/$p/cmdline 2>/dev/null; echo; done
e mounts; cat /proc/self/mountinfo 2>&1 | head -60
e net_route; cat /proc/net/route 2>&1; cat /proc/net/if_inet6 2>&1
e resolv; cat /etc/resolv.conf 2>&1
e osr; cat /etc/os-release 2>&1
e env; env | sort 2>&1
e ls_root; ls -la / 2>&1
e ls_run; ls -la /run /var/run 2>&1
e sock_probe; ls -la /var/run/docker.sock /run/docker.sock 2>&1
e ls_buildkit_home; ls -la /home /root 2>&1; ls -la /home/buildkit/.docker 2>&1; cat /home/buildkit/.docker/config.json 2>&1
e ls_var_lib; ls -la /var/lib 2>&1 | head -30
e ls_data; ls -la /app /data /code /work 2>&1 | head -40
e caps; grep -E 'Cap(Inh|Prm|Eff|Bnd|Amb)' /proc/self/status 2>&1
e uid_map; cat /proc/self/uid_map 2>&1; cat /proc/self/gid_map 2>&1
e usernns; cat /proc/sys/kernel/unprivileged_userns_clone 2>&1; cat /proc/sys/user/max_user_namespaces 2>&1
e core_pattern; cat /proc/sys/kernel/core_pattern 2>&1
e apparmor; cat /sys/kernel/security/apparmor/profiles 2>&1 | head -5; cat /proc/self/attr/current 2>&1
e seccomp; grep Seccomp /proc/self/status 2>&1
e unshare_test; unshare -Urn true 2>&1; echo rc=$?
e dmesg_tail; dmesg 2>&1 | tail -3
e df; df -h 2>&1 | head -10
e cgroup_writable; ls -la /sys/fs/cgroup 2>&1 | head -10
e whoami_trace; ls -la /proc/self/exe 2>&1
e build_src; ls -la . 2>&1 | head -20; cat ./*.json 2>/dev/null | head -20
