# Guia per a instal·lar "Docker Compose" Ubuntu Server 22.04.4
Faig aquesta guia per a que pugau instal·lar el `Docker Compose` sense ninguna complicació a través d'aquest README.
## 1.Conectar ssh tant en Windows com en Linux(Ubuntu):

### 1.1.Actualitzar els paquets:
Abans de fer res actualtizarem tots els paquets per si algo ix mal:
- ```plaintext
    sudo apt update && sudo apt upgrade -y
    ```
- ### 1.2.Instal·lar ssh 
 - Windows (PowerShell)
    ```plaintext
    Get-Service -Name ssh-agent
    ```
 - Linux(Ubuntu)
    ```plaintext
    sudo apt install ssh
    ```
### 1.3.Saber de l'estat de ssh
 - Windows (PowerShell)
    ```plaintext
    Get-Service -Name ssh-agent
    ```
 - Linux(Ubuntu)
    ```plaintext
    sudo sytemctl status ssh
    ```
### 1.4.Activar-lo tant de forma manual tant com de forma automàtica
#### 1.4.1 Activar-lo de forma manual
 - Windows (PowerShell)
    ```plaintext
    Start-Service ssh-agent
    ```
 - Linux(Ubuntu)
    ```plaintext
    sudo systemctl enable ssh
    ```
#### 1.4.2 Activar-lo de forma automàtica
 - Windows (PowerShell)
    ```plaintext
    Set-Service -Name ssh-agent -StartupType Automatic
    ```
 - Linux(Ubuntu)
    ```plaintext
    sudo systemctl enable --now ssh
    ```
## 2.Instal·lació de Docker
### 2.1 Instal·lació de Docker i els seus complements
Instal·lar Docker:
 - ```plaintext
    sudo apt install docker.io
    ```
Instal·lar els complements:
 - ```plaintext
    sudo apt install docker-compose-plugin
    ```
Ara necessitarem agregar el repositori oficial de Docker per a que funcione bé el Docker Compose
 - ```plaintext
    sudo apt remove docker docker-engine docker.io containerd runc
    ```
 - ```plaintext
    sudo apt install ca-certificates curl gnupg
    ```
 - ```plaintext
    sudo install -m 0755 -d /etc/apt/keyrings
    ```
 - ```plaintext
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
    ```
 - ```plaintext
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    ```
 - ```plaintext
    echo \

    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \

    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    ```
 - ```plaintext
    sudo apt update
    ```
Ara instal·larem "Docker Compose"
 - ```plaintext
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ```
### 2.2 Preparació per a executar el fitxer "docker-compose.yaml"
Primer que tot necesitarem scp (Secure Copy), un comand que ens permeteix enviar fitxers d'un ordinador a l'altre, ixí es com s'instal·la:
 - Windows (PowerShell)
    ```plaintext
    Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
    ```
 - Linux(Ubuntu)
    ```plaintext
    sudo apt install openssh-client
    ```
Ara que ja ho tenim tot instal·lat procedirem a copiar els mòduls a la màquina virtual:
 - Windows (PowerShell)
    ```plaintext
    scp C:\ruta\del\arxiu\docker-compose.yaml usuariServidor@ipServidor:/home/usuariServidor/ 
    ```
 - Linux(Ubuntu)
    ```plaintext
    scp /ruta/del/arxiu/docker-compose.yaml usuariServidor@ipServidor:/home/usuariServidor/
    ```
Ara necessitem tindre una carpeta anomenada `dev_addons` dins de la màquina virtual i posar els mòduls dins d'aquesta per a que a l'hora d'executar el "docker-compose.yaml" no ens done un error.
 - ```plaintext
   mv nomDirectori /home/usuari/dev_addons
   ```
Ara necessitem cambiar la extensió del fitxer `Dockerfile.txt` a `Dockerfile` per a que no ens done error.
 - ```plaintext
   mv Dockerfile.txt Dockerfile
   ```
### 2.3 Execució del "docker-compose.yaml"
**(Opcional)** Pots fer que el teu usuari siga del grup Docker per a no tindre que gastar "sudo" cada vegada:
 - ```plaintext
   sudo usermod -aG docker UsuariServidor
   ```
Recorda cambiar `UsuariServidor` per el nom del teu usuari de la màquina virtual.
 - ```plaintext
   su UsuariServidor
   ```

Abans d'executar res necessitem activar el docker:
 - ```plaintext
   sudo systemctl start docker
   ```
I si vols que s'inicie de forma automàtica quan encenges l'equip executa el següent:
 - ```plaintext
   sudo systemctl enable docker 
   ```
I per últim execute el `docker-compose.yaml`:
 - ```plaintext
   sudo docker compose up -d --build
   ```