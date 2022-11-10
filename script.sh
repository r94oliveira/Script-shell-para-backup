#!/bin/sh

#Script de Backup

	#Pega o arquivo criado com a origem e destino
	FILE=~/Documentos/dirconf/dir.txt

if [ -f "$FILE" ]
then 

#============================= Preparação para realizar o backup
		
	#Procura com o sed no arquivo dir.txt o segundo parágrafo e quarto parágrafo que contêm a origem e o destino
	#Coloca a origem e o destino nas variáveis $o e $d
	o=$(sed -n 2p `find ~/Documentos/dirconf/ -name dir.txt`) 
  	d=$(sed -n 4p `find ~/Documentos/dirconf/ -name dir.txt`)
  	
	#Mostra qual é a origem e o destino
	echo
	echo "Caminho da origem: $o"
	echo "Caminho do destino: $d"
	
	# mostra onde foi criado o dir.txt
	echo
	echo -n "Caminho do arquivo de configuração: "
	echo ~/"Documentos/dirconf/dir.txt"
	echo
	
	echo "**IMPORTANTE 1: Excluir o arquivo dir.txt do diretório informado permite configurar novamente o caminho do backup com esse script. Também é possível alterar os caminhos modificando dir.txt diretamente, mas deletar e executar o script novamente evita possíveis erros**"
	echo
	echo "**IMPORTANTE 2: Para alterar o agendamento utilize o comando 'crontab -e' no terminal**"

else

#============================= Comandos executados pela primeira vez para definir diretórios e agendar

	if ! [ -f "$FILE" ] 
	then 

	echo 
	echo "* Vamos criar o diretório dirconf em sua máquina. Caso ele já exista, serã informado uma mensagem de erro, mas ainda assim o programa funcionará corretamente *"	
	echo 
	echo
	mkdir ~/Documentos/dirconf/
	cd ~/Documentos/dirconf/
	echo
	
	dircerto="n"
	
	while [ $dircerto != "s" ]; do
	echo
	echo "Digite na próxima linha o diretório de origem:"
	echo "[ Exemplo: /home/usuario/pasta1 ]"
	echo
	read o
	echo
	echo "Digite na próxima linha o diretório de destino:"
	echo "[ Exemplo: /home/usuario/pasta2 ]"
	echo	
	read d
	echo
		
	echo "Diretório de origem:" > "dir.txt"  
	echo $o >> "dir.txt"
	echo "Diretório de destino:" >> "dir.txt"
	echo $d >> "dir.txt"
		
	# mostra o caminho do arquivo dir.txt na maquina do usuario
	echo 
	echo -n "Caminho da configuração: "
	echo ~/Documentos/dirconf/
	echo 
			
	echo "IMPORTANTE: Basta excluir o arquivo dir.txt do diretório informado para poder configurar novamente o caminho do backup com esse script."
		
	#Mostra qual é a origem e o destino
	echo 
	echo "Caminho da origem: $o"
	echo "Caminho do destino: $d"
	echo 
	
	#Confirma se origem e destino estão corretas. Se não estiverem, é possível alterar.	
	echo -n "Os caminhos estão corretos [ s / n ] ?"
	echo
	read dircerto
	echo
			
	done	
		
	#Abre a tela para agendar o backup
	echo "Deseja agendar o backup? [ s / n ]"
	read backups
	
	if  [ $backups = "s" ];
	then
	
	echo
	echo "Ok, vamos agendar!"
	echo
	echo "Caso queira realizar o backup uma vez ao dia, sempre às 10 da manhã, basta fazer o seguinte:"
	echo	
	echo "Digite '0 10 * * * ' e na frente coloque o caminho completo para esse script." 
	echo "[ Exemplo: 0 10 * * * ~/Documentos/backup.sh ]"
	echo 
	echo "No entanto, você pode alterar as informações como quiser, basta seguir as instruções da tela que serã aberta."
	echo 
	echo "Na próxima tela, a qualquer momento basta apertar Ctrl+O para salvar e/ou Ctrl+X para sair."
	echo 
	echo "Está pronto para realizar o agendamento? [ s / n ]"
	read confirma
	
	if  [ $confirma = "s" ];
	then		 
		
	crontab -e
	
	fi
	
	fi
	
	echo 		
	echo "Você ainda pode modificar o agendamento depois se quiser! Basta utilizar o comando 'crontab -e' no terminal."
					
	fi	
fi
		
#============================= Execução do backup
	
	echo	
	echo "Executando Backup"
	rsync -av --delete-excluded "$o" "$d"
	echo "Backup concluído!"
	echo 

