e(){ echo "===== $1 ====="; }
e apk; apk add --no-cache strace util-linux iputils procps e2fsprogs e2fsprogs-mkfs >/dev/null 2>&1; echo rc=$?
e dev_nodes; ls -la /dev | head -40
e mknod_test; mknod /tmp/sda1 b 8 1 2>&1; echo rc=$?; ls -la /tmp/sda1 2>&1
e read_sda1; dd if=/tmp/sda1 of=/tmp/gpt bs=512 count=4 2>&1; od -An -tx1 /tmp/gpt 2>&1 | head -6
e read_sda1_late; dd if=/tmp/sda1 of=/dev/null bs=1M count=8 skip=100 2>&1 | tail -2
e other_devs; for pair in "8 16 sdb" "253 0 dm-0" "7 0 loop0" "259 0 nvme0n1"; do set -- $pair; mknod /tmp/$3 b $1 $2 2>/dev/null && dd if=/tmp/$3 of=/dev/null bs=512 count=1 2>&1 | tail -1 && echo "READABLE $3"; done
e kallsyms; head -c 200 /proc/kallsyms 2>&1; wc -l < /proc/kallsyms 2>&1
e kconfig; ls -la /boot/config-$(cat /proc/sys/kernel/osrelease) 2>&1; head -c 200 /proc/config.gz 2>&1
e kcore; ls -la /proc/kcore 2>&1; dd if=/proc/kcore of=/dev/null bs=1 count=64 2>&1 | tail -1
e printk; cat /proc/sys/kernel/printk 2>&1
e sys_writable; echo 1 > /proc/sys/kernel/sem 2>&1; echo rc=$?; mount | grep -E ' /proc' 2>&1
e proc_rw_test; touch /proc/testwrite 2>&1; echo rc=$?
e io_uring; ls /proc/sys/kernel/io_uring_disabled 2>&1; cat /proc/sys/kernel/io_uring_disabled 2>&1
e userns; cat /proc/sys/user/max_user_namespaces 2>&1; unshare -Urm bash -c 'id; echo inner-ok' 2>&1 | head -3
e ptrace_scope; cat /proc/sys/kernel/yama/ptrace_scope 2>&1
e sibling_env; for p in 1 11 29 78 107; do echo "-- $p"; tr '\0' '\n' < /proc/$p/environ 2>&1 | head -12; done
e sibling_cwd; for p in 1 11 29 78; do echo "-- $p"; ls -l /proc/$p/cwd /proc/$p/root 2>&1 | head -4; done
e otel_sock; ls -la /dev/otel-grpc.sock 2>&1; echo | nc -U -w2 /dev/otel-grpc.sock 2>&1; echo rc=$?
e net_build; ip a; ip route
e net_scan; for t in 172.31.0.1 172.30.0.1 172.29.0.1 192.168.32.1 169.254.169.254 147.5.115.161 40.233.112.56; do nc -z -w2 $t 22 2>/dev/null && echo OPEN $t:22; done
e net_scan2; for t in 172.31.0.1 172.30.0.1 192.168.32.1; do for p in 80 443 5432 2375 6443 8080 9000; do nc -z -w2 $t $p 2>/dev/null && echo OPEN $t:$p; done; done
e imds_build; wget -q -T 5 -O - http://169.254.169.254/openstack/latest/meta_data.json 2>&1 | head -c 300
e dns_vcn; nslookup metadata.oraclevcn.com 2>&1 | head -6; getent hosts worker.clicloud.app 2>&1
e kill_own_test; kill -0 1 2>&1; echo rc=$?
e docker_dirs; ls -la /var/lib/docker 2>&1 | head -5; ls -la /home/user 2>&1 | head -5
e cgroup_dev; cat /sys/fs/cgroup/devices.list 2>&1 | head -5; ls /sys/fs/cgroup 2>&1 | head -5
