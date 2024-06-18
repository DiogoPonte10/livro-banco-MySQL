select c_codiclien, c_razaclien, count(n_numevenda) qtde
	from comclien, comvenda
    where comvenda.n_numeclien = comclien.n_numeclien
    group by c_codiclien, c_razaclien
    order by c_razaclien;

select c_razaclien,	count(n_numevenda)
    from comclien, comvenda
    where comvenda.n_numeclien = comclien.n_numeclien
    group by c_razaclien
    having count(n_numevenda) > 2;
    
select max(n_totavenda) maior_venda
	from comvenda;    
select min(n_totavenda) menor_venda
	from comvenda;
 select min(n_totavenda) menor_venda,
	max(n_totavenda) maior_venda
    from comvenda;
    
select sum(n_valovenda) valor_venda,
	sum(n_descvenda) descontos,
    sum(n_totavenda) total_vendas
    from comvenda
    where d_datavenda between '2015-01-01' and '2015-01-31';

select format(avg(n_totavenda),2)
	from comvenda;
    
select c_codiprodu,c_descprodu
	from comprodu
    where substr(c_codiprodu, 1, 3) = '123'
	and length(c_codiprodu) > 4;
    
select substr(c_razaclien, 1, 5) Razao_Social,
	length(c_codiclien) Tamanho_Cod
    from comclien
    where n_numeclien = 1;
    
select concat(c_razaforne, ' - fone: ', c_foneforne)
	from comforne
    order by c_razaforne;
    
select concat_ws(';', c_codiclien, c_razaclien, c_nomeclien)
	from comclien
    where c_razaclien like 'GREA%';
    
select lcase(c_razaclien)
	from comclien;
select ucase('banco de dados mysql')
	from dual;
    
