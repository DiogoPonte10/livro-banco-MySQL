alter table comvenda add n_vcomvenda float(10,2);

delimiter $$
create procedure processa_comissionamento(
	in data_inicial date,
    in data_final date,
    out total_processado int)
    begin
		declare total_venda float(10, 2) default 0;
        declare venda int default 0;
		declare	vendedor int default 0;
		declare	comissao float(10,2) default 0;
		declare	valor_comissao float(10,2) default 0;
		declare	aux int default 0;
		declare	fimloop int default 0;
        
        declare busca_pedido cursor for
			select n_numevenda, n_totavenda, n_numevende
            from comvenda
            where d_datavenda between data_inicial and data_final
            and n_totavenda > 0;
		
        declare continue handler
        for sqlstate '02000'
        set fimloop = 1;
        
        open busca_pedido;        
			vendas:loop			
				if fimloop = 1 then
					leave vendas;
				end if;
				
				fetch busca_pedido into venda, total_venda, vendedor;
				
				select n_porcvende
					into comissao
					from comvende
					where n_numevende = vendedor;
				
				if (comissao > 0) then
					set valor_comissao = ((total_venda * comissao) / 100);		
					update comvenda set n_vcomvenda = valor_comissao
						where n_numevenda = venda;
					commit;
				
				elseif(comissao = 0) then
					update comvenda set n_vcomvenda = 0
					where n_numevenda = venda;
					commit;
				
				else
					set comissao = 1;
					set valor_comissao = ((total_venda * comissao) / 100);
					update comvenda set n_vcomvenda = valor_comissao
					where n_numevenda = venda;
					commit;
				
				end if;
				
				set comissao = 0;
				
				set aux = aux + 1;
			end loop vendas;
        
			set total_processado = aux;
        
        close busca_pedido;
end$$
delimiter ;

call processa_comissionamento('2015-01-01', '2015-05-30', @a);
select @a;

delimiter $$
create function rt_nome_cliente(vn_numeclien int)
	returns varchar(50)
    begin
		declare nome varchar(50);
        
        select c_nomeclien into nome
			from comclien
			where n_numeclien = vn_numeclien;
            
            return nome;
	end $$
delimiter ;

select rt_nome_cliente(1);

set global event_scheduler = on;

delimiter $$
create event processa_comissao
	on schedule every 1 week starts '2015-03-01 23:38:00'
    do 
		begin
			call processa_comissionamento(
				current_date() - interval 7 day,
				current_date(), @a);
		end
$$
delimiter ;

select c_codivenda Codigo,
	n_totavenda Total,
    n_vcomvenda Comissao
    from comvenda
    where d_datavenda between current_date() - interval 60 day
    and current_date();