function foo::init
	print, 'init'
	self.a = [0,1,2,3,4,5]
	print,self->archive_start_time(3)
	return,1
end

function foo::archive_start_times, index
	return, (self->archive_start_times1())[index]
end

function foo::archive_start_times1
	return, ['0000', '0130', '0300', '0430', '0600', '0730', '0900', '1030', '1200', '1330', '1500', '1630', '1800', '1930', '2100', '2230']
end

function foo::a
	print,self.a
	print, self->archive_start_times(3)
	return, self.a
end

pro foo__define
	struct={foo, $
	a :  [0,1,2,3,4,5]}
end
