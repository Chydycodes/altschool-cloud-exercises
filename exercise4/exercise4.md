# Exercise 4

## Task:

Install PHP 7.4 on your local linux machine using the ppa:ondrej/php package repo.

### Instruction: 

 Learn how to use the add-apt-repository command
 
 Submit the content of /etc/apt/sources.list and the output of php -v command
<br>

# Solution

Ran my ssh in vagrant machine

updated my ubuntu

Installed dependencies using the command `sudo apt install software-properties-common apt-transport-https -y`

Next I imported omdrej PHP using the command `sudo add-apt-repository ppa:ondrej/php -y`

Then, I updated again by running `sudo apt-get update`

Next I installed Php with the command `sudo apt -y install php7.4`

Php is installed and i checked the version with the command `php -v`

![This is the php version](https://github.com/Chydycodes/altschool-cloud-exercises/blob/main/exercise4/php-v.PNG)
<br>

### Content of /etc/apt/sources.list

![sources list](https://github.com/Chydycodes/altschool-cloud-exercises/blob/main/exercise4/php_sources)
