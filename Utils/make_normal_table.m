function normal_table = make_normal_table(table_size)

normal_table = norminv((1:table_size)/(table_size+1), 0, 1)';