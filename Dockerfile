FROM debian:sid

# Update and install base packages
RUN apt update && apt upgrade -y
RUN apt install -y adduser man-db sudo locales

# Set up the user
RUN adduser --disabled-password --shell /bin/zsh --home /home/dev dev
RUN echo "dev:password" | chpasswd
RUN usermod -aG sudo dev

# Install user dependencies
RUN apt install -y zsh curl git bat eza fzf zoxide ripgrep tmux neovim golang unzip

# Generate locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

USER dev

# Set up environment
ENV TERM xterm
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LANG en_US.UTF-8

# Set up dotfiles
RUN rm /home/dev/.profile /home/dev/.bashrc /home/dev/.bash_logout
RUN git clone https://github.com/amcoder/dotfiles.git /home/dev/.dotfiles
WORKDIR /home/dev/.dotfiles
RUN ./install

WORKDIR /home/dev

# Install zsh plugins
RUN ["/bin/zsh", "-li", "-c", "echo Installed zsh plugins"]

# Install nvm
ENV PROFILE /dev/null
ENV NVM_DIR /home/dev/.nvm
RUN bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash' \
    && . $NVM_DIR/nvm.sh \
    && nvm install v22 \
    && nvm use default \
    && npm install -g yarn

CMD ["/bin/zsh", "-li"]
