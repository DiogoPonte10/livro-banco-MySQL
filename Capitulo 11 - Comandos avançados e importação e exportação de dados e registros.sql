show variables like '%table%';

show processlist;

select * from comclien
	into outfile 'c:/lista_clientes.txt'
    fields terminated by ','
    enclosed by '''';
    
create table comuser(
	n_numeuser int not null auto_increment,
	n_nomeuser varchar(100),
	n_nascuser date,
	primary	key(n_numeuser));

load data infile @caminho_nome_arquivo
	into table comuser
    fields terminated by ','
    enclosed by '''';