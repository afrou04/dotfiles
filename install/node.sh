
sudo apt install -y nodejs npm && \
  npm install n -g && \
  n stable && \
  apt purge -y nodejs npm && \
  apt purge -y nodejs npm 
