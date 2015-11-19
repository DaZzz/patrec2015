function error = get_error(td, tc, tis, d, c, is)

t = classregtree(td(:,tis)', tc(tis)', 'splitcriterion', 'gdi');
classes = eval(t, d(:,is)')';
zipped = cat(2, classes', c');
error = length(zipped(zipped(:,1) ~= zipped(:,2)));

end