# Run the provisioning script in noninteractive mode
export DEBIAN_FRONTEND=noninteractive

# Update the package system first
sudo apt-get -y update

# Install packages
sudo apt-get install -y curl
sudo apt-get install -y zsh
sudo apt-get install -y git
sudo apt-get install -y build-essential
sudo apt-get install -y python
sudo apt-get install -y libpq-dev
sudo apt-get install -y python-dev
sudo apt-get install -y postgresql
sudo apt-get install -y postgresql-contrib
sudo apt-get install -y pandoc
sudo apt-get install -y unzip

# Install dependecies
sudo apt-get build-dep -y ipython

# First run configuration
if [ ! -f /home/vagrant/.first_run ]; then
    echo ">>> First run <<<"
    touch /home/vagrant/.first_run

    # Set and configure zsh as the default shell
    git clone git://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh
    cp /home/vagrant/.oh-my-zsh/templates/zshrc.zsh-template /home/vagrant/.zshrc
    chsh -s /usr/bin/zsh vagrant

    # Add some custom configuration to zsh
    echo "# Custom Vagrant configuration" >> /home/vagrant/.zshrc
    echo "bindkey '[D' backward-word" >> /home/vagrant/.zshrc
    echo "bindkey '[C' forward-word" >> /home/vagrant/.zshrc
    echo "cd /django-home" >> /home/vagrant/.zshrc

    # Enable profile switching for iterm2
    echo "echo -e '\033]50;SetProfile=Vagrant\a'" >> /home/vagrant/.zlogin
    echo "echo -e '\033]50;SetProfile=Default\a'" >> /home/vagrant/.zlogout

    # Install pip
    mkdir /django-home/lib

    curl https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py | sudo python
    pip install -U distribute

    # Make vagrant user own /home
    chown -R vagrant /home
fi

# Install python requirements
pip install -r /vagrant/requirements-local.txt
