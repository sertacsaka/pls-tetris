create or replace package pls_tetris_pkg
is
    
    score number;
    score_digits char(5);
    game_level number;
    block_char char(1);
    mark_char char(1);
    countdown_start int;
    countdown_step int;
    base_tetris_score int;
    max_score int;
    current_block int;
    next_block int;
    block_r int;
    block_x int;
    block_y int;
    gameover boolean;
    
    ---

    type block_obj_sprite_char is table of char(1);
    type block_obj_coordinate is record
    (
        y block_obj_sprite_char
    );
    
    type block_obj_sprite_coords is table of block_obj_coordinate;
    type block_obj_rotated_coords is record
    (
        x block_obj_sprite_coords
    );
    
    type block_obj_sprite_rotated is table of block_obj_rotated_coords;
    type block_obj_coords is record
    (
        r block_obj_sprite_rotated
    );
    
    type block_obj_sprite is table of block_obj_coords;
    
    block_sprite block_obj_sprite;
    
    ---
    
    type screen_char is table of char(1);
    type char_coordinate is record
    (
        y screen_char
    );
    
    type screen_char_coordinates is table of char_coordinate;
    type char_coordinates is record
    (
        x screen_char_coordinates
    );
    
    type display_area is table of char_coordinates;
    
    screen display_area;
    
    ---
    
    type pipeline_record_type is record 
    (
        i0 char(1),
        i2 char(1),
        it char(1),
        e char(1),
        t char(1),
        r char(1),
        i char(1),
        s char(1),
        i4 char(1),
        i8 char(1)
    );
    
    type pipeline_table is table of pipeline_record_type;
    
    ---
          
    function start_game(start_level int default 0) return pipeline_table pipelined;
    procedure reset_screen(is_gameover boolean default false);
    
    procedure set_score(score_delta number);
    
    procedure draw_shape
    (
        id number, x number, y number, r number, s int
    );
    
    procedure clear_completed_rows;
    
    function get_block_height(id number, r number) return int;
    
    function find_landing_y_coordinate return int;
    
    procedure move_object
    (
        id number, x number, y number, r number
    );
    
    function move_it(command varchar2) return pipeline_table pipelined;
end;