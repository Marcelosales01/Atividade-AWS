# Atividade-AWS
## Atividade AWS+Linux Compass UOL.

1.Requisitos AWS:

* Gerar uma chave pública para acesso ao ambiente;
* Criar 1 instância EC2 com o sistema operacional Amazon Linux 2 (Família t3.small, 16 GB SSD);
* Gerar 1 elastic IP e anexar à instância EC2;
* Liberar as portas de comunicação para acesso público: (22/TCP, 111/TCP e UDP, 2049/TCP/UDP, 80/TCP, 443/TCP).

2.Requisitos Linux:

* Configurar o NFS entregue;

* Criar um diretorio dentro do filesystem do NFS com seu nome;

* Subir um apache no servidor - o apache deve estar online e rodando;

* Criar um script que valide se o serviço esta online e envie o resultado da validação para o seu diretorio no nfs;

* O script deve conter - Data HORA + nome do serviço + Status + mensagem personalizada de ONLINE ou offline;

* O script deve gerar 2 arquivos de saida: 1 para o serviço online e 1 para o serviço OFFLINE;

* Preparar a execução automatizada do script a cada 5 minutos.

* Fazer o versionamento da atividade;

* Fazer a documentação explicando o processo de instalação do Linux.

# Configuração AWS

1. Criar VPC (Virtual Private Cloud)
   * Acessar pelo console o serviço VPC;
   * Preencher nome e IPv4 CIDR;

2. Criar subnet pública
   * Preencher VPC ID com a criada anteriormente;
   * Criar nome e IPv4 CIDR block;
  
3. Criar Internet Gateway
   * Criar nome;
   * Associar á VPC criada;
  
4. Criar Route Table
   * Preencher nome;
   * Selecionar VPC criada;
   * Editar rota adicionando o Internet Gateway criado;
   * Associar a subnet criada;
  
5. Criar Instância EC2
   * Preencher nome, tipo de instância, AMI, armazenamento de acordo com os requisitos;
   * Criar par de chaves e armazená-las (Só será possível visualizá-las no momento da criação, por isso, armazene em um local seguro);
   * Associar a VPC e subnet criados;
  
6. Security Group
   * Preencher nome;
   * Preencher regras de entrada conforme citadas nos requisitos;

7. Criar Elastic IP
   * Em EC2, no lado esquerdo, selecionar Elastic IP
   * Criar e associar á instância criada;
  
# Configuração Linux

8. Conectar na Instância via ssh
   * ssh -i ~/.ssh/sua-KeyPair ec2-user@<Elastic_IP>

9. Criar EFS (Elastic File System)
    * Associar à VPC criada;
  
10. Montagem do NFS
    * Criar diretório para montagem;
        * sudo mkdir /mnt/efs
        * sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport <IP_EFS>:/ /mnt/efs
    * Configurar montagem automática no diretório /etc/fstab
        * echo "<IP_EFS>:/ /mnt/efs nfs4 defaults,_netdev 0 0" | sudo tee -a /etc/fstab
     
11. Criar diretório no NFS com seu nome
    * sudo mkdir /mnt/efs/<seu_nome>

12. Instalar Apache
    * sudo yum install -y httpd
    * Iniciar o Apache: sudo systemctl start httpd
    * Habilitar o Apache: sudo systemctl enable httpd
   
13. Criar script para monitorar o Apache
    * sudo vim /usr/local/bin/check_apache.sh
    * Script:
    ```
    
    #!/bin/bash

    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    SERVICE="httpd"
    STATUS=$(systemctl is-active $SERVICE)
    MESSAGE=""

    if [ "$STATUS" = "active" ]; then
        MESSAGE="ONLINE"
        echo "$TIMESTAMP - $SERVICE - $STATUS - $MESSAGE" >> /mnt/nfs/seu_nome/online.log
    else
        MESSAGE="OFFLINE"
        echo "$TIMESTAMP - $SERVICE - $STATUS - $MESSAGE" >> /mnt/nfs/seu_nome/offline.log
    fi

    ```

    * Dar permissão de execução para o script
        * sudo chmod +x /usr/local/bin/check_apache.sh

  14. Automatizar o script para a execução a cada 5 minutos
      * crontab -e
      * */5 * * * * /usr/local/bin/check_apache.sh
     
# Versionamento

  15. Inicializar repositório, adicionar à área staged, fazer o commit
      * cd /usr/local/bin
      * git init
      * git add .
      * git commit -m "Script de monitoramento do Apache"
     
  16. Configurar o destino e enviar para o repositório remoto
      * git remote add origin <url_do_repositorio>
      * git push -u origin master
     
#

   
