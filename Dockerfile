FROM debian:latest

RUN apt update && apt upgrade -y

RUN apt -y install \
    apt-transport-https \
    ca-certificates  \
    wget \
    gnupg2  \
    locales \
    git  \
    curl \
    systemctl \
    python 
    
RUN curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
RUN chmod +rx /usr/local/bin/youtube-dl

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
    
RUN wget -O- https://repo.jellyfin.org/jellyfin_team.gpg.key | apt-key add -
RUN echo "deb [arch=$( dpkg --print-architecture )] https://repo.jellyfin.org/$( awk -F'=' '/^ID=/{ print $NF }' /etc/os-release ) $( awk -F'=' '/^VERSION_CODENAME=/{ print $NF }' /etc/os-release ) main" > /etc/apt/sources.list.d/jellyfin.list

RUN apt update

RUN apt install jellyfin -y

COPY ./Init.sh /root/
COPY ./ronaldo_drinking_meme.mp4 /media

EXPOSE 8096

RUN chmod +x /root/Init.sh
CMD ["/bin/bash", "-c", "/root/Init.sh ; systemctl start jellyfin"]
