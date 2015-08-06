Dockerfile - Apache Mesos (test only)
=====================================
![0]

# - About Apache Mesos?
http://www.yongbok.net/blog/apache-mesos-cluster-resource-management/

#### - Clone
```sh
root@ruo91:~# git clone https://github.com/ruo91/docker-mesos /opt/docker-mesos
```
#### - Build
```sh
root@ruo91:~# cd /opt/docker-mesos
root@ruo91:~# ./docker-mesos.sh
```
```sh
Usage: ./docker-mesos.sh [Options]

- Options
b, build     : Start ZooKeeper
r, run       : Start Mesos Master
rm           : Start Mesos Slave
```
```sh
root@ruo91:~# ./docker-mesos.sh build
```

#### - Run
```sh
root@ruo91:~# ./docker-mesos.sh run
```

#### - Start Daemon
- Usage
```sh
root@ruo91:~# docker exec mesos-master-1 /bin/bash mesos.sh 
```
```sh
Usage: mesos.sh [Options] [Arguments]

- Options
zk, zookeeper      : Start ZooKeeper
mm, mesos-master   : Start Mesos Master
ms, mesos-slave    : Start Mesos Slave
ma, marathon       : Start Mesos Marathon
k, kill            : kill of process

- Arguments
s, start           : Start commands
m, manual          : Manual commands

zk, zookeeper      : kill of zookeeper (k or kill option only.)
                     ex) mesos.sh k zk or mesos.sh kill zookeeper

mm, mesos-master   : kill of mesos-master (k or kill option only.)
                     ex) mesos.sh k mm or mesos.sh kill mesos-master

ms, mesos-slave    : kill of mesos-slave (k or kill option only.)
                     ex) mesos.sh k ms or mesos.sh kill mesos-slave

ma, marathon       : kill of marathon (k or kill option only.)
                     ex) mesos.sh k ma or mesos.sh kill marathon
```

- Start ZooKeeper
```sh
root@ruo91:~# docker exec mesos-master-1 /bin/bash mesos.sh zk start
```
```sh
root@ruo91:~# docker exec mesos-master-2 /bin/bash mesos.sh zk start
```
```sh
root@ruo91:~# docker exec mesos-master-3 /bin/bash mesos.sh zk start
```
```sh
Start ZooKeeper...
done
```

- Start Mesos Master
```sh
root@ruo91:~# docker exec mesos-master-1 /bin/bash mesos.sh mm start
```
```sh
root@ruo91:~# docker exec mesos-master-2 /bin/bash mesos.sh mm start
```
```sh
root@ruo91:~# docker exec mesos-master-3 /bin/bash mesos.sh mm start
```
```sh
Start Mesos Master...
done
```

- Start Mesos Slave
```sh
root@ruo91:~# docker exec mesos-slave-1 /bin/bash mesos.sh ms start
```
```sh
root@ruo91:~# docker exec mesos-slave-2 /bin/bash mesos.sh ms start
```
```sh
root@ruo91:~# docker exec mesos-slave-3 /bin/bash mesos.sh ms start
```
```sh
root@ruo91:~# docker exec mesos-slave-4 /bin/bash mesos.sh ms start
```
```sh
Start Mesos Slave...
done
```

- Start Marathon
```sh
root@ruo91:~# docker exec mesos-marathon /bin/bash mesos.sh ma start
```
```sh
Start Mesos Marathon...
done
```

# -Mesos on Docker
- Default port of Mesos Master Web UI: 5050
- Default port of Marathon Web UI: 8080 

Mesos Master & Slave
![Mesos master and slave][1]

Mesos Master Web UI
![Mesos marathon][2]

Mesos Master Web UI - Slave
![Mesos marathon][3]

Mesos Marathon
![Mesos marathon][4]

Thanks. :-)
[0]: http://cdn.yongbok.net/ruo91/img/docker/mesos/docker-mesos.png
[1]: http://cdn.yongbok.net/ruo91/img/docker/mesos/mesos-master-slave.png
[2]: http://cdn.yongbok.net/ruo91/img/docker/mesos/mesos-master-web-ui.png
[3]: http://cdn.yongbok.net/ruo91/img/docker/mesos/mesos-master-web-ui-slave.png
[4]: http://cdn.yongbok.net/ruo91/img/docker/mesos/mesos-framework-marathon.png
