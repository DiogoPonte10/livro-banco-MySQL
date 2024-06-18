delimiter $$
create function rt_percentual_comissao(vn_n_numevende int)
	returns float
    deterministic
    begin
		declare percentual_comissao float(10, 2);
        
        select n_porcvende
        into percentual_comissao
        from comvende
        where n_numevende = vn_n_numevende;
        
        return percentual_comissao;
	end;
	$$
delimiter ;

delimiter $$
create trigger tri_vendas_bi
	before insert on comvenda
	for each row

	begin
		declare percentual_comissao float(10, 2);
        declare valor_comissao float(10, 2);
        
        select rt_percentual_comissao(new.n_numevende)
			into percentual_comissao;
		
        set valor_comissao = ((total_venda * comissao) / 100);
        
        set new.n_vcomvenda = valor_comissao;
	end $$
delimiter ;

delimiter $$
create trigger tri_vendas_bu
	before update on comvenda
    for each row
    
    begin
		declare percentual_comissao float(10, 2);
        declare total_venda float(10, 2);
        declare valor_comissao float(10, 2);
        
        if (old.n_totavenda <> new.n_totavenda) then
			select rt_percentual_comissao(new.n_numevende)
            into percentual_comissao;
            
            set valor_comissao = ((total_venda * comissao) / 100);
			
            set new.n_vcomvenda = valor_comissao;
		end if;
	end
    $$
delimiter ;

delimiter $$
create trigger tri_vendas_ai
	after insert on comivenda
    for each row
    
    begin
		declare vtotal_itens float(10, 2) default 0;
        declare total_item float(10, 2) default 0;
        
        declare fimLoop boolean default false;

		declare busca_itens cursor for
			select n_valoivenda
			from comivenda
			where n_numevenda = new.n_numevenda;

		declare continue handler for
			sqlstate '02000' 
			set fimLoop = true;
        
        open busca_itens;
        
			itens : loop
				fetch busca_itens into total_item;
                
                if fimLoop then
					leave itens;
				end if;
                
				set vtotal_itens = vtotal_itens + total_item;
				
			end loop itens;
        
        close busca_itens;
        
        update comvenda set n_totavenda = vtotal_itens
        where n_numevenda = new.n_numevenda;
	end
    $$
delimiter ;

delimiter $$
create trigger tri_vendas_au
	after update on comivenda
    for each row
    
    begin
		declare vtotal_itens float(10,2) default 0;
		declare total_item float(10,2) default 0;
			
            declare busca_itens cursor for
				select n_valoivenda
                from comivenda
                where n_numevenda = new.n_numevenda;
			
            if new.n_valoivenda <> old.n_valoivenda then
				open busca_itens;
                
					itens : loop
					
						fetch busca_itens into total_item;
						set vtotal_itens = vtotal_itens + total_item;
						
					end loop itens;
				
                close busca_itens;
                
                update comvenda set n_totavenda = vtotal_itens
                where n_numevenda = new.n_numevenda;
			end if;
	end
    $$
delimiter ;

delimiter $$
create trigger tri_ivendas_af
	after delete on comivenda
	for each row
    
    begin
		declare vtotal_itens float(10, 2);
        declare vtotal_item float(10, 2);
        declare total_item float(10, 2);
        
        declare busca_itens cursor for
			select n_valoivenda
            from comivenda
            where n_numevenda = old.n_numevenda;
            
            open busca_itens;
				
                itens: loop
					
                    fetch busca_itens into total_item;
                    
                    set vtotal_itens = vtotal_itens + total_item;
				end loop itens;
                
			close busca_itens;
            
            update comvenda set n_totavenda = vtota_itens
            where n_numevenda = old.n_numevenda;
	end
    $$
delimiter ;

delimiter $$
create trigger tri_vendas_bf
	before delete on comvenda
    for each row
    
    begin
		declare vtotal_itens float(10, 2);
        declare vtotal_item float(10, 2);
        declare total_item float(10, 2);
        
        declare busca_itens cursor for
        select n_valoivenda
        from comivenda
        where n_numevenda = old.n_numevenda;
        
        open busca_itens;
        
			itens : loop
            
				fetch busca_itens into total_item;
                
                set vtotal_itens = vtotal_itens + total_item;
                
			end loop itens;
		close busca_itens;
        
        delete from comivenda
        where n_numevenda = venda;
	end
    $$
delimiter ;