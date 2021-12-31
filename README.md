# pihole

**howtos, lists and scripts for pihole**

## Index

1. [download pihole-updatelists.conf ](#download)  
2. [reverse-proxy / nginx configuration](#reverse-proxy)  
3. [deploy / docker-compose.yml](#deploy)  
4. [usage](#usage)  
  4.1 [browse](#browse)  

\# [Find Me](#findme)  
\# [License](#license)  

# 1. create groups <a name="create_groups"></a>  
**visit [pi.hole/admin/groups.php](http://pi.hole/admin/groups.php) and add:**  
```shell
firebog_tick firebog_nocross firebog_cross blp_abuse blp_ads blp_basic blp_crypto blp_drugs blp_facebook blp_fraud blp_gambling blp_malware blp_phishing blp_piracy blp_porn blp_ransomware blp_redirect blp_scam blp_smart-tv blp_tiktok blp_torrent blp_tracking blp_twitter blp_vaping blp_whatsapp blp_youtube

```






# 1. download pihole-updatelists.conf <a name="download"></a>  
**create config-folder and download pilhole-updatelists.conf**  
```shell
mkdir -p /home/docker/config-files/pihole/pihole-updatelists
cd /home/docker/config-files/pihole/pihole-updatelists
wget https://raw.githubusercontent.com/3x3cut0r/vps/main/docker/docker-compose/pihole/pihole-updatelists.conf

```

# 2. configure your nginx reverse proxy <a name="reverse-proxy"></a>  
**see: [send.conf](https://github.com/3x3cut0r/vps/blob/main/docker/docker-compose/nginx/conf.d/pihole.conf)**

# 3. deploy / docker-compose.yml <a name="deploy"></a>  
**[see docker/docker-compose/pihole/docker-compose.yml](https://github.com/3x3cut0r/vps/blob/main/docker/docker-compose/pihole/docker-compose.yml)**  

# 4. usage <a name="usage"></a>  

### 4.1 browse <a name="browse"></a>  
**Frontend**  
[https://pihole.3x3cut0r.de](https://pihole.3x3cut0r.de)  

**Backend**  
[https://pihole.3x3cut0r.de/admin](https://pihole.3x3cut0r.de/admin)  






### Find Me <a name="findme"></a>

![E-Mail](https://img.shields.io/badge/E--Mail-executor55%40gmx.de-red)
* [GitHub](https://github.com/3x3cut0r)
* [DockerHub](https://hub.docker.com/u/3x3cut0r)

### License <a name="license"></a>

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) - This project is licensed under the GNU General Public License - see the [gpl-3.0](https://www.gnu.org/licenses/gpl-3.0.en.html) for details.
