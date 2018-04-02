# Remote Updates

Depending on the system, there are lots of different remote update techniques available.  We will be using one consistent with our system - since Raspbian is a Debian based Linux distribution, we will use the Debian package infrastructure.

You have been using Debian's (and Ubuntu's, which is built on Debian) system all semester, with the ```sudo apt-get update``` and ```sudo apt-get install PACKAGE_NAME``` to update your local package database and install a particular package, respectively.

There are two separate things going on here:

1. managing the package database (querying source repositories for their index information) 
1. downloading and installing those packages

The packages are Debian packages, which include:

* metadata about the package contents, versions, etc.
* scripts to be run before installing, after installing, before removing, after removing, etc.
* the actual files (binary executables, libraries, /etc configuration files, etc.)

This week we'll be creating a [debian package](https://wiki.debian.org/RepositoryFormat) for our lamp software and automating the update process.  First, though, we need to create a package repository to host our packages. 

# Creating an Apt Repository

We're going to create a Debian package repository using [reprepro](https://mirrorer.alioth.debian.org). We'll host this on the same EC2 instance as our Django server and route it through nginx, which is already up and running to serve our Django app.

### Creating Keys

Reprepro uses [GPG](https://www.gnupg.org) keys for security, so we'll start by making keys. GPG uses [system entropy](https://en.wikipedia.org/wiki/Entropy_%28computing%29#Linux_kernel) to generate secure keys. Unfortunately we won't have enough entropy on our EC2 server -- there's no mouse and keyboard data and not nearly enough disk activity to fill the pool. 

So, as a workaround, we're going to use [rng-tools](https://www.gnu.org/software/hurd/user/tlecarrour/rng-tools.html) to generate entropy. Note that **this is a poor workaround** and will not produce cryptographically secure keys. In a production system we should generate entropy using a [hardware RNG](https://en.wikipedia.org/wiki/Hardware_random_number_generator) or by generating the keys on a local machine with keyboard and mouse activity and transferring them to our server.

```bash
cloud$ sudo apt-get install rng-tools
cloud$ sudo rngd -r /dev/urandom
```

Now we're going to configure options for how GPG keys are generated. 

We need to make our **~/.gnupg** directory and limit permissions:

```bash
cloud$ mkdir -p ~/.gnupg
cloud$ chmod og-rwx ~/.gnupg
```

Edit **~/.gnupg/gpg.conf** so that it contains the following:

```
personal-digest-preferences SHA256
cert-digest-algo SHA256
default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed
```

Finally, generate the keys:

```bash
cloud$ gpg --gen-key
```

It will ask you several questions. Answer:

* Kind of key: (1) RSA and RSA
* Length: 4096
* Expiry: 0 (key does not expire, confirm)
* Enter name and email, NO COMMENT
* Enter a passphrase and confirm. You'll need to enter this passphrase when you submit a new package to the repo.

Now go ahead and list your key:

```bash
cloud$ gpg --list-keys
```

You should get some sort of output like this:

```
pub   4096R/ND581159 2015-11-17
uid                  Your Name <you@email.com>
sub   4096R/T52BD838 2015-11-17
```

Write down the value for the subkey (after "sub"), specifically the value after the **4096R/**. In the example above, it would be **T52BD838**. You'll need this in a moment.

Publish the key to keyserver.ubuntu.com so we can access it later on our lamp. Replace {{SUB_KEY}} with the key value you just noted (T52BD838, in the example above).

```bash
gpg --keyserver keyserver.ubuntu.com --send-key {{SUB_KEY}}
```

### Create repository

Install reprepro:

```bash
cloud$ sudo apt-get install -y reprepro
```

Create a directory structure for your Debian repo, then ensure your user is the owner of the directory structure:

```bash
cloud$ sudo mkdir -p ~/connected-devices/Web/reprepro/ubuntu/{conf,dists,incoming,indices,logs,pool,project,tmp}
cloud$ cd ~/connected-devices/Web/reprepro/ubuntu/
cloud$ sudo chown -R `whoami` .
```

Now edit **~/connected-devices/Web/reprepro/ubuntu/conf/distributions** in your editor of choice. Replace the following values:

* {{FULL_NAME}} - Your full name (e.g., Jane Doe)
* {{REPO_NAME}} - Repo full name (e.g., Jane's Debian Repo)
* {{REPO_SHORT_NAME}} - Single lower case word used to refer to repository (e.g., jane)
* {{SUB_KEY}} - Key you wrote down in earlier (e.g., T52BD838)

```
Origin: {{FULL_NAME}}
Label: {{REPO_NAME}}
Codename: {{REPO_SHORT_NAME}}
Architectures: armhf armel
Suite: stable
Components: main non-free contrib
Description: Local Debian repository
SignWith: {{SUB_KEY}}
```

That should be enough to run your package server, although it's not exposed to the internet yet.

Next up: [11.2 Building a Deb Package](../11.2_Building_a_Deb_Package/README.md)

&copy; 2015-18 LeanDog, Inc. and Nick Barendt
