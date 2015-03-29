Dockerfile - Apache Mesos (test only)
=====================================
![0]

# - About mesos?
------------------
http://www.yongbok.net/blog/apache-mesos-cluster-resource-management/

#### - Clone
------------
```
root@ruo91:~# git clone https://github.com/ruo91/docker-mesos /opt/docker-mesos
```
#### - Build
------------
```
root@ruo91:~# cd /opt/docker-mesos
root@ruo91:~# docker build --rm -t mesos:slave -f 01_mesos-slave .
root@ruo91:~# docker build --rm -t mesos:master -f 02_mesos-master .
root@ruo91:~# docker build --rm -t mesos:marathon -f 03_mesos-marathon-framework .
```
#### - Run
------------
- Mesos Slave
```
root@ruo91:~# docker run -d --name="mesos-slave-1" -h "mesos-slave-1" mesos:slave
root@ruo91:~# docker run -d --name="mesos-slave-2" -h "mesos-slave-2" mesos:slave
root@ruo91:~# docker run -d --name="mesos-slave-3" -h "mesos-slave-3" mesos:slave
```

- Mesos Master
```
root@ruo91:~# docker run -d --name="mesos-master-1" -h "mesos-master-1" mesos:master
root@ruo91:~# docker run -d --name="mesos-master-2" -h "mesos-master-2" mesos:master
root@ruo91:~# docker run -d --name="mesos-master-3" -h "mesos-master-3" mesos:master
```

- Mesos Marathon
```
root@ruo91:~# docker run -d --name="mesos-marathon" -h "mesos-marathon" -p 8080:8080 mesos:marathon
```

# - Setting up
-------------
#### - IP of container
- Mesos Master
```
root@ruo91:~# docker inspect -f '{{ .NetworkSettings.IPAddress }}' \
mesos-master-1 mesos-master-2 mesos-master-3
```
```
172.17.0.58
172.17.0.59
172.17.0.60
```
 - Add hostname & ZooKeeper MyID, Start
 - SSH passwords: mesos
```
root@ruo91:~# ssh `docker inspect -f '{{ .NetworkSettings.IPAddress }}' mesos-master-1` \
"echo '172.17.0.59 mesos-master-2' >> /etc/hosts \
&& echo '172.17.0.60 mesos-master-3' >> /etc/hosts \
&& echo '1' > /etc/zookeeper/conf/myid && service zookeeper start"
```
```
root@ruo91:~# ssh `docker inspect -f '{{ .NetworkSettings.IPAddress }}' mesos-master-2` \
"echo '172.17.0.58 mesos-master-1' >> /etc/hosts \
&& echo '172.17.0.60 mesos-master-3' >> /etc/hosts \
&& echo '2' > /etc/zookeeper/conf/myid && service zookeeper start"
```
```
root@ruo91:~# ssh `docker inspect -f '{{ .NetworkSettings.IPAddress }}' mesos-master-3` \
"echo '172.17.0.58 mesos-master-1' >> /etc/hosts \
&& echo '172.17.0.59 mesos-master-2' >> /etc/hosts \
&& echo '3' > /etc/zookeeper/conf/myid && service zookeeper start"
```

- Mesos Slave
```
root@ruo91:~# ssh `docker inspect -f '{{ .NetworkSettings.IPAddress }}' mesos-slave-1` \
"echo '172.17.0.58 mesos-master-1' >> /etc/hosts \
&& echo '172.17.0.59 mesos-master-2' >> /etc/hosts \
&& echo '172.17.0.60 mesos-master-3' >> /etc/hosts"
```
```
root@ruo91:~# ssh `docker inspect -f '{{ .NetworkSettings.IPAddress }}' mesos-slave-2` \
"echo '172.17.0.58 mesos-master-1' >> /etc/hosts \
&& echo '172.17.0.59 mesos-master-2' >> /etc/hosts \
&& echo '172.17.0.60 mesos-master-3' >> /etc/hosts"
```
```
root@ruo91:~# ssh `docker inspect -f '{{ .NetworkSettings.IPAddress }}' mesos-slave-3` \
"echo '172.17.0.58 mesos-master-1' >> /etc/hosts \
&& echo '172.17.0.59 mesos-master-2' >> /etc/hosts \
&& echo '172.17.0.60 mesos-master-3' >> /etc/hosts"
```

- Mesos Marathon
```
root@ruo91:~# ssh `docker inspect -f '{{ .NetworkSettings.IPAddress }}' mesos-marathon` \
"echo '172.17.0.58 mesos-master-1' >> /etc/hosts \
&& echo '172.17.0.59 mesos-master-2' >> /etc/hosts \
&& echo '172.17.0.60 mesos-master-3' >> /etc/hosts"
```

# - Starting Mesos
------------------
- Mesos Slave
```
root@ruo91:~# ssh `docker inspect -f '{{ .NetworkSettings.IPAddress }}' mesos-slave-1` \
"/etc/mesos/mesos-slave.sh"
```
```
root@ruo91:~# ssh `docker inspect -f '{{ .NetworkSettings.IPAddress }}' mesos-slave-2` \
"/etc/mesos/mesos-slave.sh"
```
```
root@ruo91:~# ssh `docker inspect -f '{{ .NetworkSettings.IPAddress }}' mesos-slave-3` \
"/etc/mesos/mesos-slave.sh"
```

- Mesos Master
```
root@ruo91:~# ssh `docker inspect -f '{{ .NetworkSettings.IPAddress }}' mesos-master-1` \
"/etc/mesos/mesos-master.sh"
```
```
root@ruo91:~# ssh `docker inspect -f '{{ .NetworkSettings.IPAddress }}' mesos-master-2` \
"/etc/mesos/mesos-master.sh"
```
```
root@ruo91:~# ssh `docker inspect -f '{{ .NetworkSettings.IPAddress }}' mesos-master-3` \
"/etc/mesos/mesos-master.sh"
```

- Mesos Marathon
```
root@ruo91:~# ssh `docker inspect -f '{{ .NetworkSettings.IPAddress }}' mesos-marathon` \
"/etc/mesos/mesos-marathon.sh"
```

# -Mesos on Docker
--------------------
- Default port of Mesos Master Web UI: 5050 
- Default port of Marathon Web UI: 8080 

Mesos Master & Slave
----------------------
![Mesos master and slave][1]

Mesos Master Web UI
----------------------
![Mesos marathon][2]

Mesos Master Web UI - Slave
-----------------------------
![Mesos marathon][3]

Mesos Marathon
----------------
![Mesos marathon][4]

Thanks. :-)
[0]: http://cdn.yongbok.net/ruo91/img/docker/mesos/docker-mesos.png
[1]: http://cdn.yongbok.net/ruo91/img/docker/mesos/mesos-master-slave.png
[2]: http://cdn.yongbok.net/ruo91/img/docker/mesos/mesos-master-web-ui.png
[3]: http://cdn.yongbok.net/ruo91/img/docker/mesos/mesos-master-web-ui-slave.png
[4]: http://cdn.yongbok.net/ruo91/img/docker/mesos/mesos-framework-marathon.png
