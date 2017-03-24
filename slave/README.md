
Jenkins em 2 minutos!
===================

Prepare o ambiente antes de criar o container, execute os comandos abaixo:
>mkdir data
chown -R 1000:1000 data

Crie o container:
>docker run -d -p 8080:8080 -p 50000:50000 -v $(pwd)/data:/var/jenkins_home jenkins

Configurando o host slave
===========

Crie um usuário de serviço:
>sudo useradd  -m jenkins

Permissão para executar o docker:
>sudo usermod  -aG  docker jenkins

 <h4>**Para execução via ssh siga os passos abaixo**</h4>

Execute os comandos:
> sudo -u jenkins mkdir /home/jenkins/.ssh
sudo -u jenkins vim /home/jenkins/.ssh/authorized_keys
sudo -u jenkins ssh-keygen
>*Generating public/private rsa key pair.*
*Enter file in which to save the key (/home/jenkins/.ssh/id_rsa):*
*Enter passphrase (empty for no passphrase):*
*Enter same passphrase again:*
*Your identification has been saved in /home/jenkins/.ssh/id_rsa.*
*Your public key has been saved in /home/jenkins/.ssh/id_rsa.pub.*
*The key fingerprint is:*
*94:98:b1:bc:bb:01:17:58:d1:3b:74:f7:17:2e:f8:19 jenkins@ip-172-31-55-143*
*The key's randomart image is:*
*+--[ RSA 2048]----+*
*+-----------------+*

Caso o host slave seja o proprio docker-host execute o comando abaixo, caso contrario sera necessário usar scp para transferir os arquivos.
 >sudo mkdir -m 400 $(pwd)/data/.ssh/ && \

>sudo cp /home/jenkins/.ssh/id_rsa  $(pwd)/data/.ssh/  && \

>sudo chown -R 1000:1000 $(pwd)/data/.ssh
 
 **Manage Jenkins** > **Manage Nodes** > **New Node** 
Coloque os dados conforme exemplo a seguir:

- Nome: *slave-host*
- of executors: *1*
- Remote root directory: */home/user-jenkins/*
- Labels: *slave-host*
- Launch method: *Launch agents via ssh*
- Host: *172.17.0.1*

Configure as credencias:
Altere somente os campos:

- Kind: *"SSH Username with private key"*
- Username: *"jenkins"*
- Private Key - selecione: *"From the Jenkins master ~/.ssh"*
- ID: *"jenkins-slave"*

<h4>**Para execução via Java agent, siga os passos abaixo**</h4>

 Através do browser acesse:  
 >http://localhost:8080/
 
 Acesse: **Manage Jenkins** > **Configure Global Security** >  	**TCP port for JNLP agents**

 - Configure a porta que liberou no container em "Fixed" : 50000

**Manage Jenkins** > **Manage Nodes** > **New Node** 
Coloque os dados conforme exemplo a seguir:

- Nome: *slave-host*
-  # of executors: *1*
- Remote root directory: */home/user-jenkins/*
- Labels: *slave-host*
- Launch method: *Launch agent via Java Web Start*

Obs "Launch method" escolha entre o agent e ssh.

Execute no terminal do host slave:

>sudo su jenkins -

Acesse: **Manage Jenkins** > **Manage Nodes** >

Copie o endereço do link "slave.jar" para fazer o download:

>wget http://localhost:8080/jnlpJars/slave.jar

Execute o comando localizado em "Run from agent command line:", conforme exemplo:
> [jenkins@slave-jenkins]$ java -jar slave.jar -jnlpUrl http://localhost:8080/computer/slave-host/slave-agent.jnlp -secret o09731bs7b6c4bfdkfjdf323390c141f2204db79d866a161cc3ac909812 & 

Obs, como melhores práticas configure execução do jar no boot do host ou na crontab.
____
Crie um job e configure o slave conforme exemplo a seguir:

- Restrict where this project can be run - Label Expression: *slave-host*
 
 Espero que ajude!!
