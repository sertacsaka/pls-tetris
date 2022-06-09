select * from table(pls_tetris_pkg.start_game); --start/restart game

select * from table(pls_tetris_pkg.move_it('LEFT')); --move left

select * from table(pls_tetris_pkg.move_it('RIGHT')); --move right

select * from table(pls_tetris_pkg.move_it('ROTATE_CW')); --rotate clockwise

select * from table(pls_tetris_pkg.move_it('ROTATE_CCW')); --rotate counter clockwise

select * from table(pls_tetris_pkg.move_it('DOWN')); --drop down
    
--falling effect simulation related commands

select * from table(pls_tetris_pkg.move_it('PASS_COUNTDOWN')); --dont wait falling effect

select * from table(pls_tetris_pkg.move_it('WAIT')); --wait for falling effect