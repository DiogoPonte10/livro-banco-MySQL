select * from comclien;

select n_numeclien, c_codiclien, c_razaclien 
	from comclien
    where c_codiclien = '0001';
    
select c_codivenda Cod_Venda,
	(select c_razaclien
    from comclien
    where n_numeclien = comvenda.n_numeclien)
    Nome_Cliente
    from comvenda;
    
create table comclien_bkp as(
	select * from comclien
    where c_estaclien = 'SP');
    
create table comcontato(
	n_numecontato int not null auto_increment,
    c_nomecontato varchar(200),
    c_fonecontato varchar(30),
    c_cidacontato varchar (200),
    c_estacontato varchar (2),
    n_numeclien int,
    primary key(n_numecontato));
    
insert into comtato(
	select n_numeclien,
    c_nomeclien,
    c_foneclien,
    c_cidaclien,
    c_estaclien,
    c_numeclien
    from comclien);
    
update comcontato set c_cidacontato = 'LONDRINA',
	c_estacontato = 'PR'
    where n_numeclien in (select n_numeclien
    from comclien_bkp);

delete from comcontato
	where n_numeclien not in (
	select n_numeclien from comvenda );

commit;