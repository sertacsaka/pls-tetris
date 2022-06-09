create or replace package body pls_tetris_pkg
is  
    function start_game(start_level int default 0) return pipeline_table pipelined
    is
        piperow pipeline_record_type;
    begin
        block_char := '#';
        mark_char := 'X';
        score := 0;
        game_level := start_level;
        countdown_start := 9 - game_level;
        countdown_step := countdown_start;
        
        base_tetris_score := 25;
        max_score := 99999;
        
        gameover := false;
        
        screen := display_area();
        screen.extend(2);
        
        for i in 1..screen.count
        loop
            screen(i).x := screen_char_coordinates();
            screen(i).x.extend(10);
        end loop;
        
        --blocks area
        for i in 1..screen(1).x.count
        loop
            screen(1).x(i).y := screen_char();
            screen(1).x(i).y.extend(20);
        end loop;
        
        --game screen
        for i in 1..screen(2).x.count
        loop
            screen(2).x(i).y := screen_char();
            screen(2).x(i).y.extend(24);
        end loop;
        
        ---
        
        block_sprite := block_obj_sprite();
        block_sprite.extend(7);
        
        for s in 1..block_sprite.count
        loop
            block_sprite(s).r := block_obj_sprite_rotated();
            block_sprite(s).r.extend(4);

            for o in 1..block_sprite(1).r.count
            loop
            
                block_sprite(s).r(o).x := block_obj_sprite_coords();
                block_sprite(s).r(o).x.extend(4);
                    
                for i in 1..block_sprite(1).r(o).x.count
                loop
                    block_sprite(s).r(o).x(i).y := block_obj_sprite_char();
                    block_sprite(s).r(o).x(i).y.extend(4);
                end loop;
                
            end loop;
        end loop;
        
        -----------
        --I block--
        -----------
        
        --1 3
        --####
        --
        --
        --
        
        for i in 1 .. block_sprite(4).r.count
        loop
            if i in (1, 3) then
                block_sprite(1).r(i).x(1).y(1) := block_char;
                block_sprite(1).r(i).x(2).y(1) := block_char;
                block_sprite(1).r(i).x(3).y(1) := block_char;
                block_sprite(1).r(i).x(4).y(1) := block_char;
            end if;
        end loop;
        
        --2 4
        --#
        --#
        --#
        --#
        
        for i in 1 .. block_sprite(4).r.count
        loop
            if i in (2, 4) then
                block_sprite(1).r(i).x(1).y(1) := block_char;
                block_sprite(1).r(i).x(1).y(2) := block_char;
                block_sprite(1).r(i).x(1).y(3) := block_char;
                block_sprite(1).r(i).x(1).y(4) := block_char;
            end if;
        end loop;
        
        -----------
        --J block--
        -----------
        
        --1
        --#
        --###
        --
        --
        
        block_sprite(2).r(1).x(1).y(1) := block_char;
        block_sprite(2).r(1).x(1).y(2) := block_char;
        block_sprite(2).r(1).x(2).y(2) := block_char;
        block_sprite(2).r(1).x(3).y(2) := block_char;
        
        --2
        -- ##
        -- #
        -- #
        --
        
        block_sprite(2).r(2).x(2).y(1) := block_char;
        block_sprite(2).r(2).x(3).y(1) := block_char;
        block_sprite(2).r(2).x(2).y(2) := block_char;
        block_sprite(2).r(2).x(2).y(3) := block_char;
        
        --3
        --
        --###
        --  #
        --
        
        block_sprite(2).r(3).x(1).y(2) := block_char;
        block_sprite(2).r(3).x(2).y(2) := block_char;
        block_sprite(2).r(3).x(3).y(2) := block_char;
        block_sprite(2).r(3).x(3).y(3) := block_char;
        
        --4
        -- #
        -- #
        --##
        --
        
        block_sprite(2).r(4).x(2).y(1) := block_char;
        block_sprite(2).r(4).x(2).y(2) := block_char;
        block_sprite(2).r(4).x(1).y(3) := block_char;
        block_sprite(2).r(4).x(2).y(3) := block_char;
        
        -----------
        --L block--
        -----------
        
        --1
        --  #
        --###
        --
        --
        
        block_sprite(3).r(1).x(3).y(1) := block_char;
        block_sprite(3).r(1).x(1).y(2) := block_char;
        block_sprite(3).r(1).x(2).y(2) := block_char;
        block_sprite(3).r(1).x(3).y(2) := block_char;
        
        --2
        -- #
        -- #
        -- ##
        --
        
        block_sprite(3).r(2).x(2).y(1) := block_char;
        block_sprite(3).r(2).x(2).y(2) := block_char;
        block_sprite(3).r(2).x(2).y(3) := block_char;
        block_sprite(3).r(2).x(3).y(3) := block_char;
        
        --3
        --
        --###
        --#
        --
        
        block_sprite(3).r(3).x(1).y(2) := block_char;
        block_sprite(3).r(3).x(2).y(2) := block_char;
        block_sprite(3).r(3).x(3).y(2) := block_char;
        block_sprite(3).r(3).x(1).y(3) := block_char;
        
        --4
        --##
        -- #
        -- #
        --
        
        block_sprite(3).r(4).x(1).y(1) := block_char;
        block_sprite(3).r(4).x(2).y(1) := block_char;
        block_sprite(3).r(4).x(2).y(2) := block_char;
        block_sprite(3).r(4).x(2).y(3) := block_char;
        
        -----------
        --O block--
        -----------
        
        --1 2 3 4
        --##
        --##
        --
        --
        
        for i in 1 .. block_sprite(4).r.count
        loop
            block_sprite(4).r(i).x(1).y(1) := block_char;
            block_sprite(4).r(i).x(2).y(1) := block_char;
            block_sprite(4).r(i).x(1).y(2) := block_char;
            block_sprite(4).r(i).x(2).y(2) := block_char;
        end loop;
        
        -----------
        --S block--
        -----------
        
        --1 3
        -- ##
        --##
        --
        --
        
        for i in 1 .. block_sprite(4).r.count
        loop
            if i in (1, 3) then
                block_sprite(5).r(i).x(2).y(1) := block_char;
                block_sprite(5).r(i).x(3).y(1) := block_char;
                block_sprite(5).r(i).x(1).y(2) := block_char;
                block_sprite(5).r(i).x(2).y(2) := block_char;
            end if;
        end loop;
        
        --2 4
        --#
        --##
        -- #
        --
        
        for i in 1 .. block_sprite(4).r.count
        loop
            if i in (2, 4) then
                block_sprite(5).r(i).x(1).y(1) := block_char;
                block_sprite(5).r(i).x(1).y(2) := block_char;
                block_sprite(5).r(i).x(2).y(2) := block_char;
                block_sprite(5).r(i).x(2).y(3) := block_char;
            end if;
        end loop;
        
        -----------
        --T block--
        -----------
        
        --1
        -- #
        --###
        --
        --
        
        block_sprite(6).r(1).x(2).y(1) := block_char;
        block_sprite(6).r(1).x(1).y(2) := block_char;
        block_sprite(6).r(1).x(2).y(2) := block_char;
        block_sprite(6).r(1).x(3).y(2) := block_char;
        
        --2
        -- #
        -- ##
        -- #
        --
        
        block_sprite(6).r(2).x(2).y(1) := block_char;
        block_sprite(6).r(2).x(2).y(2) := block_char;
        block_sprite(6).r(2).x(3).y(2) := block_char;
        block_sprite(6).r(2).x(2).y(3) := block_char;
        
        --3
        --
        --###
        -- #
        --
        
        block_sprite(6).r(3).x(1).y(2) := block_char;
        block_sprite(6).r(3).x(2).y(2) := block_char;
        block_sprite(6).r(3).x(3).y(2) := block_char;
        block_sprite(6).r(3).x(2).y(3) := block_char;
        
        --4
        -- #
        --##
        -- #
        --
        
        block_sprite(6).r(4).x(2).y(1) := block_char;
        block_sprite(6).r(4).x(1).y(2) := block_char;
        block_sprite(6).r(4).x(2).y(2) := block_char;
        block_sprite(6).r(4).x(2).y(3) := block_char;
        
        -----------
        --Z block--
        -----------
        
        --1 3
        --##
        -- ##
        --
        --
        
        for i in 1 .. block_sprite(4).r.count
        loop
            if i in (1, 3) then
                block_sprite(7).r(i).x(1).y(1) := block_char;
                block_sprite(7).r(i).x(2).y(1) := block_char;
                block_sprite(7).r(i).x(2).y(2) := block_char;
                block_sprite(7).r(i).x(3).y(2) := block_char;
            end if;
        end loop;
        
        --2 4
        -- #
        --##
        --#
        --
        
        for i in 1 .. block_sprite(4).r.count
        loop
            if i in (2, 4) then
                block_sprite(7).r(i).x(2).y(1) := block_char;
                block_sprite(7).r(i).x(1).y(2) := block_char;
                block_sprite(7).r(i).x(2).y(2) := block_char;
                block_sprite(7).r(i).x(1).y(3) := block_char;
            end if;
        end loop;
        
        ---
        
        set_score(0);
        
        reset_screen;
        
        current_block := trunc(dbms_random.value(1,8));
        
        next_block := trunc(dbms_random.value(1,8));

        draw_shape(next_block, 1, 22, 1, 2);
   
        move_object(current_block, 4, 1, 1);
        
        for j in 1 .. screen(2).x(1).y.count
        loop
            piperow.i0 := screen(2).x(1).y(j);
            piperow.i2 := screen(2).x(2).y(j);
            piperow.it := screen(2).x(3).y(j);
            piperow.e := screen(2).x(4).y(j);
            piperow.t := screen(2).x(5).y(j);
            piperow.r := screen(2).x(6).y(j);
            piperow.i := screen(2).x(7).y(j);
            piperow.s := screen(2).x(8).y(j);
            piperow.i4 := screen(2).x(9).y(j);
            piperow.i8 := screen(2).x(10).y(j);
                    
            pipe row (piperow);
        end loop;
        
        return;
    end;
    
    procedure reset_screen(is_gameover boolean default false)
    as
    begin
      
        for i in 1..screen(2).x.count
        loop
            for j in 1..screen(2).x(i).y.count
            loop
                screen(2).x(i).y(j) := null;
            end loop;
        end loop;
      
        for i in 1..screen(2).x.count
        loop
            screen(2).x(i).y(20) := '_';
        end loop;
        
        screen(2).x(1).y(21) := 'N';
        screen(2).x(2).y(21) := 'E';
        screen(2).x(3).y(21) := 'X';
        screen(2).x(4).y(21) := 'T';
        screen(2).x(5).y(21) := '|';
        screen(2).x(6).y(21) := 'S';
        screen(2).x(7).y(21) := 'C';
        screen(2).x(8).y(21) := 'O';
        screen(2).x(9).y(21) := 'R';
        screen(2).x(10).y(21) := 'E';
        
        screen(2).x(5).y(22) := '|';
        
        screen(2).x(5).y(23) := '|';
        screen(2).x(6).y(23) := 'L';
        screen(2).x(7).y(23) := 'E';
        screen(2).x(8).y(23) := 'V';
        screen(2).x(9).y(23) := 'E';
        screen(2).x(10).y(23) := 'L';
        
        screen(2).x(5).y(22) := '|';
        
        screen(2).x(6).y(22) := substr(score_digits, 1, 1);
        screen(2).x(7).y(22) := substr(score_digits, 2, 1);
        screen(2).x(8).y(22) := substr(score_digits, 3, 1);
        screen(2).x(9).y(22) := substr(score_digits, 4, 1);
        screen(2).x(10).y(22) := substr(score_digits, 5, 1);
        
        screen(2).x(5).y(24) := '|';
        
        screen(2).x(10).y(24) := game_level;
        
        screen(2).x(4).y(24) := countdown_step;
        
        for i in 1..screen(1).x.count
        loop
            for j in 1..screen(1).x(i).y.count
            loop
                if screen(1).x(i).y(j) is not null then
                    screen(2).x(i).y(j) := screen(1).x(i).y(j);
                end if;
            end loop;
        end loop;
        
        if is_gameover then
        
            screen(2).x(1).y(9) := '-';
            screen(2).x(2).y(9) := 'G';
            screen(2).x(3).y(9) := '-';
            screen(2).x(4).y(9) := 'A';
            screen(2).x(5).y(9) := '-';
            screen(2).x(6).y(9) := 'M';
            screen(2).x(7).y(9) := '-';
            screen(2).x(8).y(9) := 'E';
            screen(2).x(9).y(9) := '-';
            screen(2).x(10).y(9) := '-';
        
            screen(2).x(1).y(11) := '-';
            screen(2).x(2).y(11) := '-';
            screen(2).x(3).y(11) := 'O';
            screen(2).x(4).y(11) := '-';
            screen(2).x(5).y(11) := 'V';
            screen(2).x(6).y(11) := '-';
            screen(2).x(7).y(11) := 'E';
            screen(2).x(8).y(11) := '-';
            screen(2).x(9).y(11) := 'R';
            screen(2).x(10).y(11) := '-';
            
        end if;
    end;
    
    procedure set_score(score_delta number)
    as
    begin
        if score + base_tetris_score >= max_score
        then
            score := 0;
            game_level := 0;
            countdown_step := countdown_start;
        else
            score := score + score_delta;
            
            score_digits := lpad(score, 5, '0');
            
            if trunc((score)/10000) >= game_level then
                game_level := trunc((score)/10000);
            end if;
            
            countdown_start := 9 - game_level;
        end if;
    end;
    
    procedure draw_shape(id number, x number, y number, r number, s int)
    as
    begin
        for i in block_sprite(id).r(r).x.first .. block_sprite(id).r(r).x.last
        loop
            for j in block_sprite(id).r(r).x(i).y.first .. block_sprite(id).r(r).x(i).y.last
            loop
                if block_sprite(id).r(r).x(i).y(j) is not null then
                    screen(s).x(x+i-1).y(y+j-1) := block_sprite(id).r(r).x(i).y(j);
                end if;
            end loop;
        end loop;
    end;
    
    procedure clear_completed_rows
    as
        reverse_j int;
        row_full boolean;
        reverse_y int;
        full_row_count int;
    begin
        full_row_count := 0;
        
        for j in 1..screen(1).x(1).y.count
        loop
            reverse_j := screen(1).x(1).y.count - j + 1;
            row_full := true;
            
            for i in 1..screen(1).x.count
            loop
                if screen(1).x(i).y(reverse_j) is null then
                    row_full := false;
                end if;
            end loop;
            
            if row_full then
            
                full_row_count := full_row_count + 1;
            
                for i in 1..screen(1).x.count
                loop
                    screen(1).x(i).y(reverse_j) := mark_char;
                    screen(2).x(i).y(reverse_j) := mark_char;
                end loop;
                
            end if;
        end loop;
        
        set_score((game_level+1)*base_tetris_score*full_row_count);
        
        for j in 1..screen(1).x(1).y.count
        loop

            if screen(1).x(1).y(j) = mark_char then

                if j = 1 then 

                    for i in 1 .. screen(1).x.count
                    loop
                        screen(1).x(i).y(j) := null;
                    end loop;
                    
                else

                    for y in 2 .. j
                    loop
                        reverse_y := j - y + 1;

                        for i in 1 .. screen(1).x.count
                        loop
                            screen(1).x(i).y(reverse_y+1) := screen(1).x(i).y(reverse_y);
                        end loop;
                        
                    end loop;
                    
                end if;
            end if;
            
        end loop;
    end;
    
    function find_landing_y_coordinate return int
    is
        landing_y_coordinate int;
        reverse_j int;
        screen_x int;
        screen_y int;
        column_empty boolean;
        collision_length int;
    begin
        collision_length := screen(1).x(1).y.count;

        for i in block_sprite(current_block).r(block_r).x.first .. block_sprite(current_block).r(block_r).x.last
        loop
            column_empty := true;
            
            for j in block_sprite(current_block).r(block_r).x(i).y.first .. block_sprite(current_block).r(block_r).x(i).y.last
            loop
                if block_sprite(current_block).r(block_r).x(i).y(j) is not null then
                    column_empty := false;
                end if;
            end loop;
                
            if not column_empty then
            
                for j in block_sprite(current_block).r(block_r).x(i).y.first .. block_sprite(current_block).r(block_r).x(i).y.last
                loop
                    reverse_j := block_sprite(current_block).r(block_r).x(i).y.count - j + 1;

                    if block_sprite(current_block).r(block_r).x(i).y(reverse_j) is not null then

                        screen_x := block_x+i-1;
                        screen_y := block_y+reverse_j-1;

                        for y in screen_y+1 .. screen(1).x(1).y.count 
                        loop
                            if screen(1).x(screen_x).y(y) is not null then

                                if y-screen_y-1 < collision_length then
                                    collision_length := y-screen_y-1;
                                    landing_y_coordinate := block_y + collision_length;
                                end if;
                                    
                            elsif y = screen(1).x(1).y.count then

                                if y-screen_y < collision_length then
                                    collision_length := y-screen_y;
                                    landing_y_coordinate := block_y + collision_length;
                                end if;
                                    
                            end if;
                        end loop;
                            
                        exit;
                    end if;
                end loop;
            end if;
        end loop;
    
        return landing_y_coordinate;
    end;
    
    function get_block_height(id number, r number) return int
    is
        block_height int;
    begin
        block_height := 0;
    
        for i in block_sprite(id).r(r).x.first .. block_sprite(id).r(r).x.last
        loop
            for j in block_sprite(id).r(r).x(i).y.first .. block_sprite(id).r(r).x(i).y.last
            loop
                if block_sprite(id).r(r).x(i).y(j) is not null and j > block_height then
                    block_height := j;
                end if;
            end loop; 
        end loop;
        
        return block_height;
    end;
    
    procedure move_object(id number, x number, y number, r number)
    as
        screen_x int;
        screen_y int;
        collision boolean;
        wall_collision boolean;
        previous_y int;
    begin
        collision := false;
        wall_collision := false;
        
        for i in block_sprite(id).r(r).x.first .. block_sprite(id).r(r).x.last
        loop
            for j in block_sprite(id).r(r).x(i).y.first .. block_sprite(id).r(r).x(i).y.last
            loop
                if block_sprite(id).r(r).x(i).y(j) is not null then
                        
                    screen_x := x+i-1;
                    screen_y := y+j-1;
                            
                    if 
                        screen_x between 1 and screen(1).x.count and
                        screen_y between 1 and screen(1).x(1).y.count 
                    then
                        if screen(1).x(x+i-1).y(y+j-1) is not null then
                            collision := true;
                        end if;
                    else
                        if screen_x < 1 or screen_x > screen(1).x.count then
                            wall_collision := true;
                        else
                            collision := true;
                        end if;
                    end if;
                end if;
            end loop;
        end loop;
        
        previous_y := y;
        
        if not collision and not wall_collision then

            if y = screen(1).x(1).y.count - get_block_height(id, r) + 1 then
           
                draw_shape(id, x, y, r, 1);          
                draw_shape(id, x, y, r, 2);
                
                if previous_y <= 1 then gameover := true;
                else
                
                    block_x := 4;
                    block_y := 1;
                    block_r := 1;
            
                    current_block := next_block;
                    next_block := trunc(dbms_random.value(1,8));
                
                end if; 
                
            else
    
                draw_shape(id, x, y, r, 2);
                
                block_x := x;
                block_y := y;
                block_r := r;
                
            end if;
            
        else
      
            draw_shape(id, block_x, block_y, block_r, 2);
            
            if collision then
            
                draw_shape(id, block_x, block_y, block_r, 1);
                
                if previous_y <= 1 then gameover := true;
                else
                
                    block_x := 4;
                    block_y := 1;
                    block_r := 1;
            
                    current_block := next_block;
                    next_block := trunc(dbms_random.value(1,8));
                
                end if; 

            end if;
            
        end if;
    end;

    function move_it(command varchar2) return pipeline_table pipelined 
    is  
        piperow pipeline_record_type;
        
        target_x number;
        target_y number;
        target_r number;
    begin
    
        target_x := block_x;
        target_y := block_y;
        target_r := block_r;
        
        if command != 'DOWN' then
            if command = 'PASS_COUNTDOWN' then
                target_y := target_y + 1;
                countdown_step := countdown_start;
            else
                if countdown_step - 1 < 0 then
                    target_y := target_y + 1;
                    countdown_step := countdown_start;
                else
                    countdown_step := countdown_step - 1;
                end if;
            end if;
        end if;
        
        if command = 'LEFT' then target_x := block_x - 1;
        elsif command = 'RIGHT' then target_x := block_x + 1;
        elsif command = 'DOWN' then target_y := find_landing_y_coordinate();
        elsif command = 'ROTATE_CW' then target_r := case when block_r + 1 > 4 then 1 else block_r + 1 end;
        elsif command = 'ROTATE_CCW' then target_r := case when block_r - 1 = 0 then 4 else block_r - 1 end;
        else null;
        end if;
        
        if not gameover then
    
            reset_screen;
                
            draw_shape(next_block, 1, 22, 1, 2);
            
            move_object(current_block, target_x, target_y, target_r);
            
            clear_completed_rows();
            
        else
        
            reset_screen(gameover);
            
        end if;
        
        for j in 1 .. screen(2).x(1).y.count
        loop
            piperow.i0 := screen(2).x(1).y(j);
            piperow.i2 := screen(2).x(2).y(j);
            piperow.it := screen(2).x(3).y(j);
            piperow.e := screen(2).x(4).y(j);
            piperow.t := screen(2).x(5).y(j);
            piperow.r := screen(2).x(6).y(j);
            piperow.i := screen(2).x(7).y(j);
            piperow.s := screen(2).x(8).y(j);
            piperow.i4 := screen(2).x(9).y(j);
            piperow.i8 := screen(2).x(10).y(j);
                    
            pipe row (piperow);
        end loop;
        
        return;
        
    end move_it;
end;