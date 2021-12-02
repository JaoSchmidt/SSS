#!/bin/bash

# Gera site simples baseado em estoque usando os itens de arquivo .csv
# O output é um arquivo html pré-configurado
# Como usar? ./gerarSiteEstoque.sh <arquivo>
#
# É também capaz de gerar um separador quando colocado "Categoria:" no inicio de uma linha qlq,
# útil caso seja necessário separar vizualmente as tabelas geradas
#
# Algumas particularidades
# Converte tabs (\t) em ponto e virgula
# Fora esses casos, o csv precisa conter ';' como separador
# Esse programa exclui os espaços entre cada ';', pq é comum isso ocorrer ao digitar no excel
# "Categoria:" no inicio da linha torna o input inválido como .csv. Na vdd essas linhas eu adiciono dps por conta própria


# converte tabs em ';'
csv_file=itens.csv
sed 's/\t/;/g' $1 > $csv_file
echo "<!DOCTYPE html>
<html>
	<head>
		<style>
			.center {
				text-align: center;
			}
			.title {
				text-align: center;
				font-size:20px;
				font-weight:bold;
				padding-top:12px;
				padding-bottom: 12px;
				background-color: #d97012
			}
			hr.solid{
				border-top: 3px solid #bbb;
			}
			hr.rounded {
				border-top: 8px solid #bbb;
				border-radius: 5px;
			}
			#estoque {
				margin-left:auto;
				margin-right:auto;
			}
			#estoque tr:nth-child(even){background-color: #f2f2f2;}
			#estoque th {
			  padding-top: 12px;
			  padding-bottom: 12px;
			  text-align: left;
			  background-color: #d97102;
			}	
		</style>
		<meta charset=\"UTF-8\">
		<title>Estoque Atual</title>
	</head>
	<body>
	<div class=\"center\">
		<h1>Catálogos de itens para revenda</h1>
		<h3>Página contém todos os estoques disponíveis atualmente</h3>
		<h4>Contato:</h4>
		<p>Cel: 21 99719-4265 ou 21 97468-4345</p>
		<hr class=\"rounded\">
	</div>
	<div class=>" > site.html

declare -i row=0

first_table=true
while IFS=$';\n' read -r -a array; do
   # caso tenha 'Categoria:' no inicio da linha -> cria nova tabela
	 if [[ $array  == Categoria:* ]]; then
		 if $first_table ; then 
			 first_table=false
		 else
			 echo -e '\t\t</table>' >> site.html
			 echo -e '\t\t<hr class="solid">' >> site.html
		 fi
		 echo -e '\t\t<table id="estoque">' >> site.html
		 echo -e '\t\t<caption class="title">'${array[@]#*:}'</caption>\n\t\t\t<tr>' >> site.html
		 # printa o cabeçalho da tabela
		 IFS=$';\n' read -r -a array;
		 for i in "${array[@]}"; do
			  echo -e '\t\t\t\t<th>'$i"</th>" >> site.html
		 done
		 echo -e '\t\t\t</tr>' >> site.html
	 else
		#printa uma linhq qlq
		 echo -e '\t\t\t<tr>' >> site.html
		 for i in "${array[@]}"; do
			  echo -e '\t\t\t\t<td>'$i"</td>" >> site.html
		 done
		 echo -e '\t\t\t</tr>' >> site.html
	 fi
done < "$csv_file"	
	
echo "			</table>
		</div>	
	</body>
</html>" >> site.html
