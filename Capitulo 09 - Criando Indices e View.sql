alter table comclien add
	index idx_comclien_3(c_codiclien);
alter table comclien add
	index idx_comclien_4(c_razaclien);
    
show indexes from comclien;

alter table comvenda add unique index
	idx_comvenda_1(c_codivenda);
    
show indexes from comvenda;

alter table comclien drop index idx_comclien_2;
alter table comvenda drop index idx_comvenda_1;

create or replace view clientes_vendas as
	select c_razaclien, c_nomeclien, c_cnpjclien,
    c_codivenda, n_totavenda, d_datavenda
    from comclien, comvenda
    where comclien.n_numeclien = comvenda.n_numeclien
    order by 1;
    
select * from clientes_vendas;

create or replace view produtos as
	select n_numeprodu, c_codiprodu, c_descprodu,
    n_valoprodu, c_situprodu, n_numeforne
    from comprodu;
    
insert into produtos values(
	6, '0006', 'SMART WATCH', '2412.98', 'A', 1);

update produtos set n_valoprodu = '1245.99'
	where n_numeprodu = 6;
commit;