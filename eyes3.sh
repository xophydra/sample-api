e(){ echo "===== $1 ====="; }
e modules_full; cat /proc/modules 2>&1
e lockdown; cat /sys/kernel/security/lockdown 2>&1; ls /sys/kernel/security 2>&1
e modsigs; ls /sys/module/kernel/parameters 2>&1 | head; cat /sys/module/kernel/parameters/module_sig_* 2>&1
e cpuvuln; for f in /sys/devices/system/cpu/vulnerabilities/*; do printf '%s: ' "$f"; cat "$f" 2>&1; done
e ksym_count; wc -l < /proc/kallsyms 2>&1
e ksym_grep; for s in nf_tables_newrule nf_tables_newset io_uring_setup io_uring_register esp6_input xfrm_policy_insert af_packet_release bpf_probe_read_kernel commit_creds pipe_buffer_setattr keyctl_assume_authority userfaultfd_copy move_pages bpf; do printf '%s=' "$s"; grep -c " $s$" /proc/kallsyms 2>/dev/null; done
e ksym_uring; grep -c io_uring /proc/kallsyms 2>&1
e ksym_bpf; grep -c bpf_prog /proc/kallsyms 2>&1
e ksym_modreq; grep -c request_module /proc/kallsyms 2>&1
e sysctl_key; cat /proc/sys/kernel/kptr_restrict 2>&1; cat /proc/sys/kernel/unprivileged_bpf_disabled 2>&1; cat /proc/sys/net/core/bpf_jit_enable 2>&1; cat /proc/sys/kernel/perf_event_paranoid 2>&1
e modprobe_path; cat /proc/sys/kernel/modprobe 2>&1
e hostname_whoami; hostname 2>&1; cat /etc/hostname 2>&1; ls -la /etc/hosts /etc/hostname 2>&1
e uptime_host; cat /proc/uptime 2>&1; cat /proc/loadavg 2>&1
e sock_paths; ls -la /run/user 2>&1; find / -maxdepth 3 -name 'docker.sock' -o -maxdepth 3 -name 'buildkit.sock' 2>/dev/null | head
e af_packet; echo test | nc -l -p 19999 >/dev/null 2>&1 & sleep 0.2; nc -w1 127.0.0.1 19999 </dev/null 2>&1; echo netlocal_rc=$?
e ping_test; ping -c1 -W2 172.31.0.1 2>&1 | tail -2
e raw_sock; ping -c1 -W2 -s 1 8.8.8.8 2>&1 | tail -2
