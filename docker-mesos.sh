# Title: Testing scripts
# Maintainer: Yongbok Kim (ruo91@yongbok.net)
#!/bin/bash

function f_build {
  # Mesos Slave
  echo "BUild Slave..." && sleep 1
      docker build --rm -t mesos:slave -f 01_mesos-slave .
  echo "Done."
  echo

  # Mesos Master
  echo "Build Master..." && sleep 1
      docker build --rm -t mesos:master -f 02_mesos-master .
  echo "Done."
  echo

  # Mesos Marathon
  echo "Build Marathon..." && sleep 1
      docker build --rm -t mesos:marathon -f 03_mesos-marathon-framework .
  echo "Done."
  echo
}

function f_run {
  # Mesos Slave
  for ((i=1; i<5; i++)); do
      echo "Run Mesos Slave... #$i" && sleep 1
          docker run -d --name="mesos-slave-$i" -h "mesos-slave-$i" mesos:slave
      echo "Done."
      echo
  done

  # Mesos Master
  for ((i=1; i<4; i++)); do
      echo "Run Mesos Master... #$i" && sleep 1
          docker run -d --name="mesos-master-$i" -h "mesos-master-$i" -p 505$i:5050 mesos:master
      echo "Done."
      echo
  done

  # Mesos Marathon
  echo "Run Marathon..." && sleep 1
      docker run -d --name="mesos-marathon" -h "mesos-marathon" -p 8080:8080 mesos:marathon
  echo "Done."
  echo
}

function f_static_ip {
  # Pipework (Static IP)
  if [[ -f "$(which docker-pipework)" || -f "$(which pipework)" ]]; then
      # Mesos Slave
      for ((i=1; i<5; i++)); do
          echo "Setting of Static IP - Mesos Slave #$i" && sleep 1
              docker-pipework docker0 mesos-slave-$i 172.17.2.$i/16
          echo "Done."
          echo
      done

      # Mesos Master
      echo "Setting of Static IP - Mesos Master #1" && sleep 1
          docker-pipework docker0 mesos-master-1 172.17.2.5/16
      echo "Done."
      echo

      echo "Setting of Static IP - Mesos Master #2" && sleep 1
          docker-pipework docker0 mesos-master-2 172.17.2.6/16
      echo "Done."
      echo

      echo "Setting of Static IP - Mesos Master #3" && sleep 1
          docker-pipework docker0 mesos-master-3 172.17.2.7/16
      echo "Done."
      echo

      # Mesos Marathon
      echo "Setting of Static IP - Mesos Marathon" && sleep 1
          docker-pipework docker0 mesos-marathon 172.17.2.8/16
      echo "Done."
      echo

  else
      echo "Install pipework..." && sleep 1
          curl -o /usr/bin/pipework -L "https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework"
          chmod a+x /usr/bin/pipework
          ln -s /usr/bin/pipework /usr/bin/docker-pipework
      echo "Done."
      echo

      # Recursive
      f_static_ip
  fi
}

function f_rm {
  echo "Step #1 - Stop all containers"
      docker stop mesos-slave-1 mesos-slave-2 mesos-slave-3 mesos-slave-4 mesos-master-1 mesos-master-2 mesos-master-3 mesos-marathon > /dev/null
  echo "Done."
  echo

  echo "Step #2 - Remove all containers"
      docker rm mesos-slave-1 mesos-slave-2 mesos-slave-3 mesos-slave-4 mesos-master-1 mesos-master-2 mesos-master-3 mesos-marathon > /dev/null
  echo "Done."
  echo

  DOCKER_IMAGES_NONE_CHECK="$(docker images | grep "<none>" | head -n 1 | awk '{ printf $1 "\n" }')"
  if [ "$DOCKER_IMAGES_NONE_CHECK" == "<none>" ]; then
      echo "Step #3 - Remove <none> images"
          docker rmi $(docker images | grep "<none>" | awk '{ printf $3 " " }')
      echo "Done."
      echo
  else
      echo
  fi
}

function f_help {
  echo "Usage: $ARG_0 [Options]"
  echo
  echo "- Options"
  echo "b, build     : Build images"
  echo "r, run       : Run containers"
  echo "rm           : Stop and remove container & images"
  echo
}

# Main
ARG_0="$0"
ARG_1="$1"

case $ARG_1 in
    b|build)
        f_build
    ;;

    r|run)
        f_run
        f_static_ip
    ;;


    rm)
        f_rm
    ;;

    *)
      f_help
    ;;
esac
